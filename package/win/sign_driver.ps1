$env:Path += ";C:\Program Files (x86)\Windows Kits\8.1\bin\x64"
$env:Path += ";C:\Program Files (x86)\Windows Kits\10\bin\x86"

$FOLDER=$args[0]
$OSes="XP_X86,Vista_X86,Vista_X64,7_X86,7_X64,8_X86,8_X64,6_3_X86,6_3_X64,10_X86,10_X64"
Inf2Cat.exe /driver:$FOLDER /os:$OSes

$FILE = $args[1]
$CERT=$args[2]
$TSURL="http://timestamp.comodoca.com"
signtool.exe sign /v /f $CERT  /t $TSURL $FILE