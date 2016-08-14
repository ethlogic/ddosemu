# Properties used for Rev1.0 of VC709 (Type1, div-1)
set_property BITSTREAM.CONFIG.BPI_SYNC_MODE Type1 [current_design]
set_property BITSTREAM.CONFIG.EXTMASTERCCLK_EN div-1 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property CONFIG_VOLTAGE 1.5 [current_design]
set_property CFGBVS GND [current_design]

###############################################################################
###############################################################################
create_clock -name mcb_clk_ref -period 5 [get_ports FPGA_SYSCLK_P]

# Bank: 38 - Byte 
set_property VCCAUX_IO DONTCARE [get_ports {FPGA_SYSCLK_P}]
set_property IOSTANDARD DIFF_SSTL15 [get_ports {FPGA_SYSCLK_P}]
set_property PACKAGE_PIN H19 [get_ports {FPGA_SYSCLK_P}]

# Bank: 38 - Byte 
set_property VCCAUX_IO DONTCARE [get_ports {FPGA_SYSCLK_N}]
set_property IOSTANDARD DIFF_SSTL15 [get_ports {FPGA_SYSCLK_N}]
set_property PACKAGE_PIN G18 [get_ports {FPGA_SYSCLK_N}]

##GT Ref clk
set_property PACKAGE_PIN AH8 [get_ports SFP_CLK_P]
set_property PACKAGE_PIN AH7 [get_ports SFP_CLK_N]

# SFP TX Disable for 10G PHY
set_property PACKAGE_PIN AB41  [get_ports {ETH1_TX_DISABLE}]
set_property IOSTANDARD LVCMOS18 [get_ports {ETH1_TX_DISABLE}]
#set_property PACKAGE_PIN Y42  [get_ports {ETH2_TX_DISABLE}]
#set_property IOSTANDARD LVCMOS18 [get_ports {ETH2_TX_DISABLE}]
#set_property PACKAGE_PIN AC38  [get_ports {ETH3_TX_DISABLE}]
#set_property IOSTANDARD LVCMOS18 [get_ports {ETH3_TX_DISABLE}]
#set_property PACKAGE_PIN AC40  [get_ports {ETH4_TX_DISABLE}]
#set_property IOSTANDARD LVCMOS18 [get_ports {ETH4_TX_DISABLE}]

##-------------------------------------
## LED Status Pinout   (bottom to top)
##-------------------------------------
#set_property PACKAGE_PIN AM39  [get_ports {led[0]}]
#set_property PACKAGE_PIN AN39  [get_ports {led[1]}]
#set_property PACKAGE_PIN AR37  [get_ports {led[2]}]
#set_property PACKAGE_PIN AT37  [get_ports {led[3]}]
#set_property PACKAGE_PIN AR35  [get_ports {led[4]}]
#set_property PACKAGE_PIN AP41  [get_ports {led[5]}]
#set_property PACKAGE_PIN AP42  [get_ports {led[6]}]
#set_property PACKAGE_PIN AU39  [get_ports {led[7]}]

#set_property IOSTANDARD LVCMOS18 [get_ports {led[0]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {led[1]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {led[2]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {led[3]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {led[4]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {led[5]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {led[6]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {led[7]}]

#set_property SLEW SLOW [get_ports led]
#set_property DRIVE 4 [get_ports led]

##-------------------------------------
## BUTTON
##-------------------------------------
#set_property PACKAGE_PIN AR40 [get_ports {button_n}]
#set_property PACKAGE_PIN AP40 [get_ports {button_s}]
#set_property PACKAGE_PIN AW40 [get_ports {button_w}]
#set_property PACKAGE_PIN AU38 [get_ports {button_e}]
#set_property PACKAGE_PIN AV39 [get_ports {button_c}]

#set_property IOSTANDARD LVCMOS18 [get_ports {button_n}]
#set_property IOSTANDARD LVCMOS18 [get_ports {button_s}]
#set_property IOSTANDARD LVCMOS18 [get_ports {button_w}]
#set_property IOSTANDARD LVCMOS18 [get_ports {button_e}]
#set_property IOSTANDARD LVCMOS18 [get_ports {button_c}]

