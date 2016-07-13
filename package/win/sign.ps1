$env:Path += ";C:\Program Files (x86)\Windows Kits\8.1\bin\x64"
$CERT = $args[0]
$FILE = $args[1]
$TSURL = "http://timestamp.comodoca.com"
Write-Host "Signing $FILE Using certificate: $CERT..."
#$PASS = Read-Host -assecurestring "PFX Password"
#/p $PASS
signtool.exe sign /f $CERT /t $TSURL $FILE
