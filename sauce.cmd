@echo off
:: Prepare timestamp
set zerotime=%time: =0%
set outputtime=20%date:~6,2%-%date:~3,2%-%date:~0,2%T%zerotime:~0,8%+08:00

echo Checking internet connection...
ping %1 -n 1 -w 1000 > NUL

if errorlevel 1 (GOTO FALLBACK) else (GOTO ALLGOOD)

:FALLBACK
echo Internet Test Failed
:: YOUR CODE
jq -c ". += [{\"time\":\"%outputtime%\",\"status\":\"NOTOK\"}]" %2 >temp.json
::...
GOTO FINISH

:ALLGOOD
echo Internet Test was successful
:: MAYBE REVERSE THE METRICS?
jq -c ". += [{\"time\":\"%outputtime%\",\"status\":\"OK\"}]" %2 >temp.json
GOTO FINISH

:FINISH
xcopy /Y temp.json %2
git pull origin %3
git add %2
git commit -m"%2 Updated"
git push origin %3
exit 0