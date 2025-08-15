#ifndef _TYPES_H
#define _TYPES_H

typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned int uint32_t;
typedef unsigned long long uint64_t;

typedef signed char int8_t;
typedef signed short int16_t;
typedef signed int int32_t;
typedef signed long long int64_t;

#define FALSE (0)
#define TRUE (!FALSE)

#define NULL (0)

#define BIT(x) (1 << (x))
#define MASK(x) ((1 << (x)) - 1)

#endif