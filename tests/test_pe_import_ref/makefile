# JWasm Test Suite

SOURCE:=$(firstword $(wildcard test.*.asm))
SOURCE?=test.pe.import.ref.asm


OBJ_OK=test_ok.obj
OBJ_DIRECT=test_direct.obj


# WINE=wine 
WINE?=

# AS=$(WINE)jwasm
AS=jwasm
LD=$(WINE)jwlink
# LD=wine jwlink
ARCHIVER=7z


ASM64_BASE?=/masm64

ASM64_INC=$(ASM64_BASE)/include64/
ASM64_MACROS=$(ASM64_BASE)/macros64/
ASM64_LIB=$(ASM64_BASE)/lib64/


.PHONY:	test
.PHONY:	diff env run clean help pack


all:	test diff run


test:	test_ok.exe test_direct.exe 


$(OBJ_OK):	$(SOURCE)
	$(AS) -coff -zzs -zze -I=$(ASM64_INC) -I=$(ASM64_MACROS) -nm=test -Fd -Fo=$@ -Fl=test_ok.lst -Sg $<


$(OBJ_DIRECT):	$(SOURCE)
	$(AS) -coff -I=$(ASM64_INC) -I=$(ASM64_MACROS) -nm=test -Fd -Fo=$@ -Fl=test_direct.lst -Sg -DDIRECT_IMPORTS $< || true


test_ok.exe:	$(OBJ_OK)
	$(LD) @test.link system ok libpath $(ASM64_LIB) file $^


test_direct.exe:	$(OBJ_DIRECT)
	$(LD) @test.link system direct libpath $(ASM64_LIB) file $^ || true


diff:
	diff test_ok.lst test_direct.lst >tests.diff || true


env:
	@echo ASM64 base: $(ASM64_BASE)
	@echo Includes: $(ASM64_INC)
	@echo Macros: $(ASM64_MACROS)
	@echo Libs: $(ASM64_LIB)
	@echo Assembler: $(AS)
	@echo Linker: $(LD)


run:
	@echo 'Running test executables ...'

	@printf "\n\n%s\n\n" "Test 'OK'"

	$(WINE)test_ok.exe

	@printf "\n\n%s\n\n" "Test 'DIRECT'"

	$(WINE)test_direct.exe || true


clean:
	rm -f *.err *.exe *.lst *.map *.o *.obj


help:
	@$(WINE)$(AS) -h


pack:
	$(ARCHIVER) a -tzip test.pe.import.ref.zip README.md *.asm *.inc *.lnk *.lst makefile *.exe
