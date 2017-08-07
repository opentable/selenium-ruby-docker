FROM docker.otenv.com/ot-ubuntu:latest

ADD https://s3-us-west-2.amazonaws.com/deploy-images/libyjpagent.so /opt/libyjpagent.so
ADD stage2.sh /
RUN /stage2.sh

MAINTAINER Lai-Mei Ng

RUN apt-get update
# install the prerequisite patches here so that rvm will install under non-root account. 
RUN apt-get install -y curl patch gawk g++ gcc make libc6-dev patch libreadline6-dev zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 autoconf libgdbm-dev libncurses5-dev automake libtool bison pkg-config libffi-dev 

##Prerequisites for chrome 
RUN apt-get install -y xvfb libxi6 libxss1 libgconf2-4 libappindicator1 libindicator7 libasound2 libnspr4 libx11-xcb1 fonts-liberation libnss3 xdg-utils

## prerequisites for ruby gems
RUN apt-get install -y libcurl3 libcurl3-gnutls libcurl4-openssl-dev libxml2-dev libxslt-dev freetds-dev 

##Prerequisites for chrome
WORKDIR /tmp
# Install Chrome 59
ADD chrome64_59.0.3071.86.deb /tmp
RUN sudo dpkg -i chrome64_59.0.3071.86.deb
#RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb 
#RUN dpkg -i google-chrome-stable_current_amd64.deb
#RUN apt-get -fy install google-chrome-stable

# Install ChromeDriver.
RUN wget -N http://chromedriver.storage.googleapis.com/2.31/chromedriver_linux64.zip -P /tmp
RUN apt-get install unzip
RUN unzip chromedriver_linux64.zip -d /tmp
RUN rm chromedriver_linux64.zip
RUN mv -f chromedriver /usr/local/share/
RUN chmod +x /usr/local/share/chromedriver
RUN ln -s /usr/local/share/chromedriver /usr/local/bin/chromedriver

##Clone Automation Test repository
WORKDIR /usr/src/automated-tests
ADD cweb-automation-tests /usr/src/automated-tests/

##Create automation test user
RUN useradd -ms /bin/bash auto_testuser
RUN usermod -a -G auto_testuser auto_testuser
RUN usermod -a -G sudo auto_testuser
RUN echo "ALL ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers
USER auto_testuser

##Install RVM, Ruby and Bundler
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
#RUN /bin/bash -l -c "\curl https://get.rvm.io | bash -s stable"
##This is a workaround till this issue is fixed: https://github.com/rvm/rvm/issues/4068
RUN /bin/bash -l -c "\curl https://raw.githubusercontent.com/wayneeseguin/rvm/stable/binscripts/rvm-installer | bash -s stable"
RUN /bin/bash -l -c "echo "source $HOME/.rvm/scripts/rvm" >> ~/.bash_profile"
RUN /bin/bash -l -c "rvm autolibs disable"
RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "rvm install 2.2"
RUN /bin/bash -l -c "echo 'gem: --no-ri --no-rdoc' > ~/.gemrc"
RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"

#ADD setupchrome.sh /tmp
#RUN /bin/bash -l -c "/tmp/setupchrome.sh" 

WORKDIR /usr/src/automated-tests
RUN sudo chown -R auto_testuser:auto_testuser /usr/src/automated-tests
RUN sudo chmod +w /usr/src/automated-tests

RUN sudo chown -R auto_testuser:auto_testuser /home/auto_testuser
WORKDIR /usr/src/automated-tests/Cucumber
RUN /bin/bash -l -c "source $HOME/.bash_profile"
RUN /bin/bash -l -c "bundle install --gemfile=/usr/src/automated-tests/Cucumber/Gemfile"
RUN /bin/bash -l -c "gem query --local"

# interactive shell by default so rvm is sourced automatically
ENTRYPOINT /bin/bash -l 
