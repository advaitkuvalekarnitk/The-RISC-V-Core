module control_unit (input [6:0] opcode,
                    input [2:0] funct3,
                    input [6:0] funct7,
                    input zero_flag_from_alu,
                    input less_than_flag,
          
                    output reg [1:0] program_counter_mux_selector,
                    output reg write_enable_data_memory,
                    output reg write_enable_register_memory,
                    output reg [2:0]extender_control_signal,
                    output reg alu_source_mux_selector,
                    output reg [2:0]register_memory_write_mux_selector, 
                    output reg [3:0] alu_control_signal
                    );

always @(*) begin
    program_counter_mux_selector = 2'b0;
    write_enable_data_memory = 1'b0;
    write_enable_register_memory = 1'b0;
    extender_control_signal = 3'b0;
    alu_source_mux_selector = 1'b0;
    register_memory_write_mux_selector = 3'b0; 
    alu_control_signal = 4'b0;

    case (opcode)
        //R-type
        7'b0110011 : begin
            program_counter_mux_selector = 2'b0;
            write_enable_data_memory = 1'b0;
            write_enable_register_memory = 1'b1;
            extender_control_signal = 3'b0;
            alu_source_mux_selector = 1'b0;
            register_memory_write_mux_selector = 3'b000; // Fixed width matching literal

            if(funct3 == 3'b0 && funct7[5] == 1'b0)       begin alu_control_signal = 4'b0010; end 
            else if(funct3 == 3'b0 && funct7[5] == 1'b1)  begin alu_control_signal = 4'b0100; end 
            else if(funct3 == 3'b001 && funct7[5] == 1'b0) begin alu_control_signal = 4'b0110; end 
            else if(funct3 == 3'b010 && funct7[5] == 1'b0) begin alu_control_signal = 4'b1000; end 
            else if(funct3 == 3'b011 && funct7[5] == 1'b0) begin alu_control_signal = 4'b1001; end 
            else if(funct3 == 3'b100 && funct7[5] == 1'b0) begin alu_control_signal = 4'b0011; end 
            else if(funct3 == 3'b101 && funct7[5] == 1'b0) begin alu_control_signal = 4'b0101; end 
            else if(funct3 == 3'b101 && funct7[5] == 1'b1) begin alu_control_signal = 4'b0111; end 
            else if(funct3 == 3'b110 && funct7[5] == 1'b0) begin alu_control_signal = 4'b0001; end 
            else if(funct3 == 3'b111 && funct7[5] == 1'b0) begin alu_control_signal = 4'b0000; end 
        end

        //I-type 
        7'b0010011 : begin
            program_counter_mux_selector = 2'b0;
            write_enable_data_memory = 1'b0;
            write_enable_register_memory = 1'b1;
            extender_control_signal = 3'b0;
            alu_source_mux_selector = 1'b1;
            register_memory_write_mux_selector = 3'b000; // Fixed width matching literal

            if(funct3 == 3'b0)      begin alu_control_signal = 4'b0010; end 
            else if(funct3 == 3'b001) begin alu_control_signal = 4'b0110; end 
            else if(funct3 == 3'b010) begin alu_control_signal = 4'b1000; end 
            else if(funct3 == 3'b011) begin alu_control_signal = 4'b1001; end 
            else if(funct3 == 3'b100) begin alu_control_signal = 4'b0011; end 
            else if(funct3 == 3'b101 && funct7[5] == 0) begin alu_control_signal = 4'b0101; end 
            else if(funct3 == 3'b101 && funct7[5] == 1) begin alu_control_signal = 4'b0111; end 
            else if(funct3 == 3'b110) begin alu_control_signal = 4'b0001; end 
            else if(funct3 == 3'b111) begin alu_control_signal = 4'b0000; end 
        end

        //Load Instructions
        7'b0000011 : begin 
            program_counter_mux_selector = 2'b0;
            write_enable_data_memory = 1'b0;
            write_enable_register_memory = 1'b1;
            extender_control_signal = 3'b0;
            alu_source_mux_selector = 1'b1;
            register_memory_write_mux_selector = 3'b001; // Fixed width matching literal
            alu_control_signal = 4'b0010;
        end

        //Store Instructions
        7'b0100011 : begin 
            program_counter_mux_selector = 2'b0;
            write_enable_data_memory = 1'b1;
            write_enable_register_memory = 1'b0;
            extender_control_signal = 3'b001;
            alu_source_mux_selector = 1'b1;
            register_memory_write_mux_selector = 3'b000; // Fixed width matching literal
            alu_control_signal = 4'b0010;
        end

        //Conditional Branching 
        7'b1100011 : begin
            write_enable_data_memory = 1'b0;
            write_enable_register_memory = 1'b0;
            extender_control_signal = 3'b011;
            alu_source_mux_selector = 1'b0;
            register_memory_write_mux_selector = 3'b000; // Fixed width matching literal
            
            if (funct3 == 3'b000) begin // BEQ
                alu_control_signal = 4'b0100;
                program_counter_mux_selector = (zero_flag_from_alu) ? 2'b01 : 2'b00;
            end
            else if (funct3 == 3'b001) begin // BNE
                alu_control_signal = 4'b0100;
                program_counter_mux_selector = (!zero_flag_from_alu) ? 2'b01 : 2'b00;
            end
            else if (funct3 == 3'b100) begin // BLT
                alu_control_signal = 4'b1000;
                program_counter_mux_selector = (less_than_flag) ? 2'b01 : 2'b00;
            end
            else if (funct3 == 3'b101) begin // BGE
                alu_control_signal = 4'b1000;
                program_counter_mux_selector = (!less_than_flag) ? 2'b01 : 2'b00;
            end
            else if (funct3 == 3'b110) begin // BLTU
                alu_control_signal = 4'b1001;
                program_counter_mux_selector = (less_than_flag) ? 2'b01 : 2'b00;
            end
            else if (funct3 == 3'b111) begin // BGEU
                alu_control_signal = 4'b1001;
                program_counter_mux_selector = (!less_than_flag) ? 2'b01 : 2'b00;
            end
            else begin
                alu_control_signal = 4'b0000;
                program_counter_mux_selector = 2'b00;
            end
        end

        // LUI
        7'b0110111 : begin 
            program_counter_mux_selector = 2'b0;
            write_enable_data_memory = 1'b0;
            write_enable_register_memory = 1'b1;
            extender_control_signal = 3'b010;
            alu_source_mux_selector = 1'b0;
            register_memory_write_mux_selector = 3'b011; // Fixed width matching literal
            alu_control_signal = 4'b0000;
        end

        // AUIPC
        7'b0010111 : begin
            program_counter_mux_selector = 2'b0;
            write_enable_data_memory = 1'b0;
            write_enable_register_memory = 1'b1;
            extender_control_signal = 3'b010;
            alu_source_mux_selector = 1'b0;
            register_memory_write_mux_selector = 3'b010; // Fixed width matching literal
            alu_control_signal = 4'b0000;
        end

        // JAL
        7'b1101111 : begin
            program_counter_mux_selector = 2'b01;
            write_enable_data_memory = 1'b0;
            write_enable_register_memory = 1'b1;
            extender_control_signal = 3'b100;
            alu_source_mux_selector = 1'b0;
            register_memory_write_mux_selector = 3'b100;
            alu_control_signal = 4'b0000;
        end

        // JALR
        7'b1100111 : begin
            program_counter_mux_selector = 2'b10;
            write_enable_data_memory = 1'b0;
            write_enable_register_memory = 1'b1;
            extender_control_signal = 3'b000;
            alu_source_mux_selector = 1'b1;
            register_memory_write_mux_selector = 3'b100;
            alu_control_signal = 4'b0010;
        end
    endcase
end

endmodule