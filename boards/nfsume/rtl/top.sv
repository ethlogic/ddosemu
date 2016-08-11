`include "../rtl/setup.v"
`timescale 1ps / 1ps

module top #(
	parameter PL_LINK_CAP_MAX_LINK_WIDTH = 2,
	parameter C_DATA_WIDTH               = 64,
	parameter KEEP_WIDTH                 = C_DATA_WIDTH / 32
)(
	input wire FPGA_SYSCLK_P,
	input wire FPGA_SYSCLK_N,
	inout wire I2C_FPGA_SCL,
	inout wire I2C_FPGA_SDA,

	// PCI Express
	output wire [(PL_LINK_CAP_MAX_LINK_WIDTH - 1) : 0] pci_exp_txp,
	output wire [(PL_LINK_CAP_MAX_LINK_WIDTH - 1) : 0] pci_exp_txn,
	input  wire [(PL_LINK_CAP_MAX_LINK_WIDTH - 1) : 0] pci_exp_rxp,
	input  wire [(PL_LINK_CAP_MAX_LINK_WIDTH - 1) : 0] pci_exp_rxn,
	input  wire sys_clk_p,
	input  wire sys_clk_n,
	input  wire sys_rst_n,

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

// PCIe
wire user_clk;
wire [C_DATA_WIDTH-1:0] m_axis_cq_tdata_reg;
wire             [84:0] m_axis_cq_tuser_reg;
wire                    m_axis_cq_tlast_reg;
wire   [KEEP_WIDTH-1:0] m_axis_cq_tkeep_reg;
wire                    m_axis_cq_tvalid_reg;
wire             [21:0] m_axis_cq_tready_reg;

wire [C_DATA_WIDTH-1:0] s_axis_cc_tdata_reg;
wire             [32:0] s_axis_cc_tuser_reg;
wire                    s_axis_cc_tlast_reg;
wire   [KEEP_WIDTH-1:0] s_axis_cc_tkeep_reg;
wire                    s_axis_cc_tvalid_reg;
wire              [3:0] s_axis_cc_tready_reg;
pcie_top pcie_top0(.*);

// Ethernet
eth_top eth1_top(.*);

endmodule

