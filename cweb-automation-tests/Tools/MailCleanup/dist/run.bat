rem Example: java -jar MailCleanup.jar 10.21.0.26 qasql\vkretov Opentable123

REM Check acceptable regions
if %1 == () goto :USAGE
if %2 == () goto :USAGE
if %3 == () goto :USAGE

java -jar MailCleanup.jar %1 %2 %3

goto :DONE

:USAGE
echo "Usage: "
echo "run.bat <emailserver> <account> <pwd>"
echo "Valid values:"
echo "   <emailserver>  = 10.21.0.26"
echo "   <account>      = qasql\vkretov"
echo "   <pwd>          = Opentable123"

:DONE
echo DONE
