<# 
This Script has been created by SinJK

#>


$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())

if(Get-ScheduledTask | Select-Object TaskName | Where-Object {$_.TaskName -eq "twittos"}) 
{

    Write-host "existing"

} 

else
{

    if($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) -eq $true){

            Write-Host "Admin, OK, continuing"
            Write-host "not existing"
            Write-Host "Creating the task"

            $PSScriptRoot
            $hour = Read-Host "Enter the hour to schedule the script every day (ex: 8:00am)"
            $action = New-ScheduledTaskAction -Execute  C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -Argument "-File $PSScriptRoot\BOT_Twitter.ps1"
            $trigger = New-ScheduledTaskTrigger -At $hour -Daily
            $principal = New-ScheduledTaskPrincipal -UserID $env:USERNAME -LogonType ServiceAccount -RunLevel Highest
            $settings = New-ScheduledTaskSettingsSet -MultipleInstances Parallel

Register-ScheduledTask -TaskName "twittos" -Action $action -Trigger $trigger -Settings $settings -Principal $principal
   

}else
{

Write-Host "Please launch script as admin !!!"
Write-Host "Leaving the script ..."


exit
}
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
$ie.visible = $false

while ($ie.busy) {sleep -milliseconds 50}
$iex = $ie.Document.DocumentElement.getElementsByTagName("button") | Where-Object {$_.classname -eq 'submit EdgeButton EdgeButton--primary EdgeButtom--medium'}
if($iex.ToString() -eq [String]::Empty){

Write-host "deja connecté"
} else{


Write-host "connexion en cours"
$login = Read-Host "Enter a password for user account"
while($login -eq ""){
$login = Read-Host "Enter a your login"
}
$SecurePassword = Read-Host "Enter your password" -AsSecureString
while($SecurePassword -eq ""){
$SecurePassword = Read-Host "Enter your password" -AsSecureString
}            
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword)            
$PlainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)


Start-Sleep(2)
$log = $ie.document.DocumentElement.getElementsByTagName("input") | Where-Object {$_.name -eq 'session[username_or_email]'}
$pw = $ie.document.DocumentElement.getElementsByTagName("input") | Where-Object {$_.name -eq 'session[password]'}
Foreach($element in $log)
    {
        $element.value = $login
    } 
Foreach($element in $pw)
    {
        $element.value = $PlainPassword
    } 

$connect=$ie.Document.DocumentElement.getElementsByClassName("submit EdgeButton EdgeButton--primary EdgeButtom--medium") | Select-Object -First 1

$connect.click()
$PlainPassword = ""

}



while ($ie.busy) {sleep -milliseconds 50}

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

