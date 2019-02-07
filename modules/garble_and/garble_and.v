//=============================================
// evaluator_and.v
// 4 SHA-1
// --------------------------------------------
// Xin Fang; 2015
//=============================================


module garble_and(

	input wire			clk,
	input wire			reset_n,

	input wire			input_valid,
	input wire	[79:0]	R,
	input wire	[79:0]	Ga,
	input wire	[79:0]	Gb,
	
	input wire	[63:0]	g_id,
	
	//output wire			Gc_valid,
	
	output wire 		output_valid,
	
	output wire			ready,
	output wire	[79:0]	Gc,
	
	//output wire			toSend01_valid,
	output wire [79:0]	toSend01,
	
	//output wire			toSend10_valid,
	output wire [79:0]	toSend10,
	
	//output wire			toSend11_valid,
	output wire [79:0]	toSend11

);

	reg	[79:0]		Ga0;
	reg	[79:0]		Ga1;
	reg	[79:0]		Gb0;
	reg	[79:0]		Gb1;
	
	reg [63:0]		gid;
	
	//reg [79:0]		mask;

	reg				Gcvld;
	reg	[79:0]		Gc0;
	reg	[79:0]		Gc1;

	//reg				valid01;
	reg	[79:0]		generated01;
	
	//reg				valid10;
	reg	[79:0]		generated10;
	
	//reg				valid11;
	reg	[79:0]		generated11;
	
	reg				outputvld;
	
	reg				CL;
	reg				CR;
	
	wire [2 :0]		iout_sig1;
	wire [2 :0]		iout_sig2;
	wire [2 :0]		iout_sig3;
	wire [2 :0]		iout_sig4;
	
	reg				ready_sig;
	
	wire				ready_sig1;
	wire 	[159:0]			digest_sig1;
	wire	[79: 0]			digest_80_sig1;
	wire				digest_valid_sig1;
	
	wire				ready_sig2;
	wire 	[159:0]			digest_sig2;
	wire	[79: 0]			digest_80_sig2;
	wire				digest_valid_sig2;
	
	wire				ready_sig3;
	wire 	[159:0]			digest_sig3;
	wire	[79: 0]			digest_80_sig3;
	wire				digest_valid_sig3;
	
	wire				ready_sig4;
	wire 	[159:0]			digest_sig4;
	wire	[79: 0]			digest_80_sig4;
	wire				digest_valid_sig4;
	
	
	
	
	
	
	assign Gc					= Gc0;
	//assign Gc_valid 			= Gcvld;
	
	//assign toSend01_valid		= valid01;
	assign toSend01         	= generated01;

	//assign toSend10_valid		= valid10;
	assign toSend10         	= generated10;

	//assign toSend11_valid		= valid11;
	assign toSend11         	= generated11;
	
	assign output_valid			= outputvld;
	
	assign ready					= ready_sig;
	
	

garbled_core garbled_core_inst1
(
	.clk(clk) ,	// input  clk_sig
	.reset_n(reset_n) ,	// input  reset_n_sig
	.kpq_valid(input_valid) ,	// input  kpq_valid_sig
	.kp(Ga0) ,	// input [79:0] kp_sig
	.kq(Gb0) ,	// input [79:0] kq_sig
	.gid(gid) ,	// input [63:0] gid_sig
	.iout(iout_sig1) ,	// output [2:0] iout_sig
	.ready(ready_sig1) ,	// output  ready_sig
	.digest(digest_sig1) ,	// output [159:0] digest_sig
	.digest_80(digest_80_sig1) ,	// output [79:0] digest_80_sig
	.digest_valid(digest_valid_sig1) 	// output  digest_valid_sig
);
	
	
garbled_core garbled_core_inst2
(
	.clk(clk) ,	// input  clk_sig
	.reset_n(reset_n) ,	// input  reset_n_sig
	.kpq_valid(input_valid) ,	// input  kpq_valid_sig
	.kp(Ga0) ,	// input [79:0] kp_sig
	.kq(Gb1) ,	// input [79:0] kq_sig
	.gid(gid) ,	// input [63:0] gid_sig
	.iout(iout_sig2) ,	// output [2:0] iout_sig
	.ready(ready_sig2) ,	// output  ready_sig
	.digest(digest_sig2) ,	// output [159:0] digest_sig
	.digest_80(digest_80_sig2) ,	// output [79:0] digest_80_sig
	.digest_valid(digest_valid_sig2) 	// output  digest_valid_sig
);


