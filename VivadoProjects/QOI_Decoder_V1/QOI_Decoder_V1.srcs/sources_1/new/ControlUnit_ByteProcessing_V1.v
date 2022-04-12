`timescale 1ns / 1ps

module ControlUnit_ByteProcessing_V1
                (
                    input wire clk,
                    input wire rst,

                    input wire startDecoding,

                    input wire [8-1:0]currentVal_OP

                );

// Combine fetch and decode
localparam  IDLE = 4'd0,
            FETCH = 4'd1,
            DECODE = 4'd2, 
            RGB_PROCESSING = 4'd3,
            INDEX_PROCESSING = 4'd4,
            SMALL_DIFF_PRCOESSING = 4'd5,
            MEDIUM_DIFF_PROCESSING = 4'd6,
            RUN_LENGTH_PROCESSING = 4'd7,
            STOP = 4'd15;

wire RGB_format;
assign RGB_format = currentVal_OP & 8'b1111_1110;
wire [1:0]OPCode;
assign OPCode = currentVal_OP[7:6];






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
                    if(startDecoding == 1)
                        nextState = IDLE;
                    else
                        nextState = FETCH;
                end
            FETCH:
                begin
                    nextState = DECODE;
                end 
            DECODE:
                begin
                    if(RGB_format == 1)
                        nextState = RGB_PROCESSING;
                    else
                        begin
                            case(OPCode)
                                2'b00: // QOI_OP_INDEX
                                    nextState = INDEX_PROCESSING;
                                2'b01: // QOI_OP_DIFF
                                    nextState = SMALL_DIFF_PRCOESSING;
                                2'b10: // QOI_OP_LUMA
                                    nextState = MEDIUM_DIFF_PROCESSING;
                                2'b11: // QOI_OP_RUN
                                    nextState = RUN_LENGTH_PROCESSING;
                                default:
                                    nextState = 'hx;
                            endcase
                        end
                end
            RGB_PROCESSING:
                begin
                end
            default: 
                begin
                    nextState = 4'dx;
                end
        endcase
    end



endmodule
