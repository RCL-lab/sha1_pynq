#include "ap_cint.h"

void sha1_control (  	uint1 	i_cs,
						uint1 	i_we,
						uint8 	i_address,
						uint32 	i_write,
						uint1 	*o_cs,
						uint1 	*o_we,
						uint8 	*o_address,
						uint32	*o_write,
						uint32	i_read,
						uint1 	i_error,
						uint32	*o_read,
						uint1	*o_error
					)
{
#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS INTERFACE s_axilite port=i_cs
#pragma HLS INTERFACE s_axilite port=i_we
#pragma HLS INTERFACE s_axilite port=i_address
#pragma HLS INTERFACE s_axilite port=i_write

#pragma HLS INTERFACE s_axilite port=o_read
#pragma HLS INTERFACE s_axilite port=o_error

	*o_cs = i_cs;
	*o_we = i_we;
	*o_address = i_address;
	*o_write = i_write;
	*o_read = i_read;
	*o_error = i_error;

					}

