# Description: Boxstarter Script
# Author: Microsoft
# Common dev settings for machine learning using Windows and Linux native tools

Disable-UAC

# Get the base URI path from the ScriptToCall value
$bstrappackage = "-bootstrapPackage"
$Boxstarter | Foreach-Object { write-host "The key name is $_.Key and value is $_.Value"  }

$helperUri = $Boxstarter['ScriptToCall']
write-host "ScriptToCall is $helperUri"

$strpos = $helperUri.IndexOf($bstrappackage)
$helperUri = $helperUri.Substring($strpos + $bstrappackage.Length)
$helperUri = $helperUri.TrimStart("'", " ")
$helperUri = $helperUri.TrimEnd("'", " ")
$helperUri = $helperUri.Substring(0, $helperUri.LastIndexOf("/"))
$helperUri += "/scripts"
write-host "helper script base URI is $helperUri"

function executeScript {
    Param ([string]$script)
    write-host "executing $helperUri/$script ..."
	iex ((new-object net.webclient).DownloadString("$helperUri/$script"))
}

#--- Setting up Windows ---
executeScript "SystemConfiguration.ps1";
# XXXYD TEMPORARY  executeScript "FileExplorerSettings.ps1";
# XXXYD TEMPORARY  executeScript "RemoveDefaultApps.ps1";
# XXXYD TEMPORARY  executeScript "CommonDevTools.ps1";
executeScript "VirtualizationTools.ps1";
executeScript "GetMLPythonSamplesOffGithub.ps1";

# TODO: now install additional ML tools inside the WSL distro once default user w/blank password is working
write-host "Installing tools inside the WSL distro..."
Ubuntu1804
echo "About to update"
sudo apt update 
echo "About to upgrade"
sudo apt upgrade 
echo "now updated, installing python and python-pip"
sudo apt install python3 python-pip 
echo " installing other python tools"
sudo apt install python-numpy python-scipy pandas
sudo pip install -U scikit-learn
echo "Finished installing tools inside the WSL distro"
exit 

Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula
