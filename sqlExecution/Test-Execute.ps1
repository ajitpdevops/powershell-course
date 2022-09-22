Import-Module .\Scripts\Modules\Ops-SQLCommands\Ops-InvokeSQL.ps1
$Function = ( Get-Content .\Scripts\Modules\Ops-SQLCommands\Ops-InvokeSQL.ps1 | Out-String )

function Test-FileLock {
    param (
      [parameter(Mandatory=$true)]
      [string]
      $Path
    )
  
    $oFile = New-Object System.IO.FileInfo $Path
    Write-Output $oFile
  
    if ((Test-Path -Path $Path) -eq $false) {
      return $false
    }

    try {
        $oStream = $oFile.Open([System.IO.FileMode]::Open, [System.IO.FileAccess]::ReadWrite, [System.IO.FileShare]::None)
        
        write-Verbose "File $oFile has been opened"
    
        if ($oStream) {
          $oStream.Close()
          write-Verbose "File $oFile has been closed"
        }

        $false

      } catch {
        # file is locked by a process.
        write-Verbose "File $oFile has been locked by another process"
        return $true

      }
}

function Invoke-SQLQueryParallel {
    param (
        [String]$Platform,
        [String[]]$ClientCodeList,
        [String]$QueryToRun,
        [String]$User,
        [String]$Password,
        [String]$Path,
        [String]$QueryName
    )

    $CheckPath = Test-Path -Path $Path
    if ($CheckPath -eq $true) {
        Write-Output "Output folder already exists, continuing.."
    } else {
        New-Item -ItemType Directory -Path $Path -Force
        Write-Output "Path does not exists, hence created folder $Path"
    }

    ## Create runspace pool with min 1 and max 10 runspaces
    $rp = [runspacefactory]::CreateRunspacePool(1,1)
    
     ## Open runspace pool
    $rp.Open()

    ## Create object for runspace output
    $cmds = New-Object -TypeName System.Collections.ArrayList

     ## Grabs all of the Tenant Database Nodes from the DBLOC table and stores them in a variable
     $DBLocConnection = New-ConnectionString -DBServer $Platform -DBInstance G3SQL01 -DBName "Global" -DBUser "$User" -DBPassword "$Password"
     $PlatformString = "'" + $Platform + "'"
     # $TenantDatabaseNodes = Invoke-SQL -SQLConnection $DBLocConnection -SQLCommand "SELECT DISTINCT d.server_name FROM property p JOIN dbloc d ON p.dbloc_id = d.dbloc_id WHERE p.status_id = 1 AND d.DBType_ID = 4 ORDER BY d.Server_Name"
     
     ## AP: This is only for my Local, this need to removed and uncomment the above line
     $TenantDatabaseNodes = Invoke-SQL -SQLConnection $DBLocConnection -SQLCommand "SELECT DISTINCT d.server_name FROM property p JOIN dbloc d ON p.dbloc_id = d.dbloc_id ORDER BY d.Server_Name"
    

     Write-Output "`n#--------------------------------------------------------------------------------#"
     Write-Output "  Platform : $Platform"
     Write-Output "  TenantDBs: $($TenantDatabaseNodes.Server_Name)"
     Write-Output "#--------------------------------------------------------------------------------#"

}