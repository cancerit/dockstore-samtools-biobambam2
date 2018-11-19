#!/bin/bash

set -xe

if [[ -z "${TMPDIR}" ]]; then
  TMPDIR=/tmp
fi

set -u

# for SAMTOOLS install
VER_SAMTOOLS="1.7"

if [ "$#" -lt "1" ] ; then
  echo "Please provide an installation path such as /opt/ICGC"
  exit 1
fi

## SAMTOOLS (tar.bz2)
if [ ! -e $SETUP_DIR/samtools.success ]; then
  curl -sSL --retry 10 https://github.com/samtools/samtools/releases/download/${VER_SAMTOOLS}/samtools-${VER_SAMTOOLS}.tar.bz2 > distro.tar.bz2
  rm -rf distro/*
  tar --strip-components 1 -C distro -xjf distro.tar.bz2
  cd distro
  ./configure --enable-plugins --enable-libcurl --with-htslib=$INST_PATH --prefix=$INST_PATH
  make clean
  make -j$CPU all
  make install
  cd $SETUP_DIR
  rm -rf distro.* distro/*
  touch $SETUP_DIR/samtools.success
fi
