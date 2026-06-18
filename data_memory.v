module data_memory (input [31:0] alu_result,
                    input clk,
                    input [2:0] funct_3,          
                    input [31:0] write_data_data_memory,
                    input write_enable_data_memory,
                    output reg [31:0] read_data);

reg [31:0] ram [1023:0];

// Writing is synchronous to avoid corruption and unnecessary updates
always @(posedge clk) begin
    if(write_enable_data_memory) begin 
        case (funct_3)
            3'b000: begin // SB 
                case (alu_result[1:0])
                    2'b00: ram[alu_result[31:2]][7:0]   <= write_data_data_memory[7:0];
                    2'b01: ram[alu_result[31:2]][15:8]  <= write_data_data_memory[7:0];
                    2'b10: ram[alu_result[31:2]][23:16] <= write_data_data_memory[7:0];
                    2'b11: ram[alu_result[31:2]][31:24] <= write_data_data_memory[7:0];
                endcase
            end

            3'b001: begin // SH (Store Half-word)
                case (alu_result[1])
                    1'b0: ram[alu_result[31:2]][15:0]  <= write_data_data_memory[15:0];
                    1'b1: ram[alu_result[31:2]][31:16] <= write_data_data_memory[15:0];
                endcase
            end // Fixed: Added missing end for case 3'b001 block

            3'b010: begin // SW (Store Word)
                ram[alu_result[31:2]] <= write_data_data_memory;
            end
            
            default: begin 
                ram[alu_result[31:2]] <= write_data_data_memory;
            end
        endcase
    end
end

// Reading is asynchronous for zero wait time
always @(*) begin
    case(funct_3)
        3'b000: begin // LB (Load Byte - Sign Extended)
            case (alu_result[1:0])
                2'b00: read_data = {{24{ram[alu_result[31:2]][7]}},  ram[alu_result[31:2]][7:0]};
                2'b01: read_data = {{24{ram[alu_result[31:2]][15]}}, ram[alu_result[31:2]][15:8]};
                2'b10: read_data = {{24{ram[alu_result[31:2]][23]}}, ram[alu_result[31:2]][23:16]};
                2'b11: read_data = {{24{ram[alu_result[31:2]][31]}}, ram[alu_result[31:2]][31:24]};
            endcase
        end
            
        3'b001: begin // LH 
            case (alu_result[1])
                1'b0: read_data = {{16{ram[alu_result[31:2]][15]}}, ram[alu_result[31:2]][15:0]};
                1'b1: read_data = {{16{ram[alu_result[31:2]][31]}}, ram[alu_result[31:2]][31:16]};
            endcase
        end

        3'b010: begin // LW 
            read_data = ram[alu_result[31:2]];
        end

        3'b100: begin // LBU 
            case (alu_result[1:0])
                2'b00: read_data = {24'b0, ram[alu_result[31:2]][7:0]};
                2'b01: read_data = {24'b0, ram[alu_result[31:2]][15:8]};
                2'b10: read_data = {24'b0, ram[alu_result[31:2]][23:16]};
                2'b11: read_data = {24'b0, ram[alu_result[31:2]][31:24]};
            endcase
        end
            
        3'b101: begin // LHU 
            case (alu_result[1])
                1'b0: read_data = {16'b0, ram[alu_result[31:2]][15:0]};
                1'b1: read_data = {16'b0, ram[alu_result[31:2]][31:16]};
            endcase
        end
            
        default: read_data = ram[alu_result[31:2]];
    endcase
end

endmodule