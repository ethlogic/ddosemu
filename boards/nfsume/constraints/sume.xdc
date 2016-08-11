set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property CFGBVS GND [current_design]
set_property CONFIG_VOLTAGE 1.8 [current_design]

# FPGA_SYSCLK (200MHz)
set_property -dict { PACKAGE_PIN G18   IOSTANDARD LVDS     } [get_ports { FPGA_SYSCLK_N }];
set_property -dict { PACKAGE_PIN H19   IOSTANDARD LVDS     } [get_ports { FPGA_SYSCLK_P }];
create_clock -add -name sys_clk_pin -period 5.00 -waveform {0 2.5} [get_ports {FPGA_SYSCLK_P}]; 

# I2C
set_property SLEW SLOW [get_ports I2C_FPGA_SCL]
set_property DRIVE 16 [get_ports I2C_FPGA_SCL]
set_property PACKAGE_PIN AK24 [get_ports I2C_FPGA_SCL]
set_property PULLUP true [get_ports I2C_FPGA_SCL]
set_property IOSTANDARD LVCMOS18 [get_ports I2C_FPGA_SCL]

set_property SLEW SLOW [get_ports I2C_FPGA_SDA]
set_property DRIVE 16 [get_ports I2C_FPGA_SDA]
set_property PACKAGE_PIN AK25 [get_ports I2C_FPGA_SDA]
set_property PULLUP true [get_ports I2C_FPGA_SDA]
set_property IOSTANDARD LVCMOS18 [get_ports I2C_FPGA_SDA]

