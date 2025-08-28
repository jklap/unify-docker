#!/usr/bin/env bash

# fail on error
set -e

if [ "x${1}" == "x" ]; then
    echo please pass PKGURL as an environment variable
    exit 0
fi

apt-get update
apt-get install -qy --no-install-recommends \
    apt-transport-https \
    curl \
    dirmngr \
    gpg \
    gpg-agent \
    openjdk-17-jre-headless \
    procps \
    libcap2-bin \
    tzdata

echo 'deb [signed-by=/usr/share/keyrings/unifi-repo.gpg] https://www.ui.com/downloads/unifi/debian stable ubiquiti' | tee /etc/apt/sources.list.d/100-ubnt-unifi.list
curl -L -o /usr/share/keyrings/unifi-repo.gpg https://dl.ui.com/unifi/unifi-repo.gpg

#echo 'deb [signed-by=/usr/share/keyrings/mongodb-server-3.6.pgp] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/3.6 multiverse' | tee /etc/apt/sources.list.d/100-mongodb-server.list
#curl -s -N https://pgp.mongodb.com/server-3.6.asc | gpg --dearmor > /usr/share/keyrings/mongodb-server-3.6.pgp
# need to set trusted because signature has expired and EOL'ed
#echo 'deb [trusted=yes] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse' | tee /etc/apt/sources.list.d/100-mongodb-server.list
#echo 'deb [signed-by=/usr/share/keyrings/mongodb-server-4.2.pgp] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse' | tee /etc/apt/sources.list.d/100-mongodb-server.list
#curl -s -N https://pgp.mongodb.com/server-4.2.asc | gpg --dearmor > /usr/share/keyrings/mongodb-server-4.2.pgp

#echo 'deb [signed-by=/usr/share/keyrings/mongodb-server-4.4.pgp] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.4 multiverse' | tee /etc/apt/sources.list.d/100-mongodb-server.list
#curl -s -N https://pgp.mongodb.com/server-4.4.asc | gpg --dearmor > /usr/share/keyrings/mongodb-server-4.4.pgp

#echo 'deb [signed-by=/usr/share/keyrings/mongodb-server-5.0.pgp] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/5.0 multiverse' | tee /etc/apt/sources.list.d/100-mongodb-server.list
#curl -s -N https://pgp.mongodb.com/server-5.0.asc | gpg --dearmor > /usr/share/keyrings/mongodb-server-5.0.pgp

#echo 'deb [signed-by=/usr/share/keyrings/mongodb-server-6.0.pgp] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/6.0 multiverse' | tee /etc/apt/sources.list.d/100-mongodb-server.list
#curl -s -N https://pgp.mongodb.com/server-6.0.asc | gpg --dearmor > /usr/share/keyrings/mongodb-server-6.0.pgp

echo 'deb [signed-by=/usr/share/keyrings/mongodb-server-7.0.pgp] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/7.0 multiverse' | tee /etc/apt/sources.list.d/100-mongodb-server.list
curl -s -N https://pgp.mongodb.com/server-7.0.asc | gpg --dearmor > /usr/share/keyrings/mongodb-server-7.0.pgp

apt-get update

if [ -d "/usr/local/docker/pre_build/$(dpkg --print-architecture)" ]; then
    find "/usr/local/docker/pre_build/$(dpkg --print-architecture)" -type f -exec '{}' \;
fi

curl -L -o ./unifi.deb "${1}"
apt -qy install ./unifi.deb
rm -f ./unifi.deb
chown -R unifi:unifi /usr/lib/unifi
rm -rf /var/lib/apt/lists/*

rm -rf ${ODATADIR} ${OLOGDIR} ${ORUNDIR} ${BASEDIR}/data ${BASEDIR}/run ${BASEDIR}/logs
mkdir -p ${DATADIR} ${LOGDIR} ${RUNDIR}
ln -s ${DATADIR} ${BASEDIR}/data
ln -s ${RUNDIR} ${BASEDIR}/run
ln -s ${LOGDIR} ${BASEDIR}/logs
ln -s ${DATADIR} ${ODATADIR}
ln -s ${LOGDIR} ${OLOGDIR}
ln -s ${RUNDIR} ${ORUNDIR}
mkdir -p /var/cert ${CERTDIR}
ln -s ${CERTDIR} /var/cert/unifi

rm -rf "${0}"
