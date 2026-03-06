#ifndef _XT_DSCP_H
#define _XT_DSCP_H

#include <linux/types.h>

#define XT_DSCP_MASK	0xfc	/* 11111100 */
#define XT_DSCP_SHIFT	2

struct xt_dscp_info {
	__u8 dscp;
	__u8 invert;
};

#endif /* _XT_DSCP_H */
