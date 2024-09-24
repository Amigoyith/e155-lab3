module storage_ctrl (
	input logic clk,
    input logic reset,
    input logic key_pressed,
    input logic [3:0] key_digit,
    output logic [3:0] dig0,
    output logic [3:0] dig1
);
    logic last_key; //last_key value pressed?
    always_ff @(posedge clk) begin
        if (!reset) begin //default values setup
            dig0 <= 4'hF;
            dig1 <= 4'hF;
            last_key <= 0;
        end else begin
            // Rising edge detection (when pressed)
            if (key_pressed && !last_key) begin
                dig1 <= dig0;
                dig0 <= key_digit;
            end
            // Update key_pressed
            last_key <= key_pressed;
        end
    end
endmodule

