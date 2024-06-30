`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.04.2024 17:38:46
// Design Name: 
// Module Name: risc_16_bit_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module risc_16_bit_tb;
reg clk = 0;
wire [15:0] ALU_OUT;
wire [15:0] MAX_VAL;
integer k = 0;
risc_16_bit dut(.clk(clk), .ALU_OUT(ALU_OUT), .MAX_VAL(MAX_VAL));

always #5 clk = ~clk;

initial
begin
//for(k = 0; k<16; k = k+1)
//dut.reg_bank[k] <= 16'd0;

//dut.memory[0] = 16'b0000_0011_0100_0100 ; //add r1, r2, r3;
////dut.memory[1] = 16'b0000_0100_0100_0100 ;  //add r1 , r2, r4;
////dut.memory[2] = 16'b0000_0011_0100_0100 ; // add r1 
//dut.memory[1] = 16'b1001_0000_0000_0101;  //beqz r0, #5
//dut.memory[2] = 16'b0000_0011_0100_0100 ; //add r1, r2, r3;
//dut.memory[3] = 16'b0000_0011_0100_0100 ; //add r1, r2, r3;
//dut.memory[4] = 16'b0000_0011_0100_0100 ; //add r1, r2, r3;
//dut.memory[5] = 16'b0000_0011_0100_0100 ; //add r1, r2, r3;
//dut.memory[6] = 16'b0000_0100_0100_0100 ; //add r1 , r2, r4;
//dut.memory[7] = 16'b0110_0001_0100_1010;  //addi r2, r1, #10;

/* INSTRUCTION CHECK */
/*
dut.memory[0] = 16'b0000_0011_0100_0100 ;//add r1, r2, r3; r1 <= r2+r3
dut.memory[1] = 16'b0000_1011_0100_0100 ;//sub r1, r2, r3; r1 <= r3-r2
dut.memory[2] = 16'b0001_0011_0100_0100 ;//MUL R1, R2, R3; R1 <= R3*R2
dut.memory[3] = 16'b0001_1011_0100_0100 ;//AND R1, R2, R3; R1 <= R3&R2
dut.memory[4] = 16'b0010_0011_0100_0100 ;//OR R1, R2, R3; R1 <= R3|R2
dut.memory[5] = 16'b0010_1010_0000_0100 ;//INV R1, R2; R1 <= ~R2
dut.memory[6] = 16'b0011_0011_0100_0100 ;//LSL R1, R2, R3
dut.memory[7] = 16'b0011_1011_0100_0100 ;//LSR R1,R2,R3
dut.memory[8] = 16'b0100_0010_0000_0100 ;//DEC R1,R2
dut.memory[9] = 16'b0100_1010_0000_0100 ;//INC R1,R2
dut.memory[10] = 16'b0101_0010_0000_0100;//MOV R1,R2
dut.memory[11] = 16'b0101_1011_0100_0100;//SLT R1,R2,R3
dut.memory[12] = 16'b0110_0010_0010_0111;//ADDI R1,R2,#7
dut.memory[13] = 16'b0110_1010_0010_0111;//SUBI R1,R2,#7
dut.memory[14] = 16'b0111_0010_0010_0111;//SLTI R1,R2,#7
dut.memory[15] = 16'b0111_1000_0010_0111;//MOVI R1, #7
//dut.memory[16] = 16'b1000_0001_0100_0100;//BNEQ R1, R2, #4
//dut.memory[17] = 16'b1000_1001_0100_0100;//BEQ R1,R2,#4
//dut.memory[18] = 16'b1001_0001_0000_0101;//BEQZ R1,#5
//dut.memory[19] = 16'b1001_1001_0000_0101;//BNEQZ R1,#5
dut.memory[16] = 16'b1010_0001_1100_1111;//LD R1, 4(R6)   r1 <= 21st loc
dut.memory[17] = 16'b1010_1001_1110_1111;//ST R1, 15(R7)  22nd loc <= r2
dut.memory[22] = 16'b1011_0000_0000_0000;//HALT
dut.memory[21] = 16'd99;

*/
/*finding max of an array*/
/*
dut.memory[0] <= 16'b0111_1000_1000_1000; //MOVI R4, #8
dut.memory[1] <= 16'b0111_1000_0000_0000; //MOVI R0, #0   :loop1
dut.memory[2] <= 16'b1010_0001_1000_1111; //LD R1, OS(R4)  OS = 15
dut.memory[3] <= 16'b0101_1010_0010_0000; //SLT R0, R2, R1
dut.memory[4] <= 16'b0100_0100_0001_0000; //DEC R4, R4
dut.memory[5] <= 16'b1001_0000_0000_0010; //BEQZ R0 loop2
dut.memory[6] <= 16'b0101_0001_0000_1000; //MOV R2, R1
dut.memory[7] <= 16'b1001_1100_0001_1010; //BNEQZ R4, loop1  :loop2
dut.memory[8] <= 16'b1011_0000_0000_0000; //Halt

dut.memory[0] = 16'b0111_1000_1000_1000; //MOVI R4, #8
dut.memory[1] = 16'b1010_0001_1000_1111; //LD R1, OS(R4)  OS = 15
dut.memory[2] = 16'b0101_0001_0000_1000; //MOV R2, R1

//user data
dut.memory[23] <= 16'd94;
dut.memory[22] <= 16'd78;
dut.memory[21] <= 16'd231;
dut.memory[20] <= 16'd123;
dut.memory[19] <= 16'd9;
dut.memory[18] <= 16'd14;
dut.memory[17] <= 16'd121;
dut.memory[16] <= 16'd0;

dut.PC <= 0;
*/
#30000 $stop; 
end


endmodule
