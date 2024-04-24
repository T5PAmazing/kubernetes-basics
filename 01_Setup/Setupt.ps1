function ensureVSCinstall {
    param()
    begin {
        Write-Output "Checking for VS Code installation"
    }
    process {
        $paths = @(
            "$env:ProgramFiles\Microsoft VS Code\Code.exe",  # Typical path for system-wide installation
            "$env:LOCALAPPDATA\Programs\Microsoft VS Code\Code.exe"  # Typical path for user installation
        )

        # Check each path to see if the VS Code executable exists
        $vscodeInstalled = $false
        foreach ($path in $paths) {
            if (Test-Path $path) {
                $vscodeInstalled = $true
                Write-Output "VS Code is installed at $path"
                break
            }
        }

        if (-not $vscodeInstalled) {
            Write-Output "VS Code is not installed."
            cmd /c 	winget install -e --id Microsoft.VisualStudioCode
            Write-Output "VS Code is installed now!"
        }
    }
    end {
        Write-Output "VS Code present proceeding to next step."
    }
}



function hyperVcheck(){
    param()
    begin{
        Write-Output "Checking if Hyper-V is enabled"
    }
    process{
        $serviceName = "vmcompute"
        $serviceStatus = Get-Service -Name $serviceName

        if ($serviceStatus.Status -eq "Running") {
            Write-Output "Hyper-V is enabled and running."
            Restart-Computer        
        } else {
            Write-Output "Hyper-V service is not running. Hyper-V may not be enabled."
            Write-Output "Enabing Hyper-V now!"

            DISM /Online /Enable-Feature /All /FeatureName:Microsoft-Hyper-V
            Restart-Computer
           
        }
    }
    end{
        Write-Output "Hyper-V enabled!"
    }
}

function installChoco(){
    param()
    begin{
        Write-Output "Setting up execution policy"
        Set-ExecutionPolicy Bypass -Scope Process
    }
    process{
        Write-Output "install Choco"
        Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')) 
    }
    end{
        Write-Output "Choco installed"
    }
}

installChoco
ensureVSCinstall
hyperVcheck
