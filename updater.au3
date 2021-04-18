;Leech GWCA OPCODES - List Comprehension

#include <InetConstants.au3>
#include <MsgBoxConstants.au3>
#include <WinAPIFiles.au3>
#include <FileConstants.au3>

Leech()

Func Leech()
    ; Save the downloaded file to the temporary folder.
    Local $sFilePath = _WinAPI_GetTempFileName(@ScriptDir)

	Const $url = "https://raw.githubusercontent.com/GregLando113/GWCA/master/Include/GWCA/Packets/Opcodes.h"

    ; Download the file by waiting for it to complete. The option of 'get the file from the local cache' has been selected.
    Local $iBytesSize = InetGet($url, $sFilePath, $INET_FORCERELOAD)

	; Open the file for reading and store the handle to a variable.
    Local $hFileOpen = FileOpen($sFilePath, $FO_READ)
    If $hFileOpen = -1 Then
        MsgBox($MB_SYSTEMMODAL, "", "An error occurred when reading the file.")
        Return False
	 EndIf

   Local $oldstub = "updatestub.au3"
   Local $oldbackupstub = @ScriptDir &"\updatestub_old.au3"
   ; Create file in same folder as script
   $sFileName = @ScriptDir &"\updatestub.au3"

   If FileExists($oldstub) Then
	  If FileExists("updatestub_old.au3") Then FileDelete($oldbackupstub)
	  FileMove($oldstub, "updatestub_old.au3")
   EndIf


    ; Open file - deleting any existing content
   $hFilehandle = FileOpen($sFileName, $FO_OVERWRITE)
   ; Prove it exists
   If FileExists($sFileName) Then
   ; MsgBox($MB_SYSTEMMODAL, "File", "Exists")
   Else
    MsgBox($MB_SYSTEMMODAL, "File", "Does not exist")
   EndIf

   While 1
    Local $line = FileReadLine($hFileOpen)
	If @error = -1 Then ExitLoop
	Local $strip

	$strip =  StringRegExpReplace($line, "#pragma once", "")
	$strip =  StringRegExpReplace($strip, "#define ", "$")
	$strip =  StringRegExpReplace($strip, "//.*", @CRLF)
	$strip = StringStripWS($strip, $STR_STRIPALL)
	$strip =  StringRegExpReplace($strip, "\)", @CRLF)
	$strip =  StringRegExpReplace($strip, "\(", " = ")
	$strip =  StringRegExpReplace($strip, "\$", "Global Const $")
	$strip = StringRegExpReplace($strip, "Global Const \$GAME_SMSG_.*", "")
	$strip = StringRegExpReplace($strip, "GAME_CMSG", "HEADER")

	FileWrite($hFilehandle, $strip)
   WEnd

   ;clean up file handles
    FileClose($hFileOpen)
	FileClose($hFilehandle)

    ; Delete temp file from inet library
    FileDelete($sFilePath)


 EndFunc   ;==>LEECH
