@echo off
Rem Thanks Jason for most of this.
TITLE Installing PocketMine as Source (Raptors)
cd /d %~dp0

if exist %~dp0PocketMine-MP\ goto PMSTART

where git >nul 2>nul || (powershell -command "& { iwr https://github.com/git-for-windows/git/releases/download/v2.26.0-rc2.windows.1/PortableGit-2.26.0-rc2-64-bit.7z.exe -OutFile PortableGit.exe }" & start PortableGit.exe & pause)

if exist .\PortableGit\cmd\git.exe (
	set GIT=.\PortableGit\cmd\git.exe
	del PortableGit.exe
) else (
	set GIT=git
)
%GIT% clone https://github.com/pmmp/PocketMine-MP.git -b master --recursive

rd /s /q PortableGit

cd PocketMine-MP

del start.cmd
del start.ps1

powershell -command "& { iwr https://gist.githubusercontent.com/jasonwynn10/f3e8cdb10f0fc39c17835a4c1c2c0538/raw/027ae623bf8dac7f95089bf1a5e5f4733a07b514/start.cmd -OutFile start.cmd }"
powershell -command "& { iwr https://gist.githubusercontent.com/jasonwynn10/f3e8cdb10f0fc39c17835a4c1c2c0538/raw/027ae623bf8dac7f95089bf1a5e5f4733a07b514/start.ps1 -OutFile start.ps1 }"

powershell -command "& { iwr https://ci.appveyor.com/api/buildjobs/s38vjp5cm4kwn7u2/artifacts/php-7.3.16-vc15-x64.zip -OutFile php.zip }"
powershell -command "Expand-Archive -Path php.zip -DestinationPath ."

del php.zip
start /w vc_redist.x64.exe

powershell -command "& { iwr https://getcomposer.org/installer -OutFile composer-setup.php }"

.\bin\php\php.exe composer-setup.php --install-dir=bin
.\bin\php\php.exe .\bin\composer.phar install --no-interaction --ansi
del composer-setup.php

mkdir plugins
cd tests\plugins\PocketMine-DevTools
..\..\..\bin\php\php.exe -dphar.readonly=0 .\src\DevTools\ConsoleScript.php --make .\ --relative .\ --out ..\..\..\plugins\DevTools.phar
cd ..\..\..

:: We're in the main dir now
cd PocketMine-MP
move /y *.* ../
move /y .git ../github
move /y .github ../github
move /y bin ../bin
move /y build ../build
move /y changelogs ../changelogs
move /y doxygen ../doxygen
move /y resources ../resources
move /y src ../src
move /y tests ../tests
move /y tools ../tools
move /y vendor ../vendor
cd ../
rmdir /s /q PocketMine-MP
mkdir core_plugins
clear
echo "Completed!"
:: To Do: Raptor API downloads.