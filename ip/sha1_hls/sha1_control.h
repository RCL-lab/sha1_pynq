#include "ap_cint.h"
void sha1_control(   uint1 	i_cs,
					uint1 	i_we,
					uint8 	i_address,
					uint32 	i_write,

					uint1 	*o_cs,
					uint1 	*o_we,
					uint8 	*o_address,
					uint32	*o_write,

					uint32	i_read,
					uint1	i_error,
					uint32	*o_read,
					uint1	*o_error

					);
