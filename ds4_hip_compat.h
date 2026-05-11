#ifndef DS4_HIP_COMPAT_H
#define DS4_HIP_COMPAT_H

#if defined(__HIPCC__)

__device__ __forceinline__ static int32_t __dp4a(int32_t a, int32_t b, int32_t c) {
    union { int32_t i; char4 c4; } ua, ub;
    ua.i = a; ub.i = b;
    return amd_mixed_dot(ua.c4, ub.c4, c, false);
}

__device__ __forceinline__ static int32_t __vcmpne4(int32_t a_, int32_t b_) {
    uint32_t a = (uint32_t)a_, b = (uint32_t)b_, res = 0;
#pragma unroll
    for (int i = 0; i < 4; i++) {
        if ((uint8_t)(a >> (i * 8)) != (uint8_t)(b >> (i * 8)))
            res |= (0xFFu << (i * 8));
    }
    return (int32_t)res;
}

__device__ __forceinline__ static int32_t __vsub4(int32_t a_, int32_t b_) {
    uint32_t a = (uint32_t)a_, b = (uint32_t)b_, res = 0;
#pragma unroll
    for (int i = 0; i < 4; i++) {
        uint32_t ba = (a >> (i * 8)) & 0xFF;
        uint32_t bb = (b >> (i * 8)) & 0xFF;
        res |= ((ba > bb ? ba - bb : 0) << (i * 8));
    }
    return (int32_t)res;
}

#endif

#endif
