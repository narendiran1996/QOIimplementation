`timescale 1ns / 1ps

module tb_ByteProcessing();

reg clk, rst, startDecoding;


 wire [8-1:0]Rout;
 wire [8-1:0]Gout;
 wire [8-1:0]Bout;
 wire validOutput;
TopModule_Decoder_ByteProcessing_V1 DUT
                (
                    clk,
                    rst,
                    startDecoding,
                    Rout,
                    Gout,
                    Bout,
                    validOutput
                );

always
    begin
        clk =0;
        #5;
        clk = 1;
        #5;
    end


initial 
    begin
        rst = 1; startDecoding = 0;
        #548;
        rst =0;
        #784;
        startDecoding = 1
        ;
        #10000;
    end
    
    integer f;
initial
    f = $fopen("/media/narendiran/MOVIES/QOIimplementation/outputRGB.txt","w");

always@(posedge clk)
    begin
        if(validOutput == 1)
            $fwrite(f, "%d,%d,%d\n", Rout, Gout,Bout);        
    end

initial
    begin
        #900;
        $fclose(f);
        $finish;
    end
    
endmodule
