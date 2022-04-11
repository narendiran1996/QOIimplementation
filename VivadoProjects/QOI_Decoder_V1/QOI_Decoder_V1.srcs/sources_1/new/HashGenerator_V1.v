`timescale 1ns / 1ps


// # (r * 3 + g * 5 + b * 7 + a * 11) % 64
// # (r * 3 + g * 5 + b * 7 + a * 11)  & 0b00111111
module HashGenerator_V1
                (
                    input wire [8-1:0]RedIn,
                    input wire [8-1:0]GreenIn,
                    input wire [8-1:0]BlueIn,


                    output wire [6-1:0]hashOut
                );


wire [$clog2(3*255)-1:0]redM;
wire [6-1:0]redA;
assign redM = (RedIn<<1) + RedIn;
assign redA = redM[6-1:0];




wire [$clog2(5*255)-1:0]greenM;
wire [6-1:0]greenA;
assign greenM = (GreenIn<<2) + GreenIn;
assign greenA = greenM[6-1:0];



wire [$clog2(7*255)-1:0]blueM;
wire [6-1:0]blueA;
assign blueM = (BlueIn<<3) - BlueIn;
assign blueA = blueM[6-1:0];



assign hashOut = redA + greenA + blueA + 6'd53;


endmodule
