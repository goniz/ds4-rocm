#ifndef DS4_HIP_COMPAT_H
#define DS4_HIP_COMPAT_H

#if defined(__HIPCC__)

typedef __attribute__((ext_vector_type(4))) unsigned char uchar4_v;

__device__ __forceinline__ static int32_t __dp4a(int32_t a, int32_t b, int32_t c) {
    union { int32_t i; char4 c4; } ua, ub;
    ua.i = a; ub.i = b;
    return amd_mixed_dot(ua.c4, ub.c4, c, false);
}

__device__ __forceinline__ static int32_t __vcmpne4(int32_t a_, int32_t b_) {
    union { int32_t i; uchar4_v c4; } ua, ub;
    ua.i = a_; ub.i = b_;
    union { int32_t i; uchar4_v c4; } ur;
    ur.c4 = (uchar4_v)(ua.c4 != ub.c4);
    return ur.i;
}

__device__ __forceinline__ static int32_t __vsub4(int32_t a_, int32_t b_) {
    union { int32_t i; uchar4_v c4; } ua, ub, ur;
    ua.i = a_; ub.i = b_;
    ur.c4 = ua.c4 - ub.c4;
    return ur.i;
}

#endif

#endif
