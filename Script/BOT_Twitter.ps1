[string]$login = "login or mail or phone number"
[string]$mdp= "password"
$html = @"

Content of your tweet

"@
$ie = new-object -com "InternetExplorer.Application"
$ie.navigate("https://twitter.com/login?lang=en")
$ie.visible = $false
sleep 5

while($ie.ReadyState -ne 4) {start-sleep -m 100}     

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

$tweet=$ie.Document.DocumentElement.getElementsByClassName("js-global-new-tweet js-tooltip EdgeButton EdgeButton--primary js-dynamic-tooltip") | Select-Object -First 1
$tweet.click()
Start-Sleep(5)

$text=$ie.Document.DocumentElement.getElementsByTagName("div") | Where-Object {$_.classname -eq 'tweet-box rich-editor is-showPlaceholder'}
$txt2= $text.Document.DocumentElement.getElementsByTagName("p")
Foreach($element in $txt2)
    {
  
$element.outerText = $html

    } 

$applybtn=$ie.Document.DocumentElement.getElementsByClassName("SendTweetsButton EdgeButton EdgeButton--primary EdgeButton--medium js-send-tweets") | Select-Object -First 1

$applybtn.click()


