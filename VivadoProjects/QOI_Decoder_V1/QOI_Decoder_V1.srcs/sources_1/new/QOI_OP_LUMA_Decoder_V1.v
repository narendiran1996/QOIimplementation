`timescale 1ns / 1ps

module QOI_OP_LUMA_Decoder_V1
                (
                    input wire [6-1:0]currentVal_DG,
                    input wire [8-1:0]nextByte_dr_dg_db_dg,
                    input wire [24-1:0]currPix_R_G_B,

                    output wire [24-1:0]newPix_R_G_B
                );

wire [6-1:0]DG;
assign DG = currentVal_DG;
wire [8-1:0]diffG = DG + 8'd224; //-32


wire [4-1:0]dr_dg, db_dg;
assign dr_dg = nextByte_dr_dg_db_dg[7:4];
assign db_dg = nextByte_dr_dg_db_dg[3:0];

wire [8-1:0]diffR, diffB;
assign diffR = dr_dg + diffG + 8'd248; // -8
assign diffB = db_dg + diffG + 8'd248; // -8


assign newPix_R_G_B[23:16] = currPix_R_G_B[23:16] + diffR;
assign newPix_R_G_B[15:8] = currPix_R_G_B[15:8] + diffG;
assign newPix_R_G_B[7:0] = currPix_R_G_B[7:0] + diffB;


endmodule
