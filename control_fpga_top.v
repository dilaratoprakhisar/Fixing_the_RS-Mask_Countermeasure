/*

NOTES:
* This file is intended to work for an arbitrary number of shares by just updating the N_SHARES parameter
It has, however, only been tested with N_SHARES = 3

Instructions are
- FIXvsFIXmaskOff = 1;
- FIXvsRNDmaskOff = 2;
- RNDvsRNDmaskOff = 3;
- FIXvsFIXmaskOn = 4;
- FIXvsRNDmaskOn = 5;
- RNDvsRNDmaskOn = 6;

TODO: It would be nice to change the instructions to have one bit meaning something. Like bit #0 controls masks, bit #1 controls FIX group 1 etc.

*/

module control_fpga_top (
    input  wire       clk              ,
    input  wire       reset            ,
    input  wire       pin_rx           ,
    input  wire       crypto_ready     ,
    input  wire [7:0] data_to_control  ,
    output reg  [7:0] data_from_control,
    output wire       pin_tx           ,
    output reg        crypto_start     ,
    output wire       clk_out,
    // state
    output wire [3:0] ctrl_state
);

	assign clk_out = clk;
	
	// States
	// localparam STATE_IDLE        = 4'h0;
	// localparam STATE_RECEIVE     = 4'h1;
	// localparam STATE_RAND        = 4'h2;
	// localparam STATE_SEND_PT_KEY = 4'h3;
	// localparam STATE_WAIT        = 4'h4;
	// localparam STATE_READ_CT     = 4'h5;
	// localparam STATE_LOOPBACK    = 4'h6;
	// localparam STATE_SEND_CT     = 4'h7;
	
	localparam STATE_IDLE = 9'b000000001;
	localparam STATE_RECEIVE = 9'b000000010;
	localparam STATE_RAND = 9'b000000100;			// read randomness itself or hust the seed
	localparam STATE_SEND_PT_KEY = 9'b000001000;				// this may trigger in other states
	localparam STATE_WAIT = 9'b000010000;
	localparam STATE_READ_CT = 9'b000100000;
	localparam STATE_LOOPBACK = 9'b001000000; 
	localparam STATE_SEND_CT = 9'b010000000;
	localparam STATE_SEND_SEED = 9'b100000000;
	//   parameter <state6> = 3'b101;
	//   parameter <state7> = 3'b110;
	//   parameter <state8> = 3'b111;
	
	reg [8:0] state = STATE_IDLE;
	assign ctrl_state = state[7:4];				// ISSUE: now we don't have enough lights to correctly encode the state
	
	// Constants dependant on design
	localparam sbox_delay = 8; // clks to eval 1 Sbox
	localparam N_SHARES = 3;
	localparam N_RECEIVE_BYTES = sbox_delay + sbox_delay + 16 + 4 + 1;	// 1 byte of ptg1, ptg2 and  16 for aes_rng initial plaintext +  totalcount + 
																		// instruction

	// Test parameters
	localparam RNG_KEY       = 128'h000102030405060708090a0b0c0d0e0f;
	localparam CLK_FREQUENCY = 6144000                              ; // Clock frequency the FPGA is running on in Hz
	localparam UART_BAUDRATE = 19200                                ; // Baudrate used for uart communication

	 localparam UART_CLK_PER_BIT = CLK_FREQUENCY/UART_BAUDRATE; // Use this normally. TODO: This floors the result, we might want rounding
	//localparam UART_CLK_PER_BIT = 4; // Use this when simulating


	// Stuff we receive from control script (except rng initial plaintext)
	reg [7:0] instruction;
	reg [sbox_delay*8-1:0] pt_group1;	// For sbox with 5 regs we need 6 different inputs
	reg [sbox_delay*8-1:0] pt_group2;
	reg [ 31:0] total_count;			// counts number of experiments to make in one go

	// Ciphertext from main FPGA
	reg [sbox_delay*8-1:0] ciphertext_group1;
	reg [sbox_delay*8-1:0] ciphertext_group2;
	// reg [7:0] ct_unshared_byte;
	// reg [N_SHARES*8-1:0] ct_shared_byte;
	
	// Various wires and registers
	reg [7:0] pt_byte_to_send     ; // This will be r1 ^ r2 ^ pt, wher pt is selected according to coin
	reg [9:0] counter          = 0; // Generic counter used throughout
	reg [3:0] share_n_counter  = 0; // Counter for which share we are sending/receiving
	
	// The following is needed only when we send fresh randomness from the board directly
	// reg [7:0] fresh_byte_to_send;
	// reg [sbox_delay*64*2-1:0] fresh_rand; // with reg = 4, 255:0
	
	// KEEP, DON'T CHANGE UART DATA
	wire [7:0] uart_rx_byte;
	wire       uart_rx_dv  ; // UART RX data valid.
	reg        uart_tx_dv  ;
	reg  [7:0] uart_tx_byte;
	wire       uart_tx_done;
	
	// SEED related parameters
	// localparam S_SB_b   = N_SHARES * 8; // Size of a shared byte in bits
	localparam S_SEED_bytes = 5; // Size of seed in bytes used for counters
	localparam S_SEED_b = 5 * 8; // Size of seed in bits (40 is needed for keccak)
	reg [S_SEED_b-1:0] seed; 
	
	// aes rng
	reg [127:0] rng_plaintext;
	reg [127:0] rng_key = RNG_KEY;
	wire [127:0] rng_ciphertext;
	reg rng_start = 0;
	wire rng_ready;
	reg [127:0] rand_masks [0:(N_SHARES-1)-1]; // a place to store the masks for sharing (do we really need that second minus sign??)
	
	reg coin;
	
	integer j;
	integer k;
	
	uart_rx #(.CLKS_PER_BIT(UART_CLK_PER_BIT)) uart_rx (.i_Clock(clk), .i_Rx_Serial(pin_rx), .o_Rx_DV(uart_rx_dv), .o_Rx_Byte(uart_rx_byte));
	uart_tx #(.CLKS_PER_BIT(UART_CLK_PER_BIT)) uart_tx (.i_Clock(clk), .i_Tx_DV(uart_tx_dv), .i_Tx_Byte(uart_tx_byte), .o_Tx_Serial(pin_tx), .o_Tx_Done(uart_tx_done));
	
	aes_128 aes_rng (.clk(clk), .reset(reset), .start(rng_start), .plaintext(rng_plaintext), .key(rng_key), .ready(rng_ready), .ciphertext(rng_ciphertext));


	// Generating the share to send. pt_groupx, key, and rand_masks will be rotated when needed
	always @(*) begin
		if (coin) begin
			pt_byte_to_send = pt_group2[sbox_delay*8-1:sbox_delay*8-8];		// how it was: pt_byte_to_send = pt_group2[63:56];
		end else begin
			pt_byte_to_send = pt_group1[sbox_delay*8-1:sbox_delay*8-8];
		end
		// fresh_byte_to_send = fresh_rand[sbox_delay*64-1:sbox_delay*64-8]; // fresh randomness for the Sbox
		for (j = 0; j < N_SHARES - 1; j = j + 1) begin
			pt_byte_to_send  = pt_byte_to_send ^ rand_masks[j][127:120];
		end
	end
	
	///////////////////////////////////
	// Summary of the registers used:
	// data_from_control - sends a byte of information to the main board
	// crypto_start - used during the IDLE state of the main board letting it know when it is time to sync with the control board
	// state - responsible for the change of state (ideally we should implement FSM apart from register block)
	// instruction - 8-bit register, stores the instruction type generated by the connected computer 
	// pt_group1 - 1st input group plaintext
	// pt_group2 - 2nd input group plaintext
	// total_count - counts number of experiments to make in one go
	// ciphertext_group1 - 1st output group ciphertext
	// ciphertext_group2 - 2nd output group ciphertext
	// pt_byte_to_send - NOT REALLY A REG: keeps the value of the chosen ptx with randomness, transfers to sending
	// counter - regular 10 bit counter for conditional things
	// share_n_counter - share counter to switch between them
	// uart_tx_dv - says when to transfer data
	// uart_tx_byte - info that is transfered
	// rng_plaintext - seed for AES rng
	// rng_key - fixed key of RNG (aligned with TVLA standard)
	// rng_start - let's RNG know when to run randomness generation
	// rand_masks - keeps random masks for the shares
	// coin - flip for a particular set
	// seed - to keep the seed before transfer 
	// 
	// TOTAL: 21 register
	////////////////////////////////////
	
	// Control logic FSM 
	always @(posedge clk /*or posedge reset*/) begin
		if (reset) begin
			state <= STATE_IDLE;
		end else begin
		case (state)
			STATE_IDLE : begin
				counter           <= 0;
				share_n_counter   <= 0;
				crypto_start      <= 0;
				uart_tx_dv        <= 0;
				rng_key           <= RNG_KEY;
				rng_start         <= 0;
				ciphertext_group1 <= 0;
				ciphertext_group2 <= 0;
				if (uart_rx_dv) begin
					instruction <= uart_rx_byte;
					state       <= STATE_RECEIVE;
				end
			end
			
			STATE_RECEIVE : begin
				if (counter == N_RECEIVE_BYTES - 1) begin
					state <= STATE_RAND;
					counter   <= 0;
					rng_start <= 1;
				end else if (uart_rx_dv) begin
					counter <= counter + 1'b1;
					// First we receive initial rng plaintext
					if (counter < 16 ) begin
						rng_plaintext <= {rng_plaintext[119:0], uart_rx_byte};
					end
					// Receive pt_group
					else if (counter < sbox_delay + 16) begin
						pt_group1 <= {pt_group1[sbox_delay*8-9:0], uart_rx_byte};
					end
					// Receive pt_group2
					else if (counter < sbox_delay + sbox_delay + 16) begin
						pt_group2 <= {pt_group2[sbox_delay*8-9:0], uart_rx_byte};
					end
					// receive total_count
					else begin
						total_count <= {total_count[23:0], uart_rx_byte};
					end
				end
			end
			
			// Generate all the randomness we need for one encryption
			// Here we need rand sharings for 8*sbox_regs bits of randomness + fresh rand 64 per clk (the latter is implementation related)
			// we will just generate and transfer seed
			STATE_RAND : begin
				if (rng_ready & !rng_start) begin
					counter <= counter + 1'b1;
					rng_plaintext <= rng_ciphertext;
					if (counter == (N_SHARES-1) + 3) begin
						// state <= STATE_SEND_PT_KEY;
						state <= STATE_SEND_SEED;
						counter <= 0;
						crypto_start <= 1; // we want our crypto FPGA to start here 
					end else begin
						rng_start <= 1;
					end
					case (counter)
						0 : begin
							coin <= rng_ciphertext[127];
						end
						1 : begin
							if ((instruction == 8'h4) | (instruction == 8'h5) | (instruction == 8'h6)) begin
								seed <= rng_ciphertext[S_SEED_b-1:0];
							end else begin
								seed <= 0;
							end
						end
						2 : begin
							if ((instruction == 8'h3) | (instruction == 8'h6) /*remove following | (instruction == 8'h5)*/) begin
								pt_group1 <= rng_ciphertext[127:128-(sbox_delay*8)];
								//pt_group1 <= 0;
							end
						end
						3 : begin
							if ((instruction == 8'h2) | (instruction == 8'h3) | (instruction == 8'h5) | (instruction == 8'h6)) begin
								pt_group2[sbox_delay*8-1:0] <= rng_ciphertext[127:128-(sbox_delay*8)];
							end
						end
						default : begin
							if ((instruction == 8'h4) | (instruction == 8'h5) | (instruction == 8'h6)) begin
								rand_masks[counter-4] <= rng_ciphertext; // Fill the random masks
							end else begin
								rand_masks[counter-4] <= 0;
							end
						end
					endcase
				end else begin
					rng_start <= 0;
				end
			end
			
			// provide a PRNG with randomness first because we want that noise in advance
			STATE_SEND_SEED : begin
				crypto_start <= 0;		// we turn that off here to avoid power fluctuations during the trigger stage
				if (counter == S_SEED_bytes - 1) begin
					state <= STATE_SEND_PT_KEY;
					counter <= 0;
				end else begin
					counter <= counter + 1;
				end
				data_from_control  <= seed[S_SEED_b-1 -:8];
				seed[S_SEED_b-1:0] <= {seed[S_SEED_b-9 : 0], seed[S_SEED_b-1 -: 8]};
			end
			
			/*  We send N_SHARES bytes, then rotate masks and pt/key
			Using for-loops in order to support multiple values of N_SHARES */
			STATE_SEND_PT_KEY : begin
				if ((share_n_counter == N_SHARES - 1) & (counter < sbox_delay)) begin
					// Rotate
					if (counter < sbox_delay) begin
						pt_group1 <= {pt_group1[sbox_delay*8-8-1:0], pt_group1[sbox_delay*8-1:sbox_delay*8-8]};
						pt_group2 <= {pt_group2[sbox_delay*8-8-1:0], pt_group2[sbox_delay*8-1:sbox_delay*8-8]};
					end
					// We rotate all the random vectors, as they will end up where they started anyway
					for (j = 0; j < (N_SHARES-1); j = j + 1) begin
						rand_masks[j] <= {rand_masks[j][119:0], rand_masks[j][127:120]};
					end
					if (share_n_counter == 0) begin
						data_from_control <= pt_byte_to_send;
					end else begin
						data_from_control <= rand_masks[share_n_counter - 1][127:120];
					end
					share_n_counter <= 0;
					counter  <= counter + 1'b1;
				end
				else if (counter < sbox_delay) begin
					if (share_n_counter == 0) begin
						data_from_control <= pt_byte_to_send;
					end else begin
						data_from_control <= rand_masks[share_n_counter - 1][127:120];
					end
					share_n_counter <= share_n_counter + 1'b1;
				end
				else begin
					state <= STATE_WAIT;
					counter <= sbox_delay + sbox_delay*4; // 1 time wait and 1 time encrypt with no done signal 
					share_n_counter <= 0;
				end
			end

			STATE_WAIT : begin
				if (counter == 0) begin
					state <= STATE_READ_CT;
					share_n_counter <= 0;
				end
				else begin
					counter <= counter - 1'b1;
				end
			end
			
			STATE_READ_CT : begin
				counter <= counter + 1'b1;
				if (counter == sbox_delay - 1) begin
					share_n_counter <= share_n_counter + 1'b1;
					counter <= 0;
					if (share_n_counter == N_SHARES - 1) begin
						state <= STATE_LOOPBACK;
					end
				end
				/* Ciphertext is received with the full 128 bit shares of share 1, then share 2 etc. Not interleaved*/
				if (coin == 0) begin
					if (share_n_counter == 0) begin
						ciphertext_group1 <= {ciphertext_group1[sbox_delay*8-9:0], data_to_control};
					end else begin
						ciphertext_group1 <= {ciphertext_group1[sbox_delay*8-9:0], data_to_control ^ ciphertext_group1[sbox_delay*8-1:sbox_delay*8-8]};
					end
				end else begin
					if (share_n_counter == 0) begin
						ciphertext_group2 <= {ciphertext_group2[sbox_delay*8-9:0], data_to_control};
					end else begin
						ciphertext_group2 <= {ciphertext_group2[sbox_delay*8-9:0], data_to_control ^ ciphertext_group2[sbox_delay*8-1:sbox_delay*8-8]};
					end
				end
			end
			
			STATE_LOOPBACK : begin
				counter <= 0;
				share_n_counter <= 0;
				if (total_count == 1) begin
					state <= STATE_SEND_CT;
				end else begin
					total_count <= total_count - 1'b1;
					state <= STATE_RAND;
					rng_start <= 1;
				end
			end
			
			STATE_SEND_CT : begin
				if (counter == sbox_delay*2) begin
					counter <= 0;
					state <= STATE_IDLE;
					uart_tx_dv <= 0;
					ciphertext_group1 <= 0;
					ciphertext_group2 <= 0;
				end else begin
					if (counter == 0) begin
						uart_tx_dv <= 1;
						counter <= counter + 1'b1; // actually just using this to figure out if we have started
						uart_tx_byte <= ciphertext_group1[sbox_delay*8-1:sbox_delay*8-8];
						ciphertext_group1 <= {ciphertext_group1[sbox_delay*8-9:0], ciphertext_group1[sbox_delay*8-1:sbox_delay*8-8]};
					end else if (uart_tx_done & !uart_tx_dv) begin
						if (counter < sbox_delay) begin
							uart_tx_byte <= ciphertext_group1[sbox_delay*8-1:sbox_delay*8-8];
							ciphertext_group1 <= {ciphertext_group1[sbox_delay*8-9:0], ciphertext_group1[sbox_delay*8-1:sbox_delay*8-8]};
						end else begin
							uart_tx_byte <= ciphertext_group2[sbox_delay*8-1:sbox_delay*8-8];
							ciphertext_group2 <= {ciphertext_group2[sbox_delay*8-9:0], ciphertext_group2[sbox_delay*8-1:sbox_delay*8-8]};
						end
						uart_tx_dv <= 1;
						counter <= counter + 1'b1;
					end else begin
						uart_tx_dv <= 0;
					end
				end
			end
		endcase
		end
	end

endmodule