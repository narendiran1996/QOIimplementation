`timescale 1ns / 1ps

module ControlUnit_ByteProcessing_V1
                #
                (
                    parameter DEPTH = 30750
                )
                (
                    input wire clk,
                    input wire rst,

                    input wire startDecoding,

                    input wire [8-1:0]currentVal_OP,


                    output wire [8-1:0]currentByte_Plus_1, 
                    output wire [8-1:0]currentByte_Plus_2,


                    output reg [$clog2(DEPTH)-1:0]addressIn,



                    output reg [5-1:0]RGB_INDEX_SDIFF_MDIFF_RUNN,
                    output reg validOutput,


                    output wire doneProcessing

                );

// Combine fetch and decode
localparam  IDLE = 4'd0,
            FETCH = 4'd1,
            DECODE = 4'd2, 
            RGB_PROCESSING1 = 4'd3,
            RGB_PROCESSING2 = 4'd8,
            RGB_PROCESSING3 = 4'd9,
            INDEX_PROCESSING = 4'd4,
            SMALL_DIFF_PRCOESSING = 4'd5,
            MEDIUM_DIFF_PROCESSING = 4'd6,
            RUN_LENGTH_PROCESSING = 4'd7,
            RUN_LENGTH_PROCESSING_DEC = 4'd11,
            WRITE_RGB = 4'd10,
            WRITE_MDIFF = 4'd12,
            STOP = 4'd15;

wire RGB_format;
assign RGB_format = (currentVal_OP == 8'b1111_1110);
wire [1:0]OPCode;
assign OPCode = currentVal_OP[7:6];
reg memoryDoneReg;
wire memoryDone;

reg addressInc, currentByte_Plus_1_BufferIn, currentByte_Plus_2_BufferIn;

reg [6-1:0]runVal;


reg [4-1:0]presentState, nextState;


always @(posedge clk)
    begin
        if(rst == 1)
            presentState <= IDLE;
        else
            presentState <= nextState;
    end



always@(*)
    begin
        case (presentState)
            IDLE:
                begin
                    addressInc = 0;
                    validOutput = 0;
                    currentByte_Plus_1_BufferIn = 0;
                    currentByte_Plus_2_BufferIn = 0;
                    RGB_INDEX_SDIFF_MDIFF_RUNN = 5'b00000;
                    if(startDecoding == 1)
                        nextState = IDLE;
                    else
                        nextState = FETCH;
                end
            FETCH:
                begin
                    addressInc = 0;
                    validOutput = 0;
                    currentByte_Plus_1_BufferIn = 0;
                    currentByte_Plus_2_BufferIn = 0;
                    RGB_INDEX_SDIFF_MDIFF_RUNN = 5'b00000;
                    nextState = DECODE;
                end 
            DECODE:
                begin
                    addressInc = 0;
                    validOutput = 0;
                    currentByte_Plus_1_BufferIn = 0;
                    currentByte_Plus_2_BufferIn = 0;
                    RGB_INDEX_SDIFF_MDIFF_RUNN = 5'b00000;
                    if(memoryDoneReg == 1)
                        begin
                            nextState = STOP;
                        end
                    else if(RGB_format == 1)
                        begin
                            addressInc = 1;
                            nextState = RGB_PROCESSING1;
                        end
                    else
                        begin
                            case(OPCode)
                                2'b00: // QOI_OP_INDEX
                                    begin
                                        addressInc = 1;
                                        nextState = INDEX_PROCESSING;
                                    end
                                2'b01: // QOI_OP_DIFF
                                    begin
                                        addressInc = 1;
                                        nextState = SMALL_DIFF_PRCOESSING;
                                    end
                                2'b10: // QOI_OP_LUMA
                                    begin
                                         addressInc = 1;
                                        nextState = MEDIUM_DIFF_PROCESSING;
                                    end
                                2'b11: // QOI_OP_RUN
                                    begin
                                        addressInc = 1;
                                        nextState = RUN_LENGTH_PROCESSING;
                                    end
                                default:
                                    nextState = 'hx;
                            endcase
                        end
                end
            RGB_PROCESSING1:
                begin
                    addressInc = 1;
                    validOutput = 0;
                    currentByte_Plus_1_BufferIn = 0;
                    currentByte_Plus_2_BufferIn = 0;
                    RGB_INDEX_SDIFF_MDIFF_RUNN = 5'b00000;
                    nextState = RGB_PROCESSING2;
                end
            RGB_PROCESSING2:
                begin
                    addressInc = 1;
                    validOutput = 0;
                    currentByte_Plus_1_BufferIn = 1;
                    currentByte_Plus_2_BufferIn = 0;
                    RGB_INDEX_SDIFF_MDIFF_RUNN = 5'b00000;
                    nextState = RGB_PROCESSING3;
                end
            RGB_PROCESSING3:
                begin
                    currentByte_Plus_1_BufferIn = 0;
                    currentByte_Plus_2_BufferIn = 1;
                    RGB_INDEX_SDIFF_MDIFF_RUNN = 5'b00000;
                    addressInc = 1;
                    validOutput = 0;
                    nextState = WRITE_RGB;
                end
            WRITE_RGB:
                begin 
                    currentByte_Plus_1_BufferIn = 0;
                    currentByte_Plus_2_BufferIn = 0;
                    RGB_INDEX_SDIFF_MDIFF_RUNN = 5'b10000;          
                    addressInc = 0;
                    validOutput = 1;
                    nextState = DECODE;
                end
            INDEX_PROCESSING:
                begin
                    currentByte_Plus_1_BufferIn = 0;
                    currentByte_Plus_2_BufferIn = 0;
                    RGB_INDEX_SDIFF_MDIFF_RUNN = 5'b01000;          
                    addressInc = 0;
                    validOutput = 1;
                    nextState = DECODE;
                end
            SMALL_DIFF_PRCOESSING:
                begin
                    currentByte_Plus_1_BufferIn = 0;
                    currentByte_Plus_2_BufferIn = 0;
                    RGB_INDEX_SDIFF_MDIFF_RUNN = 5'b00100;          
                    addressInc = 0;
                    validOutput = 1;
                    nextState = DECODE;
                end
            MEDIUM_DIFF_PROCESSING:
                begin
                    currentByte_Plus_1_BufferIn = 1;
                    currentByte_Plus_2_BufferIn = 0;
                    RGB_INDEX_SDIFF_MDIFF_RUNN = 5'b00000;          
                    addressInc = 1;
                    validOutput = 0;
                    nextState = WRITE_MDIFF;
                end
            WRITE_MDIFF:
                begin
                    currentByte_Plus_1_BufferIn = 0;
                    currentByte_Plus_2_BufferIn = 0;
                    RGB_INDEX_SDIFF_MDIFF_RUNN = 5'b00010;          
                    addressInc = 0;
                    validOutput = 1;
                    nextState = DECODE;
                end
            RUN_LENGTH_PROCESSING:
                begin
                    currentByte_Plus_1_BufferIn = 0;
                    currentByte_Plus_2_BufferIn = 0;
                    RGB_INDEX_SDIFF_MDIFF_RUNN = 5'b00001;          
                    addressInc = 0;
                    validOutput = 1;
                    if(runVal == 0)
                        nextState = DECODE;
                    else
                        nextState = RUN_LENGTH_PROCESSING_DEC;
                end
            RUN_LENGTH_PROCESSING_DEC:
                begin
                     currentByte_Plus_1_BufferIn = 0;
                    currentByte_Plus_2_BufferIn = 0;
                    RGB_INDEX_SDIFF_MDIFF_RUNN = 5'b00000;          
                    addressInc = 0;
                    validOutput = 0;
                    nextState = RUN_LENGTH_PROCESSING;
                end
            STOP:
                begin
                    currentByte_Plus_1_BufferIn = 0;
                    currentByte_Plus_2_BufferIn = 0;
                    RGB_INDEX_SDIFF_MDIFF_RUNN = 5'b00000;          
                    addressInc = 0;
                    validOutput = 0;
                    nextState = STOP;
                end
            default: 
                begin
                    RGB_INDEX_SDIFF_MDIFF_RUNN = 5'hx;
                    currentByte_Plus_1_BufferIn = 'hx;
                    currentByte_Plus_2_BufferIn = 'hx;
                    validOutput = 'hx;
                    addressInc = 'hx;
                    nextState = 4'dx;
                end
        endcase
    end




always @(posedge clk )
    begin
        if(rst == 1)
            addressIn <= 14;
        else
            if(addressInc == 1)
                addressIn <= addressIn + 1;
            else
                addressIn <= addressIn;

    end


assign memoryDone = addressIn == (DEPTH-8);
always @(posedge clk ) 
    begin
        if(rst == 1)
            memoryDoneReg <= 0;
        else
            memoryDoneReg <= memoryDone;   
    end

assign doneProcessing = (presentState == STOP);


RegBuffers_V1  CP1
                (
                    .clk(clk),
                    .rst(rst),
                    
                    .bufferIn(currentByte_Plus_1_BufferIn),
                    
                    .dataIn(currentVal_OP),
                    
                    .dataOut(currentByte_Plus_1)
                );



RegBuffers_V1  CP2
                (
                    .clk(clk),
                    .rst(rst),
                    
                    .bufferIn(currentByte_Plus_2_BufferIn),
                    
                    .dataIn(currentVal_OP),
                    
                    .dataOut(currentByte_Plus_2)
                );             



always @(posedge clk ) 
    begin
        if(rst == 1)
            runVal <= 0;
        else    
            begin
                if(presentState == DECODE)
                    runVal <= currentVal_OP[6-1:0];
                else if(presentState == RUN_LENGTH_PROCESSING_DEC)
                    runVal <= runVal - 1;
                else
                    runVal <= runVal;
            end
    end

reg [32-1:0]countValidOuts;
always @(posedge clk )
    begin
        if(rst == 1)
            countValidOuts <= 0;
        else   
            begin
                if(validOutput == 1)
                    countValidOuts <= countValidOuts + 1;
            end
    end 



endmodule
