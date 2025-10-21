# JWasm Test Suite

SOURCE:=$(firstword $(wildcard test.*.asm))
SOURCE?=test.pe.import.ref.asm


OBJ_OK=test_ok.obj
OBJ_FAIL=test_fail.obj
OBJ_FIX=test_fix.obj


# WINE=wine 
WINE?=

AS=$(WINE)jwasm
LD=$(WINE)jwlink
ARCHIVER=7z


ASM64_BASE?=/masm64

ASM64_INC=$(ASM64_BASE)/include64/
ASM64_MACROS=$(ASM64_BASE)/macros64/
ASM64_LIB=$(ASM64_BASE)/lib64/


.PHONY:	test
.PHONY:	diff env run clean help pack


all:	test diff run


test:	test_ok.exe test_fail.exe test_fix.exe


$(OBJ_OK):	$(SOURCE)
	$(AS) -q -coff -zzs -zze -I=$(ASM64_INC) -I=$(ASM64_MACROS) -nm=test -Fd -Fo=$@ -Fl=test_ok.lst -Sg $<


$(OBJ_FAIL):	$(SOURCE)
	$(AS) -q -coff -zzs -zze -I=$(ASM64_INC) -I=$(ASM64_MACROS) -nm=test -Fd -Fo=$@ -Fl=test_fail.lst -Sg -DDIRECT_IMPORTS $< || true


$(OBJ_FIX):	$(SOURCE)
	$(AS) -q -coff -zzs -zze -I=$(ASM64_INC) -I=$(ASM64_MACROS) -nm=test -Fd -Fo=$@ -Fl=test_fix.lst -Sg -DDIRECT_IMPORTS -DDIRECT_IMPORTS_FIX $< || true


test_ok.exe:	$(OBJ_OK)
	$(LD) @test.link system ok libpath $(ASM64_LIB) file $^


test_fail.exe:	$(OBJ_FAIL)
	$(LD) @test.link system fail libpath $(ASM64_LIB) file $^ || true


test_fix.exe:	$(OBJ_FIX)
	$(LD) @test.link system fix libpath $(ASM64_LIB) file $^ || true


diff:
	diff test_ok.lst test_fail.lst >tests.diff || true


env:
	@echo ASM64 base: $(ASM64_BASE)
	@echo Includes: $(ASM64_INC)
	@echo Macros: $(ASM64_MACROS)
	@echo Libs: $(ASM64_LIB)
	@echo Assembler: $(AS)
	@echo Linker: $(LD)


run:
	@echo Expected test result: OK
	@echo
	
	$(WINE)test_ok.exe

	@echo Expected test result: FAIL
	@echo

	$(WINE)test_fail.exe || true


clean:
	rm -f *.err *.exe *.lst *.map *.o *.obj


help:
	@$(WINE)$(AS) -h


pack:
	$(ARCHIVER) a -tzip test.pe.import.ref.zip README.md *.asm *.inc *.lnk *.lst makefile *.exe
