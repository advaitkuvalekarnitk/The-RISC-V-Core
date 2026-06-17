module register_file (input clk, 
                    input [31:0] write_data,
                    input write_enable,
                    input [4:0] rs1_address, rs2_address, rd_address,
                    output [31:0] read_1, read_2
                    );

reg [31:0] memory_array [31:0];

always @(posedge clk)
begin
    if((write_enable == 1) && (rd_address != 5'b0))
    begin
        memory_array[rd_address] <= write_data;
    end
end

//we cant just initialize x0 to zero at the very start cuz itll lose its value everytime we turn the power off, also initial blocks are non synthesizable so thats also a no go. 

assign read_1 = (rs1_address == 5'b0) ? 32'b0 : memory_array[rs1_address];
assign read_2 = (rs2_address == 5'b0) ? 32'b0 : memory_array[rs2_address]; 

endmodule