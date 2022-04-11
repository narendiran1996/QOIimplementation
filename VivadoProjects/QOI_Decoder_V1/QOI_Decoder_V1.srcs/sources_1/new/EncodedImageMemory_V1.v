`timescale 1ns / 1ps

module EncodedImageMemory_V1
                #
                (
                    parameter DEPTH = 30758,
                    parameter MEM_FILE = "/media/narendiran/MOVIES/QOIimplementation/MemFiles/encodedQOIImage.mem"
                )
                (
                    input wire clk,
                    input wire rst,

                    input wire [$clog2(DEPTH)-1:0]addressIn,
                    output reg [8-1:0]dataOut
                );


reg [8-1:0]MEMREGS[0:DEPTH-1];


initial 
    begin
        $readmemh(MEM_FILE, MEMREGS) ;
    end


always @(posedge clk)
    begin
        if(rst == 1)        
            dataOut <= 0;
        else
            dataOut <= MEMREGS[addressIn];
    end


endmodule
