/*
    We simply want AES-128 encryption to generate reproducible random numbers.
    This wrapper module achieves that.
    The design (https://github.com/secworks/aes/) could be stripped down further.
    We neither need nor want extra functionality, like 256 bit key support and decryption.
*/
module aes_128(input wire clk,
               input wire reset,
               input wire start,
               input wire [127:0] plaintext,
               input wire [127:0] key,
               output reg ready,
               output wire [127:0] ciphertext
               );
    
    localparam STATE_IDLE = 2'h0;
    localparam STATE_INIT = 2'h1;
    localparam STATE_ENC  = 2'h2;

    reg [1:0] state;

    wire reset_n = !reset;
    wire core_ready;
    reg core_init;
    reg core_next;
    wire core_valid;

    aes_core core(
    .clk(clk),
    .reset_n(reset_n),
    
    .encdec(1'b1), // 1 means encrypt
    .init(core_init),
    .next(core_next),
    .ready(core_ready),
    
    .key({key, 128'h0}),
    .keylen(1'b0), // 0 means 128 bit key length
    
    .block(plaintext),
    .result(ciphertext),
    .result_valid(core_valid)
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= STATE_IDLE;
            core_next <= 0;
            core_init <= 0;
            ready <= 0;
        end else begin
            case (state)
                STATE_IDLE: begin
                    if (start) begin
                        state <= STATE_INIT;
                        core_init <= 1;
                        ready <= 0;
                    end
                end
                STATE_INIT: begin
                    if (core_ready & !core_init) begin
                        state <= STATE_ENC;
                        core_next <= 1;
                    end
                    core_init <= 0;
                end
                STATE_ENC: begin
                    core_next <= 0;
                    if (core_ready & !core_next) begin
                        state <= STATE_IDLE;
                        ready <= 1;
                    end
                end
            endcase
        end
    end
endmodule
