#ifndef _XT_IDLETIMER_H
#define _XT_IDLETIMER_H

#include <linux/types.h>

struct idletimer_tg_info {
	__u32 timeout;
	char label[32];

	/* for kernel module internal use only */
	struct idletimer_tg *timer __attribute__((aligned(8)));
};

struct idletimer_tg_info_v1 {
	__u32 timeout;
	char label[32];
	__u8 send_nl_msg;

	/* for kernel module internal use only */
	struct idletimer_tg *timer __attribute__((aligned(8)));
};

#endif
