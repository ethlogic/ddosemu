`timescale 1ps / 1ps
`define SIMULATION

module testbench #(
	parameter PL_LINK_CAP_MAX_LINK_WIDTH = 2,
	parameter C_DATA_WIDTH               = 64,
	parameter KEEP_WIDTH                 = C_DATA_WIDTH / 32
)(
	input wire user_clk,
	input wire clk100,
	input wire cold_reset,
	input wire SFP_CLK_P
);

wire SFP_REC_CLK_P;
wire SFP_REC_CLK_N;
wire ETH1_RX_P;
wire ETH1_RX_N;
wire ETH1_TX_DISABLE;
wire user_clk;

wire tmp_cq_tready;
wire tmp_cc_tready;

wire [C_DATA_WIDTH-1:0] m_axis_cq_tdata_reg;
wire             [84:0] m_axis_cq_tuser_reg;
wire                    m_axis_cq_tlast_reg;
wire   [KEEP_WIDTH-1:0] m_axis_cq_tkeep_reg;
wire                    m_axis_cq_tvalid_reg;
wire             [21:0] m_axis_cq_tready_reg = {22{tmp_cq_tready}};

wire [C_DATA_WIDTH-1:0] s_axis_cc_tdata_reg;
wire             [32:0] s_axis_cc_tuser_reg;
wire                    s_axis_cc_tlast_reg;
wire   [KEEP_WIDTH-1:0] s_axis_cc_tkeep_reg;
wire                    s_axis_cc_tvalid_reg;
wire              [3:0] s_axis_cc_tready_reg = {4{tmp_cc_tready}};
host_pio_wr host_pio_wr0 (
	.user_clk   (user_clk),
	.reset      (cold_reset),
	.cq_tdata   (m_axis_cq_tdata_reg),
	.cq_tuser   (m_axis_cq_tuser_reg),
	.cq_tlast   (m_axis_cq_tlast_reg),
	.cq_tkeep   (m_axis_cq_tkeep_reg),
	.cq_tvalid  (m_axis_cq_tvalid_reg),
	.cq_tready  (tmp_cq_tready),
	.cc_tdata   (s_axis_cc_tdata_reg),
	.cc_tuser   (s_axis_cc_tuser_reg),
	.cc_tlast   (s_axis_cc_tlast_reg),
	.cc_tkeep   (s_axis_cc_tkeep_reg),
	.cc_tvalid  (s_axis_cc_tvalid_reg),
	.cc_tready  (tmp_cc_tready)
);

eth_top #(
	.cold_reset_count(14'h1f),
	.ifg_len(28'hF)
) eth1_top (
	.user_clk              (user_clk),
	.clk100                (clk100),
	.cold_reset            (cold_reset),
	.SFP_CLK_P             (SFP_CLK_P),
	.SFP_CLK_N             (1'b0),
	.SFP_REC_CLK_P         (SFP_REC_CLK_P),
	.SFP_REC_CLK_N         (SFP_REC_CLK_N),
	.ETH1_TX_P             (1'b0),
	.ETH1_TX_N             (1'b0),
	.ETH1_RX_P             (ETH1_RX_P),
	.ETH1_RX_N             (ETH1_RX_N),
	.I2C_FPGA_SCL          (1'b0),
	.I2C_FPGA_SDA          (1'b0),
	.SFP_CLK_ALARM_B       (1'b0),
	.ETH1_TX_FAULT         (1'b0),
	.ETH1_RX_LOS           (1'b0),
	.ETH1_TX_DISABLE       (ETH1_TX_DISABLE),
	.m_axis_cq_tdata_reg   (m_axis_cq_tdata_reg),
	.m_axis_cq_tuser_reg   (m_axis_cq_tuser_reg),
	.m_axis_cq_tlast_reg   (m_axis_cq_tlast_reg),
	.m_axis_cq_tkeep_reg   (m_axis_cq_tkeep_reg),
	.m_axis_cq_tvalid_reg  (m_axis_cq_tvalid_reg),
	.m_axis_cq_tready_reg  (m_axis_cq_tready_reg),
	.s_axis_cc_tdata_reg   (s_axis_cc_tdata_reg),
	.s_axis_cc_tuser_reg   (s_axis_cc_tuser_reg),
	.s_axis_cc_tlast_reg   (s_axis_cc_tlast_reg),
	.s_axis_cc_tkeep_reg   (s_axis_cc_tkeep_reg),
	.s_axis_cc_tvalid_reg  (s_axis_cc_tvalid_reg),
	.s_axis_cc_tready_reg  (s_axis_cc_tready_reg)
);

endmodule
