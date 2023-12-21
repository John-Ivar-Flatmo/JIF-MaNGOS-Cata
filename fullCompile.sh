#!/bin/bash
##compiles from scratch after deleating exiting build

##todo

scriptDir="${PWD}" ##find the real script dir

rm -r "$scriptDir/build"

##threads=$((`nproc`+1)) ##available cores +1 to ensure fast compile time
##threads=$(((`nproc`)/2)) ##half of available threads +1 for reduced ram usage and not cook system
threads=$(((`nproc`)/4)) ##forth of available threads +1 for reduced ram usage and not cook system when builing multiple at once
##threads=2 ##more than 2 threads might interfere with other uses since we only have 4 and run servers
if [ "$threads" -eq "0" ]; then
    threads=1
fi
echo "threads: $threads"

export CC=/usr/bin/clang	##mangos seems to prefer clang for building, fine
export CXX=/usr/bin/clang++

cmakeFlags=" -DCMAKE_INSTALL_PREFIX=$buildDir/build/built -DBUILD_MANGOSD:BOOL=1 -DBUILD_REALMD:BOOL=1 -DBUILD_TOOLS:BOOL=0 -DUSE_STORMLIB:BOOL=1 -DSCRIPT_LIB_ELUNA:BOOL=1 -DSCRIPT_LIB_SD3:BOOL=1 -DSOAP:BOOL=1 -DPLAYERBOTS:BOOL=1 -DPCH:BOOL=1 -DDEBUG:BOOL=1"
# wont build without PCH enabled atm	##tools broke atm
mkdir "$scriptDir/build"
cd "$scriptDir/build"
cmake "$scriptDir/" $cmakeFlags
make -j$threads
make install ##not acutaly installing just copying files to  DCMAKE_INSTALL_PREFIX



##alternate implementation, using tools built in clean command, not as thurogh but safer if building in the wrong diretory
#threads=1
#cmakeFlags=" -DCMAKE_INSTALL_PREFIX=./built -DBUILD_EXTRACTORS=OFF -DPCH=0 -DDEBUG=1 -DBUILD_PLAYERBOT=ON"
#mkdir build
#cmake --build "./build" --target clean $cmakeFlags
#cmake --build "./build" $cmakeFlags
#cd build
#make clean
#make -j$threads
#make install ##not acutaly installing just copying files to  DCMAKE_INSTALL_PREFIX
