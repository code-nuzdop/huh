@echo off
setlocal

set "PF86=%ProgramFiles(x86)%"
if "%PF86%"=="" set "PF86=%ProgramFiles%"
set "VSWHERE=%PF86%\Microsoft Visual Studio\Installer\vswhere.exe"

set "VSPATH="
if exist "%VSWHERE%" (
  for /f "usebackq tokens=*" %%i in (`"%VSWHERE%" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath`) do set "VSPATH=%%i"
)
if not defined VSPATH (
  if exist "%PF86%\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat" set "VSPATH=%PF86%\Microsoft Visual Studio\2022\Community"
  if exist "%PF86%\Microsoft Visual Studio\2022\Professional\VC\Auxiliary\Build\vcvars64.bat" set "VSPATH=%PF86%\Microsoft Visual Studio\2022\Professional"
  if exist "%PF86%\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvars64.bat" set "VSPATH=%PF86%\Microsoft Visual Studio\2022\Enterprise"
)

if not defined VSPATH (
  echo [!] Visual Studio with the C++ workload was not found.
  echo     Install "Desktop development with C++" via the VS Installer, then re-run.
  exit /b 1
)

call "%VSPATH%\VC\Auxiliary\Build\vcvars64.bat" >nul
if errorlevel 1 ( echo [!] vcvars64.bat failed & exit /b 1 )
echo [*] toolchain: %VSPATH%

for %%f in (r6esp.cpp cfg.h mem.h esp.h diag.h) do if not exist "%%f" ( echo [!] missing %%f & exit /b 1 )

cl /nologo /std:c++17 /EHsc /O2 /MT /DUNICODE /D_UNICODE r6esp.cpp ^
   /Fe:Overlay3.exe /MP ^
   /link /SUBSYSTEM:WINDOWS /MANIFESTUAC:"level='requireAdministrator'" ^
   user32.lib gdi32.lib advapi32.lib comctl32.lib d2d1.lib dwrite.lib d3d11.lib dxgi.lib dcomp.lib

if errorlevel 1 ( echo [!] build failed & exit /b 1 )
echo [+] built Overlay3.exe

