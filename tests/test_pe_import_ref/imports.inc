; imports.inc

dllimp	macro	dllname

	ifdef	DIRECT_IMPORTS

	ifb	<dllname>
		option	dllimport:none
	else
		option	dllimport:<dllname>
	endif

	endif	; DIRECT_IMPORTS

endm


; Imports

dllimp	kernel32.dll

GetModuleHandleA	proto	lpModuleName:PCSTR
GetModuleHandle		textequ	<GetModuleHandleA>

GetCommandLineA		proto
GetCommandLine		textequ	<GetCommandLineA>

GetStartupInfoA		proto	lpStartupInfo:ptr
GetStartupInfoW		proto	lpStartupInfo:ptr
GetStartupInfo		textequ	<GetStartupInfoA>

OutputDebugStringA	proto	lpOutputString:PCSTR
OutputDebugStringW	proto	lpOutputString:PCWSTR
OutputDebugString	textequ	<OutputDebugStringA>

ExitProcess		proto	uExitCode:UINT


dllimp	msvcrt.dll

__getmainargs		proto	argc:ptr, argv:ptr, env:ptr, doWildCard:dword, startInfo:ptr
getmainargs		textequ	<__getmainargs>

printf			proto	format:ptr byte, :vararg
sprintf			proto	buffer:ptr byte, format:ptr byte, :vararg


dllimp	; required, dllimport terminator
