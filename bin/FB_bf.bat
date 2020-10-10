@rem this compiles %1.bf into %1.exe

@rem In the process it creates:
@rem     %1.c with C code.

@rem Configuration
@set "FB_BIN=%~dp0%"
@if not "%FB_BIN:~-1%"=="\" set "FB_BIN=%FB_BIN%\"
@set "FB_HOME=%FB_BIN%..\"

@call "%FB_BIN%FB_config.bat"

@if exist %1.c del /F /Q %1.c

rem compiles %1.bf into C code %1.c

if defined FB_PYTHON (
		"%FB_PYTHON%" "%FB_ESOTOPE%\esotope-bfc" %1.bf > %1.c
		java -jar "%FB_BIN%TweakCCode.jar" -i %1.c -o %1.c

		rem compiles %1.c into %1.exe

		cl %1.c /Fo: %1.obj /Fe: %1.exe
		del %1.obj
	)
)