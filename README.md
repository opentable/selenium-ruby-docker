# selenium-ruby-docker

Work in progress

Artifactory image: docker.otenv.com/seleniumruby226

Dockerfile spins of:
Ruby 2.2.6
Seleinum Webdriver
Latest Firefox
Geckodriver V0.13.0
Clone of https://github.com/lngot/automated-tests

To Run test on MAC:
Install and open  XQuartz
in Xtem run:
 socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"

From terminal commandline:
Get the inet ip address from ifconfig en0
xhost +<inet ipaddr>

