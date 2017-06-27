#!/bin/bash

set -o nounset -o errexit -o xtrace

export DEBIAN_FRONTEND=noninteractive

# prevent daemons from starting in the container

cat > /usr/sbin/policy-rc.d <<EOF
#!/bin/sh
exit 101
EOF

chmod +x /usr/sbin/policy-rc.d

add-apt-repository -y ppa:openjdk-r/ppa
apt-get update
apt-get install -y openjdk-8-jdk
apt-get clean

# workaround for https://github.com/docker-library/openjdk/issues/19
/var/lib/dpkg/info/ca-certificates-java.postinst configure

if [ ! -e /etc/ssl/certs/java/cacerts ]; then
    echo "Java CA certificates file not present!"
    exit 5
fi
