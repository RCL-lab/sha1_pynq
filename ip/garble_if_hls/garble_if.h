#include "ap_cint.h"
void garble_if(   	uint1 	i_ov,
					uint1 	i_ready,
					uint80 	i_Gc,
					uint80 	i_toSend01,
					uint80 	i_toSend10,
					uint80  i_toSend11,

					uint80 	*o_ov,
					uint1 	*o_ready,
					uint80 	*o_Gc,
					uint80 	*o_toSend01,
					uint80 	*o_toSend10,
					uint80  *o_toSend11,

					uint1 	*o_iv,
					uint80 	*o_R,
					uint80 	*o_Ga,
					uint80	*o_Gb,
					uint64	*o_gid,

					uint1 	i_iv,
					uint80 	i_R,
					uint80 	i_Ga,
					uint80	i_Gb,
					uint64	i_gid

					);
