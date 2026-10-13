/*
 * Host-fallback implementations of the GOMP offload entry points emitted by
 * gfortran for "!$omp target" constructs (used unconditionally in EPW).
 * On macOS, conda-forge's libgomp is a symlink to LLVM libomp, which does not
 * export these symbols. Without an offload device, the semantics are:
 * run the target region on the host and treat data mapping as a no-op.
 */
#include <stdbool.h>
#include <stddef.h>

void GOMP_target_ext(int device, void (*fn)(void *), size_t mapnum,
                     void **hostaddrs, size_t *sizes, unsigned short *kinds,
                     unsigned int flags, void **depend, void **args) {
  fn(hostaddrs);
}

void GOMP_target_update_ext(int device, size_t mapnum, void **hostaddrs,
                            size_t *sizes, unsigned short *kinds,
                            unsigned int flags, void **depend) {}

void GOMP_target_enter_exit_data(int device, size_t mapnum, void **hostaddrs,
                                 size_t *sizes, unsigned short *kinds,
                                 unsigned int flags, void **depend) {}

/* Host teams construct with a single team: execute the body exactly once. */
bool GOMP_teams4(unsigned int num_teams_low, unsigned int num_teams_high,
                 unsigned int thread_limit, bool first) {
  return first;
}
