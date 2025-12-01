; Memvid Windows Installer
; Simple installer that adds memvid.exe to PATH

!define APP_NAME "Memvid"
!define APP_VERSION "0.1.6"
!define APP_PUBLISHER "Memvid"
!define APP_EXECUTABLE "memvid.exe"
!define APP_SOURCE "memorycli.exe"
!define INSTALL_DIR "$PROGRAMFILES\Memvid"

; Modern UI
!include "MUI2.nsh"

; Installer settings
Name "${APP_NAME}"
OutFile "memvid-installer.exe"
InstallDir "${INSTALL_DIR}"
RequestExecutionLevel admin

; Interface settings
!define MUI_ABORTWARNING
!define MUI_WELCOMEPAGE_TITLE "Welcome to Memvid CLI"
!define MUI_WELCOMEPAGE_TEXT "The Memvid CLI is the primary developer tool for creating, inspecting, indexing, and querying$\r$\nMemvid v2 (.mv2) memory files. It provides a safe, offline-first, and deterministic workflow for$\r$\nbuilding and managing portable AI memory.$\r$\n$\r$\nThe installer will set up the Memvid CLI on your system and optionally add it to your PATH so you$\r$\ncan run \"memvid\" from any command prompt.$\r$\n$\r$\nClick Next to continue."
; Custom logo on welcome and finish pages
!define MUI_WELCOMEFINISHPAGE_BITMAP "logo.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "logo.bmp"
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"

; Pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "..\LICENSE"
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_LANGUAGE "English"

; Function to add to PATH
Function AddToPath
    Exch $0
    Push $1
    Push $2
    Push $3
    
    ; Read the current PATH from registry
    ReadRegStr $1 HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "Path"
    
    ; Check if already in PATH
    Push "$1;"
    Push "$0;"
    Call StrStr
    Pop $2
    StrCmp $2 "" 0 AddToPath_done
    
    ; Check if already in PATH (without semicolon)
    Push "$1;"
    Push "$0\;"
    Call StrStr
    Pop $2
    StrCmp $2 "" 0 AddToPath_done
    
    ; Add to PATH
    StrCpy $2 "$1;$0"
    WriteRegExpandStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "Path" $2
    SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000
    
    AddToPath_done:
    Pop $3
    Pop $2
    Pop $1
    Pop $0
FunctionEnd

; Function to remove from PATH
Function un.RemoveFromPath
    Exch $0
    Push $1
    Push $2
    Push $3
    Push $4
    Push $5
    Push $6
    
    ReadRegStr $1 HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "Path"
    
    StrCpy $5 $1 1 -1 ; copy last char
    StrCmp $5 ";" +2 ; if last char != ;
        StrCpy $1 "$1;" ; append ;
    Push $1
    Push "$0;"
    Call un.StrStr ; Find `$0;` in $1
    Pop $2 ; pos
    StrCmp $2 "" unRemoveFromPath_done
        ; else, it is in path
        ; $2 is now the pos of the start of $0; in $1
        ; copy the part before $2
        StrCpy $3 $1 $2
        StrLen $6 "$0;"
        IntOp $2 $2 + $6 ; move $2 to after $0;
        StrCpy $4 $1 "" $2 ; copy the part after $0;
        StrCpy $3 "$3$4"
        StrCpy $5 $3 1 -1 ; copy last char
        StrCmp $5 ";" 0 +2 ; if last char == ;
            StrCpy $3 $3 -1 ; remove last char
        WriteRegExpandStr HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment" "Path" $3
        SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000
    
    unRemoveFromPath_done:
    Pop $6
    Pop $5
    Pop $4
    Pop $3
    Pop $2
    Pop $1
    Pop $0
FunctionEnd

; Helper function to find substring
Function StrStr
    Exch $R1 ; st=haystack,old$R1, $R1=needle
    Exch    ; st=old$R1,haystack, $R1=needle
    Exch $R2 ; st=old$R1,old$R2, $R1=haystack, $R2=needle
    Push $R3
    Push $R4
    Push $R5
    StrLen $R3 $R1
    StrCpy $R4 0
    loop:
        StrCpy $R5 $R2 $R3 $R4
        StrCmp $R5 $R1 done
        StrCmp $R5 "" done
        IntOp $R4 $R4 + 1
        Goto loop
    done:
        StrCpy $R1 $R2 "" $R4
        Pop $R5
        Pop $R4
        Pop $R3
        Pop $R2
        Exch $R1
FunctionEnd

Function un.StrStr
    Exch $R1 ; st=haystack,old$R1, $R1=needle
    Exch    ; st=old$R1,haystack, $R1=needle
    Exch $R2 ; st=old$R1,old$R2, $R1=haystack, $R2=needle
    Push $R3
    Push $R4
    Push $R5
    StrLen $R3 $R1
    StrCpy $R4 0
    loop:
        StrCpy $R5 $R2 $R3 $R4
        StrCmp $R5 $R1 done
        StrCmp $R5 "" done
        IntOp $R4 $R4 + 1
        Goto loop
    done:
        StrCpy $R1 $R2 "" $R4
        Pop $R5
        Pop $R4
        Pop $R3
        Pop $R2
        Exch $R1
FunctionEnd

; Installer section
Section "Install" SecInstall
    SetOutPath "$INSTDIR"
    
    ; Copy the executable (rename from memorycli.exe to memvid.exe)
    File "${APP_SOURCE}"
    Rename "$INSTDIR\memorycli.exe" "$INSTDIR\${APP_EXECUTABLE}"
    
    ; Add to PATH
    Push "$INSTDIR"
    Call AddToPath
    
    ; Create uninstaller
    WriteUninstaller "$INSTDIR\Uninstall.exe"
    
    ; Registry entries for Add/Remove Programs
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" \
        "DisplayName" "${APP_NAME}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" \
        "UninstallString" "$INSTDIR\Uninstall.exe"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" \
        "Publisher" "${APP_PUBLISHER}"
    WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}" \
        "DisplayVersion" "${APP_VERSION}"
SectionEnd

; Uninstaller section
Section "Uninstall"
    ; Remove from PATH
    Push "$INSTDIR"
    Call un.RemoveFromPath
    
    ; Delete files
    Delete "$INSTDIR\${APP_EXECUTABLE}"
    Delete "$INSTDIR\Uninstall.exe"
    RMDir "$INSTDIR"
    
    ; Remove registry entries
    DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}"
SectionEnd

