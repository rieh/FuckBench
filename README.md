# FuckBench

## What is it?

FuckBench (*FB*) is a set of Windows batch files and tools to compile from several languages into [BrainFuck](https://en.wikipedia.org/wiki/Brainfuck) (*BF*).

Optionally, in addition to creating BF code, FB can compile generated BF code into 
higly optimized C files using the [Esotope](https://github.com/lifthrasiir/esotope-bfc) BF to C compiler.
If a C compiler is available, a Windows executable is also created.

Currently, FB supports compiling the following languages to BF:
 * ANSI C (with some [limitations](https://www.cc65.org/doc/cc65-4.html))
 * 6502 Assembly
 * [FuckBrainFuck](http://www.inshame.com/search/label/My%20Progs%3A%20FuckBrainfuck)
 
## How does it work?
 
FB includes a BF emulator for the 6502 CPU (`6502.fbf`); this allows using cross-compilers available for the 6502 CPU to create BF code.
A "linker" is provided (`CodeMerge.jar`) to "link" 6502 executable code to the emulator, creating a single BF file that can then be executed by using any available BF compiler or interpreter.

Given the generated code is not the fastest, I strongly suggest to configure a C compiler, as explained below, 
such that C code generated by Esotope can be turned into a Windows executable.

## Usage
  
### Configuration

FB relies on a set of external tools. Some of them need to be installed, as described below.
Others are made available under the `<root>\redistr` folder, for your convenience.
 
  1. Download latest FuckBench release and unzip it in a folder on your machine. We will refer to this folder as `<root>`.
  2. I strongly suggest to add `<root>\bin` to your path, such that FB tools can be invoked from any location in your machine.
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

  6. Install [Python 2](https://www.python.org/downloads/). I suggest using [WinPython](https://winpython.github.io/)
	 for easier installation; notice however that *WinPython has some limitation on the installation folder name*.
  7. Edit `<root>\bin\config.bat` and set `FB_PYTHON` to the Python interpreter executable. 
  
Optional - the below steps are required if you want to compile C code generated above into a Windows executable.

  8. Edit `<root>\bin\FB_ccompiler.bat` an adapt it to your C compiler.
    This batch file receives the name of a .c file (*without* extension) to compile and it is assumed
	to call any intalled C compiler to do the job.
	It is up to you to modify this batch file to properly invoke any C compiler you are using.
	If you are not using any C compler, just leave this file blank.

### Specifications for the BrainFuck environment

To successfully run, BF code created by FB requires a BF interpreter or compiler with below specifications;
please notice the section above explains how to use Esotope and any Windows C compiler to create Windows 
executables out of your BF generated code.

 * Unsigned wrapping 16 bit cells (0-65565).
	
 * A tape of at least 131193 cells.
   At the beginning of execution the tape head is assumed to be in the leftmost cell
   and will move ony to cells on its right.
	  
* The Windows executables created with Esotope + C compiler, when encountering a BF `,` comand will read 
  a string from console until user presses enter. The string is returned with a terminating $0A (LF) char.

  For example, when the generated BF code contains a `,` execution stops waiting for user input.
  Users enters "A1!" followed by "enter" key. BF will receive the characters with decimal ASCII code:
  $41, $31, $21, $0A in this order.
	  
  Notice that the cc65 libraries provided with FB read input until either a $00 (nul) or $0A (LF) character is returned;
  if $00 is read, it is replaced by $0A before being returned.
  
	  
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

`<root>\notepad++` folder contains a custom language definition for the FuckBrainFuck language, to be used ith [Notepad++](https://notepad-plus-plus.org/) editor.

### Compiling 6502 assembly

FB uses [ca65](https://www.cc65.org/doc/ca65.html), a 6502 assembler contained within [cc65](https://cc65.github.io/) 6502 C cross-compiler to compile 6502 assembly code into a 6502 executable that is then linked to the 6502bf BF emulator to produce
final BF code.

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

FB uses [cc65](https://cc65.github.io/) 6502 C cross-compiler to compile C code into a 6502 executable that is then
linked to the 6502bf BF emulator to produce final BF code.

You can invoke:

```
FB_cl f
```

to compile `f.c` source file into `f_c.bf` BrainFuck code, `f_c.c` C code (for `f_c.bf`) and corresponding executable Windows file `f.exe`.

Again, if Python or C compilers have not been configured, compilation will stop at some intermediate steps.

Notice you can pass [compilation parameters](https://www.cc65.org/doc/cl65-2.html) to the compiler; by default `FB_cl` will enable some optimization (`-Oir`). Please notices that cc65 somehow [differs](https://www.cc65.org/doc/cc65-4.html) from ANSI C.

## The 6502bf emulator

 * DEC mode
 * SYSCALLS
 * Loop detection (for debug JMP/JSR/BRK/brances)
 * ...
  
### Changing 6502 emulator

 * Add new SYSCALLS
 * Careful in changing mem[] position -> Linker
 * ...
 
### Compiling 6502 emulator

Run `<root>\bin\FB_build_emu.bat` to rebuild the 6502bf emulator (`6502bf.bf`).

## Making a new release

`<root>\bin\FB_run_tests.bat` runs a battery of tests for FB; in the proces, it also rebuilds FB assets.
Because of this, it can be used as preparation for a new release. 
It can also used to run regression tests, enabling only some checks, as explained below.

  1. It will rebuild 6502bf emulator.
     This can be skipped with `-e` option from command line.
  2. It will rebuild and execute 6502 functional tests, in order to verify the emulator runs correctly.
     This can be skipped with `-f` option from command line.
  3. It will rebuild cc65 libraries.
     This can be skipped with `-l` option from command line.
  4. For each sub folder in `<root>\test`, it will compile files contained therein, execute them
     and compare their output with corresponding `.ref` file, issuing an error when they do not match.
     This can be skipped with `-t` option from command line.
  5. Providing the `-v` option, will print verbose output to console.

If all of the above tests ran successfully, FB will be re-built and it is ready for a release.

*Please notice that Python and C compiler must be configured to run regression tests.*