`timescale 1ns / 1ps

module QOI_OP_RUN_Decoder_V1
                (
                    input wire [6-1:0]currentVal_DG,
                    input wire [24-1:0]currPix_R_G_B,
                    output wire [24-1:0]newPix_R_G_B
                );


wire [6-1:0]runVal;
assign runVal = currentVal_DG;
assign newPix_R_G_B = currPix_R_G_B;



endmodule
