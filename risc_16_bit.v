`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.04.2024 14:32:44
// Design Name: 
// Module Name: risc_16_bit
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

module risc_16_bit(clk, ALU_OUT, MAX_VAL);
input clk;
output reg [15:0] ALU_OUT, MAX_VAL;
reg [2:0] stage = 0;
reg[15:0] PC,IR, NPC, A, B, IMM, LMD, br_cond;
reg[2:0] ex_type;

reg [15:0] reg_bank[0:7];
reg [15:0] memory[0:1023];

parameter ADD = 5'd0, SUB = 5'd1, MUL = 5'd2, AND = 5'd3,
OR = 5'd4, INV = 5'd5, LSL = 5'd6, LSR = 5'd7, DEC = 5'd8,
INC = 5'd9, MOV = 5'd10, SLT = 5'd11, ADDI = 5'd12, SUBI = 5'd13, 
SLTI = 5'd14, MOVI = 5'd15, BNEQ = 5'd16, BEQ = 5'd17, BEQZ = 5'd18,
BNEQZ = 5'd19, LD = 5'd20, ST = 5'd21, HLT = 5'd22;


parameter RR_ALU = 3'd0, RM_ALU = 3'd1, LOAD = 3'd2, STORE = 3'd3, BRANCH = 3'd4, HALT = 3'd5;


initial begin
reg_bank[0] <= 16'd0;
reg_bank[1] <= 16'd0;
reg_bank[2] <= 16'd0;
reg_bank[3] <= 16'd0;
reg_bank[4] <= 16'd0;
reg_bank[5] <= 16'd0;
reg_bank[6] <= 16'd0;
reg_bank[7] <= 16'd0;

memory[0] <= 16'b0111_1000_1000_1000; //MOVI R4, #8
memory[1] <= 16'b0111_1000_0000_0000; //MOVI R0, #0   :loop1
memory[2] <= 16'b1010_0001_1000_1111; //LD R1, OS(R4)  OS = 15
memory[3] <= 16'b0101_1010_0010_0000; //SLT R0, R2, R1
memory[4] <= 16'b0100_0100_0001_0000; //DEC R4, R4
memory[5] <= 16'b1001_0000_0000_0010; //BEQZ R0 loop2
memory[6] <= 16'b0101_0001_0000_1000; //MOV R2, R1
memory[7] <= 16'b1001_1100_0001_1010; //BNEQZ R4, loop1  :loop2
memory[8] <= 16'b1011_0000_0000_0000; //Halt


PC <=0;


//user data
memory[23] <= 16'd94;
memory[22] <= 16'd78;
memory[21] <= 16'd231; // Maximum of arra
memory[20] <= 16'd123;
memory[19] <= 16'd9;
memory[18] <= 16'd14;
memory[17] <= 16'd121;
memory[16] <= 16'd0;

end
always @(posedge clk)    
begin
case(stage)
0:  // fetch
begin
IR <= memory[PC];
NPC <= PC;
PC <= PC+1;
stage <= 1;
br_cond <=0;
end

1:  // decode
begin
A <= reg_bank[IR[10:8]];

B <= reg_bank[IR[7:5]];

IMM <= {{11{IR[4]}}, {IR[4:0]}};

case(IR[15:11])
ADD, SUB, MUL, AND, OR,
INV, LSL, LSR, DEC, INC,
MOV, SLT                    : ex_type <= RR_ALU;
ADDI,SUBI,SLTI,MOVI         : ex_type <= RM_ALU;
LD                          : ex_type <= LOAD;
ST                          : ex_type <= STORE;
BNEQ,BEQ,BEQZ,BNEQZ         : ex_type <= BRANCH;
HLT                         : ex_type <= HALT;
default                     : ex_type <= HALT;
endcase
stage <= 2;
end

2: //exec
begin
case(ex_type)
RR_ALU:
begin
case(IR[15:11])
ADD : ALU_OUT <= A+B;
SUB : ALU_OUT <= A-B;
MUL : ALU_OUT <= A*B;
AND : ALU_OUT <= A& B;
OR  : ALU_OUT <= A|B;
INV : ALU_OUT <= ~A;
LSL : ALU_OUT <= A << B;
LSR : ALU_OUT <= A >> B;
DEC : ALU_OUT <= A-1;
INC : ALU_OUT <= A+1;
MOV : ALU_OUT <= A; 
SLT : ALU_OUT <= (A<B)?(1):(0);
endcase
end
RM_ALU:
begin
case(IR[15:11])
ADDI : ALU_OUT <= A+IMM;
SUBI : ALU_OUT <= A-IMM;
SLTI : ALU_OUT <= (A<IMM)?(1):(0);
MOVI : ALU_OUT <= IMM;
endcase
end
LOAD, STORE: ALU_OUT <= B+IMM;
BRANCH: 
begin
case(IR[15:11])
BEQZ: br_cond <= (A == 0);
BNEQZ: br_cond <= (A != 0);
BEQ: br_cond <= (A == B);
BNEQ: br_cond <= (A != B);
default br_cond <=0;
endcase
end
default:ALU_OUT <=0;
endcase
stage <= 3;
end

3: //mem
begin
case(ex_type)
LOAD: LMD <= memory[ALU_OUT];
STORE: memory[ALU_OUT] <= A;
endcase
stage <= 4;
end

4: // write_back
begin
case(ex_type)
RR_ALU : reg_bank[IR[4:2]]  <= ALU_OUT;
RM_ALU : reg_bank[IR[7:5]]  <= ALU_OUT;
LOAD   : reg_bank[IR[10:8]] <= LMD;
BRANCH : PC <= (br_cond == 1)?(NPC+IMM):(PC);
endcase
stage <= (ex_type == HALT)? (5):(0);
MAX_VAL <= (ex_type == HALT)?(reg_bank[2]):(0);
end
default: ALU_OUT <= 0;
endcase
end

endmodule
