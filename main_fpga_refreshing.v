`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:02:47 07/30/2024 
// Design Name: 
// Module Name:    main_fpga_new 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module main_fpga_refreshing(
	input  wire       clk              ,
	input  wire       reset            ,
	input  wire       crypto_start     ,
	input  wire [7:0] data_from_control, // input  wire [7:0] data_from_control,
	output reg  [7:0] data_to_control  , // output reg  [7:0] data_to_control  ,
	output reg        crypto_ready     ,
	output wire       start_out        ,
	output wire       ready_out        ,
	output wire [2:0] main_state
);

	// renewed version of top logic for FSM
	
	// states as local parameters
	parameter STATE_IDLE = 7'b0000001;
	parameter STATE_READ_INPUT = 7'b0000010;
	parameter STATE_READ_RAND = 7'b0000100;			// read randomness itself or hust the seed
	parameter STATE_ENC = 7'b0001000;				// this may trigger in other states
	parameter STATE_SEND_CT = 7'b0010000;
	parameter STATE_WAIT_CYCLE = 7'b0100000;
//   parameter <state6> = 3'b101;
//   parameter <state7> = 3'b110;
//   parameter <state8> = 3'b111;
	parameter STATE_READ_SEED = 7'b1000000; 
	
	// state register to keep current stage (check out the flags used here)
	/*(* FSM_ENCODING="SEQUNTIAL", SAFE_IMPLEMENTATION="YES", SAFE_RECOVERY_STATE="STATE_IDLE" *)*/ 
	reg [6:0] state = STATE_IDLE;
	
	// Additional parameters that we use for the implementation
	parameter sbox_delay = 8;		// here we choose the delay depending on the number of registers 
	parameter N_SHARES = 3;
	
	// to enumerate
	integer i;
	
	// registers that are used as parts of FSM (consider them in every case of the state)
	// except for the regs defined as outputs: crypto_ready, data_to_control
	reg [7:0] counter = 0; 
	reg [$clog2(N_SHARES)-1:0] share_n_counter = 0;
	reg [sbox_delay*8-1:0] pt_shares [0:N_SHARES-1];	// for 4 stages we have 32 bits
	reg [sbox_delay*8-1:0] ct_shares [0:N_SHARES-1];	// not really adjustable since we have to use fixed bit lengths for assignment
	// reg [19:0] fresh_rnd; // we want to use fresh randomness for all clk cycles, even irrelevant ones (we measure 9, not 4)
	
	// PRNG related declaration
	localparam S_SEED_bytes = 5; // Size of seed in bytes used for counters
	localparam S_SEED_b = 5 * 8; // Size of seed in bits (40 is needed for keccak)
	reg en_Keccak_RNG;
	reg rst_cipher;		// reset high provides Keccak with some initial input
	reg [S_SEED_b-1:0] seed;	// we need 40 bits for Keccak
	wire [799:0] rnd_generated;
	
	
	
	// wires connecting FSM with the uut
	// wire [63:0] fresh_to_box;
	wire [7:0] pt_share_1, pt_share_2, pt_share_3;  
	wire [7:0] ct_share_1, ct_share_2, ct_share_3;
	wire [31:0] rnd_unreg;		// to register inside the Sbox
	
	assign start_out = (state == STATE_WAIT_CYCLE); // change to STATE_ENC    or   STATE_READ_RAND
	assign ready_out = (state == STATE_SEND_CT);
	assign main_state = state[2:0]; // this has to be fixed, now doesn't show the correct state
	
	// Connections
	assign pt_share_1 = pt_shares[0][sbox_delay*8-1:sbox_delay*8-8];
	assign pt_share_2 = pt_shares[1][sbox_delay*8-1:sbox_delay*8-8];
	assign pt_share_3 = pt_shares[2][sbox_delay*8-1:sbox_delay*8-8];
	//assign fresh_to_box = fresh_rnd[sbox_delay*64*2-1:sbox_delay*64*2-64];
	
	// The unit under test (AES Sbox in that case)
	AES_S_box Sbox_uut(.clk(clk),  // 39 bits of Randomness already registered
						.I1(pt_share_1), .I2(pt_share_2), .I3(pt_share_3),	// 8 bits
                  .r(rnd_generated[271:0]),						
						.O1(ct_share_1), .O2(ct_share_2), .O3(ct_share_3));	// 8 bits 
	
	
						
	// PRNG used for fresh randomness not to transfer it from the control board:
	Keccak_p800 pRNG (
		.start(en_Keccak_RNG), .clk(clk), .rst(rst_cipher), 
		.seed(seed),
		.s_out_r(rnd_generated),
		.rand_unreg(rnd_unreg)
	);
	
	// keep here the register of Keccak_p800 generated randomness
	// Or not, we just duplicate 32 bits of output for now to reuse them in Sbox
	
	// FSM description (all the assignments are done with registers, nothing more, careful with the counters, conditions are fine)
	always @(posedge clk) begin
		if (reset) begin
			state <= STATE_IDLE;
		end
		else begin 
			/*(* PARALLEL_CASE *)*/ case (state) // what does it mean parallel case?
				STATE_IDLE : begin
					if (crypto_start) begin
						// state <= STATE_READ_INPUT;
						state <= STATE_READ_SEED;
						// share_n_counter <= share_n_counter + 1'b1;
						// pt_shares[share_n_counter] <= {pt_shares[share_n_counter][sbox_delay*8-9:0], data_from_control};
						// fresh_rnd <= {fresh_rnd[sbox_delay*64*2-9:0], data_from_control};
						crypto_ready <= 1'b0;
						data_to_control <= 8'b0;
						counter <= 8'b0;
						for (i = 0; i < N_SHARES; i = i + 1) begin
							ct_shares[i] <= 0;
							pt_shares[i] <= 0;
						end
						// fresh_rnd <= 639'b0;
						rst_cipher <= 1'b0;
						en_Keccak_RNG <= 1'b0;
					end
					else begin 
						share_n_counter <= 1'b0;
						for (i = 0; i < N_SHARES; i = i + 1) begin
							pt_shares[i] <= 0;
							ct_shares[i] <= 0;
						end 
						//fresh_rnd <= 639'b0;
						crypto_ready <= 1'b0;
						data_to_control <= 8'b0;
						counter <= 8'b0;
						rst_cipher <= 1'b0;
						en_Keccak_RNG <= 1'b0;
					end
				end
				
				STATE_READ_SEED: begin
					seed[7:0] <= data_from_control;
					seed[S_SEED_b-1:8] <= seed[S_SEED_b - 9:0];
					if (counter == S_SEED_bytes - 1) begin
						state <= STATE_READ_INPUT;
						// counter <= 7'd25;
						counter <= 8'd0;
						rst_cipher <= 1'b1;
						// en_Keccak_RNG <= 1'b1; // enable PRNG as soon as the seed is ready
					end else begin
						counter <= counter + 1'b1;
					end
				end
				
				STATE_READ_INPUT : begin
					rst_cipher <= 1'b0;
					en_Keccak_RNG <= 1'b1; // this should be changed to 1!! to correctly run the pRNG
					if ( (counter < sbox_delay) && (share_n_counter == N_SHARES - 1) ) begin
						pt_shares[share_n_counter] <= {pt_shares[share_n_counter][sbox_delay*8-9:0], data_from_control};
						// fresh_rnd <= {fresh_rnd[sbox_delay*64*2-65:0], fresh_rnd[sbox_delay*64*2-1:sbox_delay*64*2-64]};
						share_n_counter <= 1'b0;
						counter <= counter + 1'b1;
						ct_shares[0][sbox_delay*8-1:0] <= {ct_shares[0][sbox_delay*8-9:0], ct_share_1};	// rotate before we output them
						ct_shares[1][sbox_delay*8-1:0] <= {ct_shares[1][sbox_delay*8-9:0], ct_share_2};
						ct_shares[2][sbox_delay*8-1:0] <= {ct_shares[2][sbox_delay*8-9:0], ct_share_3};
					end
					else if (counter < sbox_delay) begin
						pt_shares[share_n_counter] <= {pt_shares[share_n_counter][sbox_delay*8-9:0], data_from_control};
						// fresh_rnd <= {fresh_rnd[sbox_delay*64*2-65:0], fresh_rnd[sbox_delay*64*2-1:sbox_delay*64*2-64]};
						share_n_counter <= share_n_counter + 1'b1;
						// Check after 1st synthesis if we need the following kind of expressions
						// counter <= counter;
						ct_shares[0][sbox_delay*8-1:0] <= {ct_shares[0][sbox_delay*8-9:0], ct_share_1};	// rotate before we output them
						ct_shares[1][sbox_delay*8-1:0] <= {ct_shares[1][sbox_delay*8-9:0], ct_share_2};
						ct_shares[2][sbox_delay*8-1:0] <= {ct_shares[2][sbox_delay*8-9:0], ct_share_3};
					end
					else begin
						// state <= STATE_READ_RAND;
						// counter <= 0;
						// state <= STATE_ENC;
						// counter <= 8'b00000001;
						state <= STATE_WAIT_CYCLE;
						counter <= 8'd0;
						// fresh_rnd <= {fresh_rnd[sbox_delay*64*2-9:0], data_from_control};
						// fresh_rnd <= {fresh_rnd[sbox_delay*64*2-65:0], fresh_rnd[sbox_delay*64*2-1:sbox_delay*64*2-64]};
						// start rotation (goes while ENC is not finished)
						for (i = 0; i < N_SHARES; i = i + 1) begin
							pt_shares[i] <= {pt_shares[i][sbox_delay*8-9:0], pt_shares[i][sbox_delay*8-1:sbox_delay*8-8]};
						end
						ct_shares[0][sbox_delay*8-1:0] <= {ct_shares[0][sbox_delay*8-9:0], ct_share_1};	// rotate before we output them
						ct_shares[1][sbox_delay*8-1:0] <= {ct_shares[1][sbox_delay*8-9:0], ct_share_2};
						ct_shares[2][sbox_delay*8-1:0] <= {ct_shares[2][sbox_delay*8-9:0], ct_share_3};
						// always output ct_shares as well (???)
					end
				end
				
				STATE_WAIT_CYCLE : begin
					if (counter < sbox_delay*4 - 2) begin
						for (i = 0; i < N_SHARES; i = i + 1) begin
							pt_shares[i] <= {pt_shares[i][sbox_delay*8-9:0], pt_shares[i][sbox_delay*8-1:sbox_delay*8-8]};
						end
						ct_shares[0][sbox_delay*8-1:0] <= {ct_shares[0][sbox_delay*8-9:0], ct_share_1};	// rotate before we output them
						ct_shares[1][sbox_delay*8-1:0] <= {ct_shares[1][sbox_delay*8-9:0], ct_share_2};
						ct_shares[2][sbox_delay*8-1:0] <= {ct_shares[2][sbox_delay*8-9:0], ct_share_3};
						counter <= counter + 1'b1;
					end
					else begin
						for (i = 0; i < N_SHARES; i = i + 1) begin
							pt_shares[i] <= {pt_shares[i][sbox_delay*8-9:0], pt_shares[i][sbox_delay*8-1:sbox_delay*8-8]};
						end
						ct_shares[0][sbox_delay*8-1:0] <= {ct_shares[0][sbox_delay*8-9:0], ct_share_1};	// rotate before we output them
						ct_shares[1][sbox_delay*8-1:0] <= {ct_shares[1][sbox_delay*8-9:0], ct_share_2};
						ct_shares[2][sbox_delay*8-1:0] <= {ct_shares[2][sbox_delay*8-9:0], ct_share_3};
						// counter <= 8'b00000001;
						state <= STATE_ENC;
					end
				end
				
				
				STATE_ENC : begin
					if (counter < sbox_delay*4 - 2 + sbox_delay - 1) begin
						counter <= counter + 1'b1;
						ct_shares[0][sbox_delay*8-1:0] <= {ct_shares[0][sbox_delay*8-9:0], ct_share_1};	// rotate before we output them
						ct_shares[1][sbox_delay*8-1:0] <= {ct_shares[1][sbox_delay*8-9:0], ct_share_2};
						ct_shares[2][sbox_delay*8-1:0] <= {ct_shares[2][sbox_delay*8-9:0], ct_share_3};
						// rotate to provide correct inputs
						for (i = 0; i < N_SHARES; i = i + 1) begin
							pt_shares[i] <= {pt_shares[i][sbox_delay*8-9:0], pt_shares[i][sbox_delay*8-1:sbox_delay*8-8]};
						end
					end
					else begin
						state <= STATE_SEND_CT;
						counter <= 0;
						share_n_counter <= 0;
						for (i = 0; i < N_SHARES; i = i + 1) begin
							pt_shares[i] <= {pt_shares[i][sbox_delay*8-9:0], pt_shares[i][sbox_delay*8-1:sbox_delay*8-8]};
							// ct_shares[i] <= {ct_shares[i][sbox_delay*8-9:0], ct_shares[i][sbox_delay*8-1:sbox_delay*8-8]};
						end
						ct_shares[0][sbox_delay*8-1:0] <= {ct_shares[0][sbox_delay*8-9:0], ct_share_1};	// rotate before we output them
						ct_shares[1][sbox_delay*8-1:0] <= {ct_shares[1][sbox_delay*8-9:0], ct_share_2};
						ct_shares[2][sbox_delay*8-1:0] <= {ct_shares[2][sbox_delay*8-9:0], ct_share_3};
					end
				end
				
				STATE_SEND_CT : begin
					en_Keccak_RNG <= 1'b0; // This was not here before and probably may be removed, to check which part will leak
					if ( (counter == sbox_delay - 1) && (share_n_counter == N_SHARES - 1) ) begin
						state <= STATE_IDLE;
						crypto_ready <= 1'b1;
						share_n_counter <= 0;
						counter <= 0;
						for (i = 0; i < N_SHARES; i = i + 1) begin
							pt_shares[i] <= 0;
							ct_shares[i] <= 0;
						end
						data_to_control <= ct_shares[share_n_counter][sbox_delay*8-1:sbox_delay*8-8];
					end
					else if (counter == sbox_delay - 1) begin
						crypto_ready <= 1;
						share_n_counter <= share_n_counter + 1'b1;
						counter <= 0;
						// rotate both cts now 
						for (i = 0; i < N_SHARES; i = i + 1) begin
							if (i == share_n_counter) begin
								ct_shares[share_n_counter] <= {ct_shares[share_n_counter][sbox_delay*8-9:0], 8'b0};
							end
							else begin
								ct_shares[i] <= {ct_shares[i][sbox_delay*8-9:0], ct_shares[i][sbox_delay*8-1:sbox_delay*8-8]};
							end
						end
						data_to_control <= ct_shares[share_n_counter][sbox_delay*8-1:sbox_delay*8-8];
						for (i = 0; i < N_SHARES; i = i + 1) begin
							pt_shares[i] <= {pt_shares[i][sbox_delay*8-9:0], pt_shares[i][sbox_delay*8-1:sbox_delay*8-8]};
						end
					end
					else begin
						crypto_ready <= 1;
						counter <= counter + 1'b1;
						for (i = 0; i < N_SHARES; i = i + 1) begin
							if (i == share_n_counter) begin
								ct_shares[share_n_counter] <= {ct_shares[share_n_counter][sbox_delay*8-9:0], 8'b0};
							end
							else begin
								ct_shares[i] <= {ct_shares[i][sbox_delay*8-9:0], ct_shares[i][sbox_delay*8-1:sbox_delay*8-8]};
							end
						end
						data_to_control <= ct_shares[share_n_counter][sbox_delay*8-1:sbox_delay*8-8];
						for (i = 0; i < N_SHARES; i = i + 1) begin
							pt_shares[i] <= {pt_shares[i][sbox_delay*8-9:0], pt_shares[i][sbox_delay*8-1:sbox_delay*8-8]};
						end
					end
				end
				
				default : begin
					state <= STATE_IDLE;
				end
			endcase
		end
	end

endmodule