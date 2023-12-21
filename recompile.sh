#!/bin/bash
##compiles even if its already been compiled ##fast if already been compiled before

##todo

scriptDir="${PWD}" ##find the real script dir

#rm -r "$scriptDir/build/built"

threads=1  ##single threaded to see code errors cleaner
echo "threads: $threads"

echo "dependencies"
echo "build-essential git make cmake clang libssl-dev libbz2-dev"
echo "default-libmysqlclient-dev libace-dev"

export CC=/usr/bin/clang	##mangos seems to prefer clang for building, fine
export CXX=/usr/bin/clang++

cmakeFlags="-DCMAKE_INSTALL_PREFIX=$scriptDir/build/built -DBUILD_MANGOSD:BOOL=1 -DBUILD_REALMD:BOOL=1 -DBUILD_TOOLS:BOOL=0 -DUSE_STORMLIB:BOOL=1 -DSCRIPT_LIB_ELUNA:BOOL=1 -DSCRIPT_LIB_SD3:BOOL=1 -DSOAP:BOOL=1 -DPLAYERBOTS:BOOL=1 -DPCH:BOOL=1 -DDEBUG:BOOL=1"
# wont build without PCH enabled atm	##tools broke atm
mkdir "$scriptDir/build"
mkdir "$scriptDir/build/built"
cd "$scriptDir/build"
cmake "$scriptDir/" $cmakeFlags
make -j$threads
make install ##not acutaly installing just copying files to  DCMAKE_INSTALL_PREFIX
