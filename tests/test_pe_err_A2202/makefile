# JWasm Test Suite

ERR_CODE := A2202

SOURCE := $(firstword $(wildcard test.*.asm))
SOURCE ?= test.err.$(ERR_CODE).asm

AS=jwasm
ARCHIVER=7z


.PHONY:	test_ok test_fail diff clean help pack


all:	test_ok test_fail diff


test_ok:
	$(AS) -pe -Fo=test_ok.exe -Fl=test_ok.lst -Sg $(SOURCE)


test_fail:
	$(AS) -pe -Fo=test_fail.exe -Fl=test_fail.lst -Sg -DDIRECT_CALL=1 $(SOURCE)


diff:
	diff test_ok.lst test_fail.lst >tests.diff || true


clean:
	rm -f *.err *.exe *.lst *.map *.o *.obj

help:
	@$(AS) -h

pack:
	$(ARCHIVER) a -tzip test.err.$(ERR_CODE).zip README.md *.asm *.inc makefile *.exe
