# JWasm `-pe` Test Suite for Error A2202

## Overview

JWasm fails to build and exe with `-pe` option when direct calls to imported functions are used.

Imports are defined with `dllimport` option.

Error message when using direct `call` (not via `invoke`):

- Error A2202: Output format doesn't support externals


## Details

Code with `invoke` builds OK:

```asm
	invoke	GetModuleHandle, NULL
	mov	hInstance, eax

	invoke	GetCommandLine
	mov	pCommandLine, eax

	invoke	printf, addr strAppTitle
	invoke	printf, pCommandLine

	invoke	ExitProcess, 0
```

Equivalent code with direct `call` fails to build with error `A2202`:

```asm
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
```

### Expected behaviour:

Both code variants should compile without errors.


## Source

Test for Error A2202:

- `test.err.A2202.asm`.


## Build

```sh
make
```

Main targets:

### test_ok

```sh
jwasm -pe -Fo=test_ok -Fl=test_ok.lst -Sg test.err.A2202.asm
```

### test_fail

```sh
jwasm -pe -Fo=test_fail -Fl=test_ok.lst -Sg -DDIRECT_CALL=1 test.err.A2202.asm
```

Build result:

- `test_ok` target result: **OK**
- `test_fail` target result: **FAIL**

Compiles **OK** only if `DIRECT_CALL` is not defined.


## Listings diff

```sh
diff test_ok.lst test_fail.lst >tests.diff
```

### Code: test_ok

|Offset		|Dump		|	|Code		|
|----:		|:-------	|:----:	|:----------	|
|		|		|	|**GetModuleHandleA:**	|
|00000000	|		|	|`invoke	GetModuleHandleA, NULL`
|00000000	|6A00		|*	|`push	NULL`
|		|		|*	|`externdef _imp__GetModuleHandleA@4: ptr proc`
|00000002	|FF1500000000	|*	|`call	_imp__GetModuleHandleA@4`
|00000008	|A300000000	|	|`mov	hInstance, eax`
|		|		|	|**GetCommandLine:**	|
|0000000D	|		|	|`invoke	GetCommandLineA`
|		|		|*	|`externdef	_imp__GetCommandLineA@0: ptr proc`
|0000000D	|FF1500000000	|*	|`call	_imp__GetCommandLineA@0`
|00000013	|A300000000	|	|`mov	pCommandLine, eax`


### Code: test_fail

|Offset		|Dump		|	|Code		|
|----:		|:-------	|:----:	|:----------	|
|		|		|	|**GetModuleHandleA:**	|
|00000000	|		|	|`push	NULL`
|00000002	|		|	|`call	GetModuleHandleA`
|00000007	|		|	|`mov	hInstance, eax`
|		|		|	|**GetCommandLine:**	|
|0000000C	|		|	|`call	GetCommandLineA`
|00000011	|		|	|`mov	pCommandLine, eax`


There is no dump in this listing, may be another bug.


### Symbols

!["Diff"][img.diff]

Missing imports:

|Name	|Type	|Params	|Section|Scope	|Conv	|
|:------|:----	|---:	|:------|----	|----	|
|`_imp__ExitProcess@4`		|`@LPPROC`|8h|`.idata$5`|Public|STDCALL
|`_imp__GetCommandLineA@0`	|`@LPPROC`|0h|`.idata$5`|Public|STDCALL
|`_imp__GetModuleHandleA@4`	|`@LPPROC`|4h|`.idata$5`|Public|STDCALL
|`_imp__printf`			|`@LPPROС`|10h|`.idata$5`|Public|C


## Files

- [README.md][test.readme] — error overview and details
- [makefile][test.make] — make file to build source with different options
- [test.err.A2202.asm][test.src] — test source
- `test_ok.exe` — correct build


## Issue

Issue in official JWasm repo:

- [JWasm -pe Test Suite for Error A2202 #46][issue.official]


## Contact

- [Jupiter][jupiter.github]


[jupiter.github]: https://github.com/upiter

[test.readme]: README.md
[test.src]: test.err.A2202.asm
[test.make]: makefile

[issue.official]: https://github.com/Baron-von-Riedesel/JWasm/issues/46

[img.diff]: diff.symbols.png

