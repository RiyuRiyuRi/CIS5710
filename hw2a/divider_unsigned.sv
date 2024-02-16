/* 
Team member : Feifan Lu
Penn ID: 13440206

Team member :
Penn ID: 
 */

`timescale 1ns / 1ns

// quotient = dividend / divisor

module divider_unsigned (
    input  wire [31:0] i_dividend,
    input  wire [31:0] i_divisor,
    output wire [31:0] o_remainder,
    output wire [31:0] o_quotient
);

    // TODO: your code here
    wire[31:0] array_dividend[33];
    wire[31:0] array_remainder[33];
    wire[31:0] array_quotient[33];
    assign array_dividend[0] = i_dividend;
    assign array_remainder[0] = 0;
    assign array_quotient[0] = 0;

    genvar i;
    for(i = 0; i < 32; i = i+1) begin
    divu_1iter d(.i_dividend(array_dividend[i]), .i_divisor(i_divisor), 
                .i_remainder(array_remainder[i]), .i_quotient(array_quotient[i]),
                .o_dividend(array_dividend[i+1]), .o_remainder(array_remainder[i+1]),
                .o_quotient(array_quotient[i+1]));
    assign o_remainder = array_remainder[32];
    assign o_quotient = array_quotient[32];
    end
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
  /*
    for (int i = 0; i < 32; i++) {
        remainder = (remainder << 1) | ((dividend >> 31) & 0x1);
        if (remainder < divisor) {
            quotient = (quotient << 1);
        } else {
            quotient = (quotient << 1) | 0x1;
            remainder = remainder - divisor;
        }
        dividend = dividend << 1;
    }
    */
    // TODO: your code here
    assign o_dividend = i_dividend << 1;
    wire [31:0] temp_remainder;
    assign temp_remainder = ((i_dividend >> 31) & 1) | (i_remainder << 1);
    assign o_quotient = (temp_remainder < i_divisor) ? (i_quotient << 1) : ((i_quotient << 1) | 1);
    assign o_remainder = (temp_remainder < i_divisor) ? (temp_remainder) : (temp_remainder - i_divisor);
endmodule
