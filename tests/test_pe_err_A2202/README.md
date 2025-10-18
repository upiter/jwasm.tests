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
jwasm -pe -Fo=test_ok test.err.A2202.asm
```

### test_fail

```sh
jwasm -pe -Fo=test_fail -DDIRECT_CALL=1 test.err.A2202.asm
```

Build result:

- `test_ok` target result: **OK**
- `test_fail` target result: **FAIL**

Compiles **OK** only if `DIRECT_CALL` is not defined.


## Files

- `README.md` — error overview and details
- `makefile` — make file to build source with different options
- `test.err.A2202.asm` — test source
- `test_ok.exe` — correct build


## Contact

- [Jupiter][jupiter.github]


[jupiter.github]: https://github.com/upiter
