#!/bin/sh

BASE_FILES="CHANGELOG COPYING INSTALL.*.txt setup.rb"
LIB_FILES="mpd.rb"
TEST_FILES="test.rb"

mkdir $1
mkdir $1/lib
mkdir $1/test

cp $BASE_FILES $1/
for LF in $LIB_FILES; do cp lib/$LF $1/lib/; done;
for TF in $TEST_FILES; do cp test/$TF $1/test/; done;

tar cvzf $1.tar.gz $1
rm -rf $1
