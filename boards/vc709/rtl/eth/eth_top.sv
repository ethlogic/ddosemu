`timescale 1ns / 1ps

module eth_top #(
	parameter cold_reset_count = 14'h3fff,
	parameter ifg_len = 28'hFFFF
)(
	input logic clk50,

	input  logic SFP_CLK_P,
	input  logic SFP_CLK_N,

	input  logic ETH1_TX_P,
	input  logic ETH1_TX_N,
	output logic ETH1_RX_P,
	output logic ETH1_RX_N,

	input  logic ETH1_TX_FAULT,
	input  logic ETH1_RX_LOS,
	output logic ETH1_TX_DISABLE
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

// eth_send
logic        s_axis_tx_tvalid;
logic        s_axis_tx_tready;
logic [63:0] s_axis_tx_tdata;
logic [ 7:0] s_axis_tx_tkeep;
logic        s_axis_tx_tlast;
logic        s_axis_tx_tuser;
eth_send eth_send0 (
	.clk156(clk156),
	.sys_rst(sys_rst),

	// data out(encap)
	.s_axis_tx_tvalid(s_axis_tx_tvalid),
	.s_axis_tx_tready(s_axis_tx_tready),
	.s_axis_tx_tdata (s_axis_tx_tdata),
	.s_axis_tx_tkeep (s_axis_tx_tkeep),
	.s_axis_tx_tlast (s_axis_tx_tlast),
	.s_axis_tx_tuser (s_axis_tx_tuser)
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
	.dclk(clk50),
	.reset(sys_rst),
	.rx_statistics_vector(),
	.rxn(ETH1_TX_N),
	.rxp(ETH1_TX_P),
	.s_axis_pause_tdata(16'b0),
	.s_axis_pause_tvalid(1'b0),
	.signal_detect(!ETH1_RX_LOS),
	.tx_disable(ETH1_TX_DISABLE),
	.tx_fault(ETH1_TX_FAULT),
	.tx_ifg_delay(8'd0),
	.tx_statistics_vector(),
	.txn(ETH1_RX_N),
	.txp(ETH1_RX_P),

	.rxrecclk_out(),
	.resetdone_out(),

	// eth tx
	.s_axis_tx_tready(s_axis_tx_tready),
	.s_axis_tx_tdata (s_axis_tx_tdata),
	.s_axis_tx_tkeep (s_axis_tx_tkeep),
	.s_axis_tx_tlast (s_axis_tx_tlast),
	.s_axis_tx_tvalid(s_axis_tx_tvalid),
	.s_axis_tx_tuser (s_axis_tx_tuser & zero),
	
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

