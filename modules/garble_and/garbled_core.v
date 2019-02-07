
module garbled_core(
                 input wire            clk,
                 input wire            reset_n,

                 //input wire            init,
                 //input wire            next,
					  
					  input wire				kpq_valid,
					  input wire [79 : 0]	kp, // "abc" = 80'b01100001011000100110001110000000000000000000000000000000000000000000000000000000;
					  input wire [79 : 0]	kq, // 0 =     80'b00000000000000000000000000000000000000000000000000000000000000000000000000000000;
					  input wire [63 : 0]	gid,
					  //input wire [159 : 0]	Ri,
					  //input wire [1  : 0]	i,
					  //input wire 				Ri_valid,
					  
					  output wire [2 : 0]	iout,

                 output wire           ready,

                 output wire [159 : 0] digest,
					  output wire [79  : 0] digest_80,
                 output wire           digest_valid
                );


  //----------------------------------------------------------------
  // Internal constant and parameter definitions.
  //----------------------------------------------------------------
  parameter H0_0 = 32'h67452301;
  parameter H0_1 = 32'hefcdab89;
  parameter H0_2 = 32'h98badcfe;
  parameter H0_3 = 32'h10325476;
  parameter H0_4 = 32'hc3d2e1f0;
  
  //parameter TOKEN = 159'b101100110001001011011110100111111011001011011000110000001001001111101111000111010101000011010111001011001001000000111111111111001000111010000010110101100000010;

  parameter SHA1_ROUNDS = 79;

  parameter CTRL_IDLE   = 0;
  parameter CTRL_ROUNDS = 1;
  parameter CTRL_DONE   = 2;


  //----------------------------------------------------------------
  // Registers including update variables and write enable.
  //----------------------------------------------------------------
  reg [511: 0] block;
  reg [2:0]		iout1;
  
  reg [159 : 0] shaxorr0;
  reg [159 : 0] shaxorr1;
  reg [159 : 0] shaxorr2;
  reg [159 : 0] shaxorr3;
  
  reg [159 : 0] r0;
  reg [159 : 0] r1;
  reg [159 : 0] r2;
  reg [159 : 0] r3;
  
  reg [31 : 0] a_reg;
  reg [31 : 0] a_new;
  reg [31 : 0] b_reg;
  reg [31 : 0] b_new;
  reg [31 : 0] c_reg;
  reg [31 : 0] c_new;
  reg [31 : 0] d_reg;
  reg [31 : 0] d_new;
  reg [31 : 0] e_reg;
  reg [31 : 0] e_new;
  reg          a_e_we;

  reg [31 : 0] H0_reg;
  reg [31 : 0] H0_new;
  reg [31 : 0] H1_reg;
  reg [31 : 0] H1_new;
  reg [31 : 0] H2_reg;
  reg [31 : 0] H2_new;
  reg [31 : 0] H3_reg;
  reg [31 : 0] H3_new;
  reg [31 : 0] H4_reg;
  reg [31 : 0] H4_new;
  reg          H_we;

  reg [6 : 0] round_ctr_reg;
  reg [6 : 0] round_ctr_new;
  reg         round_ctr_we;
  reg         round_ctr_inc;
  reg         round_ctr_rst;

  reg digest_valid_reg;
  reg digest_valid_new;
  reg digest_valid_we;

  reg [1 : 0] sha1_ctrl_reg;
  reg [1 : 0] sha1_ctrl_new;
  reg         sha1_ctrl_we;


  //----------------------------------------------------------------
  // Wires.
  //----------------------------------------------------------------
  reg           digest_init;
  reg           digest_update;
  reg           state_init;
  reg           state_update;
  reg           first_block;
  reg           ready_flag;
  reg           w_init;
  reg           w_next;
  wire [31 : 0] w;




  //----------------------------------------------------------------
  // Module instantiantions.
  //----------------------------------------------------------------
  sha1_w_mem w_mem_inst(
                        .clk(clk),
                        .reset_n(reset_n),

                        .block(block),

                        .init(w_init),
                        .next(w_next),

                        .w(w)
                       );


  //----------------------------------------------------------------
  // Concurrent connectivity for ports etc.
  //----------------------------------------------------------------
  assign ready        = ready_flag;
  assign digest       = {H0_reg, H1_reg, H2_reg, H3_reg, H4_reg};
  assign digest_valid = digest_valid_reg;
  assign iout			 = iout1;
  assign digest_80	 = digest[159 : 80];



