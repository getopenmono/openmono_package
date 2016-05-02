!include "EnvVarUpdate.nsh"

Name "OpenMono"
OutFile "OpenMonoSetup-v$%VERSION%-x64.exe"
InstallDir "c:\OpenMono"

Section "Install"
	SetOutPath $INSTDIR
	File /r "dist\*"
	# TODO: Find out how to extract the paths from environment.
	File "$%QTRUNTIME%\bin\Qt5Core.dll" "$INSTDIR/monoprog"
	File "$%QTRUNTIME%\bin\icudt53.dll" "$INSTDIR/monoprog"
	File "$%QTRUNTIME%\bin\icuin53.dll" "$INSTDIR/monoprog"
	File "$%QTRUNTIME%\bin\icuuc53.dll" "$INSTDIR/monoprog"
	File "C:\windows\system32\MSVCP120.DLL" "$INSTDIR/monoprog"
	File "C:\windows\system32\MSVCR120.DLL" "$INSTDIR/monoprog"
	${EnvVarUpdate} $0 "PATH" "A" "HKLM" "$INSTDIR\bin"
	WriteUninstaller "$INSTDIR\Uninstall.exe"
SectionEnd

Section "Uninstall"
	${un.EnvVarUpdate} $0 "PATH" "R" "HKLM" "$INSTDIR"
	RMDir /r /REBOOTOK "$INSTDIR"
SectionEnd