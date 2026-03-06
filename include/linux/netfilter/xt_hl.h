#ifndef _XT_HL_H
#define _XT_HL_H

#include <linux/types.h>

enum {
	XT_HL_EQ = 0,
	XT_HL_NE,
	XT_HL_LT,
	XT_HL_GT,
};

struct xt_hl_info {
	__u8	mode;
	__u8	hop_limit;
	__u8	invert;
};

#endif /* _XT_HL_H */