//  //----------------------------------------------------------------
//  // store ri (i from 0 to 3) to r0 to r3
//  //----------------------------------------------------------------
//  always @ (posedge clk or negedge reset_n)
//	begin : ri_store
//		if(!reset_n)
//			begin
//				r0		<=		160'h0000000000000000000000000000000000000000;
//				r1		<=		160'h0000000000000000000000000000000000000000;
//				r2		<=		160'h0000000000000000000000000000000000000000;
//				r3		<=		160'h0000000000000000000000000000000000000000;
//			end
//		else if (Ri_valid) begin
//			case(i)
//				2'b00 : r0 <= Ri;
//				2'b01 : r1 <= Ri;
//				2'b10 : r2 <= Ri;
//				2'b11 : r3 <= Ri;
//			endcase;
//		end
//	end
//					

	always @*
		begin: blockassign
			if(!reset_n)
				block		=	0;
			else if(kpq_valid) begin
				block		= {kp, kq, gid, 1'b1, 223'h0, 64'h00000000000000E0};
			end
		end


  //----------------------------------------------------------------
  // reg_update
  // Update functionality for all registers in the core.
  // All registers are positive edge triggered with
  // asynchronous active low reset. 
  // Change to synchronous here.
  //----------------------------------------------------------------
  always @ (posedge clk)
    begin : reg_update
      if (!reset_n)
        begin
          a_reg            <= 32'h00000000;
          b_reg            <= 32'h00000000;
          c_reg            <= 32'h00000000;
          d_reg            <= 32'h00000000;
          e_reg            <= 32'h00000000;
          H0_reg           <= 32'h00000000;
          H1_reg           <= 32'h00000000;
          H2_reg           <= 32'h00000000;
          H3_reg           <= 32'h00000000;
          H4_reg           <= 32'h00000000;
          digest_valid_reg <= 0;
          round_ctr_reg    <= 7'b0000000;
          sha1_ctrl_reg    <= CTRL_IDLE;
        end
      else
        begin
          if (a_e_we)
            begin
              a_reg <= a_new;
              b_reg <= b_new;
              c_reg <= c_new;
              d_reg <= d_new;
              e_reg <= e_new;
            end

          if (H_we)
            begin
              H0_reg <= H0_new;
              H1_reg <= H1_new;
              H2_reg <= H2_new;
              H3_reg <= H3_new;
              H4_reg <= H4_new;
            end

          if (round_ctr_we)
            begin
              round_ctr_reg <= round_ctr_new;
            end

          if (digest_valid_we)
            begin
              digest_valid_reg <= digest_valid_new;
            end

          if (sha1_ctrl_we)
            begin
              sha1_ctrl_reg <= sha1_ctrl_new;
            end
        end
    end // reg_update


  //----------------------------------------------------------------
  // digest_logic
  //
  // The logic needed to init as well as update the digest.
  //----------------------------------------------------------------
  always @*
    begin : digest_logic
      H0_new = 32'h00000000;
      H1_new = 32'h00000000;
      H2_new = 32'h00000000;
      H3_new = 32'h00000000;
      H4_new = 32'h00000000;
      H_we = 0;

      if (digest_init)
        begin
          H0_new = H0_0;
          H1_new = H0_1;
          H2_new = H0_2;
          H3_new = H0_3;
          H4_new = H0_4;
          H_we = 1;
        end

      if (digest_update)
        begin
          H0_new = H0_reg + a_reg;
          H1_new = H1_reg + b_reg;
          H2_new = H2_reg + c_reg;
          H3_new = H3_reg + d_reg;
          H4_new = H4_reg + e_reg;
          H_we = 1;
        end
    end // digest_logic


  //----------------------------------------------------------------
  // state_logic
  //
  // The logic needed to init as well as update the state during
  // round processing.
  //----------------------------------------------------------------
  always @*
    begin : state_logic
      reg [31 : 0] a5;
      reg [31 : 0] f;
      reg [31 : 0] k;
      reg [31 : 0] t;

      a5     = 32'h00000000;
      f      = 32'h00000000;
      k      = 32'h00000000;
      t      = 32'h00000000;
      a_new  = 32'h00000000;
      b_new  = 32'h00000000;
      c_new  = 32'h00000000;
      d_new  = 32'h00000000;
      e_new  = 32'h00000000;
      a_e_we = 0;

      if (state_init)
        begin
          if (first_block)
            begin
              a_new  = H0_0;
              b_new  = H0_1;
              c_new  = H0_2;
              d_new  = H0_3;
              e_new  = H0_4;
              a_e_we = 1;
            end
          else
            begin
              a_new  = H0_reg;
              b_new  = H1_reg;
              c_new  = H2_reg;
              d_new  = H3_reg;
              e_new  = H4_reg;
              a_e_we = 1;
            end
        end

      if (state_update)
        begin
          if (round_ctr_reg <= 19)
            begin
              k = 32'h5a827999;
              f =  ((b_reg & c_reg) ^ (~b_reg & d_reg));
            end
          else if ((round_ctr_reg >= 20) && (round_ctr_reg <= 39))
            begin
              k = 32'h6ed9eba1;
              f = b_reg ^ c_reg ^ d_reg;
            end
          else if ((round_ctr_reg >= 40) && (round_ctr_reg <= 59))
            begin
              k = 32'h8f1bbcdc;
              f = ((b_reg | c_reg) ^ (b_reg | d_reg) ^ (c_reg | d_reg));
            end
          else if (round_ctr_reg >= 60)
            begin
              k = 32'hca62c1d6;
              f = b_reg ^ c_reg ^ d_reg;
            end

          a5 = {a_reg[26 : 0], a_reg[31 : 27]};
          t = a5 + e_reg + f + k + w;

          a_new  = t;
          b_new  = a_reg;
          c_new  = {b_reg[1 : 0], b_reg[31 : 2]};
          d_new  = c_reg;
          e_new  = d_reg;
          a_e_we = 1;
        end
    end // state_logic


  //----------------------------------------------------------------
  // round_ctr
  //
  // Update logic for the round counter, a monotonically
  // increasing counter with reset.
  //----------------------------------------------------------------
  always @*
    begin : round_ctr
      round_ctr_new = 0;
      round_ctr_we  = 0;

      if (round_ctr_rst)
        begin
          round_ctr_new = 0;
          round_ctr_we  = 1;
        end

      if (round_ctr_inc)
        begin
          round_ctr_new = round_ctr_reg + 1'b1;
          round_ctr_we  = 1;
        end
    end // round_ctr


  //----------------------------------------------------------------
  // sha1_ctrl_fsm
  // Logic for the state machine controlling the core behaviour.
  //----------------------------------------------------------------
  always @*
    begin : sha1_ctrl_fsm
      digest_init      = 0;
      digest_update    = 0;
      state_init       = 0;
      state_update     = 0;
      first_block      = 0;
      ready_flag       = 0;
      w_init           = 0;
      w_next           = 0;
      round_ctr_inc    = 0;
      round_ctr_rst    = 0;
      digest_valid_new = 0;
      digest_valid_we  = 0;
      sha1_ctrl_new    = CTRL_IDLE;
      sha1_ctrl_we     = 0;

      case (sha1_ctrl_reg)
        CTRL_IDLE:
          begin
            ready_flag = 1;

            if (kpq_valid)
              begin
                digest_init      = 1;
                w_init           = 1;
                state_init       = 1;
                first_block      = 1;
                round_ctr_rst    = 1;
                digest_valid_new = 0;
                digest_valid_we  = 1;
                sha1_ctrl_new    = CTRL_ROUNDS;
                sha1_ctrl_we     = 1;
              end

//            if (next)
//              begin
//                w_init           = 1;
//                state_init       = 1;
//                round_ctr_rst    = 1;
//                digest_valid_new = 0;
//                digest_valid_we  = 1;
//                sha1_ctrl_new    = CTRL_ROUNDS;
//                sha1_ctrl_we     = 1;
//              end
          end


        CTRL_ROUNDS:
          begin
            state_update  = 1;
            round_ctr_inc = 1;
            w_next        = 1;

            if (round_ctr_reg == SHA1_ROUNDS)
              begin
                sha1_ctrl_new = CTRL_DONE;
                sha1_ctrl_we  = 1;
              end
          end


        CTRL_DONE:
          begin
            digest_update    = 1;
            digest_valid_new = 1;
            digest_valid_we  = 1;
            sha1_ctrl_new    = CTRL_IDLE;
            sha1_ctrl_we     = 1;
          end
      endcase // case (sha1_ctrl_reg)
    end // sha1_ctrl_fsm
	 
	 	 
//	always @(posedge clk or negedge reset_n)
//		begin: sha1xorRi
//			if(!reset_n) begin
//				shaxorr0		<= 	0;
//				shaxorr1		<=		0;		
//				shaxorr2		<=		0;		
//				shaxorr3		<=		0;	
//			end
//			else if (digest_valid_reg) begin
//				shaxorr0		<=		digest;
//				shaxorr1		<=		digest;
//				shaxorr2		<=		digest;
//				shaxorr3		<=		digest;
//			end
//			
//	end
	
	always @(posedge clk)
		begin : ifmatchtoken
			//if (shaxorr0[159:0] ==      160'b0000100110011001001111100011011001000111000001101000000101101010101110100011111000100101011100010111100001010000110000100110110010011100110100001101100010011101)
				//iout1 	=  3'b000;
			//else if (shaxorr1[159:0] == 160'b0010100110011001001111100011011001000111000001101000000101101010101110100011111000100101011100010111100001010000110000100110110010011100110100001101100010011101)
				//iout1 	=  3'b001;
			//else 
			if (digest_80 == 80'b10000111110111000111100100100101111111001110001001111111100001111011110101010111)
				iout1 	=  3'b101;  //this is the right answer.
			//else if (shaxorr3[159:0] == 160'b0110100110011001001111100011011001000111000001101000000101101010101110100011111000100101011100010111100001010000110000100110110010011100110100001101100010011101)
			// iout1 	=  3'b011;
			else iout1 = 3'b111;
		end

endmodule // garbled_sha1

//======================================================================
// EOF garbled_sha1.v
//======================================================================
