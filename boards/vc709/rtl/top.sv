`timescale 1ps / 1ps

module top (
	input wire FPGA_SYSCLK_P,
	input wire FPGA_SYSCLK_N,

	// Ethernet
	input  wire SFP_CLK_P,
	input  wire SFP_CLK_N,
	output wire SFP_REC_CLK_P,
	output wire SFP_REC_CLK_N,
	input  wire SFP_CLK_ALARM_B,
	output wire [7:0] led,

	// Ethernet (ETH1)
	input  wire ETH1_TX_P,
	input  wire ETH1_TX_N,
	output wire ETH1_RX_P,
	output wire ETH1_RX_N,
	input  wire ETH1_TX_FAULT,
	input  wire ETH1_RX_LOS,
	output wire ETH1_TX_DISABLE
);

// clk200
wire clk200;
IBUFDS IBUFDS_clk200 (
	.I(FPGA_SYSCLK_P),
	.IB(FPGA_SYSCLK_N),
	.O(clk200)
);

// clk100
wire clk100;
logic [1:0] clock_divide;
always_ff @(posedge clk200)
	clock_divide <= clock_divide + 2'b1;
BUFG buffer_clk100 (
	.I(clock_divide[0]),
	.O(clk100)
);

// cold_reset
logic cold_reset;
logic [13:0] cold_counter;
always_ff @(posedge clk200) begin
	if (cold_counter != 14'h3fff) begin
		cold_reset <= 1'b1;
		cold_counter <= cold_counter + 14'd1;
	end else
		cold_reset <= 1'b0;
end

// Ethernet
eth_top eth1_top(.*);

endmodule

