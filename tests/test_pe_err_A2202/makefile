# JWasm Test Suite

ERR_CODE := A2202

SOURCE := $(firstword $(wildcard test.*.asm))
SOURCE ?= test.err.$(ERR_CODE).asm

# WINE=wine 
WINE?=

# AS=$(WINE)jwasm
AS=jwasm
LD=$(WINE)jwlink
ARCHIVER=7z


.PHONY:	test_ok test_fail test_fix diff clean help pack


all:	test_ok test_fail test_fix diff


test_ok:
	$(AS) -pe -Zli -Fo=test_ok.exe -Fl=test_ok.lst -Sg $(SOURCE)


test_fail:
	$(AS) -pe -Fo=test_fail.exe -Fl=test_fail.lst -Sg -DDIRECT_CALL=1 $(SOURCE) || true


test_fix:
	$(AS) -pe -Zli -Fo=test_fix.exe -Fl=test_fix.lst -Sg -DDIRECT_CALL=1 -DDIRECT_CALL_FIX=1 $(SOURCE)


run:
	@echo 'Running test executables ...'

	@printf "\n\n%s\n\n" "Test 'OK'"
	$(WINE)test_ok.exe || true

	@printf "\n\n%s\n\n" "Test 'FAIL'"
	$(WINE)test_fail.exe || true

	@printf "\n\n%s\n\n" "Test 'FIX'"
	$(WINE)test_fix.exe || true


diff:
	diff test_ok.lst test_fail.lst >tests.diff || true


clean:
	rm -f *.err *.exe *.lst *.map *.o *.obj

help:
	@$(AS) -h

pack:
	$(ARCHIVER) a -tzip test.err.$(ERR_CODE).zip README.md *.asm *.inc makefile *.exe
