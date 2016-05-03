!include "EnvVarUpdate.nsh"

Name "OpenMono"
OutFile "OpenMonoSetup-v$%VERSION%-x64.exe"
InstallDir "c:\OpenMono"

!define MSVS_FILE "$%VCREDIST%"

;Request application privileges for Windows Vista, 7, 8
RequestExecutionLevel admin

Section "Install"

	SetOutPath $INSTDIR
	
	File "${MSVS_FILE}" 	
	ExecWait '"$INSTDIR\${MSVS_FILE}"  /passive /norestart'	

	File /r "dist\*"
	File "windows.ico"
	${EnvVarUpdate} $0 "PATH" "A" "HKLM" "$INSTDIR\bin"
	WriteUninstaller "$INSTDIR\Uninstall.exe"

	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\OpenMono" \
				 "DisplayName" "OpenMono Developer Environment"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\OpenMono" \
				 "UninstallString" "$\"$INSTDIR\Uninstall.exe$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\OpenMono" \
				 "DisplayIcon" "$\"$INSTDIR\windows.ico$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\OpenMono" \
				 "Publisher" "OpenMono (Monolit ApS)"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\OpenMono" \
				 "DisplayVersion" "$\"$%VERSION%$\""
				 WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\OpenMono" \
				 "EstimatedSize" "189000"

	Delete "$INSTDIR/${MSVS_FILE}"
SectionEnd

Section "Uninstall"
	${un.EnvVarUpdate} $0 "PATH" "R" "HKLM" "$INSTDIR"
	RMDir /r /REBOOTOK "$INSTDIR"

	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\OpenMono"
SectionEnd