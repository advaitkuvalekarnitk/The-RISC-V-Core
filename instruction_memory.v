module instruction_memory(input [31:0]current_instruction_address_input,
                        output [31:0] instruction_out);
        
reg [31:0] instruction_memory [1023:0];        //32x1024 memory for instuctions, can increase easily if we want

assign instruction_out = instruction_memory[current_instruction_address_input[31:2]];

initial begin
    // 1. R-Type Verification: ADD x1, x0, 5; ADD x2, x0, 10; ADD x3, x1, x2 (x3 = 15)
    instruction_memory[0] = 32'h00500093; // ADDI x1, x0, 5
    instruction_memory[1] = 32'h00A00113; // ADDI x2, x0, 10
    instruction_memory[2] = 32'h002081B3; // ADD  x3, x1, x2 (x3 = 15)
    
    // 2. Logic Verification: AND x4, x1, x2; OR x5, x1, x2; XOR x6, x1, x2
    instruction_memory[3] = 32'h0020F233; // Corrected: AND x4, x1, x2 (Result: 0)
    instruction_memory[4] = 32'h0020E2B3; // Corrected: OR  x5, x1, x2 (Result: 15)
    instruction_memory[5] = 32'h0020C333; // Corrected: XOR x6, x1, x2 (Result: 15)
    
    // 3. Memory Verification: SW x3, 0(x1); LW x7, 0(x1)
    instruction_memory[6] = 32'h0030A023; // SW  x3, 0(x1)
    instruction_memory[7] = 32'h0000A383; // LW  x7, 0(x1) (x7 should be 15)
    
    // 4. Branch Verification: BEQ x3, x7, +8 (Jump to index 9)
    instruction_memory[8] = 32'h00718463; // BEQ x3, x7, 8
    instruction_memory[9] = 32'h00000013; // (Skip this)
    
    // 5. Jump Verification: JAL x8, 4 (Jump to index 11)
    instruction_memory[10] = 32'h0040046F; // JAL x8, 4
    instruction_memory[11] = 32'h00100493; // ADDI x9, x0, 1
end

endmodule
