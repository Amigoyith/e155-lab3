module synchronizer (
input logic clk,
input logic [3:0] col,
output logic [3:0] col_sync
);

logic [3:0] temp;
always_ff @(posedge clk) begin
    temp <= col ;   // 1st flip-flop <-- async input
    col_sync <= temp;   // 2nd flip-flop --> sync output
end

endmodule