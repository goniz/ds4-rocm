#!/bin/sh
set -e
F="$1"

sed -i '1a\#include "ds4_hip_compat.h"' "$F"
sed -i 's|"ds4_iq2_tables_cuda.inc"|"ds4_iq2_tables_rocm.inc"|' "$F"
sed -i 's|<hipblas.h>|<hipblas/hipblas.h>|' "$F"
sed -i 's|<mma.h>|<rocwmma/rocwmma.hpp>|' "$F"

sed -i 's/nvcuda::wmma/rocwmma/g' "$F"
sed -i 's@#if __CUDA_ARCH__ >= 700@#if !defined(__CUDA_ARCH__) || __CUDA_ARCH__ >= 700@' "$F"

sed -i 's/0xffffffffu/0xffffffffull/g' "$F"
sed -i 's/0xffu *<</0xffull <</g' "$F"
sed -i 's/0xffffu *<</0xffffull <</g' "$F"
sed -i 's/__shfl_down_sync(0xffffffffull,/__shfl_down_sync(__activemask(),/g' "$F"
sed -i 's/__shfl_sync(0xffffffffull,/__shfl_sync(__activemask(),/g' "$F"
sed -i 's/__shfl_xor_sync(0xffffffffull,/__shfl_xor_sync(__activemask(),/g' "$F"

sed -i 's/uint32_t mask = 0xffull/uint64_t mask = 0xffull/g' "$F"
sed -i 's/uint32_t mask = 0xffffull/uint64_t mask = 0xffffull/g' "$F"

perl -i -0pe 's/HIP_R_32F,(\s*\n\s*)HIPBLAS_GEMM_DEFAULT/HIPBLAS_COMPUTE_32F,$1HIPBLAS_GEMM_DEFAULT/g' "$F"

sed -i 's/hipMemAdvise(/hipMemAdvise_v2(/g' "$F"
sed -i 's/hipMemPrefetchAsync(/hipMemPrefetchAsync_v2(/g' "$F"

sed -i 's/CUDA_QK_K/DS4_QK_K/g' "$F"
sed -i 's/cuda_block_q2_K/ds4_block_q2_K/g' "$F"
sed -i 's/cuda_block_q8_K/ds4_block_q8_K/g' "$F"
sed -i 's/cuda_block_iq2_xxs/ds4_block_iq2_xxs/g' "$F"

sed -i 's/"ds4: CUDA/"ds4: ROCm/g' "$F"

perl -i -0pe 's/"ds4: ROCm backend initialized on %s \(sm_%d%d\)\\n",\n\s*prop\.name, prop\.major, prop\.minor/"ds4: ROCm backend initialized on %s (%s)\\n",\n                prop.name, prop.gcnArchName/s' "$F"
