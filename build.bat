@echo off

set name="edim"

set "projDirectory=%cd%"
set compiler=%1
set command=%compiler%
set arch=%2
set type=%3
rem.TODO- Fix these:
if exist "%projDirectory%\src\win32\NUL" (
   set win32sources="%projDirectory%\src\win32\*.c"
)
if not exist "%projDirectory%\src\libs\NUL" goto :continue
set libc="%projDirectory%\src\libs\*.c"
set libh="-I%projDirectory%\src\libs"
set msvclibh="/I%projDirectory%\src\libs"

:continue
if /i "%compiler%"=="gcc" goto :gcc
if /i "%compiler%"=="clang" goto :clang
if /i "%compiler%"=="msvc" goto :msvc
if /i "%compiler%"=="" goto :msvc
if /i "%command%"=="run" goto :run
if /i "%command%"=="clean" goto :clean
if /i "%command%"=="init" goto :initmsvc
if /i "%command%"=="help" goto :help
echo Error: Unknown command [argument 2]
goto :end


:gcc
if /i "%arch%"=="x86" goto :gccx86
if /i "%arch%"=="x64" goto :gccx64
if /i "%arch%"=="" goto :gccx86
echo Error: Unknown architecture. Must enter either 'x86' or 'x86_64' [argument 2]
goto :end

:gccx86
mkdir build\debug >NUL 2>NUL
cd build\debug
echo Using GCC
gcc -m32 -Wall -g -D_CRT_SECURE_NO_WARNINGS ..\..\src\*.c %win32sources% %libc% -I..\..\src\headers\ %libh% -o %name%.exe
cd ..\.. 
goto :end

:gccx64
mkdir build\debug >NUL 2>NUL
cd build\debug
echo Using GCC
gcc -m64 -Wall -g -D_CRT_SECURE_NO_WARNINGS ..\..\src\*.c %win32sources% %libc% -I..\..\src\headers\ %libh% -o %name%.exe
cd ..\.. 
goto :end


:clang
if /i "%arch%"=="x86" goto :clangx86
if /i "%arch%"=="x64" goto :clangx64
if /i "%arch%"=="" goto :clangx86
echo Error: Unknown architecture. Must enter either 'x86' or 'x86_64' [argument 2]
goto :end

:clangx86
mkdir build\debug >NUL 2>NUL
cd build\debug
echo Using Clang for Windows
clang -m32 -Wall -g -D_CRT_SECURE_NO_WARNINGS ..\..\src\*.c %win32sources% %libc% -I..\..\src\headers\ %libh% -o %name%.exe
cd ..\.. 
goto :end

:clangx64
mkdir build\debug >NUL 2>NUL
cd build\debug
echo Using Clang for Windows
clang -m64 -Wall -g -D_CRT_SECURE_NO_WARNINGS ..\..\src\*.c %win32sources% %libc%  -I..\..\src\headers\ %libh% -o %name%.exe
cd ..\.. 
goto :end


:msvc
where cl >NUL 2>NUL
if %ERRORLEVEL%==0 goto :msvcdo
if /i "%arch%"=="x86" goto :msvcx86
if /i "%arch%"=="x64" goto :msvcx64
if /i "%arch%"=="" goto :msvcx64
echo Error: Unknown architecture. Must enter either 'x86' or 'x86_64' [argument 2]
goto :end

:msvcx86
if exist "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\*" (
   call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x86
   goto :msvcdo
)
if exist "C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\VC\Auxiliary\Build" (
   call "C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\VC\Auxiliary\Build\vcvars32.bat"
   goto :msvcdo
)
if exist "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build" (
   call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvars32.bat"
   goto :msvcdo
)
echo Error: Failed to find MSVC 2015 or 2017. Make sure it is installed!
goto :end

:msvcx64
if exist "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\*" (
   call "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x64
   goto :msvcdo
)
if exist "C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\VC\Auxiliary\Build" (
   call "C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\VC\Auxiliary\Build\vcvars64.bat"
   goto :msvcdo
)
if exist "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build" (
   call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvars64.bat"
   goto :msvcdo
)
echo Error: Failed to find MSVC 2015 or 2017. Make sure it is installed!
goto :end

:msvcdo
if /i "%type%"=="release" goto :msvcdorelease
cd %projDirectory%
mkdir build\debug
rem.cd build\debug
echo Using MSVC
cl /D_CRT_SECURE_NO_WARNINGS /TC /nologo /Oi /Gm- /MP /FC /fp:fast /fp:except- /Zi /Zo /DEBUG %projDirectory%\src\*.c %win32sources% %libc%  /I%projDirectory%\src\headers\ %msvclibh% /link -OUT:%projDirectory%\build\debug\\%name%.exe -incremental:no -opt:ref -subsystem:console
rem.cd ..\.. 
goto :end

:msvcdorelease
cd %projDirectory%
mkdir build\release
rem.cd build\release
echo Using MSVC
cl /D_CRT_SECURE_NO_WARNINGS /TC /nologo /O2i /Gm- /MP /FC /fp:fast /fp:except- %projDirectory%\src\*.c %win32sources% %libc%  /I%projDirectory%\src\headers\ %msvclibh% /link -OUT:%projDirectory%\build\release\\%name%.exe -incremental:no -opt:ref -subsystem:console
rem.cd ..\.. 
goto :end


:initmsvc
where cl >NUL 2>NUL
if %ERRORLEVEL%==0 goto :initmsvcalreadydone
if /i "%arch%"=="x86" goto :initmsvcx86
if /i "%arch%"=="x64" goto :initmsvcx64
if /i "%arch%"=="" goto :initmsvcx86
echo Error: Unknown architecture. Must enter 'x86' or 'x64' [argument 2]
goto :end

:initmsvcx86
if exist "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\*" (
   "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x86
   goto :end
)
echo Error: Failed to find MSVC 2015. Make sure it is installed!
goto :end

:initmsvcx64
if exist "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\*" (
   "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat" x64
   goto :end
)
echo Error: Failed to find MSVC 2015. Make sure it is installed!
goto :end

:initmsvcalreadydone
echo Info: MSVC has already been initialized.
goto :end


:run
if "%arch%"=="release" goto runrelease
if "%type%"=="release" goto runrelease
if not exist build\debug\%name%.exe (
   echo Must compile project before you can run it.
   goto :end
)
call build\debug\%name%.exe
goto :end

:runrelease
if not exist build\release\%name%.exe (
   echo Must compile project before you can run it.
   goto :end
)
call build\release\%name%.exe
goto :end


:clean
rmdir /S build


:end
set "win32sources="
set "libc="
set "libh="
set "msvclibh="
