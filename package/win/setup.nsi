
!include "MUI2.nsh"
!include "EnvVarUpdate.nsh"

Name "OpenMono Developer Environment"
OutFile "OpenMonoSetup-v$%VERSION%-x$%ARCH%.exe"
InstallDir "c:\OpenMono"

!define MSVS_FILE "$%VCREDIST%"
Var INF_OEM

;Request application privileges for Windows Vista, 7, 8
RequestExecutionLevel admin

!include LogicLib.nsh

Function .onInit
UserInfo::GetAccountType
pop $0
${If} $0 != "admin" ;Require admin rights on NT4+
    MessageBox mb_iconstop "Administrator rights required!"
    SetErrorLevel 740 ;ERROR_ELEVATION_REQUIRED
    Quit
${EndIf}
FunctionEnd

!define MUI_ICON "windows.ico"
!define MUI_UNICON "windowsUninstall.ico"
!define MUI_BGCOLOR "ecf0f1"

; ---- Pages
!insertmacro MUI_PAGE_LICENSE "monoprog\src\LICENSE.txt"
!insertmacro MUI_PAGE_INSTFILES

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_LANGUAGE "English"

; ---- Sections

Section "Install" SecInstall

	SetOutPath $INSTDIR
	
	File "${MSVS_FILE}" 	
	ExecWait '"$INSTDIR\${MSVS_FILE}"  /passive /norestart'	

	File /r "dist\*"
	File "windows.ico"
	File "mono_psoc5_library\Generated_Source\PSoC5\USBUART_cdc.inf"

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

	!include x64.nsh
	${DisableX64FSRedirection}
	nsExec::ExecToLog '"$SYSDIR\PnPutil.exe" /a "$INSTDIR\USBUART_cdc.inf"' $0
	${EnableX64FSRedirection}

	Delete "$INSTDIR/${MSVS_FILE}"
SectionEnd

;Language strings
  LangString DESC_SecInstall ${LANG_ENGLISH} "A test section."

  ;Assign language strings to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SecInstall} $(DESC_SecInstall)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END

Section "Uninstall"
	${un.EnvVarUpdate} $0 "PATH" "R" "HKLM" "$INSTDIR"
	RMDir /r /REBOOTOK "$INSTDIR"
	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\OpenMono"
SectionEnd