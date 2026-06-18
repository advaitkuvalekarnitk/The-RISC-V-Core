module program_counter_target (input [31:0]program_counter_current_address,
                            input [31:0] input_from_extender,
                            output [31:0] program_counter_target_output);

assign program_counter_target_output = input_from_extender + program_counter_current_address;

endmodule