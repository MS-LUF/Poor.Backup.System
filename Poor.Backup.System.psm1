#
# Created by: lucas.cueff[at]lucas-cueff.com
#
# v0.1 : 
# - manage configuration settings file and environment
# - add or remove files to backup definition
# - log backup
# - compress backup to a zip file
#
#'(c) 2018-2019 lucas-cueff.com - Distributed under Artistic Licence 2.0 (https://opensource.org/licenses/artistic-license-2.0).'

<#
	.SYNOPSIS 
	simple powershell module to backup file or folder using Powershell Core

	.DESCRIPTION
	simple powershell module to backup file or folder using Powershell Core
	
	.EXAMPLE
	C:\PS> import-module Poor.Backup.System.psm1
#>
Function Start-PoorBackup {
    <#
		.SYNOPSIS 
		Start a 'poor' backup task

		.DESCRIPTION
		Start a 'poor' backup task
            
        .PARAMETER Facets
	    -NoProgressBar switch
	    Remove graphical progress bar for copy and compression
        
        .OUTPUTS
        System.IO.DirectoryInfo
        System.IO.FileInfo

		.EXAMPLE
		Start a PoorBackup
        C:\PS> Start-PoorBackup

        .EXAMPLE
		Start a PoorBackup without progress bar
		C:\PS> Start-PoorBackup -NoProgressBar
    #>
    [cmdletbinding()]
    Param (
        [switch]$NoProgressBar
    )
    process {
        $script:ItemID = $null
        $script:ItemPercent = $null
        if ($NoProgressBar) {
            $tmpProgressPreference = $global:progressPreference
            $global:progressPreference = 'SilentlyContinue'
        }
        if (!($global:PoorBackupSettings.LogDir -and $global:PoorBackupSettings.TargetBackupDir -and $global:PoorBackupSettings.ItemsToBackup)) {
            throw "PoorBackupSettings does not exist. Please use Set-PoorBackupSettings cmdlet to generate it properly or use Import-PoorBackupSettings to load XML settings into memory"
        }
        $ticks = (get-date).Ticks
        $logFileName = join-path $global:PoorBackupSettings.LogDir "PoorBackupSystem_$($ticks).log"
        $BackupFolder = join-path $global:PoorBackupSettings.TargetBackupDir $ticks
        if (!(test-path $BackupFolder)) {
            new-item $BackupFolder -Force -Type Directory | out-null
        }
        Write-PoorBackupLog -Message "==> PoorBackupSystem Starting <==" -Path $logFileName
        Write-PoorBackupLog -Message "Enumarating current back session settings :" -Path $logFileName
        Write-PoorBackupLog -Message "- Target Host Backup directory : $($BackupFolder)" -Path $logFileName
        Write-PoorBackupLog -Message "- Content to backup : $($global:PoorBackupSettings.ItemsToBackup -join ",")" -Path $logFileName
        Write-PoorBackupLog -Message "Starting Real Poor Backup : " -Path $logFileName
        foreach ($item in $global:PoorBackupSettings.ItemsToBackup) {
            $script:ItemID = $script:ItemID + 1
            $script:ItemPercent = $script:ItemID/$global:PoorBackupSettings.ItemsToBackup.count*100 
            if ($script:ItemPercent -lt 100) {
                Write-Progress -Activity "Backuping Poorly Items" -Status "Backing up in Progress:" -CurrentOperation $item -PercentComplete ($script:ItemPercent) -Id 0
            } else {
                Write-Progress -Activity "Backuping Poorly Items" -Status "End of Backup" -CurrentOperation $item -PercentComplete $script:ItemPercent -Id 0 -Completed
            }
            Write-PoorBackupLog -Message "- backup $($item) to $($BackupFolder)..." -Path $logFileName
            if ($item.contains(":")) {
                $targetBackupPath = join-path $BackupFolder ($item.split(":"))[1]
            } else {
                $targetBackupPath = join-path $BackupFolder $item
            }
            Write-PoorBackupLog -Message "full backup target destination folder $($targetBackupPath)" -Path $logFileName
            if (!(test-path $item)) {
                Write-PoorBackupLog -Message "$($item) not found - item will be skipped" -Path $logFileName -Level Warn
            } else {  
                if (!(test-path (split-path $targetBackupPath))) {
                    New-Item (split-path $targetBackupPath) -Force -Type Directory | out-null
                }
                try {
                    Copy-Item $item -Destination (split-path $targetBackupPath) -Recurse -Force | out-null
                } catch {
                    Write-PoorBackupLog -Message "not able to backup $($item) - Error Type: $($_.Exception.GetType().FullName) - Error Message: $($_.Exception.Message)" -Path $logFileName -Level Error
                }
            }
        }
        if ($global:PoorBackupSettings.CompressBackup) {
            try {
                Compress-Archive -Path $BackupFolder -DestinationPath (join-path (split-path $BackupFolder) "$($ticks).zip") -CompressionLevel Optimal -Force | out-null
            } catch {
                Write-PoorBackupLog -Message "not able to archive backup file $((join-path (split-path $BackupFolder) "$($ticks).zip")) - Error Type: $($_.Exception.GetType().FullName) - Error Message: $($_.Exception.Message)" -Path $logFileName -Level Error
            }
            try {
                remove-item $BackupFolder -Force -Recurse | out-null
            } catch {
                Write-PoorBackupLog -Message "not able to remove backup folder $($BackupFolder) after compression - Error Type: $($_.Exception.GetType().FullName) - Error Message: $($_.Exception.Message)" -Path $logFileName -Level Error
            }
        }
        Write-PoorBackupLog -Message "==> PoorBackupSystem Closing <==" -Path $logFileName
        Write-PoorBackupLog -Message "There is no PoorRestoreSystem, DoItYourSelfRestoreSystem ;-)" -Path $logFileName
        if ($NoProgressBar) {
            $global:progressPreference = $tmpProgressPreference
        }
        get-childitem $Global:PoorBackupSettings.TargetBackupDir
    }
}
Function Import-PoorBackupSettings {
    <#
		.SYNOPSIS 
		Import PoorBackup Settings file into current PowerShell environment

		.DESCRIPTION
        Import PoorBackup Settings file into current PowerShell environment as global variable PoorBackupSettings
        
        .PARAMETER SettingsFile
        -SettingsFile string {full path to target xml file name, directory must exist}
        default value : $home\".PoorBackup\settings.xml"
	    full path to custom target xml settings file
		
		.OUTPUTS
		Deserialized.System.Management.Automation.PSCustomObject
		
		.EXAMPLE
		Import PoorBackup settings using default file and path
        C:\PS> Import-PoorBackupSettings
        
        .EXAMPLE
		Import PoorBackup settings using a specific config file
		C:\PS> Import-PoorBackupSettings -SettingsFile C:\tmp\mybackupstuff.xml
    #>
    [cmdletbinding()]
	Param (
      [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$false)]
      [ValidateScript({test-path "$($_)"})]
	    [string]$SettingsFile = (join-path $home ".PoorBackup\settings.xml")
    )
    process {
        if (!(test-path $SettingsFile)) {
            throw "$($SettingsFile) does not exist - Please use Set-PoorBackupSettings first to create your configuration file"
        }
        try {
            $global:PoorBackupSettings = Import-Clixml $SettingsFile
        } catch {
            write-error -message "Error Type: $($_.Exception.GetType().FullName)"
            write-error -message "Error Message: $($_.Exception.Message)"
        }
        if (!($global:PoorBackupSettings.LogDir -and $global:PoorBackupSettings.TargetBackupDir -and $global:PoorBackupSettings.ItemsToBackup)) {
            throw "XML file not valid. Please use Set-PoorBackupSettings cmdlet to generate it properly"
        } else {
            $global:PoorBackupSettings
        }
    }
}
Function Set-PoorBackupSettings {
    <#
		.SYNOPSIS 
		Set PoorBackup settings

		.DESCRIPTION
		Set PoorBackup settings (as global variable and external file) : Log directory, target backup directory, file and folder to backup, backup compression
		
        .PARAMETER LogDir
        -LogDir string {full path to target log directory, directory must exist}
        mandatory
        full path to target log directory

        .PARAMETER TargetBackupDir
        -TargetBackupDir string {full path to target backup directory, directory must exist}
        mandatory
        full path to target backup directory

        .PARAMETER SettingsFile
        -SettingsFile string {full path to target settings xml file, directory must exist}
        default value : $home\".PoorBackup\settings.xml"
        full path to target settings xml file

        .PARAMETER CompressBackup
        -CompressBackup switch
        Enable Backup as a zip file archive

        .PARAMETER ItemsToBackup
        -ItemsToBackup array of string
        mandatory
        List of items (file or folder) to backup

        .OUTPUTS
		System.IO.DirectoryInfo
        System.IO.FileInfo
		
		.EXAMPLE
		Backup "C:\Users\adm\Documents\GitHub","C:\Users\adm\Documents\Gitlab\","C:\Users\adm\Documents\file.ext" to C:\Backup with compression and log operations to c:\logs
		C:\PS> Set-PoorBackupSettings -LogDir c:\logs -TargetBackupDir C:\Backup -ItemsToBackup @("C:\Users\adm\Documents\GitHub","C:\Users\adm\Documents\Gitlab\","C:\Users\adm\Documents\file.ext") -CompressBackup
    #>
    [cmdletbinding()]
	Param (
      [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$false)]
      [ValidateScript({test-path "$($_)"})]
	    [string]$LogDir,
      [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$false)]
      [ValidateScript({test-path "$($_)"})]
		[string]$TargetBackupDir,
      [Parameter(Mandatory=$true,ValueFromPipelineByPropertyName=$false)]
      [ValidateScript({test-path "$($_)"})]
        [System.Collections.ArrayList]$ItemsToBackup,
      [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$false)]
        [switch]$CompressBackup,
      [Parameter(Mandatory=$false,ValueFromPipelineByPropertyName=$false)]
        [ValidateScript({test-path (split-path "$($_)")})]
        [string]$SettingsFile = (join-path $home ".PoorBackup\settings.xml")
    )
    process {
        if ($global:PoorBackupSettings) {
            $global:PoorBackupSettings = $null
        }
        if (!(test-path (join-path $home ".PoorBackup"))) {
            New-Item -Path (join-path $home ".PoorBackup") -Force -Type Directory | out-null
        }
        if (!(test-path (join-path $LogDir "PoorBackup"))) {
            New-Item (join-path $LogDir "PoorBackup") -Force -Type Directory | out-null
        }
        $LogDir = (join-path $LogDir "PoorBackup")
        if (!(test-path (join-path $TargetBackupDir "PoorBackup"))) {
            New-Item (join-path $TargetBackupDir "PoorBackup") -Force -Type Directory | out-null
        }
        $TargetBackupDir = (join-path $TargetBackupDir "PoorBackup")
        $global:PoorBackupSettings = New-Object psobject -Property @{
            LogDir = $LogDir
            TargetBackupDir = $TargetBackupDir
            ItemsToBackup = $ItemsToBackup
            CompressBackup = $CompressBackup
            SettingsFile = $SettingsFile
        }
        Export-Clixml -path "$($SettingsFile)" -InputObject $global:PoorBackupSettings -Force
        Get-Item "$($SettingsFile)"
    }
}
Function Add-ItemToPoorBackup {
    <#
		.SYNOPSIS 
		Add new item to backup list

		.DESCRIPTION
		Add new item (file or folder) to backup list
        
        .PARAMETER BackupItem
        -BackupItem String or System.IO
        mandatory
        new item to add to backup list

		.OUTPUTS
		System.String
		
		.EXAMPLE
		Add folder c:\important to backup list
        C:\PS> Add-ItemToPoorBackup -BackupItem "c:\important"

        .EXAMPLE
		Add folder c:\important to backup list (pipe mode)
        C:\PS> get-item "c:\important" | Add-ItemToPoorBackup
    #>
    [cmdletbinding()]
	Param (
      [Parameter(Mandatory=$true,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$true)]
      [ValidateScript({($_ -is [System.IO.DirectoryInfo]) -or ($_ -is [System.IO.FileInfo]) -or ($_ -is [System.String])})]
        $BackupItem
    )
    process {
        if (!($global:PoorBackupSettings.LogDir -and $global:PoorBackupSettings.TargetBackupDir -and $global:PoorBackupSettings.ItemsToBackup)) {
            throw "PoorBackupSettings does not exist. Please use Set-PoorBackupSettings cmdlet to generate it properly or use Import-PoorBackupSettings to load XML settings into memory"
        }
        $BackupItemType = $BackupItem | Get-Member | Select-Object -ExpandProperty TypeName -Unique
        switch ($BackupItemType) {
            System.IO.FileInfo {
                if ($BackupItem.fullname) {
                    if ($global:PoorBackupSettings.ItemsToBackup -notcontains $BackupItem.fullname) {
                        $global:PoorBackupSettings.ItemsToBackup.add($BackupItem.fullname)
                    }
                }
            }
            System.IO.DirectoryInfo {
                if ($BackupItem.fullname) {
                    if ($global:PoorBackupSettings.ItemsToBackup -notcontains $BackupItem.fullname) {
                        $global:PoorBackupSettings.ItemsToBackup.add($BackupItem.fullname)
                    }
                }
            }
            System.String {
                if ($global:PoorBackupSettings.ItemsToBackup -notcontains $BackupItem)  {
                    $global:PoorBackupSettings.ItemsToBackup.add($BackupItem)
                }
            }
        }
        $global:PoorBackupSettings.ItemsToBackup
    }
}
Function Remove-ItemFromPoorBackup {
    <#
		.SYNOPSIS 
		Remove new item from backup list

		.DESCRIPTION
		Remove new item (file or folder) from backup list
        
        .PARAMETER BackupItem
        -BackupItem String or System.IO
        mandatory
        current item to remove from backup list

		.OUTPUTS
		System.String
		
		.EXAMPLE
		Remove folder c:\important from backup list
        C:\PS> Remove-ItemFromPoorBackup -BackupItem "c:\important"

        .EXAMPLE
		Remove folder c:\important from backup list (pipe mode)
        C:\PS> get-item "c:\important" | Remove-ItemFromPoorBackup
    #>
    [cmdletbinding()]
	Param (
      [Parameter(Mandatory=$true,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$true)]
      [ValidateScript({($_ -is [System.IO.DirectoryInfo]) -or ($_ -is [System.IO.FileInfo]) -or ($_ -is [System.String])})]
        $BackupItem
    )
    Process {
        if (!($global:PoorBackupSettings.LogDir -and $global:PoorBackupSettings.TargetBackupDir -and $global:PoorBackupSettings.ItemsToBackup)) {
            throw "PoorBackupSettings does not exist. Please use Set-PoorBackupSettings cmdlet to generate it properly or use Import-PoorBackupSettings to load XML settings into memory"
        }
        $BackupItemType = $BackupItem | Get-Member | Select-Object -ExpandProperty TypeName -Unique
        switch ($BackupItemType) {
            System.IO.FileInfo {
                if ($BackupItem.fullname) {
                    if ($global:PoorBackupSettings.ItemsToBackup -contains $BackupItem.fullname) {
                        $global:PoorBackupSettings.ItemsToBackup.remove($BackupItem.fullname)
                    }
                }
            }
            System.IO.DirectoryInfo {
                if ($BackupItem.fullname) {
                    if ($global:PoorBackupSettings.ItemsToBackup -contains $BackupItem.fullname) {
                        $global:PoorBackupSettings.ItemsToBackup.remove($BackupItem.fullname)
                    }
                }
            }
            System.String {
                if ($global:PoorBackupSettings.ItemsToBackup -contains $BackupItem)  {
                    $global:PoorBackupSettings.ItemsToBackup.remove($BackupItem)
                }
            }
        }
        $global:PoorBackupSettings.ItemsToBackup
    }
}
function Write-PoorBackupLog {
    <#
		.SYNOPSIS 
		Write to log file

		.DESCRIPTION
		Write to log file
        
        .PARAMETER Message
        -Message string
        mandatory
        string to write to log file

        .PARAMETER Path
        -Path string {full path to target log file}
        mandatory
        full path to log file to write in

        .PARAMETER Level
        -Level string {"Error","Warn","Info"}
        default value : Info
        Type of information to log
        
		.OUTPUTS
		none
		
		.EXAMPLE
		Write "Hello world" as information to "c:\logs\test.log"
        C:\PS> Write-PoorBackupLog -Message "Hello world" -Path "c:\logs\test.log"
        
        .EXAMPLE
		Write "Bad world" as error to "c:\logs\test.log"
		C:\PS> Write-PoorBackupLog -Message "Bad world" -Path "c:\logs\test.log" -Level Error
    #> 
    [CmdletBinding()] 
    Param ( 
        [Parameter(Mandatory=$true, ValueFromPipeline=$True, ValueFromPipelineByPropertyName=$true)] 
        [ValidateNotNullOrEmpty()]
            [string]$Message, 
        [Parameter(Mandatory=$true)] 
            [string]$Path, 
        [Parameter(Mandatory=$false)] 
        [ValidateSet("Error","Warn","Info")] 
            [string]$Level="Info"
    ) 
    Process { 
        if (!(Test-Path $Path)) {
            Write-Verbose "Creating $($Path)." 
            New-Item $Path -Force -Type File | out-null
        } 
        $FormattedDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss" 
        try {
            "$($FormattedDate) $($Level.ToUpper()): $($Message)" | Out-File -FilePath $Path -Append
            Write-Debug "$($FormattedDate) $($Level.ToUpper()): $($Message)"
        } catch {
            write-error -message "Error Type: $($_.Exception.GetType().FullName)"
            write-error -message "Error Message: $($_.Exception.Message)"
        }
    } 
}

Export-ModuleMember Start-PoorBackup, Set-PoorBackupSettings, Add-ItemToPoorBackup, Remove-ItemFromPoorBackup, Import-PoorBackupSettings, Write-PoorBackupLog