module risc_v_core (
    input clk,
    input rst
);
    // Wire declarations
    wire [31:0] pc_current, pc_next, pc_plus_4, pc_target;
    wire [31:0] instr;
    wire [31:0] read_data1, read_data2, write_back_data;
    wire [31:0] extended_imm;
    wire [31:0] alu_b, alu_out;
    wire [31:0] mem_read_data;
    wire [3:0] alu_ctrl;
    wire [2:0] ext_ctrl, funct3;
    wire [6:0] opcode, funct7;
    wire zero, lt, reg_we, mem_we, alu_src;
    wire [1:0] pc_sel;
    wire [2:0] wb_sel;
    wire [4:0] rs1_address, rs2_address, rd_address;


    assign pc_plus_4 = pc_current + 4;
    assign funct3 = instr[14:12];
    assign funct7 = instr[31:25];
    assign opcode = instr[6:0];


    program_counter pc (.next_instruction_address(pc_next), .clk(clk), .rst(rst), .current_instruction_address(pc_current));

    instruction_memory im (.current_instruction_address_input(pc_current), .instruction_out(instr));

    control_unit cu (
        .opcode(opcode), .funct3(funct3), .funct7(funct7), 
        .zero_flag_from_alu(zero), .less_than_flag(lt),
        .program_counter_mux_selector(pc_sel), .write_enable_data_memory(mem_we), 
        .write_enable_register_memory(reg_we), .extender_control_signal(ext_ctrl), 
        .alu_source_mux_selector(alu_src), .register_memory_write_mux_selector(wb_sel), 
        .alu_control_signal(alu_ctrl)
    );

    register_file rf (
        .clk(clk), .write_data(write_back_data), .write_enable(reg_we),
        .rs1_address(instr[19:15]), .rs2_address(instr[24:20]), .rd_address(instr[11:7]),
        .read_1(read_data1), .read_2(read_data2)
    );

    sign_extender se (.extender_control(ext_ctrl), .instruction_from_instruction_memory(instr), .extended_value(extended_imm));
    
    program_counter_target pct (.program_counter_current_address(pc_current), .input_from_extender(extended_imm), .program_counter_target_output(pc_target));

    assign alu_b = alu_src ? extended_imm : read_data2;
    ALU alu (.a(read_data1), .b(alu_b), .alu_control(alu_ctrl), .alu_output(alu_out), .zero_flag(zero), .less_than_flag(lt));

    data_memory dm (.alu_result(alu_out), .clk(clk), .funct_3(funct3), .write_data_data_memory(read_data2), .write_enable_data_memory(mem_we), .read_data(mem_read_data));

    assign write_back_data = (wb_sel == 3'b001) ? mem_read_data : 
                             (wb_sel == 3'b010) ? (pc_current + extended_imm) : 
                             (wb_sel == 3'b100) ? pc_plus_4 : alu_out;


    assign pc_next = (pc_sel == 2'b01) ? pc_target :                   // JAL/Branch target
                    (pc_sel == 2'b10) ? (read_data1 + extended_imm) : // JALR
                    pc_plus_4;
                     
     endmodule