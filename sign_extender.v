module sign_exteder (input [2:0] extender_control,
                    input [31:0] instruction_from_instruction_memory,
                    output reg [31:0] extended_value);

always @(*)begin
case(extender_control)
//I-type
3'b000 : extended_value = {{20{instruction_from_instruction_memory[31]}}, instruction_from_instruction_memory[31:20]};
//S-type
3'b001 : extended_value = {{20{instruction_from_instruction_memory[31]}},instruction_from_instruction_memory[31:25], instruction_from_instruction_memory[11:7]};
//U-type
3'b010 : extended_value = {instruction_from_instruction_memory[31:12], 12'b0};
//B-type
3'b011 : extended_value = {{19{instruction_from_instruction_memory[31]}}, instruction_from_instruction_memory[31], instruction_from_instruction_memory[7], instruction_from_instruction_memory[30:25], instruction_from_instruction_memory[11:8], 1'b0};
//default
default : extended_value = 32'b0;
endcase
end

endmodule