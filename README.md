# FuckBench

## What is it?

FuckBench (*FB*) is a set of Windows batch files and tools to compile from several languages into [BrainFuck](https://en.wikipedia.org/wiki/Brainfuck) (*BF*).

Optionally, in addition to creating BF code, FB compiled generated BF code into 
higly optimized C files using the [Esotope](https://github.com/lifthrasiir/esotope-bfc) BF to C compiler.
If a C compiler is configured, a Windows executable is also created.

Currently, FB supports compiling the following languages to BF:
 * ANSI C (no float support)
 * 6502 Assembler
 * [FuckBrainFuck](http://www.inshame.com/search/label/My%20Progs%3A%20FuckBrainfuck)
 
## How does it work?
 
FB includes a BF emulator for the 6502 CPU (`6502.fbf`); this allows using cross-compilers available for the 6502 CPU to create BF code.
A "linker" is provided (`CodeMerge.jar`) to "link" 6502 executable code to the emulator, creating a single BF file that can then be executed
by using any available BF compiler or interpreter.

Given the generated code is not the fastest, I strongly suggest to configure a C compiler, as explained below, 
such that C code generated by Esotope can be turned into a Windows executable.

## Usage
  
### Configuration



FB relies on a set of external tools. Some of them need to be installed, as described below.
Others are made available under the `<root>\redistr` folder, for your convenience.
 
  1. Download latest BF release and unzip it in a folder on your machine. We will refer to this folder as `<root>`.
  2. I strongly suggest to add `<root>\bin` to your path such that FB tools can be invoked from any location in your machine.
     The below examples assume batch files in the `<root>\bin` folder are accessible from the current colder in the command prompt.
  3. Install [Java](https://www.oracle.com/java/technologies/javase-downloads.html).
     FB needs Java 15 or later.
	 Normally, Java installer updates PATH environment variable as required, if not, make sure the folder used by your
	 Java installation is added to the path. FB assumes `java` command will work when invoked from within any folder.
  4. Download [cc65](https://cc65.github.io/) 6502 C cross-compiler and install it as explained in the
	 "[Getting Started](https://cc65.github.io/getting-started.html)" page. Notice that *the installation folder
	 for cc65 must NOT contain any space*.
  5. Edit `<root>\bin\config.bat` and set `FB_CC65` to the folder where you installed cc65. 
  
Optional - the below steps are required if you want to compile generated BF code into C.
If you skip the below configuration, BF compilation will stop after genereating BF code.

  6. Install [Python 2](https://www.python.org/downloads/).
  7. Edit `<root>\bin\config.bat` and set `FB_PYTHON` to the Python interpreter executable. 
  
Optional - the below steps are required if you want to compile C code generated above into a Windows executable.

  8. Edit `<root>\bin\FB_ccompiler.bat` an adapt it to your C compiler.
    This batch file receives the name of a .c file (*without* extension) to compile and it is assumed
	to call any intalled C compiler to do the job.
	It is up to you to modify this batch file to properly invoke any C compiler you are using.
	If you are not using any C compler, just leave this file blank.

### Specifications for the BrainFuck environment

To successfully run, BF code created by FB the emulator requires an interpreter or compile withbelow specifications:

 * Unsigned wrapping 16 bit cells (0-65565).
	
 * A tape of at least 131193 cells.
   At the beginning of execution the tape head is assumed to be in the leftmost cell
   and will move ony to cells on its right.
	  
* The compiler used for testing on an input ("," comand) will read a string from console until
  user presses enter. The string is returned with a terminating $0D char.

  For example, when the code contains a "," execution stops waiting for user input.
  Users enters "A1!" followed by "enter" key.
  BrainFuck will receive the characters with decimal ASCII code: 65, 49, 33, 10 in this sequence.
	  
  Notice this has implications in using the C libraries. The code in read.s reads input
  until a $00 or $A0 character is returned; if $00 ir read, it is replaced by $A0 before returning
  from C call.
	  
### Compiling BrainFuck code

If you followed the above optional steps, you can invoke:

```
FB_bf f
```

to compile BrainFuck `f.bf` source file into `f.c` C code and corresponding executable Windows file `f.exe`.

Again, if Python or C compilers have not been configured, compilation will stop at some intermediate steps.

### Compiling FuckBrainFuck code

You can invoke:

```
FB_fbf f
```

to compile FuckBrainFuck `f.fbf` source file into `f.bf` BrainFuck code, `f.c` C code and corresponding executable Windows file `f.exe`.

Again, if Python or C compilers have not been configured, compilation will stop at some intermediate steps.

### Compiling 6502 assembly

FB uses [ca65](https://www.cc65.org/doc/ca65.html), a 6502 assembler contained within [cc65](https://cc65.github.io/) 6502 C cross-compiler,
to compile 6502 assembly code into a 6502 executable that is then linked to the 6502bf BF emulator to produce final BF code.

You can invoke:

```
FB_asm f
```

to compile ca65 assembly file `f.s` source file into `f.bf` BrainFuck code, `f.c` C code and corresponding executable Windows file `f.exe`.

Again, if Python or C compilers have not been configured, compilation will stop at some intermediate steps.

The file `cc65\6502bf.inc` contains a set of macros that expose some features available in the 6502bf emulator.

The code can use zeropage variables (except for 26 bytes reserved by ca65) and the whole of RAM (starting from $200),
with the exception of a 4KB stack located in high memory. For more information, please refer to `cc65\6502bf.cfg`
configuration file and [cc65 documentation](https://cc65.github.io/doc/customizing.html).

### Compiling ANSI C

FB uses [cc65](https://cc65.github.io/) 6502 C cross-compiler,
to compile C code into a 6502 executable that is then linked to the 6502bf BF emulator to produce final BF code.

You can invoke:

```
FB_cl f
```

to compile `f.c` source file into `f_c.bf` BrainFuck code, `f_c.c` C code (for `f_c.bf`) and corresponding executable Windows file `f_c.exe`.

Again, if Python or C compilers have not been configured, compilation will stop at some intermediate steps.

Notice you can pass [compilation parameters](https://www.cc65.org/doc/cl65-2.html) to the compiler; by default `FB_cl` will enable maximum optimization.
Please notices that cc65 somehow [differs](https://www.cc65.org/doc/cc65-4.html) from ANSI C.

## The 6502bf emulator

 * DEC mode
 * SYSCALLS
 * ...
  
### Changing 6502 emulator

 * Add new SYSCALLS
 * Carful in changing mem[] position -> Linker
 * ...
 
### Compiling 6502 emulator

 * ...

## Making the build

 * Build script
 * Needs Esotope and C compiler to run regression tests