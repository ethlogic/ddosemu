module host_pio_rd #(
	parameter PL_LINK_CAP_MAX_LINK_WIDTH = 2,
	parameter C_DATA_WIDTH               = 64,
	parameter KEEP_WIDTH                 = C_DATA_WIDTH / 32
)(
	input logic user_clk,
	input logic reset,

	output logic [C_DATA_WIDTH-1:0] cq_tdata,
	output logic             [84:0] cq_tuser = 0,
	output logic                    cq_tlast,
	output logic   [KEEP_WIDTH-1:0] cq_tkeep,
	output logic                    cq_tvalid,
	output logic                    cq_tready,

	output logic [C_DATA_WIDTH-1:0] cc_tdata,
	output logic             [32:0] cc_tuser = 0,
	output logic                    cc_tlast,
	output logic   [KEEP_WIDTH-1:0] cc_tkeep,
	output logic                    cc_tvalid,
	output logic                    cc_tready
);

logic [7:0] count;
always_ff @(posedge user_clk) begin
	if (reset) begin
		count <= 0;
	end else begin
		if (count != 16)
			count <= count + 1;
	end
end

// cq
always_comb begin
	case (count)
		8'h4: {cq_tvalid, cq_tready, cq_tlast, cq_tkeep, cq_tdata} = {1'b1, 1'b1, 1'b0, 2'b11, 64'h00000000_c0004000};
		8'h5: {cq_tvalid, cq_tready, cq_tlast, cq_tkeep, cq_tdata} = {1'b1, 1'b1, 1'b1, 2'b11, 64'h00000000_70000001};
		8'h6: {cq_tvalid, cq_tready, cq_tlast, cq_tkeep, cq_tdata} = {1'b0, 1'b1, 1'b0, 2'b11, 64'h00000000_c0004000};
		8'h7: {cq_tvalid, cq_tready, cq_tlast, cq_tkeep, cq_tdata} = {1'b0, 1'b1, 1'b0, 2'b11, 64'h00000000_c0004000};
		8'h8: {cq_tvalid, cq_tready, cq_tlast, cq_tkeep, cq_tdata} = {1'b0, 1'b1, 1'b0, 2'b11, 64'h00000000_c0004000};
		8'h9: {cq_tvalid, cq_tready, cq_tlast, cq_tkeep, cq_tdata} = {1'b0, 1'b1, 1'b0, 2'b11, 64'h00000000_c0004000};
		8'ha: {cq_tvalid, cq_tready, cq_tlast, cq_tkeep, cq_tdata} = {1'b0, 1'b1, 1'b0, 2'b11, 64'h00000000_c0004000};
		8'hb: {cq_tvalid, cq_tready, cq_tlast, cq_tkeep, cq_tdata} = {1'b0, 1'b1, 1'b0, 2'b11, 64'h00000000_c0004000};
		default:
		      {cq_tvalid, cq_tready, cq_tlast, cq_tkeep, cq_tdata} = {1'b0, 1'b0, 1'b0, 2'b00, 64'h00000000_00000000};
	endcase
end

// cc
always_comb begin
	case (count)
		8'h4: {cc_tvalid, cc_tready, cc_tlast, cc_tkeep, cc_tdata} = {1'b0, 1'b1, 1'b0, 2'b11, 64'h00000000_00000000};
		8'h5: {cc_tvalid, cc_tready, cc_tlast, cc_tkeep, cc_tdata} = {1'b0, 1'b1, 1'b0, 2'b11, 64'h00000000_00000000};
		8'h6: {cc_tvalid, cc_tready, cc_tlast, cc_tkeep, cc_tdata} = {1'b0, 1'b1, 1'b0, 2'b11, 64'h00000000_00000000};
		8'h7: {cc_tvalid, cc_tready, cc_tlast, cc_tkeep, cc_tdata} = {1'b0, 1'b1, 1'b0, 2'b11, 64'h00000000_00000000};
		8'h8: {cc_tvalid, cc_tready, cc_tlast, cc_tkeep, cc_tdata} = {1'b0, 1'b1, 1'b0, 2'b11, 64'h00000000_00000000};
		8'h9: {cc_tvalid, cc_tready, cc_tlast, cc_tkeep, cc_tdata} = {1'b0, 1'b1, 1'b0, 2'b11, 64'h00000000_00000000};
		8'ha: {cc_tvalid, cc_tready, cc_tlast, cc_tkeep, cc_tdata} = {1'b1, 1'b1, 1'b0, 2'b11, 64'h00000001_00010000};
		8'hb: {cc_tvalid, cc_tready, cc_tlast, cc_tkeep, cc_tdata} = {1'b1, 1'b1, 1'b1, 2'b11, 64'h000000bb_00aaf800};
		default:
		      {cc_tvalid, cc_tready, cc_tlast, cc_tkeep, cc_tdata} = {1'b0, 1'b0, 1'b0, 2'b00, 64'h00000000_00000000};
	endcase
end

endmodule

