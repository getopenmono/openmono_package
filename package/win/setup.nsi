!include "EnvVarUpdate.nsh"

Name "OpenMono"
OutFile "OpenMonoSetup-v$%VERSION%-x64.exe"
InstallDir "$PROGRAMFILES\OpenMono"

Section "Install"
	SetOutPath $INSTDIR
	File /r "dist\*"
	# TODO: Find out how to extract the paths from environment.
	File "$%QTRUNTIME%\bin\Qt5Core.dll"
	File "C:\windows\system32\MSVCP100.DLL"
	File "C:\windows\system32\MSVCR100.DLL"
	${EnvVarUpdate} $0 "PATH" "A" "HKLM" "$INSTDIR\bin"
	WriteUninstaller "$INSTDIR\Uninstall.exe"
SectionEnd

Section "Uninstall"
	${un.EnvVarUpdate} $0 "PATH" "R" "HKLM" "$INSTDIR"
	Delete "$INSTDIR\Qt5Core.dll"
	Delete "$INSTDIR\MSVCP100.DLL"
	Delete "$INSTDIR\MSVCR100.DLL"
	Delete "$INSTDIR\monoprog.exe"
	Delete "$INSTDIR\Uninstall.exe"
	RMDir "$INSTDIR"
SectionEnd