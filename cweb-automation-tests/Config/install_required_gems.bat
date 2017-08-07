@echo off
echo Installing all gems required for Automation...

cd ..\Cucumber\vendor\cache
call gem install bundler --no-rdoc --no-ri

cd ..\..
bundle install --local
