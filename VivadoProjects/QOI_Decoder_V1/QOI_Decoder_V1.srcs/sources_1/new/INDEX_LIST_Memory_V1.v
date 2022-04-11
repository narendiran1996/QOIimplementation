`timescale 1ns / 1ps


module INDEX_LIST_Memory_V1
                (
                    input wire clk,
                    input wire rst,

                    input wire [6-1:0]readAddressIn,
                    output reg [24-1:0]readDataOut,

                    input wire [6-1:0]writeAddressIn,
                    input wire [24-1:0]writeDataIn,
                    input wire writeEnable
                );

reg [24-1:0]REG_INDEX_LIST[0:64-1];

always @(posedge clk)
    begin
        if(rst == 1)
            readDataOut <= 0;
        else
            begin
                if(writeEnable == 1)
                    REG_INDEX_LIST[writeAddressIn] = writeDataIn;
                readDataOut <= REG_INDEX_LIST[readAddressIn];
            end
    end


endmodule
