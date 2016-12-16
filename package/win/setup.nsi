
!include "MUI2.nsh"
!include "EnvVarUpdate.nsh"

!define MUI_PRODUCT "OpenMono SDK"
!define MUI_NAME "Monomake"
!define MUI_FILE "Monomake-UI.exe"
!define MUI_VERSION "$%VERSION%"
Name "${MUI_PRODUCT}"
OutFile "OpenMonoSetup-v${MUI_VERSION}.exe"
InstallDir "c:\OpenMono"

!define MSVS_FILE "$%VCREDIST%"
Var INF_OEM

;Request application privileges for Windows Vista, 7, 8
RequestExecutionLevel admin

!include LogicLib.nsh

!define MUI_ICON "install_icon.ico"
!define MUI_UNICON "windowsUninstall.ico"
!define MUI_BGCOLOR "ecf0f1"

; ---- Pages

; Installer
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

; Uninstaller
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_LANGUAGE "English" 

; ---- Sections

Section "SDK (Required)" SecInstall
	SectionIn RO
	SetOutPath $INSTDIR
	
	File "${MSVS_FILE}" 	
	ExecWait '"$INSTDIR\${MSVS_FILE}"  /passive /norestart'	

	File /r "dist\*"
	File "install_icon.ico"
	File "USBUART_cdc.inf"
	File "USBUART_cdc.cat"

	${EnvVarUpdate} $0 "PATH" "A" "HKLM" "$INSTDIR\bin"
	WriteUninstaller "$INSTDIR\Uninstall.exe"

	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\OpenMono" \
				 "DisplayName" "OpenMono SDK"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\OpenMono" \
				 "UninstallString" "$\"$INSTDIR\Uninstall.exe$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\OpenMono" \
				 "DisplayIcon" "$\"$INSTDIR\install_icon.ico$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\OpenMono" \
				 "Publisher" "OpenMono (Monolit ApS)"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\OpenMono" \
				 "DisplayVersion" "${VERSION}"
				 WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\OpenMono" \
				 "EstimatedSize" "200000"

	!include x64.nsh
	${DisableX64FSRedirection}
	nsExec::ExecToLog '"$SYSDIR\PnPutil.exe" /i /a "$INSTDIR\USBUART_cdc.inf"' $0
	${EnableX64FSRedirection}

	Delete "$INSTDIR/${MSVS_FILE}"
SectionEnd

Section "Monomake GUI" SecMonomakeUI
	File /r "win-ia32-unpacked\*"
	CreateShortCut  "$SMPROGRAMS\${MUI_NAME}.lnk" "$INSTDIR\${MUI_FILE}" "" "$INSTDIR\${MUI_FILE}" 0
SectionEnd

Section "ELF File Association" SecFileAssoc
	File "elf.ico"

	; Register ELF file association
	WriteRegStr HKCU "Software\Classes\.elf" "" "OpenMono.Application"
	WriteRegStr HKCU "Software\Classes\OpenMono.Application" "" "Mono Application"
	WriteRegStr HKCU "Software\Classes\OpenMono.Application\DefaultIcon" "" "$INSTDIR\elf.ico"
	WriteRegStr HKCU "Software\Classes\OpenMono.Application\shell\open\command" "" '"$INSTDIR\${MUI_FILE}" "%1"'
SectionEnd

Section  "MonoKiosk Integration" SecUrlAssoc
	; Register openmono URL protocol association
	WriteRegStr HKCU "Software\Classes\openmono" "" "URL:openmono"
	WriteRegStr HKCU "Software\Classes\openmono" "URL Protocol" ""
	WriteRegStr HKCU "Software\Classes\openmono\shell\open\command" "" '"$INSTDIR\${MUI_FILE}" "%1"'
SectionEnd


;Language strings
LangString DESC_SecInstall ${LANG_ENGLISH} "The required SDK:$\n - Monomake cmd.line.$\n - Monoprog$\n - ARM GCC Embedded$\n - Mono Framework$\n - Gnu Make Tools"
LangString DESC_SecMonomakeUI ${LANG_ENGLISH} "Graphical User Interface for installing application on Mono and create mono application projects."
LangString DESC_SecFileAssoc ${LANG_ENGLISH} "Installa mono application by opening an ELF file"
LangString DESC_SecUrlAssoc ${LANG_ENGLISH} "Associate with the URL openmono:// to Monomake, to enable one-click installs from MonoKiosk"

