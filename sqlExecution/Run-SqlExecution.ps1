Import-Module .\Scripts\Modules\Ops-SQLCommands\Ops-InvokeSQL.ps1
$Function = ( Get-Content .\Scripts\Modules\Ops-SQLCommands\Ops-InvokeSQL.ps1 | Out-String )

function Test-FileLock {
  param (
    [parameter(Mandatory=$true)][string]$Path
  )

  $oFile = New-Object System.IO.FileInfo $Path

  if ((Test-Path -Path $Path) -eq $false) {
    return $false
  }

  try {
    $oStream = $oFile.Open([System.IO.FileMode]::Open, [System.IO.FileAccess]::ReadWrite, [System.IO.FileShare]::None)

    if ($oStream) {
      $oStream.Close()
    }
    $false
  } catch {
    # file is locked by a process.
    return $true
  }
}

Function Invoke-SQLQueryParallel {
    Param(
        [String]$Platform,
        [String[]]$ClientCodeList,
        [String]$QueryToRun,
        [String]$User,
        [String]$Password,
        [String]$Path,
        [String]$QueryName
    )
    Try{
        #Check if the output folder currently exists, if not create it
        $CheckPath = Test-Path -Path $Path
        If ($CheckPath -eq $true) {
            Write-Output "Folder already exists, continuing"
        }
        Else {
            New-Item -ItemType Directory -Path "$Path" -Force
            Write-Output "Created Folder $Path"
        }

        ## Create runspace pool with min 1 and max 10 runspaces
        $rp = [runspacefactory]::CreateRunspacePool(1, 1)

        ## Open runspace pool
        $rp.Open()

        ## Create object for runspace output
        $cmds = New-Object -TypeName System.Collections.ArrayList

        #Grabs all of the Tenant Database Nodes from the DBLOC table and stores them in a variable
        $DBLocConnection = New-ConnectionString -DBServer $Platform -DBInstance G3SQL01 -DBName "Global" -DBUser "$User" -DBPassword "$Password"
        $PlatformString = "'" + $Platform + "'"
        $TenantDatabaseNodes = Invoke-SQL -SQLConnection $DBLocConnection -SQLCommand "SELECT DISTINCT d.server_name FROM property p JOIN dbloc d ON p.dbloc_id = d.dbloc_id WHERE p.status_id = 1 AND d.DBType_ID = 4 ORDER BY d.Server_Name"

        Write-Output "`n#--------------------------------------------------------------------------------#"
        Write-Output "  Platform : $Platform"
        Write-Output "  TenantDBs: $($TenantDatabaseNodes.Server_Name)"
        Write-Output "#--------------------------------------------------------------------------------#"

        Foreach ($TenantDatabase in $TenantDatabaseNodes) {
            $TenantDatabaseConnection = New-ConnectionString -DBServer $TenantDatabase.Server_Name -DBInstance G3SQL01 -DBName 'master' -DBUser "$User" -DBPassword "$Password"

            IF ($ClientCodeList) {
                # Get ClientCodeList into SQL string list format
                [String[]] $ClientList = $ClientCodeList.Split(",")
                $ClientListSQLString = @()
                $Count = 1
                Foreach ($Client in $ClientList) {
                    If ($Count -lt $ClientList.Count) {
                        $ArrayEntry = "('$Client'),"
                    }
                    Else {
                        $ArrayEntry = "('$Client')"
                    }
                    $ClientListSQLString += $ArrayEntry
                    $Count += 1
                }
                # Create SQL Command to get DBNames for each Client Code
                $ClientList_SQLCommand = "
                    declare @ClientList table (Client_Code nvarchar(10))
                    Insert INTO @ClientList values $ClientListSQLString
                    select d.DBName as Name,c.Client_Code
                    from Global.dbo.dbloc d
                    JOIN Property p ON d.dbloc_id = p.dbloc_id
                    JOIN Client c ON p.client_id = c.client_id
                    where c.Client_Code in (select Client_Code from @ClientList)
                    AND d.Server_Name = '$($TenantDatabase.Server_Name)'"
                $PropertyList = Invoke-SQL -SQLConnection $DBLocConnection -SQLCommand $ClientList_SQLCommand
            } Else {
                $PropertyList = Invoke-SQL -SQLConnection $TenantDatabaseConnection -SQLCommand "SELECT name FROM sys.databases WHERE name NOT IN ('master','model','msdb','tempdb','DBAUtils')"
            }
            
            Write-Output "`n#--------------------------------------------------------------------------------#"
            Write-Output "  Executing Query against Tenant Database Node: $($TenantDatabase.Server_Name)"
            Write-Output "  Properties on Tenant Database Node          : $($PropertyList.count)"
            Write-Output "#--------------------------------------------------------------------------------#"

            Foreach ($Property in $PropertyList) {

                #Create parameters object to pass variables
                $SQLCommand = $QueryToRun
                $Server = $Server
                $Connection = $Connection
                $Path = $Path
                $QueryName = $QueryName
                $Function = $Function


                #Establish SQL Connection Variable
                $Server = $TenantDatabase.Server_Name
                $DBName = $($Property.Name)
                $Connection = New-ConnectionString -DBServer $Server -DBInstance G3SQL01 -DBName $DBName -DBUser "$User" -DBPassword "$Password"

                ## Create Powershell instance for each server
                Write-Output "Creating Powershell runspace instance on $Server for $DBname"
                $psa = [powershell]::Create()
                $psa.RunSpacePool = $rp

                ## Script to be run
                [void]$psa.AddScript( {
                        param ($SQLCommand, $Server, $Connection, $Path, $QueryName, $Function)
                        . ([ScriptBlock]::Create($Function))
                        $Results = Invoke-SQL -SQLConnection $Connection -SQLCommand $SQLCommand
                        $Results | Export-CSV "$Path\${QueryName}_${Server}.csv" -NoTypeInformation -Append
                    })
                ## Additional parameters plus execution of script
                [void]$psa.AddParameter('SQLCommand', $SQLCommand)
                [void]$psa.AddParameter('Server', $Server)
                [void]$psa.AddParameter('Connection', $Connection)
                [void]$psa.AddParameter('Path', $Path)
                [void]$psa.AddParameter('QueryName', $QueryName)
                [void]$psa.AddParameter('Function', $Function)
                $handle = $psa.BeginInvoke()

                ## Storing results
                $temp = '' | Select-Object PowerShell, Handle
                $temp.PowerShell = $psa
                $temp.Handle = $handle
                [void]$cmds.Add($temp)
            }
        }

        ## Retrieve command results and dispose session and pool
        $cmds | ForEach-Object {$_.PowerShell.EndInvoke($_.Handle)}
        $cmds | ForEach-Object {$_.PowerShell.Dispose()}
        $rp.Close()
        $rp.Dispose()
    } catch { Throw $_.Exception }
}
Invoke-SQLQueryParallel -Platform ${env:Platform} -ClientCodeList ${env:ClientCodeList} -QueryToRun ${env:QueryToRun} -User ${env:User} -Password ${env:Password} -Path ${env:Path} -QueryName ${env:QueryName}