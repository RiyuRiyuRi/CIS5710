/* INSERT NAME AND PENNKEY HERE */

`timescale 1ns / 1ns

// quotient = dividend / divisor
typedef struct packed {
    logic [31:0] dividend;
    logic [31:0] divisor;
    logic [31:0] remainder;
    logic [31:0] quotient;  
  } stage_2;

module divider_unsigned_pipelined (
    input wire clk, rst,
    input  wire [31:0] i_dividend,
    input  wire [31:0] i_divisor,
    output wire [31:0] o_remainder,
    output wire [31:0] o_quotient
);

// TODO: your code here
wire [31:0] dividend[0:32];
wire [31:0] remainder[0:32];
wire [31:0] quotient[0:32];

//--- stage 1:
assign dividend[0] = i_dividend;
assign remainder[0] = 'd0;
assign quotient[0] = 'd0;

generate
    genvar i;

    for (i = 0; i < 16; i = i + 1) begin    :   div_bits_loop_1
        divu_1iter u_divu_1iter(
            .i_dividend  ( dividend[i]  ),
            .i_divisor   ( i_divisor     ),
            .i_remainder ( remainder[i] ),
            .i_quotient  ( quotient[i]  ),
            .o_dividend  ( dividend[i+1]  ),
            .o_remainder ( remainder[i+1] ),
            .o_quotient  ( quotient[i+1]  )
        );
    end
endgenerate

//--- register:
stage_2 reg_stage_2;

always_ff @(posedge clk) 
if (rst) begin
    reg_stage_2.dividend <= 'd0;
    reg_stage_2.divisor <= 'd0;
    reg_stage_2.remainder <= 'd0;
    reg_stage_2.quotient <= 'd0;
end else begin
    reg_stage_2.dividend <= dividend[16];
    reg_stage_2.divisor <= i_divisor;
    reg_stage_2.remainder <= remainder[16];
    reg_stage_2.quotient <= quotient[16];
end

//--- stage 2:
assign dividend[16] = reg_stage_2.dividend;
assign remainder[16] = reg_stage_2.remainder;
assign quotient[16] = reg_stage_2.quotient;

generate
    genvar j;

    for (j = 16; j < 32; j = j + 1) begin    :   div_bits_loop_2
        divu_1iter u_divu_1iter(
            .i_dividend  ( dividend[j]  ),
            .i_divisor   ( reg_stage_2.divisor ),
            .i_remainder ( remainder[j] ),
            .i_quotient  ( quotient[j]  ),
            .o_dividend  ( dividend[j+1]  ),
            .o_remainder ( remainder[j+1] ),
            .o_quotient  ( quotient[j+1]  )
        );
    end
endgenerate

assign o_remainder = remainder[32];
assign o_quotient = quotient[32];

endmodule


module divu_1iter (
    input  wire [31:0] i_dividend,
    input  wire [31:0] i_divisor,
    input  wire [31:0] i_remainder,
    input  wire [31:0] i_quotient,
    output wire [31:0] o_dividend,
    output wire [31:0] o_remainder,
    output wire [31:0] o_quotient
);

  // TODO: copy your code from HW2A here
    assign o_dividend = i_dividend << 1;
    wire [31:0] temp_remainder;
    assign temp_remainder = ((i_dividend >> 31) & 1) | (i_remainder << 1);
    assign o_quotient = (temp_remainder < i_divisor) ? (i_quotient << 1) : ((i_quotient << 1) | 1);
    assign o_remainder = (temp_remainder < i_divisor) ? (temp_remainder) : (temp_remainder - i_divisor);

endmodule
