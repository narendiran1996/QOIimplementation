`timescale 1ns / 1ps

/*
00 = -2 = 254 = 1111 1110
01 = -1 = 255 = 1111 1111
10 =  0 =   0 = 0000 0000
11 =  1 =   1 = 0000 0001
*/


module QOI_OP_DIFF_map_2_8
                (
                    input wire [1:0]A,
                    output wire [8-1:0]B
                );


assign B[0] = A[0];
assign B[7:1] = {7{~A[1]}};

endmodule
