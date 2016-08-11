set RTL_SRC [lindex $argv 0]
puts "INFO: RTL_SRC"
puts ${RTL_SRC}
set IP_SRC [lindex $argv 1]
puts "INFO: IP_SRC"
puts ${IP_SRC}
set XDC_SRC [lindex $argv 2]
puts "INFO: XDC_SRC"
puts ${XDC_SRC}

set design top
set device xc7vx690t-3-ffg1761
set outdir build

# Project Settings
#create_project -part ${device} -in_memory
create_project -name pemu -force -part ${device}

set_property target_language Verilog [current_project]
set_property default_lib work [current_project]
set_property verilog_define { {USE_DDR3_FIFO=1} {USE_XPHY=1} {USE_PVTMON=1} } [current_fileset]

update_ip_catalog -rebuild

puts "INFO: Import XDC Sources ..."
read_xdc ${XDC_SRC}

puts "INFO: Import IP Sources ..."
foreach file $IP_SRC {
	read_ip $file
#	synth_ip -force [get_files $file]
	synth_ip [get_files $file]
}

puts "INFO: Import RTL Sources ..."
foreach file $RTL_SRC {
	# verilog
	if {[string match *.v $file]} {
		puts "INFO: Import $file (Verilog)"
		read_verilog $file
	} elseif {[string match *.sv $file]} {
		puts "INFO: Import $file (SystemVerilog)"
		read_verilog -sv $file
	} elseif {[string match *.vhd $file] || [string match *.vhdl $file]} {
		puts "INFO: Import $file (VHDL)"
		read_vhdl $file
	} else {
		puts "INFO: Unsupported File $file"    
	}
}

generate_target {synthesis simulation} [get_ips]

