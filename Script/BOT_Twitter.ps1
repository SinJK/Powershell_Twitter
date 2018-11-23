$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())

if($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) -eq $true){

Write-Host "Admin, OK, continuing"

if(Get-ScheduledTask | Select-Object TaskName | Where-Object {$_.TaskName -eq "twittos"}) {

Write-host "existing"

} else{
Write-host "not existing"
Write-Host "Creating the task"

$PSScriptRoot

$action = New-ScheduledTaskAction -Execute  C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -Argument "-File $PSScriptRoot\BOT_Twitter.ps1"
$trigger = New-ScheduledTaskTrigger -At 12:40pm -Daily
$principal = New-ScheduledTaskPrincipal -UserID $env:USERNAME -LogonType ServiceAccount -RunLevel Highest
$settings = New-ScheduledTaskSettingsSet -MultipleInstances Parallel

Register-ScheduledTask -TaskName "twittos" -Action $action -Trigger $trigger -Settings $settings -Principal $principal
   

}

if(Get-Process -Name iexplore -ErrorAction SilentlyContinue){
Write-Host "Closing explorer process"
Stop-Process -Name iexplore -Force
}
else{
Write-Host "No explorer detected"
Write-Host "Continuing"
}


[string]$login = "login or email"
[string]$mdp= "password"
$html = @"
Content of your tweetssssss

"@
$ie = new-object -com "InternetExplorer.Application"
$ie.navigate("https://twitter.com/login")
$ie.visible = $true

while ($ie.busy) {sleep -milliseconds 50}
$iex = $ie.Document.DocumentElement.getElementsByTagName("button") | Where-Object {$_.classname -eq 'submit EdgeButton EdgeButton--primary EdgeButtom--medium'}
if($iex.ToString() -eq [String]::Empty){

Write-host "deja connecté"
} else{


Write-host "connexion en cours"
$log = $ie.document.DocumentElement.getElementsByTagName("input") | Where-Object {$_.name -eq 'session[username_or_email]'}
$pw = $ie.document.DocumentElement.getElementsByTagName("input") | Where-Object {$_.name -eq 'session[password]'}
Foreach($element in $log)
    {
        $element.value = $login
    } 
Foreach($element in $pw)
    {
        $element.value = $mdp
    } 

$connect=$ie.Document.DocumentElement.getElementsByClassName("submit EdgeButton EdgeButton--primary EdgeButtom--medium") | Select-Object -First 1

$connect.click()


}


}
else
{

Write-Host "Please launch script as admin !!!"
Write-Host "Leaving the script ..."


exit
}


$tweet=$ie.Document.DocumentElement.getElementsByClassName("js-global-new-tweet js-tooltip EdgeButton EdgeButton--primary js-dynamic-tooltip") | Select-Object -First 1
$tweet.click()


$text=$ie.Document.DocumentElement.getElementsByTagName("div") | Where-Object {$_.classname -eq 'tweet-box rich-editor is-showPlaceholder'}
$txt2= $text.Document.DocumentElement.getElementsByTagName("p")
Foreach($element in $txt2)
    {
  
$element.outerText = $html

    } 

$applybtn=$ie.Document.DocumentElement.getElementsByClassName("SendTweetsButton EdgeButton EdgeButton--primary EdgeButton--medium js-send-tweets") | Select-Object -First 1

$applybtn.click()

Start-Sleep(3)

$ie.Quit()

