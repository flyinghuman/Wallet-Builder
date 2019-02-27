#!/bin/bash
GIT="https://github.com/UCCNetwork/ucc.git"
COINNAME="ucc"
NCPU=2
OSX_SDK=10.11

SYSTEMS=(i686-w64-mingw32 x86_64-w64-mingw32 i686-pc-linux-gnu x86_64-unknown-linux-gnu x86_64-apple-darwin11 arm-linux-gnueabihf aarch64-linux-gnu)
FOLDERS=(WIN32 WIN64 LIN32 LIN64 MACOS ARM AARCH64)
MACDIR=MACOS

LINFLAGS="--enable-zmq --enable-glibc-back-compat --enable-reduce-exports --disable-tests LDFLAGS='-static-libstdc++ -static-libgcc' CFLAGS=-fPIC"
FLAGS="--enable-reduce-exports --disable-tests"
SDK_URL=https://bitcoincore.org/depends-sources/sdks

#no more edit below here
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

#intro
echo -e "${GREEN}"
echo -e "------------------------------"
echo -e "-   ALTCOIN BUILDER HELPER   -"
echo -e "------------------------------"
echo -e " ${NC}"

function build_wallets()
{
 # Depends
 eval "git clone $GIT SOURCES"
 eval "cd SOURCES/depends"


 #download osx sdk
 if [ -n "$OSX_SDK" -a ! -f sdk-sources/MacOSX${OSX_SDK}.sdk.tar.gz ]; then
  mkdir SDKs sdk-sources
  curl --location --fail $SDK_URL/MacOSX${OSX_SDK}.sdk.tar.gz -o sdk-sources/MacOSX${OSX_SDK}.sdk.tar.gz
 fi
 if [ -n "$OSX_SDK" -a -f sdk-sources/MacOSX${OSX_SDK}.sdk.tar.gz ]; then
  tar -C SDKs -xf sdk-sources/MacOSX${OSX_SDK}.sdk.tar.gz
 fi

 #build depends
 for index in ${!FOLDERS[*]}; do
  eval "make HOST=${SYSTEMS[$index]} -j $NCPU"
 done

 eval "cd ../../"
 DEPENDS_DIR="`pwd`/SOURCES/depends"
 mv SOURCES/depends .

 #copy sources into own OS dirs
 for index in ${!FOLDERS[*]}; do
  eval "rm -rf ${FOLDERS[$index]}"
  eval "mkdir ${FOLDERS[$index]}"
  eval "cp -a SOURCES/* ${FOLDERS[$index]}/"
 done

 mv depends SOURCES/

 #build wallets
 for index in ${!FOLDERS[*]}; do
  eval "cd ${FOLDERS[$index]}"
  eval "./autogen.sh"
 if [[ (${FOLDERS[$index]} == "LIN32" || ${FOLDERS[$index]} == "LIN64") ]]; then
  eval "./configure --prefix=${DEPENDS_DIR}/${SYSTEMS[$index]} ${LINFLAGS}"
 else 
  eval "./configure --prefix=${DEPENDS_DIR}/${SYSTEMS[$index]} ${FLAGS}"
 fi
  eval "make -j ${NCPU}"
  eval "cd .."
 done

 #build mac dmg
 cd $MACDIR
 eval "make deploy"
 eval "cp *.dmg ../"
 cd ..
}

function make_zips()
{
 #make zips
 for index in ${!FOLDERS[*]}; do
  if [[ ("${FOLDERS[$index]}" != "MACOS") ]]; then
   rm -rf ${COINNAME}-${FOLDERS[$index]}-release
   rm ${COINNAME}-${FOLDERS[$index]}.zip
   mkdir ${COINNAME}-${FOLDERS[$index]}-release
   cp ${FOLDERS[$index]}/src/${COINNAME}d ${COINNAME}-${FOLDERS[$index]}-release/
   cp ${FOLDERS[$index]}/src/${COINNAME}d.exe ${COINNAME}-${FOLDERS[$index]}-release/
   cp ${FOLDERS[$index]}/src/${COINNAME}-cli ${COINNAME}-${FOLDERS[$index]}-release/
   cp ${FOLDERS[$index]}/src/${COINNAME}-cli.exe ${COINNAME}-${FOLDERS[$index]}-release/
   cp ${FOLDERS[$index]}/src/${COINNAME}-tx ${COINNAME}-${FOLDERS[$index]}-release/
   cp ${FOLDERS[$index]}/src/${COINNAME}-tx.exe ${COINNAME}-${FOLDERS[$index]}-release/
   cp ${FOLDERS[$index]}/src/qt/${COINNAME}-qt ${COINNAME}-${FOLDERS[$index]}-release/
   cp ${FOLDERS[$index]}/src/qt/${COINNAME}-qt.exe ${COINNAME}-${FOLDERS[$index]}-release/ 
   eval "strip ${COINNAME}-${FOLDERS[$index]}-release/*"
  fi
  eval "zip ${COINNAME}-${FOLDERS[$index]}.zip ${COINNAME}-${FOLDERS[$index]}-release/*"
 done
}

function end()
{
 echo "---------------------"
 echo -e "${GREEN}All Operations are done.${NC}"
}

function ask_user()
{
 echo -e "==============================================================================="
 echo -e "This Script will built binarys for several Operating Systems (cross-compiling)."
 echo -e "1 - build binarys and make zip files"
 echo -e "2 - make zip files only"
 echo -e "x - Exit"
 echo -e "==============================================================================="
 read -e -p "$(echo -e $YELLOW What is your choice? [1/2/x] $NC)" CHOICE

 if [[ ("$CHOICE" == "1") ]]; then
  build_wallets
  make_zips
 fi
 if [[ ("$CHOICE" == "2") ]]; then
  make_zips
 fi
 if [[ ("$CHOICE" == "x") ]]; then
  exit 0
 fi
}

ask_user
