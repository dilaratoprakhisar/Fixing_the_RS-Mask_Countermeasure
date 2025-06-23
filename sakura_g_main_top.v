/*------------------------------------------------------------------------
Golden Top (.ucf) of Main FPGA on SAKURA-G (SAKURA-G-R1)

Copyright (C) 2012,2013 MORITA TECH CO.,LTD.

File name      : sakura_g_main_top.v
Version        : 1.0
Date           : Aug/19/2013
Board Revision : SAKURA-G-R1
------------------------------------------------------------------------*/

module sakura_g_main_top (
    /* Clock, Reset */
    // input wire         M_CLK_OSC,
    output wire        M_CLK_INH_B ,
    inout  wire        M_CLK_EXT0_P,
    // inout wire         M_CLK_EXT0_N,
    // input wire         M_RESET_B,
    /* User LED */
    output wire [ 9:0] M_LED       ,
    /* User Push Switch */
    input  wire        M_PUSHSW    ,
    /* User DIP Switch */
    // input wire [7:0]   M_DIPSW,
    /* User Header Pin */
    inout  wire [ 1:0] M_HEADER    ,
    // inout wire         M_HEADER_CLK_P,
    // inout wire         M_HEADER_CLK_N,
    /* USB I/F (FT2232H) */
    // input wire         FTDI_BCBUS0_RXF_B,
    // input wire         FTDI_BCBUS1_TXE_B,
    // output wire        FTDI_BCBUS2_RD_B,
    // output wire        FTDI_BCBUS3_WR_B,
    // output wire        FTDI_BCBUS4_SIWUB,
    // input wire         FTDI_BCBUS5,
    // input wire         FTDI_BCBUS6,
    // output wire        FTDI_BCBUS7_PWRSAV_B,
    // inout wire [7:0]   FTDI_BDBUS_D,
    // input wire         FTDI_PWREN_B,
    // input wire         FTDI_SUSPEND_B,
    // output wire        M_FTDI_RESET_B,
    /* FPGA Interconnect */
    inout  wire [18:0] MC_IC_D
    /* Main FPGA Configuration */
    // output wire        M_CCLK_R0,
    // output wire        M_CSO_B,
    // output wire        M_D0_DIN_MISO,
    // input wire         M_D1,
    // input wire         M_D2,
    // input wire         M_D3,
    // input wire         M_D4,
    // input wire         M_D5,
    // input wire         M_D6,
    // input wire         M_D7,
    // output wire        M_DOUT_BUSY,
    // input wire         M_HSWAPEN,
    // output wire        M_INIT_B,
    // input wire         M_M0,
    // input wire         M_M1,
    // output wire        M_MOSI_CSI_B,
    // output wire        M_RDWR_B,
    /* Reserved I/O */
    // inout wire         M_RSVIO_0_P,
    // inout wire         M_RSVIO_0_N
);

    // port to internal wires
    wire clk   = M_CLK_EXT0_P          ;
    wire reset = M_PUSHSW | MC_IC_D[16];
    assign M_CLK_INH_B = 1'b0;
// leds
    reg [19:0] cnt;

    always @(posedge clk)
        if (reset) cnt <= 20'h0;
        else     cnt <= cnt + 20'h1;
    assign M_LED[5:3] = 3'b111;
    assign M_LED[6]   = M_HEADER[0];
    assign M_LED[7]   = M_HEADER[1];
    assign M_LED[8]   = reset;
    assign M_LED[9]   = cnt[19];

    main_fpga_refreshing main_fpga_top (
        .clk              (clk          ),
        .reset            (reset        ),
        .crypto_start     (MC_IC_D[18]  ),
        .data_from_control(MC_IC_D[7:0] ),
        .data_to_control  (MC_IC_D[15:8]),
        .crypto_ready     (MC_IC_D[17]  ),
        .start_out        (M_HEADER[0]  ),
        .ready_out        (M_HEADER[1]  ),
        // internal states
        .main_state       (M_LED[2:0]   )
    );

endmodule