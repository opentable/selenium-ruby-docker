taskkill /F /IM iexplore.exe
taskkill /F /IM firefox.exe

rem @ECHO OFF
SET SRC1=C:\Documents and Settings
SET SRC2=Local Settings\Temporary Internet Files\
SET SRC3=Local Settings\History
SET SRC4=Local Settings\Temp
SET SRC5=Recent
echo About to delete files from Internet Explorer "Temporary Internet files"
FOR /D %%X IN ("%SRC1%\*") DO FOR /D %%Y IN ("%%X\%SRC2%\*.*") DO RMDIR /S /Q "%%Y"
echo About to delete files from Internet Explorer "History"
FOR /D %%X IN ("%SRC1%\*") DO FOR /D %%Y IN ("%%X\%SRC3%\*.*") DO RMDIR /S /Q "%%Y"
FOR /D %%X IN ("%SRC1%\*") DO FOR %%Y IN ("%%X\%SRC3%\*.*") DO DEL /F /S /Q "%%Y"
echo About to delete files from "Local settings\temp"
FOR /D %%X IN ("%SRC1%\*") DO FOR /D %%Y IN ("%%X\%SRC4%\*.*") DO RMDIR /S /Q "%%Y"
FOR /D %%X IN ("%SRC1%\*") DO FOR %%Y IN ("%%X\%SRC4%\*.*") DO DEL /F /S /Q "%%Y"
echo About to delete files from "Recent" i.e. what appears in Start/Documents/My Documents
FOR /D %%X IN ("%SRC1%\*") DO FOR %%Y IN ("%%X\%SRC5%\*.lnk") DO DEL /F /S /Q "%%Y"
echo About to delete files from "Windows\Temp"
cd /d %SystemRoot%\temp
del /F /Q *.*
@echo Y|RD /S ""


exit 
