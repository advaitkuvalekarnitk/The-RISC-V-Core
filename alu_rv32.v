module ALU (input [31:0]a, 
            input [31:0] b,
            input [3:0]alu_control,
            output reg [31:0] alu_output,
            output reg zero_flag,
            output reg less_than_flag);

wire [4:0] shift_amount;
assign shift_amount = b[4:0];
always @(*) begin
    zero_flag = 0;
    less_than_flag = 0;
    alu_output = 32'b0;

    case (alu_control)
    4'b0000 : alu_output = a & b;
    4'b0001 : alu_output = a | b;
    4'b0011 : alu_output = a ^ b;
    4'b0010 : alu_output = a + b;
    4'b0100 : alu_output = a - b;
    4'b0101 : alu_output = a >> shift_amount;
    4'b0110 : alu_output = a << shift_amount;
    4'b0111 : alu_output = $signed(a) >>> shift_amount;         //keeping everything unsigned as long as its explicitly needed reduces the      hardware used and also allows us to decide whether the alu output is to be interpreted as signed or unsigned later on.
    4'b1000 : begin
        less_than_flag = ($signed(a) < $signed(b)) ? 1'b1 : 1'b0;
        alu_output = {31'b0, less_than_flag};
    end
    4'b1001 : begin 
        less_than_flag = (a < b) ? 1'b1 : 1'b0;
        alu_output = {31'b0, less_than_flag};
    end
    default : alu_output = 32'b0;
    endcase
    if (alu_output == 32'b0)
    begin
        zero_flag = 1;
    end
end
endmodule