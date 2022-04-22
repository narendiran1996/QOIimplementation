`timescale 1ns / 1ps

module RegBuffers_V1
                #
                (
                    parameter Nsize = 8
                )
                (
                    input wire clk,
                    input wire rst,
                    
                    input wire bufferIn,
                    
                    input wire [Nsize-1:0]dataIn,
                    
                    output reg [Nsize-1:0]dataOut
                );



always@(posedge clk)
    begin
        if(rst == 1)
            dataOut <= 0;
        else
            begin
                if(bufferIn == 1)
                    dataOut <= dataIn;
                else
                    dataOut <= dataOut;
            end
    end



endmodule
