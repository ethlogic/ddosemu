module eth_tlptap #(
	parameter PL_LINK_CAP_MAX_LINK_WIDTH = 2,
	parameter C_DATA_WIDTH               = 64,
	parameter KEEP_WIDTH                 = C_DATA_WIDTH / 32
)(
	// Eth+IP+UDP + TLP packet
	input logic [C_DATA_WIDTH-1:0] s_axis_tdata,
	input logic              [7:0] s_axis_tuser,
	input logic                    s_axis_tlast,
	input logic   [KEEP_WIDTH-1:0] s_axis_tkeep,
	input logic                    s_axis_tvalid,
	input logic                    s_axis_tready,

	// TLP packet (FIFO write)
	output logic        wr_en,
	output logic [80:0] din,
	input  logic        full
);

logic [7:0] tmp_tkeep = { {4{s_axis_tkeep[1]}}, {4{s_axis_tkeep[0]}} };

always_comb begin
	if (!full) begin
		wr_en = s_axis_tready && s_axis_tvalid;
		din = {tmp_tkeep, s_axis_tdata, s_axis_tuser, s_axis_tlast};
	end else begin
		wr_en = 1'b0;
		din = 81'b0;
	end
end

endmodule

