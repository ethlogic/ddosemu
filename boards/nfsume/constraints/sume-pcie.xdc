set_property LOC AY35 [get_ports sys_rst_n]
set_property IOSTANDARD LVCMOS18 [get_ports sys_rst_n]
set_property PULLUP true [get_ports sys_rst_n]

#set_property LOC IBUFDS_GTE2_X1Y11 [get_cells refclk_ibuf]
#create_clock -name sys_clk -period 10 [get_ports sys_clk_p]

set_property LOC IBUFDS_GTE2_X1Y11 [get_cells pcie_top0/refclk_ibuf]
create_clock -period 10.000 -name sys_clk -add [get_pins -hier -filter name=~*refclk_ibuf/O]
create_clock -period 10.000 -name sys_clk_p -waveform {0.000 5.000} [get_ports sys_clk_p]

create_generated_clock -name clk_125mhz_x0y1 [get_pins pcie_top0/pcie3_7x_0_support_i/pipe_clock_i/mmcm_i/CLKOUT0]
create_generated_clock -name clk_250mhz_x0y1 [get_pins pcie_top0/pcie3_7x_0_support_i/pipe_clock_i/mmcm_i/CLKOUT1]
create_generated_clock -name clk_125mhz_mux_x0y1 \
                        -source [get_pins pcie_top0/pcie3_7x_0_support_i/pipe_clock_i/pclk_i1_bufgctrl.pclk_i1/I0] \
                        -divide_by 1 \
                        [get_pins pcie_top0/pcie3_7x_0_support_i/pipe_clock_i/pclk_i1_bufgctrl.pclk_i1/O]
create_generated_clock -name clk_250mhz_mux_x0y1 \
                        -source [get_pins pcie_top0/pcie3_7x_0_support_i/pipe_clock_i/pclk_i1_bufgctrl.pclk_i1/I1] \
                        -divide_by 1 -add -master_clock [get_clocks -of [get_pins pcie_top0/pcie3_7x_0_support_i/pipe_clock_i/pclk_i1_bufgctrl.pclk_i1/I1]] \
                        [get_pins pcie_top0/pcie3_7x_0_support_i/pipe_clock_i/pclk_i1_bufgctrl.pclk_i1/O]
set_clock_groups -name pcieclkmux_x0y1 -physically_exclusive -group clk_125mhz_mux_x0y1 -group clk_250mhz_mux_x0y1
set_false_path -to [get_pins {pcie_top0/pcie3_7x_0_support_i/pipe_clock_i/pclk_i1_bufgctrl.pclk_i1/S0}]
set_false_path -to [get_pins {pcie_top0/pcie3_7x_0_support_i/pipe_clock_i/pclk_i1_bufgctrl.pclk_i1/S1}]

set_false_path -from [get_ports sys_rst_n]

