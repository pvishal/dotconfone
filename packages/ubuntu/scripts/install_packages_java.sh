#!/bin/bash

if [ $1 == "install" ]; then
    sudo -E apt-get install -y openjdk-9-jdk
    sudo -E apt-get install -y openjdk-9-jre libxmu6 libpangoxft-1.0-0 libpangox-1.0-0 libxv1
    sudo -E apt-get install -y openjdk-9-jre:i386 libxmu6:i386 libpangoxft-1.0-0:i386 libpangox-1.0-0:i386 libxv1:i386
    sudo -E apt-get install -y icedtea-9-plugin
fi
