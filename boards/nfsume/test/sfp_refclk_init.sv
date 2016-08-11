module sfp_refclk_init (
	input  logic CLK,
	input  logic RST,
	output logic SFP_REC_CLK_P,
	output logic SFP_REC_CLK_N,
	input  logic SFP_CLK_ALARM_B,
	inout  logic I2C_FPGA_SCL,
	inout  logic I2C_FPGA_SDA
);
endmodule
