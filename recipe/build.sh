#!/bin/bash
./configure --prefix=${PREFIX} \
            ARCH="x86_64" \
            FOX_LIB="-L${PREFIX}/lib -lFoX_dom -lFoX_sax -lFoX_wxml -lFoX_common -lFoX_utils -lFoX_fsys " \
            IFLAGS="-I${SRC_DIR}/include -I${PREFIX}/finclude -I${SRC_DIR}/S3DE/iotk/include/" \
            CC="${CC}" \
            CPP="${CPP}" \
            LD="mpif90 -fopenmpi -fopenmp" \
            CFLAGS="${CFLAGS} -L${PREFIX}/lib -lfftw3 -lblas -llapack -lscalapack" \
            FFLAGS="${FFLAGS} -L${PREFIX}/lib -lfftw3 -lblas -llapack -lscalapack" \
            CPPFLAGS="${CPPFLAGS} -L${PREFIX}/lib -lfftw3 -lblas -llapack -lscalapack" 
 make pwall
 make install
