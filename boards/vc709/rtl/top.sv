`timescale 1ps / 1ps

module top (
	input wire FPGA_SYSCLK_P,
	input wire FPGA_SYSCLK_N,

	// SI570 user clock (input 156.25MHz)
	input wire si570_refclk_p,
	input wire si570_refclk_n,
	// USER SMA GPIO clock (output to USER SMA clock)
	output wire user_sma_clock_p,
	output wire user_sma_clock_n,

	inout  wire i2c_clk,
	inout  wire i2c_data,
	output wire i2c_mux_rst_n,
	output wire si5324_rst_n,

	// Ethernet
	input  wire SFP_CLK_P,
	input  wire SFP_CLK_N,

	// Ethernet (ETH1)
	input  wire ETH1_TX_P,
	input  wire ETH1_TX_N,
	output wire ETH1_RX_P,
	output wire ETH1_RX_N,
	output wire ETH1_TX_DISABLE
);

// clk200
wire clk200;
IBUFDS IBUFDS_clk200 (
	.I(FPGA_SYSCLK_P),
	.IB(FPGA_SYSCLK_N),
	.O(clk200)
);

// sys_rst
wire sys_rst;
reg [7:0] cold_counter = 8'h0;
reg cold_reset = 1'b0;
always @(posedge clk200) begin
	if (cold_counter != 8'hff) begin
		cold_reset <= 1'b1;
		cold_counter <= cold_counter + 8'd1;
	end else
		cold_reset <= 1'b0;
end
assign sys_rst = cold_reset;

// clk50
wire clk50;
logic [1:0] clk_divide;
always @(posedge clk200) begin
    clk_divide <= clk_divide + 1'b1;
end
BUFG buffer_clk50 (
	.I (clk_divide[1]),
	.O (clk50)
);

// clock_control(SI5324)
clock_control cc_inst (
	.i2c_clk(i2c_clk),
	.i2c_data(i2c_data),
	.i2c_mux_rst_n(i2c_mux_rst_n),
	.si5324_rst_n(si5324_rst_n),
	.rst(sys_rst),
	.clk50(clk50)
);
wire clksi570;
IBUFDS IBUFDS_0 (
	.I(si570_refclk_p),
	.IB(si570_refclk_n),
	.O(clksi570)
);
OBUFDS OBUFDS_0 (
	.I(clksi570),
	.O(user_sma_clock_p),
	.OB(user_sma_clock_n)
);

// Ethernet
logic ETH1_TX_FAULT = 1'b0;
logic ETH1_RX_LOS = 1'b0;
eth_top eth1_top(.*);

endmodule

