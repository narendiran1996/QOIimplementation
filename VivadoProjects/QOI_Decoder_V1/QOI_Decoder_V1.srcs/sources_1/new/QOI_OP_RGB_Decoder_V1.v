`timescale 1ns / 1ps


module QOI_OP_RGB_Decoder_V1
                (
                    input wire [6-1:0]currentVal_DG,
                    input wire [8-1:0]nextByte_R,
                    input wire [8-1:0]nextByte_G,
                    input wire [8-1:0]nextByte_B,

                    output wire [24-1:0]newPix_R_G_B
                );

assign newPix_R_G_B = {nextByte_R, nextByte_G, nextByte_B};


endmodule
