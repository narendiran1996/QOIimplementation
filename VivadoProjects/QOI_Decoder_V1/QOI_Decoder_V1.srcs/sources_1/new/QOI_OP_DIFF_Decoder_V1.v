`timescale 1ns / 1ps

module QOI_OP_DIFF_Decoder_V1
                (
                    input wire [6-1:0]currentVal_DR_DG_DB,
                    input wire [24-1:0]currPix_R_G_B,

                    output wire [24-1:0]newPix_R_G_B
                );



wire [2-1:0]DR, DG, DB;
assign DR = currentVal_DR_DG_DB[5:4];
assign DG = currentVal_DR_DG_DB[3:2];
assign DB = currentVal_DR_DG_DB[1:0];

wire [8-1:0]diffToAddR, diffToAddG, diffToAddB;

//assign diffToAddR =  DR + 8'd254;
//assign diffToAddG = DG + 8'd254;
//assign diffToAddB = DB + 8'd254;
QOI_OP_DIFF_map_2_8 MAPR(.A(DR), .B(diffToAddR));
QOI_OP_DIFF_map_2_8 MAPG(.A(DG), .B(diffToAddG));
QOI_OP_DIFF_map_2_8 MAPB(.A(DB), .B(diffToAddB));

assign newPix_R_G_B[23:16] = currPix_R_G_B[23:16] + diffToAddR;
assign newPix_R_G_B[15:8] = currPix_R_G_B[15:8] + diffToAddG;
assign newPix_R_G_B[7:0] = currPix_R_G_B[7:0] + diffToAddB;



endmodule
