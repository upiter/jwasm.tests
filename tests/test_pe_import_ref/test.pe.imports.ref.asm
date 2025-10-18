; test.pe.imports.ref.asm

; Import data reference

; Build:
; jwasm -pe test.pe.imports.ref.asm
; make


title	pe_imports

.errndef	__JWASM__, "JWasm compatible assembler required!"


; Options

PE_IMP_REF	equ	1
; DIRECT_IMPORTS	equ	1


.x64
.model	flat, fastcall
option	casemap:none

option	procalign:16

option	frame:auto
option	win64:3


; Types
include		defs.inc


; Imports
; ifdef	DIRECT_IMPORTS
include		imports.inc
; else
; include	kernel32.inc
; include	msvcrt.inc

ifndef	DIRECT_IMPORTS
includelib	kernel32.lib
includelib	msvcrt.lib
endif


; OutputDebugString
fn_OutputDebugString	typedef	proto	msg:ptr
pfn_OutputDebugString	typedef ptr	fn_OutputDebugString

DBG_API	struct
	OutputDebugString	pfn_OutputDebugString	?
	OutputDebugStringW	pfn_OutputDebugString	?
DBG_API	ends


.data

AppName			db	"Import reference", 0
szFmt			db	"Address @ %p", 0

Public	AsmVersion
AsmVersion		dd	__JWASM__	; VER_MAJOR * 100 + VER_MINOR
szAsmVerFmt		db	"JWasm version: %d.%d (%d)", 0

align	10h

; Testing direct import reference
Public	DbgApi
DbgApi			DBG_API	<OutputDebugStringA, OutputDebugStringW>

align	10h

; Direct import address
; pOutputDebugStringA	dq	_imp__OutputDebugStringA


.data?

hInstance		HINSTANCE	?
CommandLine		PSTR		?

align	10h
strBuffer		db 200h dup (?)


.code

print	proc EFRAME	uses rsi msg:ptr

	Local	strLf	:QWORD

	mov	rsi, rcx
	invoke	OutputDebugString, rcx
	invoke	printf, rsi

	lea	rcx, strLf
	mov	eax, 0Ah	; LF
	mov	[rcx], eax
	invoke	printf, rcx

	ret

print	endp


div100	equ	0A3D70A3Dh

Public	asm_ver
asm_ver	proc EFRAME	version:DWORD

	; mov	ecx, version
	mov	eax, ecx

	; mov
	mov	edx, div100
	inc	eax
	mul	edx
	shr	edx, 6

	mov	r8d, edx	; major version

	mov	eax, edx
	mov	edx, 100
	mul	edx

	mov	r9d, ecx
	sub	r9d, eax	; minor version

	invoke	sprintf, addr strBuffer, addr szAsmVerFmt, r8d, r9d, ecx
	lea	rax, strBuffer

	ret

asm_ver	endp


public	main
main	proc EFRAME	hInst:HINSTANCE, CmdLine:PSTR

	invoke	print, addr AppName

	; JWasm assembler version
	invoke	asm_ver, AsmVersion
	invoke	print, rax

	invoke	sprintf, addr strBuffer, addr szFmt, DbgApi.OutputDebugString
	invoke	print, addr strBuffer

	mov	rdx, DbgApi.OutputDebugString
	.if	rdx
		xor	eax, eax
	.else
		or	al, -1
	.endif

	ret

main	endp


start	proc

	xor	ecx, ecx
	invoke	GetModuleHandle, rcx
	mov	hInstance, rax

	invoke	GetCommandLineA
	mov	CommandLine, rax

	invoke	main, hInstance, rax
	invoke	ExitProcess, eax

	ret

start	endp

end	start

; vim:set ts=8 sw=8