##-------------------------------------
## DIP SW
##-------------------------------------
#set_property PACKAGE_PIN BB31 [get_ports {dipsw[7]}]
#set_property PACKAGE_PIN BA30 [get_ports {dipsw[6]}]
#set_property PACKAGE_PIN AY30 [get_ports {dipsw[5]}]
#set_property PACKAGE_PIN AW30 [get_ports {dipsw[4]}]
#set_property PACKAGE_PIN BA32 [get_ports {dipsw[3]}]
#set_property PACKAGE_PIN BA31 [get_ports {dipsw[2]}]
#set_property PACKAGE_PIN AY33 [get_ports {dipsw[1]}]
#set_property PACKAGE_PIN AV30 [get_ports {dipsw[0]}]

#set_property IOSTANDARD LVCMOS18 [get_ports {dipsw[7]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {dipsw[6]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {dipsw[5]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {dipsw[4]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {dipsw[3]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {dipsw[2]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {dipsw[1]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {dipsw[0]}]


#########################################################
# PCIe Constraints
#########################################################
##------------------------
## Clock and Reset Pinout
##------------------------

## The constraint 'NODELAY' is not supported in this version of software. Hence not converted.
#set_property LOC AV35 [get_ports perst_n]
#set_property IOSTANDARD LVCMOS18 [get_ports perst_n]
#set_property PULLUP true [get_ports perst_n]

## 100 MHz Reference Clock
#set_property PACKAGE_PIN AB7 [get_ports pcie_clk_n]
#set_property PACKAGE_PIN AB8 [get_ports pcie_clk_p]


# Timing constraints
#create_clock -name sys_clk -period 10 [get_ports pcie_clk_p]


#create_generated_clock -name clk_125mhz_mux \
#                        -source [get_pins ext_clk.pipe_clock_i/pclk_i1_bufgctrl.pclk_i1/I0] \
#                        -divide_by 1 \
#                        [get_pins ext_clk.pipe_clock_i/pclk_i1_bufgctrl.pclk_i1/O]

#create_generated_clock -name clk_250mhz_mux \
#                        -source [get_pins ext_clk.pipe_clock_i/pclk_i1_bufgctrl.pclk_i1/I1] \
#                        -divide_by 1 -add -master_clock [get_clocks -of [get_pins ext_clk.pipe_clock_i/pclk_i1_bufgctrl.pclk_i1/I1]] \
#                        [get_pins ext_clk.pipe_clock_i/pclk_i1_bufgctrl.pclk_i1/O]


#set_clock_groups -name pcieclkmux -physically_exclusive -group clk_125mhz_mux -group clk_250mhz_mux

#set_false_path -to [get_pins {ext_clk.pipe_clock_i/pclk_i1_bufgctrl.pclk_i1/S*}]

#set_false_path -from [get_ports perst_n]

##-------------------------------------
#PMBUS LOC
##-------------------------------------
#set_property PACKAGE_PIN AW37  [get_ports pmbus_clk]
#set_property IOSTANDARD LVCMOS18 [get_ports pmbus_clk]
#set_property PACKAGE_PIN AY39  [get_ports pmbus_data]
#set_property IOSTANDARD LVCMOS18 [get_ports pmbus_data]
#set_property PACKAGE_PIN AV38  [get_ports pmbus_alert]
#set_property IOSTANDARD LVCMOS18 [get_ports pmbus_alert]

# 156.25 MHz clock control LOCs
set_property IOSTANDARD LVCMOS18 [get_ports i2c_clk]
set_property SLEW SLOW [get_ports i2c_clk]
set_property DRIVE 16 [get_ports i2c_clk]
set_property PULLUP TRUE [get_ports i2c_clk]
set_property PACKAGE_PIN AT35 [get_ports i2c_clk]

set_property IOSTANDARD LVCMOS18 [get_ports i2c_data]
set_property SLEW SLOW [get_ports i2c_data]
set_property DRIVE 16 [get_ports i2c_data]
set_property PULLUP TRUE [get_ports i2c_data]
set_property PACKAGE_PIN AU32 [get_ports i2c_data]

set_property IOSTANDARD LVCMOS18 [get_ports i2c_mux_rst_n]
set_property SLEW SLOW [get_ports i2c_mux_rst_n]
set_property DRIVE 16 [get_ports i2c_mux_rst_n]
set_property PACKAGE_PIN AY42 [get_ports i2c_mux_rst_n]

set_property IOSTANDARD LVCMOS18 [get_ports si5324_rst_n]
set_property SLEW SLOW [get_ports si5324_rst_n]
set_property DRIVE 16 [get_ports si5324_rst_n]
set_property PACKAGE_PIN AT36 [get_ports si5324_rst_n]

