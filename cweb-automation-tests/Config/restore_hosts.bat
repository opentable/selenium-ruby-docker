@echo off
REM %1 hosts file

Set HOSTS_FILE=C:\Windows\System32\drivers\etc

if %1==() GOTO :ERROR

echo "Remove current hosts file"
del %HOSTS_FILE%\hosts

echo "Back up previous copy of hosts file"
ren %HOSTS_FILE%\hosts_previous hosts

echo "Deploy %1 hosts file"
copy %1 %HOSTS_FILE%\hosts_previous

echo "Flushing DNS"
ipconfig /flushdns
ipconfig /flushdns
ipconfig /flushdns
GOTO :EOF

:ERROR
echo "File not found. Error deploying hosts file"

:EOF
echo "Done."


