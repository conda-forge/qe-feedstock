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
    -DQE_ENABLE_LIBXC=ON \
    -DQE_ENABLE_TEST=ON \
    -DCMAKE_INSTALL_PREFIX=${PREFIX} \
    -DMPIEXEC_PREFLAGS="--bind-to;none;-mca;plm;isolated" \
    -DMPIEXEC_MAX_NUMPROCS=2  \
    -DTESTCODE_NPROCS=2 \
 
make

#if [[ "$mpi" == "openmpi" ]]; then
export OMPI_MCA_plm_rsh_agent=sh
# see https://cmake.org/cmake/help/v3.9/module/FindMPI.html
#fi
#make test
# Only pw, cp, and unit tests are safe to run when using cmake curently
ctest -L "pw|cp|unit" -LE epw --output-on-failure 
make install
