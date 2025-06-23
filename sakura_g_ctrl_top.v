/*------------------------------------------------------------------------
Golden Top (.ucf) of Controller FPGA on SAKURA-G (SAKURA-G-R1)

Copyright (C) 2012,2013 MORITA TECH CO.,LTD.

File name      : sakura_g_ctrl_top.v
Version        : 1.0
Date           : Aug/19/2013
Board Revision : SAKURA-G-R1
------------------------------------------------------------------------*/

module sakura_g_ctrl_top (
    /* Clock, Reset */
    // input wire         C_CLK_OSC,
    output wire        C_CLK_INH_B ,
    inout  wire        C_CLK_EXT0_P,
    // input wire         C_CLK_EXT0_N,
    // input wire         C_RESET_B,
    /* User LED */
    output wire [ 9:0] C_LED       ,
    /* User Push Switch */
    input  wire        C_PUSHSW    ,
    /* User DIP Switch */
    // input wire [7:0]   C_DIPSW,
    /* User Header Pin */
    input wire pin_rx,
    output wire pin_tx,
    // inout  wire [ 1:0] C_HEADER    ,
    // inout wire         C_HEADER_CLK_P,
    // inout wire         C_HEADER_CLK_N,
    /* USB I/F (FT2232H) */
    // input wire         FTDI_ACBUS0_RXF_B,
    // input wire         FTDI_ACBUS1_TXE_B,
    // output wire        FTDI_ACBUS2_RD_B,
    // output wire        FTDI_ACBUS3_WR_B,
    // output wire        FTDI_ACBUS4_SIWUA,
    // input wire         FTDI_ACBUS5_CLKOUT,
    // output wire        FTDI_ACBUS6_OE_B,
    // input wire         FTDI_ACBUS7,
    // inout wire [7:0]   FTDI_ADBUS_D,
    // input wire         FTDI_PWREN_B,
    // input wire         FTDI_SUSPEND_B,
    // output wire        C_FTDI_RESET_B,
    /* FPGA Interconnect */
    inout  wire [18:0] MC_IC_D
    /* Main FPGA Configuration */
    // input wire         M_CCLK_R,
    // input wire         M_CSO_B_R,
    // input wire         M_D0_DIN_MISO_R,
    // output wire        M_D1_R,
    // output wire        M_D2_R,
    // output wire        M_D3_R,
    // output wire        M_D4_R,
    // output wire        M_D5_R,
    // output wire        M_D6_R,
    // output wire        M_D7_R,
    // input wire         M_DONE_R,
    // input wire         M_DOUT_BUSY_R,
    // input wire         M_INIT_B_R,
    // output wire        M_M0_REMOTE,
    // output wire        M_M1_REMOTE,
    // input wire         M_MOSI_CSI_B_R,
    // output wire        M_PROG_B_R,
    // input wire         M_RDWR_B_R,
    /* Controller FPGA Configuration */
    // output wire        C_CCLK,
    // output wire        C_CSO_B,
    // input wire         C_HSWAPEN,
    // input wire         C_INIT_B,
    // input wire         C_M0,
    // input wire         C_M1,
    // input wire         C_MISO,
    // output wire        C_MOSI,
);

    // ports to internal wires
    assign C_CLK_INH_B = 1'b0;

    wire clk   = C_CLK_EXT0_P;
    wire reset = C_PUSHSW    ;
    assign MC_IC_D[16] = C_PUSHSW;
    // wire       tx              = C_HEADER[0];
    // wire       rx              = C_HEADER[1];
    wire [7:0] data_to_control, data_from_control;
    assign data_to_control = MC_IC_D[15:8];
    assign MC_IC_D[7:0]    = data_from_control;

    wire crypto_ready, crypto_start;
    assign MC_IC_D[18]  = crypto_start;
    assign crypto_ready = MC_IC_D[17];

    // leds
    reg [19:0] cnt;

    always @(posedge clk)
        if (reset) cnt <= 20'h0;
        else     cnt <= cnt + 20'h1;

   assign C_LED[4] = 1'b1;
   assign C_LED[5] = MC_IC_D[9];
   assign C_LED[6] = 1'b1;
   assign C_LED[7] = 1'b1;
   assign C_LED[8] = C_PUSHSW;
   assign C_LED[9] = cnt[19];

control_fpga_top control_fpga (
//    control_fpga_semi_fixed_top control_fpga_semi_fixed (
        .clk              (clk              ),
        .reset            (reset            ),
        .pin_rx           (pin_rx               ),
        .data_to_control  (data_to_control  ),
        .data_from_control(data_from_control),
        .crypto_ready     (crypto_ready     ),
        .pin_tx           (pin_tx               ),
        .crypto_start     (crypto_start     ),
        // internal states to led
       .ctrl_state       (C_LED[3:0]       )
    );


endmodule