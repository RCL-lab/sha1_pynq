#include "ap_cint.h"

void garble_if (   	uint1 	i_ov,
					uint1 	i_ready,
					uint80 	i_Gc,
					uint80 	i_toSend01,
					uint80 	i_toSend10,
					uint80  i_toSend11,

					uint1 	*o_ov,
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

					)
{
#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS INTERFACE s_axilite port=o_ov
#pragma HLS INTERFACE s_axilite port=o_ready
#pragma HLS INTERFACE s_axilite port=o_Gc
#pragma HLS INTERFACE s_axilite port=o_toSend01
#pragma HLS INTERFACE s_axilite port=o_toSend10
#pragma HLS INTERFACE s_axilite port=o_toSend11

#pragma HLS INTERFACE s_axilite port=i_iv
#pragma HLS INTERFACE s_axilite port=i_R
#pragma HLS INTERFACE s_axilite port=i_Ga
#pragma HLS INTERFACE s_axilite port=i_Gb
#pragma HLS INTERFACE s_axilite port=i_gid

#pragma HLS INTERFACE ap_none port=o_iv
#pragma HLS INTERFACE ap_none port=o_R
#pragma HLS INTERFACE ap_none port=o_Ga
#pragma HLS INTERFACE ap_none port=o_Gb
#pragma HLS INTERFACE ap_none port=o_gid

	*o_iv = i_iv;
	*o_R = i_R;
	*o_Ga = i_Ga;
	*o_Gb = i_Gb;
	*o_gid = i_gid;

	*o_ov = i_ov;
	*o_ready = i_ready;
	*o_Gc = i_Gc;
	*o_toSend01 = i_toSend01;
	*o_toSend10 = i_toSend10;
	*o_toSend11 = i_toSend11;

					}
