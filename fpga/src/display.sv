//Copies from Lab_2
module display (
    input logic clk,              
    input logic reset,   
    input logic [3:0] dig0,  
    input logic [3:0] dig1,  
    output logic [6:0] seg,     
    output logic [1:0] anode
);

    logic freq_switch;
    logic [11:0] mux_counter;
    logic [3:0] cur_num;

    always_ff @(posedge clk) begin
        if (!reset) begin
            mux_counter <= 0;
        end else begin
            mux_counter <= mux_counter + 1;
        end
    end

    // Instantiate the seven-segment display decoder
    seven_segdisplay decode (            // Use the internal oscillator clock
        .s(cur_num),
        .seg(seg)
    );

   assign freq_switch = mux_counter[11]; 	 
//assign number to display at time cycle
    always_comb begin
        if (freq_switch)
cur_num = dig0;
        else
            cur_num = dig1;
    end
//At time cycles, turn one annode for displaying 1st or 2nd digit
    always_comb begin
        if (freq_switch) 
            anode = 2'b01; //turn on 1st digit
        else 
            anode = 2'b10; //turn on 2nd digit
    end
    // Compute the sum of s1 and s2
   
endmodule


module seven_segdisplay(
input logic [3:0] s,
output logic [6:0] seg
);
always_comb begin 
   case(s)
		4'b0000 : seg	= 7'b0000001; // display 0
		4'b0001 : seg= 7'b1001111; // display 1
		4'b0010 : seg= 7'b0010010; // display 2
		4'b0011 : seg= 7'b0000110; // display 3
		4'b0100 : seg= 7'b1001100; // display 4
		4'b0101 : seg= 7'b0100100; // display 5
		4'b0110 : seg= 7'b0100000; // display 6
		4'b0111 : seg= 7'b0001111; // display 7
		4'b1000 : seg= 7'b0000000; // display 8
		4'b1001 : seg= 7'b0000100; // display 9
		4'b1010 : seg = 7'b0001000; // display A
		4'b1011 : seg = 7'b1100000; // display b
		4'b1100 : seg = 7'b0110001; // display C
		4'b1101 : seg = 7'b1000010; //display d
		4'b1110 : seg = 7'b0110000; // display E
		4'b1111 : seg = 7'b0111000; // display F
		default: seg = 7'b1111111; // display nothing 
endcase

end
endmodule