#!/bin/bash
set -ex

## Override C and Fortran preprocessor
#export CPP="${CC} -E -P"
#export FPP="${FC} -E -P -cpp"
##export CPPFLAGS="${CPPFLAGS}"


# preprocessor executable name was hardcoded
# (will be fixed in next release)
ln -s $CPP $BUILD_PREFIX/cpp

mkdir build
cd build
cmake .. \
    -DQE_ENABLE_MPI=ON \
    -DQE_ENABLE_OPENMP=ON \
    -DQE_ENABLE_SCALAPACK=ON \
    -DQE_ENABLE_TEST=ON \
    -DCMAKE_INSTALL_PREFIX=${PREFIX}
    
make

#make test
# Only pw, cp, and unit tests are safe to run when using cmake curently
ctest -L "pw|cp|unit" -LE epw

make install
