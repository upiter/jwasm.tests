# JWasm Imports Reference Test Suite

## Intro

JWasm has two useful options:

1. `-Fd` in conjunction with `option dllimport`: Write Import Definitions without using `.lib` files

2. `-pe`: create PE file (portable executable) without linker


But `dllimport` option works only with `invoke` statements and **doesn't accept data references to import entries**, so it fails to create correct pointers to import functions.

If you try to build a file with `-pe` option, you'll get this error:

- Error A2201: Output format doesn't support externals

If you try to build a file with the JWlink linker, you'll get this error:

- Zeroes instead of function addresses in `.data` section.


## How to reproduce

1. Use `dllimport` option in source to create function prototypes.

2. Declare a variable as a pointer to an imported function.

3. Build file with assembler (JWasm) and linker (JWlink).

4. Run file, you'll see that import address is just zero.

```sh
cat jwasm_pe_import_ref.asm
```

```asm
; OutputDebugString
fn_OutputDebugString	typedef	proto	msg:ptr
pfn_OutputDebugString	typedef ptr	fn_OutputDebugString

DBG_API	struct
	OutputDebugString	pfn_OutputDebugString	?
	OutputDebugStringW	pfn_OutputDebugString	?
DBG_API	ends

.data

align	10h

DbgApi	DBG_API	<OutputDebugStringA, OutputDebugStringW>
```


## Code Diff

`test_ok.exe`:

!["main code"][hiew.main.ok]

`test_fail.exe`:

!["main code"][hiew.main.fail]

## Data Reference Diff

`test_ok.exe`:

!["Data Ref"][hiew.ref.ok]

`test_fail.exe`:

!["Data Ref"][hiew.ref.fail]


## Output

### Correct result from `test_ok.exe`:

```
Import reference
JWasm version: 2.19 (219)
Address @ 0000000000401154
```

### Incorrect output from `test_fail.exe`:

```
Import reference
JWasm version: 2.19 (219)
Address @ 0000000000000000
```


[hiew.main.ok]: hiew.main.ok.png
[hiew.main.fail]: hiew.main.fail.png

[hiew.ref.fail]: hiew.ref.fail.png
[hiew.ref.ok]: hiew.ref.ok.png
