#!/bin/bash
set -ex

## Override C and Fortran preprocessor
#export CPP="${CC} -E -P"
#export FPP="${FC} -E -P -cpp"
##export CPPFLAGS="${CPPFLAGS}"


# preprocessor executable name was hardcoded
# (will be fixed in next release)
ln -s $BUILD_PREFIX/bin/x86_64-conda-linux-gnu-cpp $BUILD_PREFIX/cpp

mkdir build
cd build
cmake .. \
    -DQE_ENABLE_MPI=ON \
    -DQE_ENABLE_OPENMP=ON \
    -DQE_ENABLE_SCALAPACK=ON \
    -DQE_ENABLE_TEST=ON \
    -DCMAKE_INSTALL_PREFIX=${PREFIX}
    
make pwall ld1 cp epw

## see https://gitlab.com/QEF/q-e/-/blob/develop/test-suite/Makefile
#cd test-suite
#make run-travis
#cd ..
make test

make install