# Generated clock
create_generated_clock -name clk50 -source [get_ports FPGA_SYSCLK_P] -divide_by 4 [get_pins clk_divide_reg[1]/Q]
set clk156 [get_clocks -of_objects [get_pins network_path_inst_0/ten_gig_eth_pcs_pma_inst/refclk_p]]

#Domain crossing constraints
#set_clock_groups -name async_mcb_xgemac -asynchronous \
#  -group [get_clocks  mcb_clk_ref] \
#  -group [get_clocks  $clk156]


#set_clock_groups -name async_mig_pcie -asynchronous \
#  -group [get_clocks -include_generated_clocks mcb_clk_ref] \
#  -group [get_clocks userclk2]

#set_clock_groups -name async_mig_ref_clk50 -asynchronous \
#   -group [get_clocks mcb_clk_ref] \
#   -group [get_clocks clk50]

#set_clock_groups -name async_clk50_pcie -asynchronous \
#  -group [get_clocks clk50] \
#  -group [get_clocks userclk2]

#set_clock_groups -name async_mig_xgemac -asynchronous \
#  -group [get_clocks -include_generated_clocks mcb_clk_ref] \
#  -group [get_clocks $clk156]

#set_clock_groups -name async_userclk2_clk156 -asynchronous \
#    -group [get_clocks  userclk2] \
#    -group [get_clocks  $clk156]

   
#set_clock_groups -name async_xgemac_clk50 -asynchronous \
#   -group [get_clocks $clk156] \
#   -group [get_clocks clk50]


#set_clock_groups -asynchronous -group clk_125mhz_mux -group clk50 
#set_clock_groups -asynchronous -group clk_250mhz_mux -group clk50



# SI560 (156.25MHz) input
set_property PACKAGE_PIN AK34 [get_ports si570_refclk_p]
set_property IOSTANDARD DIFF_SSTL15 [get_ports si570_refclk_p]
set_property PACKAGE_PIN AL34 [get_ports si570_refclk_n]
set_property IOSTANDARD DIFF_SSTL15 [get_ports si570_refclk_n]

# USER_SMA_GPIO output
set_property PACKAGE_PIN AJ32 [get_ports user_sma_clock_p]
set_property IOSTANDARD DIFF_SSTL15 [get_ports user_sma_clock_p]
set_property PACKAGE_PIN AK32 [get_ports user_sma_clock_n]
set_property IOSTANDARD DIFF_SSTL15 [get_ports user_sma_clock_n]

# SMA_MGT_REFCLK (for internal SFP+ module)
#set_property PACKAGE_PIN AK7 [get_ports sma_mgt_refclk_n]
#set_property PACKAGE_PIN AK8 [get_ports sma_mgt_refclk_p]
## XGEMAC & 10GBASE-R constraints

##---------------------------------------------------------------------------------------
## 10GBASE-R constraints
##---------------------------------------------------------------------------------------
## SFP+ Cage mapping on VC709
# P2 --> X1Y12
# P3 --> X1Y13
# P4 --> X1Y14
# P5 --> X1Y15
## GT placement ## MGT_BANK_113

set_property PACKAGE_PIN AM7 [get_ports ETH1_TX_N]
set_property PACKAGE_PIN AM8 [get_ports ETH1_TX_P]
set_property PACKAGE_PIN AN1 [get_ports ETH1_RX_N]
set_property PACKAGE_PIN AN2 [get_ports ETH1_RX_P]

#set_property PACKAGE_PIN AN5 [get_ports xphy1_rxn]
#set_property PACKAGE_PIN AN6 [get_ports xphy1_rxp]
#set_property PACKAGE_PIN AP3 [get_ports xphy1_txn]
#set_property PACKAGE_PIN AP4 [get_ports xphy1_txp]
#
#set_property PACKAGE_PIN AL5 [get_ports xphy2_rxn]
#set_property PACKAGE_PIN AL6 [get_ports xphy2_rxp]
#set_property PACKAGE_PIN AM3 [get_ports xphy2_txn]
#set_property PACKAGE_PIN AM4 [get_ports xphy2_txp]
#
#set_property PACKAGE_PIN AJ5 [get_ports xphy3_rxn]
#set_property PACKAGE_PIN AJ6 [get_ports xphy3_rxp]
#set_property PACKAGE_PIN AL1 [get_ports xphy3_txn]
#set_property PACKAGE_PIN AL2 [get_ports xphy3_txp]



