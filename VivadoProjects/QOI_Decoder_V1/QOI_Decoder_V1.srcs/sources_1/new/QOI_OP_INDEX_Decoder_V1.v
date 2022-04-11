`timescale 1ns / 1ps


module QOI_OP_INDEX_Decoder_V1
                (
                    input wire clk,
                    input wire rst,

                    input wire [6-1:0]currentVal_INDEX,


                    input wire [24-1:0]currPix_R_G_B,
                    input wire writeEnable,

                    output wire [24-1:0]newPix_R_G_B

                );

wire [6-1:0]readAddr, writeAddr, hashIndex;

HashGenerator_V1    HASHG
                (
                    .RedIn(currPix_R_G_B[23:16]),
                    .GreenIn(currPix_R_G_B[15:8]),
                    .BlueIn(currPix_R_G_B[7:0]),


                    .hashOut(hashIndex)
                );


assign readAddr = currentVal_INDEX;
assign writeAddr = hashIndex;


INDEX_LIST_Memory_V1    INDEXLISTMEM
                (
                    .clk(clk),
                    .rst(rst),

                    .readAddressIn(readAddr),
                    .readDataOut(newPix_R_G_B
                    ),

                    .writeAddressIn(writeAddr),
                    .writeDataIn(currPix_R_G_B),
                    .writeEnable(writeEnable)
                );

endmodule
