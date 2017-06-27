FROM docker.otenv.com/ot-ubuntu:latest

ADD https://s3-us-west-2.amazonaws.com/deploy-images/libyjpagent.so /opt/libyjpagent.so
ADD stage2.sh /
RUN /stage2.sh

MAINTAINER Lai-Mei Ng

RUN apt-get update
# install the prerequisite patches here so that rvm will install under non-root account. 
RUN apt-get install -y curl patch gawk g++ gcc make libc6-dev patch libreadline6-dev zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 autoconf libgdbm-dev libncurses5-dev automake libtool bison pkg-config libffi-dev 

##Prerequisites for headless chrome
RUN apt-get install -y openjdk-8-jre-headless xvfb libxi6 libgconf-2-4 iceweasel

## prerequisites for ruby gems
RUN apt-get install -y libcurl3 libcurl3-gnutls libcurl4-openssl-dev libxml2-dev libxslt-dev freetds-dev 

RUN wget https://github.com/mozilla/geckodriver/releases/download/v0.13.0/geckodriver-v0.13.0-linux64.tar.gz
RUN tar -xaf geckodriver-v0.13.0-linux64.tar.gz
RUN mv -f geckodriver /usr/local/share/
RUN chmod +x /usr/local/share/geckodriver
RUN ln -s /usr/local/share/geckodriver /usr/local/bin/geckodriver
RUN rm geckodriver-v0.13.0-linux64.tar.gz

##Clone Automation Test repository
WORKDIR /usr/src/automated-tests
RUN git clone https://2383126dd451668c1fb01ac490d538b391211d6d@github.com/lngot/automated-tests.git /usr/src/automated-tests

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

ENV DISPLAY=10.10.22.8:0.0
####Need to run this manually in the docker image
#CMD Xvfb :0 -screen 0 1024x768x16&

# interactive shell by default so rvm is sourced automatically
ENTRYPOINT /bin/bash -l 
