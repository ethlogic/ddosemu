`timescale 1ns / 1ps

module eth_top #(
	parameter cold_reset_count           = 14'h3fff,

	parameter PL_LINK_CAP_MAX_LINK_WIDTH = 2,
	parameter C_DATA_WIDTH               = 64,
	parameter KEEP_WIDTH                 = C_DATA_WIDTH / 32,

	parameter ifg_len = 28'hFFFF
)(
	input logic user_clk,
	input logic clk100,
	input logic cold_reset,

	input  logic SFP_CLK_P,
	input  logic SFP_CLK_N,
	output logic SFP_REC_CLK_P,
	output logic SFP_REC_CLK_N,

	input  logic ETH1_TX_P,
	input  logic ETH1_TX_N,
	output logic ETH1_RX_P,
	output logic ETH1_RX_N,

	inout logic I2C_FPGA_SCL,
	inout logic I2C_FPGA_SDA,

	input logic SFP_CLK_ALARM_B,

	input  logic ETH1_TX_FAULT,
	input  logic ETH1_RX_LOS,
	output logic ETH1_TX_DISABLE,

	// RX_ENGINE
	input logic [C_DATA_WIDTH-1:0] m_axis_cq_tdata_reg,
	input logic             [84:0] m_axis_cq_tuser_reg,
	input logic                    m_axis_cq_tlast_reg,
	input logic   [KEEP_WIDTH-1:0] m_axis_cq_tkeep_reg,
	input logic                    m_axis_cq_tvalid_reg,
	input logic             [21:0] m_axis_cq_tready_reg,

	input logic [C_DATA_WIDTH-1:0] s_axis_cc_tdata_reg,
	input logic             [32:0] s_axis_cc_tuser_reg,
	input logic                    s_axis_cc_tlast_reg,
	input logic   [KEEP_WIDTH-1:0] s_axis_cc_tkeep_reg,
	input logic                    s_axis_cc_tvalid_reg,
	input logic              [3:0] s_axis_cc_tready_reg
);

//ila_0 ila_0_ins(
//	.clk(user_clk),
//	.probe0({ m_axis_cq_tdata_reg,
//	          m_axis_cq_tuser_reg,
//	          m_axis_cq_tlast_reg,
//	          m_axis_cq_tkeep_reg,
//	          m_axis_cq_tvalid_reg,
//	          m_axis_cq_tready_reg })
//);


// sfp_refclk_init
logic clk156;
sfp_refclk_init sfp_refclk_init0 (
	.CLK(clk100),
	.RST(cold_reset),
	.*
);

logic sys_rst;
logic [13:0] cold_counter;
always_ff @(posedge clk156) begin
	if (cold_counter != cold_reset_count) begin
		sys_rst <= 1'b1;
		cold_counter <= cold_counter + 14'd1;
	end else
		sys_rst <= 1'b0;
end


// pcs_pma_conf
logic [535:0] pcs_pma_configuration_vector;
pcs_pma_conf pcs_pma_conf0(.*);

// eth_mac_conf
logic [79:0] mac_tx_configuration_vector;
logic [79:0] mac_rx_configuration_vector;
eth_mac_conf eth_mac_conf0(.*);

// eth_tlptap (PCIe to FIFO)
logic fifo0_wr_en, fifo0_rd_en;
logic fifo0_full, fifo0_empty;
logic [80:0] fifo0_din, fifo0_dout;
eth_tlptap eth_tlptap0 (
	// data in(tap)
	.s_axis_tvalid(m_axis_cq_tvalid_reg),
	.s_axis_tready(m_axis_cq_tready_reg[0]),
	.s_axis_tdata (m_axis_cq_tdata_reg),
	.s_axis_tkeep (m_axis_cq_tkeep_reg),
	.s_axis_tlast (m_axis_cq_tlast_reg),
	.s_axis_tuser (m_axis_cq_tuser_reg[7:0]),
	// FIFO write
	.wr_en(fifo0_wr_en),
	.din(fifo0_din),
	.full(fifo0_full)
);

// eth_tlptap (PCIe to FIFO)
logic fifo1_wr_en, fifo1_rd_en;
logic fifo1_full, fifo1_empty;
logic [80:0] fifo1_din, fifo1_dout;
eth_tlptap eth_tlptap1 (
	// data in(tap)
	.s_axis_tvalid(s_axis_cc_tvalid_reg),
	.s_axis_tready(s_axis_cc_tready_reg[0]),
	.s_axis_tdata (s_axis_cc_tdata_reg),
	.s_axis_tkeep (s_axis_cc_tkeep_reg),
	.s_axis_tlast (s_axis_cc_tlast_reg),
	.s_axis_tuser (8'b0),
	// FIFO write
	.wr_en(fifo1_wr_en),
	.din(fifo1_din),
	.full(fifo1_full)
);

// pcie2eth_fifo0
pcie2eth_fifo0 pcie2eth_fifo0_ins (
	.rst(sys_rst),
	.wr_clk(user_clk),    // data in (pcie)
	.rd_clk(clk156),      // data out(eth)

	.wr_en(fifo0_wr_en),
	.rd_en(fifo0_rd_en),
	.full(fifo0_full),
	.empty(fifo0_empty),
	.din(fifo0_din),
	.dout(fifo0_dout)
);

// pcie2eth_fifo1
pcie2eth_fifo0 pcie2eth_fifo1_ins (
	.rst(sys_rst),
	.wr_clk(user_clk),    // data in (pcie)
	.rd_clk(clk156),      // data out(eth)

	.wr_en(fifo1_wr_en),
	.rd_en(fifo1_rd_en),
	.full(fifo1_full),
	.empty(fifo1_empty),
	.din(fifo1_din),
	.dout(fifo1_dout)
);

// eth_txarb
logic [82:0] out_din;
logic out_wr_en;
logic out_full;
eth_txarb eth_txarb0 (
	.clk(clk156),
	.rst(sys_rst),

	// data in: fifo0
	.fifo0_rd_en(fifo0_rd_en),
	.fifo0_dout (fifo0_dout),
	.fifo0_empty(fifo0_empty),

	// data in: fifo1
	.fifo1_rd_en(fifo1_rd_en),
	.fifo1_dout (fifo1_dout),
	.fifo1_empty(fifo1_empty),

	// data out
	.wr_en(out_wr_en),
	.din (out_din),
	.full(out_full)
);

// arb2encap_fifo
logic [82:0] out_dout;
logic out_rd_en;
logic out_empty;
arb2encap_fifo arb2encap_fifo_ins (
	.srst(sys_rst),
	.clk(clk156),

	.wr_en(out_wr_en),
	.rd_en(out_rd_en),
	.full(out_full),
	.empty(out_empty),
	.din(out_din),
	.dout(out_dout)
);

// eth_encap0 (FIFO to eth_encap)
logic        m_axis_fifo_tvalid;
logic        m_axis_fifo_tready;
logic [63:0] m_axis_fifo_tdata;
logic [ 7:0] m_axis_fifo_tkeep;
logic        m_axis_fifo_tlast;
logic        m_axis_fifo_tuser;
eth_encap eth_encap0 (
	.clk156(clk156),
	.sys_rst(sys_rst),

	// FIFO0 read
	.rd_en(out_rd_en),
	.dout (out_dout),
	.empty(out_empty),

	// data out(encap)
	.m_axis_tvalid(m_axis_fifo_tvalid),
	.m_axis_tready(m_axis_fifo_tready),
	.m_axis_tdata (m_axis_fifo_tdata),
	.m_axis_tkeep (m_axis_fifo_tkeep),
	.m_axis_tlast (m_axis_fifo_tlast),
	.m_axis_tuser (m_axis_fifo_tuser)
);


// Ethernet IP
logic txusrclk_out;
logic txusrclk2_out;
logic gttxreset_out;
logic gtrxreset_out;
logic txuserrdy_out;
logic areset_datapathclk_out;
logic reset_counter_done_out;
logic qplllock_out;
logic qplloutclk_out;
logic qplloutrefclk_out;
logic [447:0] pcs_pma_status_vector;
logic [1:0] mac_status_vector;
logic [7:0] pcspma_status;
logic rx_statistics_valid;
logic tx_statistics_valid;
wire zero = 1'b0;
axi_10g_ethernet_0 axi_10g_ethernet_0_ins (
	.coreclk_out(clk156),
	.refclk_n(SFP_CLK_N),
	.refclk_p(SFP_CLK_P),
	.dclk(clk100),
	.reset(sys_rst),
	.rx_statistics_vector(),
	.rxn(ETH1_TX_N),
	.rxp(ETH1_TX_P),
	.s_axis_pause_tdata(16'b0),
	.s_axis_pause_tvalid(1'b0),
	.signal_detect(!ETH1_RX_LOS),
	.tx_disable(ETH1_TX_DISABLE),
	.tx_fault(ETH1_TX_FAULT),
	.tx_ifg_delay(8'd8),
	.tx_statistics_vector(),
	.txn(ETH1_RX_N),
	.txp(ETH1_RX_P),

	.rxrecclk_out(),
	.resetdone_out(),

	// eth tx
	.s_axis_tx_tready(m_axis_fifo_tready),
	.s_axis_tx_tdata (m_axis_fifo_tdata),
	.s_axis_tx_tkeep (m_axis_fifo_tkeep),
	.s_axis_tx_tlast (m_axis_fifo_tlast),
	.s_axis_tx_tvalid(m_axis_fifo_tvalid),
	.s_axis_tx_tuser (m_axis_fifo_tuser & zero),
	
	// eth rx
	.m_axis_rx_tdata(),
	.m_axis_rx_tkeep(),
	.m_axis_rx_tlast(),
	.m_axis_rx_tuser(),
	.m_axis_rx_tvalid(),

	.sim_speedup_control(1'b0),
	.rx_axis_aresetn(~sys_rst),
	.tx_axis_aresetn(~sys_rst),

	.*
);

endmodule