;Assign language strings to sections
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
!insertmacro MUI_DESCRIPTION_TEXT ${SecInstall} $(DESC_SecInstall)
!insertmacro MUI_DESCRIPTION_TEXT ${SecMonomakeUI} $(DESC_SecMonomakeUI)
!insertmacro MUI_DESCRIPTION_TEXT ${SecFileAssoc} $(DESC_SecFileAssoc)
!insertmacro MUI_DESCRIPTION_TEXT ${SecUrlAssoc} $(DESC_SecUrlAssoc)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

Section "Uninstall"
	${un.EnvVarUpdate} $0 "PATH" "R" "HKLM" "$INSTDIR"
	RMDir /r /REBOOTOK "$INSTDIR"

	; Delete associations
	DeleteRegKey HKCU "Software\Classes\.elf"
	DeleteRegKey HKCU "Software\Classes\OpenMono.Application"
	DeleteRegKey HKCU "Software\Classes\openmono"

	;Delete Start Menu Shortcuts
 	Delete "$DESKTOP\${MUI_PRODUCT}.lnk"
 	Delete "$SMPROGRAMS\${MUI_PRODUCT}"

	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\OpenMono"
SectionEnd

Var IndependentSectionState

Function .onInit
UserInfo::GetAccountType
pop $0
${If} $0 != "admin" ;Require admin rights on NT4+
    MessageBox mb_iconstop "Administrator rights required!"
    SetErrorLevel 740 ;ERROR_ELEVATION_REQUIRED
    Quit
${EndIf}

	SectionGetFlags ${SecMonomakeUI} $R0
	IntOp $R0 $R0 & ${SF_SELECTED}
	StrCpy $IndependentSectionState $R0

FunctionEnd

Function .onSelChange
Push $R0
Push $R1
 
  # Check if SecMonomakeUI was just selected then select SecFileAssoc and SecUrlAssoc.
  SectionGetFlags ${SecMonomakeUI} $R0
  IntOp $R0 $R0 & ${SF_SELECTED}
  StrCmp $R0 $IndependentSectionState +3
    StrCpy $IndependentSectionState $R0
  Goto UnselectDependentSections
    StrCpy $IndependentSectionState $R0
 
  Goto CheckDependentSections
 
  # Select SecMonomakeUI if SecFileAssoc or SecUrlAssoc was selected.
  SelectIndependentSection:
 
    SectionGetFlags ${SecMonomakeUI} $R0
    IntOp $R1 $R0 & ${SF_SELECTED}
    StrCmp $R1 ${SF_SELECTED} +3
 
    IntOp $R0 $R0 | ${SF_SELECTED}
    SectionSetFlags ${SecMonomakeUI} $R0
 
    StrCpy $IndependentSectionState ${SF_SELECTED}
 
  Goto End
 
  # Were SecFileAssoc or SecUrlAssoc just unselected?
  CheckDependentSections:
 
  SectionGetFlags ${SecFileAssoc} $R0
  IntOp $R0 $R0 & ${SF_SELECTED}
  StrCmp $R0 ${SF_SELECTED} SelectIndependentSection
 
  SectionGetFlags ${SecUrlAssoc} $R0
  IntOp $R0 $R0 & ${SF_SELECTED}
  StrCmp $R0 ${SF_SELECTED} SelectIndependentSection
 
  Goto End
 
  # Unselect SecFileAssoc and SecUrlAssoc if SecMonomakeUI was unselected.
  UnselectDependentSections:
 
    SectionGetFlags ${SecFileAssoc} $R0
    IntOp $R1 $R0 & ${SF_SELECTED}
    StrCmp $R1 ${SF_SELECTED} 0 +3
 
    IntOp $R0 $R0 ^ ${SF_SELECTED}
    SectionSetFlags ${SecFileAssoc} $R0
 
    SectionGetFlags ${SecUrlAssoc} $R0
    IntOp $R1 $R0 & ${SF_SELECTED}
    StrCmp $R1 ${SF_SELECTED} 0 +3
 
    IntOp $R0 $R0 ^ ${SF_SELECTED}
    SectionSetFlags ${SecUrlAssoc} $R0
 
  End:
 
Pop $R1
Pop $R0
FunctionEnd


