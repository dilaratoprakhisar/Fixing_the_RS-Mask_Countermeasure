module tb_top ();

    initial begin
        $dumpfile("full_test.vcd");
        $dumpvars;
    end

    localparam CLK_HP = 5       ;
    localparam CLK_P  = CLK_HP*2;
	 localparam sbox_delay = 8;

    reg tb_clk   = 0;
    reg tb_reset = 0;

    // Generate clock signal
    always begin
        #CLK_HP tb_clk = !tb_clk;
    end


    integer         i          ;
    reg     [sbox_delay*8-1:0] ptg1, ptg2;
    reg     [127:0] key        ;
    reg     [ 127:0] rng_seed   ;
    wire    [ sbox_delay*8-1:0] ctg1       ;
    wire    [ sbox_delay*8-1:0] ctg2       ;
    reg     [ 31:0] total_count;
    reg     [  7:0] instruction;

    localparam         N_SEND     = sbox_delay + sbox_delay + 16 + 4  + 1;
    localparam         N_RECEIVE  = sbox_delay*2                    ;
    reg                 tx_start                           ;
    reg  [N_SEND*8-1:0] tx_data                            ;
    wire                to_board                           ;
    wire                from_board                         ;
    wire                tx_done                            ;
    // wire                   pin_tx_dummy                            ;
    wire                   rx_done ;
    wire [N_RECEIVE*8-1:0] rx_data ;
    reg                    rx_start;

    assign {ctg1, ctg2} = rx_data;

    wire [7:0] data_to_control  ;
    wire [7:0] data_from_control;

    wire start_out   ;
    wire ready_out   ;
    wire crypto_start;
    wire crypto_ready;

    // Sender and receiver is stand-in for script running on PC
    sender #(
        .N_BYTES     (N_SEND),
        .CLKS_PER_BIT(4     )
    ) sender (
        .clk    (tb_clk  ),
        .reset  (tb_reset),
        .start  (tx_start),
        .tx_data(tx_data ),
        .tx_pin (to_board),
        .done   (tx_done )
    );
    receiver #(
        .N_BYTES     (N_RECEIVE),
        .CLKS_PER_BIT(4        )
    ) receiver (
        .clk    (tb_clk    ),
        .reset  (tb_reset  ),
        .start  (rx_start  ),
        .rx_pin (from_board),
        .done   (rx_done   ),
        .rx_data(rx_data   )
    );

    control_fpga_top control_fpga (
        .clk              (tb_clk           ),
        .reset            (tb_reset         ),
        .pin_rx           (to_board         ),
        .pin_tx           (from_board       ),
        .data_to_control  (data_to_control  ),
        .data_from_control(data_from_control),
        
        .crypto_ready     (crypto_ready     ),
        .crypto_start     (crypto_start     )
    );

    main_fpga_refreshing main_fpga (
        .clk              (tb_clk           ),
        .reset            (tb_reset         ),
        .data_to_control  (data_to_control  ),
        .data_from_control(data_from_control),
        
        .crypto_ready     (crypto_ready     ),
        .crypto_start     (crypto_start     ),
        .start_out        (start_out        ),
        .ready_out        (ready_out        )
    );

    initial begin

        rng_seed = 128'h34a28da8079830f637315a43e0318832;
		  
        // ptg1 = 40'h30b586879e;//aa;
		  ptg1 = 40'h0000000163580000;//aa;
		  //ptg1 = 32'ha74031bf;
        
		  ptg2 = 40'h0;
		  // ptg2 = 32'h0;
        instruction = 8'h05;
        total_count = 32'h0005;
        // ct1 = d544170b
		  // ct1 = 5c09c708

        tx_data = {instruction ,rng_seed, ptg1, ptg2, total_count};

        #CLK_P tb_reset = 1;
        #CLK_P tb_reset = 0;
        #CLK_P tx_start = 1;
        #CLK_P tx_start = 0;

        #CLK_P rx_start = 1;
        #CLK_P rx_start = 0;
        // for (i = 0; i < 64000; i = i + 1) begin
        //     #CLK_P;
        // end
        wait(rx_done == 1);
        #100;

        $finish;
    end
endmodule