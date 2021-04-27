#!/bin/bash

export ARCH="x86_64"
export FOX_LIB="-Wl,-L${PREFIX}/lib,-lFoX_dom,-lFoX_sax,-lFoX_wxml,-lFoX_common,-lFoX_utils,-lFoX_fsys "
export IFLAGS="-I${SRC_DIR}/include -I${PREFIX}/finclude -I${SRC_DIR}/S3DE/iotk/include/"
export LIBDIRS="${PREFIX}/lib"
export BLAS_LIBS="-Wl,-lblas"
export SCALAPACK_LIBS="-Wl,-lscalapack"
export LAPACK_LIBS="-Wl,-llapack"
export FFT_LIBS="-Wl,-L${PREFIX}/lib -Wl,-lfftw3"
export FFTW_INCLUDE="-I${PREFIX}/include"
export MANUAL_DFLAGS="-D__FFTW3"

# Override C and Fortran preprocessor
export CPP="${CC} -E -P"
export FPP="${FC} -E -P -cpp"
#export CPPFLAGS="${CPPFLAGS}"

export CC="mpicc"
export CFLAGS="${CFLAGS} -fopenmp"
export FC="mpif90"
export FFLAGS="${FFLAGS} -fopenmp"
export LD="mpif90"
export LDFLAGS="${LDFLAGS} -fopenmp"

./configure \
    --prefix=${PREFIX} \
    --enable-parallel \
    --enable-openmp \
    --with-scalapack

make pwall
make ld1
make cp
make epw

# see https://gitlab.com/QEF/q-e/-/blob/develop/test-suite/Makefile
cd test-suite
make run-travis
cd ..

make install
