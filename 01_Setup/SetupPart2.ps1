function checkDockerInstall(){
    param()
    begin{
        Write-Output ""
    }
    process{
        try {
            $dockerInfo = docker info
            Write-Output "Docker is installed. Here's some information: $dockerInfo"
        } catch {
            Write-Output "Docker is not installed on this system."
            Write-Output "Starting Installation Now!"

            choco install docker-desktop -y
            Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe"
        }
    }
    end{
        Write-Output "Docker installation finished and Docker deamon started"
    }
}

function checkandInstallkubectl(){
    param()
    begin{
        Write-Output "Check if kubectl is installed"
    }
    process{
        try{
            $kubeinfo = kubectl info 
            Write-Output "Kubectl is installed. Here's some information: $kubeinfo"
        
        }
        catch{
            Write-Output "No Kubectl installation found, installing now."
            choco install kubernetes-cli -y
        }
    }
    end{
        Write-Output "Kubectl ready."
    }
}

function installMinikube(){
    param(
    )
    begin{
        Write-Output "Checking for minikube installation"
    }
    process{
        try{
            minikube start        
        }catch{
            Write-Output "minikube not installed, installing and starting now"
            choco install minikube -y
            minikube start
        }
    }
    end{
        Write-Output "minikube cluster ready to go!"
    }
}





checkDockerInstall
checkandInstallkubectl
installMinikube
schtasks /delete /tn "RunScriptAfterReboot" /f