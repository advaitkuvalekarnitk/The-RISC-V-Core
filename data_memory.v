module data_memory (input [31:0] alu_result,
                    input clk,
                    input [31:0] write_data_data_memory,
                    input write_enable_data_memory,
                    output [31:0] read_data);

reg [31:0] ram [1023:0];
//writing is better synchronous as we will usually write output once per cycle plus we avoid corrupted memory and race arounds and unnecessary continuous updates
always @(posedge clk)begin
    if(write_enable_data_memory)
    begin 
        ram[alu_result[31:2]] <= write_data_data_memory;
    end
end
//reading can be asynchronous so that no wait time
assign read_data = ram[alu_result[31:2]];
endmodule