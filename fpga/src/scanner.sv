module scanner (
    input logic int_osc,
    input logic reset,
    input logic [3:0] col,
    output logic [3:0] row,
    output logic key_pressed,
    output logic [1:0] row_active,  //which row is press on, for decoding purposes
	output logic [2:0] test_states,
	output all_released
);
    parameter DEBOUNCE_TIME = 7; //IDK but this works
    logic [15:0] debounce_counter;
    logic key_stable;
    logic [1:0] current_row;
    logic [1:0] hold_row;
    logic [3:0] hold_col;
    logic all_released;

    // State encoding for FSM
    typedef enum logic [1:0] {
        SCAN,       // Scanning state
        DEBOUNCE,   // Debouncing state
        PRESS       // Pressing state
    } state_t;
    state_t state, next_state;

  
    // Output the currently active row (1-hot encoded for row)
    always_comb begin
		if (state ==SCAN) begin
        case (current_row)
            2'b00: row = 4'b0111; //Scan 4th row
            2'b01: row = 4'b1011; //Scan 3rd row
            2'b10: row = 4'b1101; //Scan 2md row
            2'b11: row = 4'b1110; //Scan 1st row
            default: row = 4'b0000;
        endcase
		end 
		else row = 4'b0000;
		end

    // Key press detection logic: detect if any column is low
    always_ff @(posedge int_osc) begin
    if (!reset) begin
        hold_col <= 4'b1111;
    end else begin
        hold_col <= col; // PRESS the column inputs for debouncing
    end
end
    //FSM? FSM!
    always_ff @(posedge int_osc) begin
        if (!reset) begin
            state <= SCAN;
            debounce_counter <= 0;
            key_stable <= 0;
            key_pressed <= 0;
            all_released <= 0;
            hold_row <= 2'b00; // Default to row 0
        end else begin
            case (state)
                // Row Scanning State
                SCAN: begin
                if (col == 4'b1111) begin
                        next_state <= SCAN;
                    end else begin
						next_state <= DEBOUNCE;
                    end
                end

                // Debouncing state
                DEBOUNCE: begin
			if (col == 4'b1111) begin
				debounce_counter <= 0;
				key_stable <= 0;
				next_state <= SCAN;
				end
				
			else begin
				
            // Once notics key pressed -> increment debounce counter
				if (debounce_counter < DEBOUNCE_TIME) begin
					debounce_counter <= debounce_counter + 1;
					next_state <= DEBOUNCE;
				end 
				else begin
					key_stable <= 1;
					hold_row <= current_row;
					next_state <= PRESS;
				end
				
			end 
	end
            PRESS: begin
			if (col == 4'b1111) begin
				key_pressed <= 0;  //Key released
				all_released <= 1;
				debounce_counter <= 0;
				next_state <= SCAN; //Go back to scan
			end 
			else begin
				key_pressed <= 1;
				all_released <= 0;
				next_state <= PRESS; // still pressed
			end
			
			end
			default: next_state <= SCAN;
            endcase
            state <= next_state; //State update
        end
    end
	
  always_ff @(posedge int_osc) begin
    if (!reset) begin
        current_row <= 2'b00;
    end else if (state == SCAN) begin
        if (current_row == 2'b11) begin
            current_row <= 2'b00;
        end else begin current_row <= current_row + 1;
    end
end

	
    always_comb begin
        if (key_pressed)
            row_active = hold_row; // row stablely being held
        else
            row_active = current_row; // No key press? Go Scan!
    end


	
always_comb begin
    // Default value for test_states to avoid PRESSes
    test_states = 3'b000;  // Default assignment (this ensures that 'test_states' is always assigned)

    if (state == SCAN) begin
        test_states = 3'b100;
    end else if (state == DEBOUNCE) begin
        test_states = 3'b010;
    end else if (state == PRESS) begin
        test_states = 3'b001;
    end
end


endmodule