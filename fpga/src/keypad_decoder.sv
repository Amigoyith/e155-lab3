module decoder (
    input logic [3:0] col,
    input logic [1:0] row_active,
    output logic [3:0] key_digit //actual digit on keypad
);
 always_comb begin
        case ({row_active, col})
            6'b00_0111: key_digit = 4'hA;
            6'b00_1011: key_digit = 4'h3;
            6'b00_1101: key_digit = 4'h2;
            6'b00_1110: key_digit = 4'h1;
            6'b01_0111: key_digit = 4'hD;
            6'b01_1011: key_digit = 4'hF;
            6'b01_1101: key_digit = 4'h0;
            6'b01_1110: key_digit = 4'hE;
            6'b10_0111: key_digit = 4'hC;
            6'b10_1011: key_digit = 4'h9;
            6'b10_1101: key_digit = 4'h8;
            6'b10_1110: key_digit = 4'h7;
            6'b11_0111: key_digit = 4'hB;
            6'b11_1011: key_digit = 4'h6;
            6'b11_1101: key_digit = 4'h5; 
            6'b11_1110: key_digit = 4'h4;
        endcase
    end
endmodule