module instruction_memory(input [31:0]current_instruction_address_input
                        output [31:0] instruction_out);
        
reg [31:0] instruction_memory [1023:0]        //32x1024 memory for instuctions, can increase easily if we want

assign instruction_out = instruction_memory[current_instruction_address_input[31:2]];

endmodule