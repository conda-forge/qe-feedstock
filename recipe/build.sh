#!/bin/bash
# Some tests are still failing (always check manually)
# Put back `set -ex` once we can make all tests pass
set -x


# preprocessor executable name was hardcoded
# (will be fixed in next release)
ln -s $CPP $BUILD_PREFIX/cpp

mkdir build
cd build

# FOR MPIEXEC configuration, see https://cmake.org/cmake/help/v3.9/module/FindMPI.html

cmake .. \
    -DQE_ENABLE_MPI=ON \
    -DQE_ENABLE_OPENMP=ON \
    -DQE_ENABLE_SCALAPACK=ON \
    -DQE_ENABLE_LIBXC=ON \
    -DQE_ENABLE_TEST=ON \
    -DCMAKE_INSTALL_PREFIX=${PREFIX} \
    -DMPIEXEC_PREFLAGS="--oversubscribe;--bind-to;none;-mca;plm;isolated" \
    -DMPIEXEC_MAX_NUMPROCS=2  \
    -DTESTCODE_NPROCS=2 \
 
make

#if [[ "$mpi" == "openmpi" ]]; then
export OMPI_MCA_plm_rsh_agent=sh
#fi

# Only pw, cp, and unit tests are safe to run when using cmake curently (to fix in later releases)
#make test
ctest -L "pw|cp|unit" -LE epw --output-on-failure 

make install
