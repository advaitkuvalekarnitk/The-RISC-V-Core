module program_counter_plus_four (input [31:0] next_instruction_address,
                                input clk, 
                                input rst,
                                output reg [31:0] current_instruction_address);

always @(posedge clk or posedge rst)
if(rst)
current_instruction_address <= 32'b0;
else
current_instruction_address <= next_instruction_address; //pc = pc+4 to go to next instruction 

//next instruction address is controlled by a mux from outside which has a select line coming from the control unit which handles if there is a jump or branch instruction which doesnt do the usual pc+4
endmodule