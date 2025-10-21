; test.err.A2202.asm

; Test for Error A2202
; Error A2202: Output format doesn't support externals

; Build:
; make

; Test OK:
; jwasm -pe -Fo=test_ok test.err.A2202.asm

; Test FAIL:
; jwasm -pe -Fo=test_fail -DDIRECT_CALL=1 test.err.A2202.asm

; Compiles OK only if DIRECT_CALL is not defined

; Tested with:
; JWasm v2.19, Jan 24 2025

; Contact:
; Jupiter
; https://github.com/upiter


title	<test.err.A2202>

.errndef	__JWASM__, "JWasm compatible assembler required!"


.386
.model	flat, stdcall


; Options

; DIRECT_CALL		equ	1
; DIRECT_CALL_FIX		equ	1


; Defs
NULL			equ	0
PSTR			typedef	ptr byte

LF			equ	10
CR			equ	13
EOL			equ	<CR, LF>


; Imports

option dllimport:<kernel32.dll>

GetCommandLineA		proto
GetModuleHandleA	proto	:PSTR
ExitProcess		proto	:DWORD

GetCommandLine		equ	<GetCommandLineA>
GetModuleHandle		equ	<GetModuleHandleA>


option dllimport:<msvcrt.dll>

printf			proto C	:ptr byte, :VARARG


option dllimport:none


ifdef	DIRECT_CALL_FIX

externdef	_imp__GetCommandLineA@0: ptr proc
externdef	_imp__GetModuleHandleA@4: ptr proc
externdef	_imp__ExitProcess@4: ptr proc

externdef C	_imp__printf: ptr proc

; includelib	kernel32.lib
; includelib	msvcrt.lib

endif	; DIRECT_CALL_FIX


.data

strAppTitle		db	'JWASM TEST: Direct Call', EOL, 0

public	AsmVersion
AsmVersion		dd	__JWASM__	; VER_MAJOR * 100 + VER_MINOR
; strAsmVerFmt		db	"JWasm version: %d.%d (%d)", 0


.data?

hInstance		dd	?
pCommandLine		PSTR	?


.code

start	proc

	ifndef	DIRECT_CALL

	invoke	GetModuleHandle, NULL
	mov	hInstance, eax

	invoke	GetCommandLine
	mov	pCommandLine, eax

	invoke	printf, addr strAppTitle
	invoke	printf, pCommandLine

	invoke	ExitProcess, 0

	else	; DIRECT_CALL

	ifndef	DIRECT_CALL_FIX

		push	NULL
		call	GetModuleHandle
		mov	hInstance, eax

		call	GetCommandLine
		mov	pCommandLine, eax

		push	offset strAppTitle
		call	printf
		add	esp, 4*1

		push	pCommandLine
		call	printf
		add	esp, 4*1

		push	0
		call	ExitProcess

	else	; DIRECT_CALL_FIX

		push	NULL
		call	_imp__GetModuleHandleA@4
		mov	hInstance, eax

		call	_imp__GetCommandLineA@0
		mov	pCommandLine, eax

		push	offset strAppTitle
		call	_imp__printf
		add	esp, 4*1

		push	pCommandLine
		call	_imp__printf
		add	esp, 4*1

		push	0
		call	_imp__ExitProcess@4

	endif	; DIRECT_CALL_FIX

	endif	; DIRECT_CALL

start	endp

end	start


; vim:set ts=8 sw=8
