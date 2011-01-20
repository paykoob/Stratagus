;
;    stargus.nsi - Windows NSIS Installer for Stargus
;    Copyright (C) 2010  Pali Rohár <pali.rohar@gmail.com>
;
;    This program is free software: you can redistribute it and/or modify
;    it under the terms of the GNU General Public License as published by
;    the Free Software Foundation, either version 2 of the License, or
;    (at your option) any later version.
;
;    This program is distributed in the hope that it will be useful,
;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;    GNU General Public License for more details.
;
;    You should have received a copy of the GNU General Public License
;    along with this program.  If not, see <http://www.gnu.org/licenses/>.
;
;

!include "MUI2.nsh"

;--------------------------------

!define NAME "Stargus"
!ifndef VERSION
!define VERSION "1.0"
!endif
;!define VIVERSION "2.2.5.5"
!define HOMEPAGE "http://stratagus.drodin.com"
!define LICENSE "GPL v2"
!define COPYRIGHT "Copyright (c) 1998-2010 by The Stratagus Project and Pali Rohar, Android Port - Dmitry Rodin"

;--------------------------------

!define ICON "contrib/stargus.ico"
!define STARTOOL "startool.exe"
!define MPQLIST "mpqlist.txt"
!define INSTALLER "${NAME}-${VERSION}-android.exe"
!define INSTALLDIR "C:\Stratagus\data.sc\"
!define LANGUAGE "English"

!ifdef AMD64
!undef INSTALLER
!define INSTALLER "${NAME}-${VERSION}-android-x86_64.exe"
!undef NAME
!define NAME "Stargus (64 bit)"
!endif

;--------------------------------

LangString INSTALLER_RUNNING ${LANG_ENGLISH} "${NAME} Installer is already running."

LangString EXTRACTDATA_FILES ${LANG_ENGLISH} "Extracting Starcraft data files..."
LangString EXTRACTDATA_FILES_FAILED ${LANG_ENGLISH} "Extracting Starcraft data files failed."

LangString EXTRACTDATA_PAGE_HEADER_TEXT ${LANG_ENGLISH} "Choose Starcraft Location"
LangString EXTRACTDATA_PAGE_HEADER_SUBTEXT ${LANG_ENGLISH} "Choose the folder in which are Starcraft data files."
LangString EXTRACTDATA_PAGE_TEXT_TOP ${LANG_ENGLISH} "Setup will extract Starcraft data files from the following folder. You can specify location of CD or install location of Starcraft data files. Note that you need the original Starcraft CD to extract the game data files."
LangString EXTRACTDATA_PAGE_TEXT_DESTINATION ${LANG_ENGLISH} "Source Folder"
LangString EXTRACTDATA_PAGE_NOT_VALID ${LANG_ENGLISH} "This is not valid Starcraft data directory. File $DATADIRinstall.exe does not exist."

!ifdef AMD64
LangString AMD64ONLY ${LANG_ENGLISH} "This version is for 64 bits computers only."
!endif

SetCompressor lzma

Var DATADIR
Var EXTRACTNEEDED

!define MUI_ICON "${ICON}"

!define MUI_ABORTWARNING
!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_FINISHPAGE_NOREBOOTSUPPORT

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "COPYING"
!insertmacro MUI_PAGE_DIRECTORY

!define MUI_PAGE_HEADER_TEXT "$(EXTRACTDATA_PAGE_HEADER_TEXT)"
!define MUI_PAGE_HEADER_SUBTEXT "$(EXTRACTDATA_PAGE_HEADER_SUBTEXT)"
!define MUI_DIRECTORYPAGE_TEXT_TOP "$(EXTRACTDATA_PAGE_TEXT_TOP)"
!define MUI_DIRECTORYPAGE_TEXT_DESTINATION "$(EXTRACTDATA_PAGE_TEXT_DESTINATION)"
!define MUI_DIRECTORYPAGE_VARIABLE $DATADIR
!define MUI_DIRECTORYPAGE_VERIFYONLEAVE
!define MUI_PAGE_CUSTOMFUNCTION_PRE PageExtractDataPre
!define MUI_PAGE_CUSTOMFUNCTION_SHOW PageExtractDataShow
!define MUI_PAGE_CUSTOMFUNCTION_LEAVE PageExtractDataLeave
!insertmacro MUI_PAGE_DIRECTORY

!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_LANGUAGE "${LANGUAGE}"

;--------------------------------

Name "${NAME}"
Icon "${ICON}"
OutFile "${INSTALLER}"
InstallDir "${INSTALLDIR}"

;VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription" "${NAME} Installer"
;VIAddVersionKey /LANG=${LANG_ENGLISH} "FileVersion" "${VERSION}"
;VIAddVersionKey /LANG=${LANG_ENGLISH} "InternalName" "${NAME} Installer"
;VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" "${COPYRIGHT}"
;VIAddVersionKey /LANG=${LANG_ENGLISH} "License" "${LICENSE}"
;VIAddVersionKey /LANG=${LANG_ENGLISH} "Homepage" "${HOMEPAGE}"
;VIAddVersionKey /LANG=${LANG_ENGLISH} "OriginalFilename" "${INSTALLER}"
;VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductName" "${NAME} Installer"
;VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductVersion" "${VERSION}"
;VIProductVersion "${VIVERSION}"

BrandingText "${NAME} - ${VERSION}  ${HOMEPAGE}"
ShowInstDetails Show
XPStyle on
RequestExecutionLevel admin

ReserveFile "${STARTOOL}"

;--------------------------------

Function .onInit

	System::Call 'kernel32::CreateMutexA(i 0, i 0, t "${NAME}") i .r1 ?e'
	Pop $0
	StrCmp $0 0 +3

	MessageBox MB_OK|MB_ICONEXCLAMATION "$(INSTALLER_RUNNING)"
	Abort

!ifdef AMD64

	System::Call "kernel32::GetCurrentProcess() i .s"
	System::Call "kernel32::IsWow64Process(i s, *i .r0)"
	IntCmp $0 0 0 0 +3

	MessageBox MB_OK|MB_ICONSTOP "$(AMD64ONLY)"
	Abort

!endif

	StrCpy $DATADIR "D:\"

FunctionEnd

;--------------------------------

Function PageExtractDataPre

	File "/oname=$TEMP\${STARTOOL}" "${STARTOOL}"

	ClearErrors
	FileOpen $0 "$INSTDIR\extracted" "r"
	IfErrors extract

	FileRead $0 $1
	FileClose $0

	ExecDos::exec /TOSTACK "$\"$TEMP\${STARTOOL}$\" -V"
	Pop $0
	Pop $2
	Delete "$TEMP\${STARTOOL}"

	StrCpy $2 "$2$\r$\n"
	IntCmp $0 0 0 0 extract
	StrCmp $1 $2 0 extract

	StrCpy $EXTRACTNEEDED "no"
	Abort

extract:

	StrCpy $EXTRACTNEEDED "yes"

FunctionEnd

Function PageExtractDataShow

	FindWindow $0 "#32770" "" $HWNDPARENT
	GetDlgItem $1 $0 1023
	ShowWindow $1 0
	GetDlgItem $1 $0 1024
	ShowWindow $1 0

FunctionEnd

Function PageExtractDataLeave

	IfFileExists "$DATADIR\install.exe" +3

	MessageBox MB_OK|MB_ICONSTOP "$(EXTRACTDATA_PAGE_NOT_VALID)"
	Abort

FunctionEnd

;--------------------------------

Section "${NAME}"

	SectionIn RO

	SetOutPath "$INSTDIR"
	File "${STARTOOL}"
	File "${MPQLIST}"

	SetOutPath "$INSTDIR\scripts"
	File /r /x .svn "scripts\"
	SetOutPath "$INSTDIR"

	CreateDirectory "$INSTDIR\graphics"
	CreateDirectory "$INSTDIR\graphics\tilesets"
	File "/oname=graphics\tilesets\fog.png" "contrib\fog.png"

    FileOpen $9 .nomedia w
    FileClose $9

SectionEnd

Section "${NAME}" ExtractData

	StrCmp "$EXTRACTNEEDED" "no" end

	AddSize 542920

	DetailPrint ""
	DetailPrint "$(EXTRACTDATA_FILES)"
	ExecDos::exec /DETAILED "$\"$INSTDIR\${STARTOOL}$\" $\"$DATADIR$\" $\"$INSTDIR$\""
	Pop $0

	Delete "$INSTDIR\${STARTOOL}"
	Delete "$INSTDIR\${MPQLIST}"

	IntCmp $0 0 +3

	MessageBox MB_OK|MB_ICONSTOP "$(EXTRACTDATA_FILES_FAILED)"
	Abort

	SetOutPath "$INSTDIR"

end:

SectionEnd

;--------------------------------

!packhdr "exehead.tmp" "upx -9 exehead.tmp"
;!finalize "gpg --armor --sign --detach-sig %1"

