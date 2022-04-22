`timescale 1ns / 1ps

module TopModule_Decoder_ByteProcessing_V1
                (
                    input wire clk,
                    input wire rst,
                    input wire startDecoding,
                    
                    output wire [8-1:0]Rout,
                    output wire [8-1:0]Gout,
                    output wire [8-1:0]Bout,
                    output wire validOutput
                );

                               localparam DEPTH = 30758;
reg [24-1:0]finalRGB;
assign {Rout, Gout, Bout} = finalRGB;
wire [24-1:0]previousRGBValue;
wire [8-1:0]currentVal_OP,currentByte_Plus_1, currentByte_Plus_2;


wire [5-1:0]RGB_INDEX_SDIFF_MDIFF_RUNN;


wire [$clog2(DEPTH)-1:0]addressIn;
wire [8-1:0]dataOut;

EncodedImageMemory_V1   EncodedIM
                (
                    .clk(clk),
                    .rst(rst),

                    .addressIn(addressIn),
                    .dataOut(dataOut)
                );


assign currentVal_OP = dataOut;
ControlUnit_ByteProcessing_V1   CUP
                (
                    .clk(clk),
                    .rst(rst),

                    .startDecoding(startDecoding),

                    .currentVal_OP(currentVal_OP),
                    .currentByte_Plus_1(currentByte_Plus_1),
                    .currentByte_Plus_2(currentByte_Plus_2),
                    .addressIn(addressIn),
                    
                    
                    
                    .RGB_INDEX_SDIFF_MDIFF_RUNN(RGB_INDEX_SDIFF_MDIFF_RUNN),
                    .validOutput(validOutput)
                );

wire [24-1:0]RGB_24bit;
QOI_OP_RGB_Decoder_V1 RGBins
                (
                    .nextByte_R(currentByte_Plus_1),
                    .nextByte_G(currentByte_Plus_2),
                    .nextByte_B(currentVal_OP),

                    .newPix_R_G_B(RGB_24bit)
                );

wire [24-1:0]RUN_24bit;
QOI_OP_RUN_Decoder_V1 RUNNins
                (
                    .currPix_R_G_B(previousRGBValue),
                    .newPix_R_G_B(RUN_24bit)
                );

wire [24-1:0]SDIFF_24bit;
QOI_OP_DIFF_Decoder_V1 SDIFFins
                (
                    .currentVal_DR_DG_DB(currentVal_OP[5:0]),
                    .currPix_R_G_B(previousRGBValue),

                    .newPix_R_G_B(SDIFF_24bit)
                );


wire [24-1:0]INDEX_24bit;
QOI_OP_INDEX_Decoder_V1 INDEXins
                (
                    .clk(clk),
                    .rst(rst),

                    .currentVal_INDEX(currentVal_OP[6-1:0]),


                    .currPix_R_G_B(finalRGB),
                    .writeEnable(validOutput),

                    .newPix_R_G_B(INDEX_24bit)

                );

wire [24-1:0]MDIFF_24bit;
QOI_OP_LUMA_Decoder_V1 MDIFFins
                (
                    .currentVal_DG(currentByte_Plus_1[6-1:0]),
                    .nextByte_dr_dg_db_dg(currentVal_OP),
                    .currPix_R_G_B(previousRGBValue),

                    .newPix_R_G_B(MDIFF_24bit)
                );












































always@(*) 
    begin
        case (RGB_INDEX_SDIFF_MDIFF_RUNN)
            5'b00000: finalRGB = 24'd0;
            5'b10000: finalRGB = RGB_24bit;
            5'b01000: finalRGB = INDEX_24bit;
            5'b00100: finalRGB = SDIFF_24bit;
            5'b00010: finalRGB = MDIFF_24bit;
            5'b00001: finalRGB = RUN_24bit;
            default: finalRGB = 24'd0;
        endcase
    end

RegBuffers_V1 
                #
                (
                    .Nsize(24)
                )
                PREVREGINS    
                (
                    .clk(clk),
                    .rst(rst),
                    
                    .bufferIn(validOutput),
                    
                    .dataIn(finalRGB),
                    
                    .dataOut(previousRGBValue)
                );


endmodule
