`timescale 1ns / 1ps

/**
 * @param a first 1-bit input
 * @param b second 1-bit input
 * @param g whether a and b generate a carry
 * @param p whether a and b would propagate an incoming carry
 */
module gp1(input wire a, b,
           output wire g, p);
   assign g = a & b;
   assign p = a | b;
endmodule

/**
 * Computes aggregate generate/propagate signals over a 4-bit window.
 * @param gin incoming generate signals
 * @param pin incoming propagate signals
 * @param cin the incoming carry
 * @param gout whether these 4 bits internally would generate a carry-out (independent of cin)
 * @param pout whether these 4 bits internally would propagate an incoming carry from cin
 * @param cout the carry outs for the low-order 3 bits
 */
module gp2(input wire [1:0] gin, pin,
           input wire cin,
           output wire pout, gout, cout);
           assign pout = pin[0] & pin[1];
           assign gout = (gin[0] & pin[1]) | gin[1];
           assign cout = (pin[0] & cin) | gin[0];
endmodule

module gp4(input wire [3:0] gin, pin,
           input wire cin,
           output wire gout, pout,
           output wire [2:0] cout);

   // TODO: your code here
           wire [1:0] ptemp, gtemp;
           gp2 g1(.gin(gin[1:0]), .pin(pin[1:0]), .cin(cin), .pout(ptemp[0]), .gout(gtemp[0]), .cout(cout[0]));
           gp2 g2(.gin(gin[3:2]), .pin(pin[3:2]), .cin(cout[1]), .pout(ptemp[1]), .gout(gtemp[1]), .cout(cout[2]));
           gp2 g3(.gin(gtemp), .pin(ptemp), .cin(cin), .pout(pout), .gout(gout), .cout(cout[1]));

endmodule

/** Same as gp4 but for an 8-bit window instead */
module gp8(input wire [7:0] gin, pin,
           input wire cin,
           output wire gout, pout,
           output wire [6:0] cout);

   // TODO: your code here
           wire [1:0] ptemp, gtemp;
           gp4 g1(.gin(gin[3:0]), .pin(pin[3:0]), .cin(cin), .gout(gtemp[0]), .pout(ptemp[0]), .cout(cout[2:0]));
           gp4 g2(.gin(gin[7:4]), .pin(pin[7:4]), .cin(cout[3]), .gout(gtemp[1]), .pout(ptemp[1]), .cout(cout[6:4]));
           gp2 g3(.gin(gtemp), .pin(ptemp), .cin(cin), .pout(pout), .gout(gout), .cout(cout[3]));
endmodule

module cla
  (input wire [31:0]  a, b,
   input wire         cin,
   output wire [31:0] sum);

   // TODO: your code here
   wire[31:0] gin, pin;
   wire [7:0] ptemp, gtemp;
   wire [32:0] cout;
   wire [6:0] ctemp;
   wire pout, gout;

   assign cout[0] = cin;
   genvar i;
   for (i = 0; i < 8;i=i+1) begin
   gp4 g(.gin(gin[4*i+3:4*i]), .pin(pin[4*i+3:4*i]), .cin(cout[4*i]), .gout(gtemp[i]), .pout(ptemp[i]), .cout(cout[4*i+3:4*i+1]));
   end
   for (i = 0; i < 7;i=i+1) begin
   assign cout[4*(i+1)] = ctemp[i];
   end
   gp8 gp81(.gin(gtemp), .pin(ptemp), .cin(cin), .pout(pout), .gout(gout), .cout(ctemp));
   assign cout[32] = gout | (pout & cin);
   for (i = 0; i < 32;i=i+1) begin
   gp1 gp11(.a(a[i]), .b(b[i]), .g(gin[i]), .p(pin[i]));
   assign sum[i] = (a[i] ^ b[i] ^ cout[i]);
   end
endmodule
