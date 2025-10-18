# JWasm Test Suite

ERR_CODE := A2202

SOURCE := $(firstword $(wildcard test.*.asm))
SOURCE ?= test.err.$(ERR_CODE).asm


.PHONY:	test_ok test_fail clean help pack


all:	test_ok test_fail


test_ok:
	jwasm -pe -Fo=test_ok $(SOURCE)


test_fail:
	jwasm -pe -Fo=test_fail -DDIRECT_CALL=1 $(SOURCE)


clean:
	rm -f *.err *.exe *.map *.o *.obj

help:
	@jwasm -h

pack:
	7z a -tzip test.err.$(ERR_CODE).zip README.md *.asm *.inc makefile *.exe
