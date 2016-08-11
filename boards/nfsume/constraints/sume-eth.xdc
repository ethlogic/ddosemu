# SFP/QTH Transceiver clock (Must be set to value provided by Si5324, currently set to 156.25 MHz)
set_property PACKAGE_PIN E10 [get_ports SFP_CLK_P]
set_property PACKAGE_PIN E9 [get_ports SFP_CLK_N]
create_clock -add -name sfp_clk_pin -period 6.400 -waveform {0 3.200} [get_ports {SFP_CLK_P}];

#SFP Transceivers
set_property PACKAGE_PIN AM29 [get_ports SFP_CLK_ALARM_B]
set_property IOSTANDARD LVCMOS18 [get_ports SFP_CLK_ALARM_B]
set_property IOSTANDARD LVDS [get_ports SFP_REC_CLK_N]
set_property PACKAGE_PIN AW32 [get_ports SFP_REC_CLK_P]
set_property PACKAGE_PIN AW33 [get_ports SFP_REC_CLK_N]
set_property IOSTANDARD LVDS [get_ports SFP_REC_CLK_P]

# eth led
set_property -dict { PACKAGE_PIN G13  IOSTANDARD LVCMOS15 } [get_ports { led[0] }];
set_property -dict { PACKAGE_PIN L15  IOSTANDARD LVCMOS15 } [get_ports { led[1] }];
set_property -dict { PACKAGE_PIN AL22 IOSTANDARD LVCMOS15 } [get_ports { led[2] }];
set_property -dict { PACKAGE_PIN BA20 IOSTANDARD LVCMOS15 } [get_ports { led[3] }];
set_property -dict { PACKAGE_PIN AY18 IOSTANDARD LVCMOS15 } [get_ports { led[4] }];
set_property -dict { PACKAGE_PIN AY17 IOSTANDARD LVCMOS15 } [get_ports { led[5] }];
set_property -dict { PACKAGE_PIN P31  IOSTANDARD LVCMOS15 } [get_ports { led[6] }];
set_property -dict { PACKAGE_PIN K32  IOSTANDARD LVCMOS15 } [get_ports { led[7] }];
#
#set_property LOC GTHE2_CHANNEL_X1Y39 [get_cells ten_gig_eth_pcs_pma_inst0/inst/ten_gig_eth_pcs_pma_block_i/gt0_gtwizard_10gbaser_multi_gt_i/gt0_gtwizard_gth_10gbaser_i/gthe2_i]
set_property LOC GTHE2_CHANNEL_X1Y39 [get_cells eth1_top/axi_10g_ethernet_0_ins/inst/ten_gig_eth_pcs_pma/inst/ten_gig_eth_pcs_pma_block_i/gt0_gtwizard_10gbaser_multi_gt_i/gt0_gtwizard_gth_10gbaser_i/gthe2_i]
set_property PACKAGE_PIN B3 [get_ports ETH1_RX_N]
set_property PACKAGE_PIN A5 [get_ports ETH1_TX_N]
set_property PACKAGE_PIN A6 [get_ports ETH1_TX_P]
set_property PACKAGE_PIN B4 [get_ports ETH1_RX_P]
set_property PACKAGE_PIN M18 [get_ports ETH1_TX_DISABLE]
set_property IOSTANDARD LVCMOS15 [get_ports ETH1_TX_DISABLE]
set_property PACKAGE_PIN L17 [get_ports ETH1_RX_LOS]
set_property IOSTANDARD LVCMOS15 [get_ports ETH1_RX_LOS]
set_property PACKAGE_PIN M19 [get_ports ETH1_TX_FAULT]
set_property IOSTANDARD LVCMOS15 [get_ports ETH1_TX_FAULT]

# Else
set_false_path -to [get_ports -filter {NAME=~led*}]