garbled_core garbled_core_inst3
(
	.clk(clk) ,	// input  clk_sig
	.reset_n(reset_n) ,	// input  reset_n_sig
	.kpq_valid(input_valid) ,	// input  kpq_valid_sig
	.kp(Ga1) ,	// input [79:0] kp_sig
	.kq(Gb0) ,	// input [79:0] kq_sig
	.gid(gid) ,	// input [63:0] gid_sig
	.iout(iout_sig3) ,	// output [2:0] iout_sig
	.ready(ready_sig3) ,	// output  ready_sig
	.digest(digest_sig3) ,	// output [159:0] digest_sig
	.digest_80(digest_80_sig3) ,	// output [79:0] digest_80_sig
	.digest_valid(digest_valid_sig3) 	// output  digest_valid_sig
);


garbled_core garbled_core_inst4
(
	.clk(clk) ,	// input  clk_sig
	.reset_n(reset_n) ,	// input  reset_n_sig
	.kpq_valid(input_valid) ,	// input  kpq_valid_sig
	.kp(Ga1) ,	// input [79:0] kp_sig
	.kq(Gb1) ,	// input [79:0] kq_sig
	.gid(gid) ,	// input [63:0] gid_sig
	.iout(iout_sig4) ,	// output [2:0] iout_sig
	.ready(ready_sig4) ,	// output  ready_sig
	.digest(digest_sig4) ,	// output [159:0] digest_sig
	.digest_80(digest_80_sig4) ,	// output [79:0] digest_80_sig
	.digest_valid(digest_valid_sig4) 	// output  digest_valid_sig
);


	
	
	always @*
		begin: inputget
			if(!reset_n)
				begin
					Ga0				= 0;
					Ga1				= 0;
					Gb0				= 0;
					Gb1				= 0;
					//mask				= 0;
					gid				= 0;
				end
			else if(input_valid)
				begin
					Ga0				= Ga;
					Ga1				= Ga ^ R;
					Gb0				= Gb;
					Gb1				= Gb ^ R;
					//mask				= R;
					gid				= g_id;
				
					CL					= Ga[0];
					CR					= Gb[0];
				end
		end

		
		
	 always @*
		begin:	CLCR
			if(CL == 1'b0 && CR == 1'b0)
				begin
				Gc0 = digest_80_sig1;
				Gc1 = digest_80_sig1 ^ R;
				generated01	= digest_80_sig2 ^ Gc0;
				generated10 = digest_80_sig3 ^ Gc0;
				generated11 = digest_80_sig4 ^ Gc1;
				end
				else if(CL == 1'b0 && CR == 1'b1)
					begin
					Gc0 = digest_80_sig2;
					Gc1 = digest_80_sig2 ^ R;
					generated01	= digest_80_sig1 ^ Gc0;
					generated10 = digest_80_sig4 ^ Gc1;
					generated11 = digest_80_sig3 ^ Gc0;
					end
					else if (CL == 1'b1 && CR == 1'b0)
						begin
						Gc0 = digest_80_sig3;
						Gc1 = digest_80_sig3 ^ R;
						generated01	= digest_80_sig4 ^ Gc1;
						generated10 = digest_80_sig1 ^ Gc0;
						generated11 = digest_80_sig2 ^ Gc0;
						end
						else if (CL == 1'b1 && CR == 1'b1)
							begin
								Gc1 = digest_80_sig4;
								Gc0 = digest_80_sig4 ^ R;
								generated01	= digest_80_sig3 ^ Gc0;
								generated10 = digest_80_sig2 ^ Gc0;
								generated11 = digest_80_sig1 ^ Gc0;
							end
							else begin
								Gc1 = 0;
								Gc0 = 0;
								generated01	= 0;
								generated10 = 0;
								generated11 = 0;
								end
							
		end

	
	always @*
		begin: gcvalid
			outputvld		= digest_valid_sig1 & digest_valid_sig2 & digest_valid_sig3 & digest_valid_sig4;
			ready_sig		= ready_sig1 & ready_sig2 & ready_sig3 & ready_sig4;
		end
	


endmodule
