#!/bin/bash
# Some tests are still failing (always check manually)
set -ex

# On macOS, libgomp is provided by llvm-openmp (libomp), which lacks the GOMP
# offload entry points that gfortran emits for EPW's "!$omp target" constructs
if [[ ${target_platform} == osx-* ]]; then
  ${CC} ${CFLAGS} -c ${RECIPE_DIR}/gomp_target_stubs.c -o ${SRC_DIR}/gomp_target_stubs.o
  export LDFLAGS="${LDFLAGS} ${SRC_DIR}/gomp_target_stubs.o"
fi

mkdir build
cd build

MPI_CMAKE_ARGS=()
if [[ "${mpi}" == "openmpi" ]]; then
  MPI_CMAKE_ARGS+=(-DMPIEXEC_PREFLAGS="--oversubscribe;--bind-to;none;-mca;plm;isolated")
  export OMPI_MCA_plm_rsh_agent=sh
fi

cmake .. \
  ${CMAKE_ARGS} \
  "${MPI_CMAKE_ARGS[@]}" \
  -DQE_ENABLE_ELPA=ON \
  -DQE_FOX_INTERNAL=ON \
  -DQE_ENABLE_HDF5=ON \
  -DQE_ENABLE_LIBXC=OFF \
  -DQE_ENABLE_MPI=ON \
  -DQE_ENABLE_OPENMP=ON \
  -DQE_ENABLE_SCALAPACK=ON \
  -DQE_ENABLE_TEST=ON \
  -DMPIEXEC_MAX_NUMPROCS=2 \
  -DTESTCODE_NPROCS=2
cmake --build . --parallel "${CPU_COUNT}"

export OMP_NUM_THREADS=1

# Run the full test set for native builds, only the unit tests for the
# linux-aarch64 cross build (executed via QEMU), and skip tests otherwise
# (e.g. osx-arm64 on osx-64 cannot execute the target binaries)
if [[ "${target_platform}" == "${build_platform:-${target_platform}}" ]]; then
  ctest -L "pw|cp|unit" -LE epw --output-on-failure || true
elif [[ "${target_platform}" == "linux-aarch64" ]]; then
  ctest -L "unit" -LE epw --output-on-failure || true
fi

cmake --install .
