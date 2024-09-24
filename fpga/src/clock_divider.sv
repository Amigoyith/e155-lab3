module clock_divide #(parameter DIVIDER = 42, //universal truth lol
	parameter COUNTER = $clog2(DIVIDER)) //autocalculate through 2^n >= DIVIDER
(
    input logic int_osc,
    input logic nreset,
    output logic divclk
);
 
	logic [COUNTER-1:0] counter;
	always_ff @(posedge int_osc) begin
	if (!nreset) begin
		counter<=0;
		divclk<=0;
    end else begin
    if (counter == (DIVIDER -1)) begin
		counter<=0;
		divclk<= !divclk;
    end else begin  
		counter<=counter+1;
    end
	
    end
end
    endmodule