module top (
    input logic nreset,	//not reset input
    input logic [3:0] col,  //Column signal input
    output logic [3:0] row, //Scan rows output
    output logic [6:0] seg,  //7 segment display output
	output logic key_pressed,   //whether a key is pressed or not (output debug LED)
    output logic [1:0] anode ,  //MUX both digits switch on/off frequently
	output logic [2:0] test,   //three states test
	output all_released  //Are all keys released?
);
logic int_osc; 
logic [3:0] col_sync; 
logic [3:0] dig0, dig1;
logic [1:0] row_active;
logic [3:0] key_digit;
logic clk;
logic scanclk;

HSOSC #(.CLKHF_DIV(2'b00)) 
        hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));
	
synchronizer sync(.clk(int_osc), .col(col), .col_sync(col_sync));


   scanner scanner (
        .clk(scanclk),
        .reset(nreset),
        .col(col_sync),
        .row(row),
		.key_pressed(key_pressed),
        .row_active(row_active),
		.test(test),
		.scan_key_valid,
		.key_released
		//.key_out(key_out)
    );

clock_divide #(100000) realFastScan (
      .int_osc(int_osc),
      .nreset(nreset),
      .divclk(scanclk)
  );
  
	 storage_ctrl taketurns (
        .clk(scanclk),
        .reset(nreset),
        .key_pressed(key_pressed),
		.key_digit(key_digit),
        .dig0(dig0),
        .dig1(dig1)
    );
	decoder decoder(
	.col(col),
	.row_active(row_active),
	.key_digit(key_digit)
	);

display display(
.clk(int_osc),
.reset(nreset),
.dig0(dig0),
.dig1(dig1),
.seg(seg),
.anode(anode)
);


	
endmodule
