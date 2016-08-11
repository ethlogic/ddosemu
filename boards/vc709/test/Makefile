sim_top = testbench

VERILATOR_SRC := sim_main.cpp

SIM_SRC := testbench.sv
RTL_SRC := $(wildcard ../../../cores/pkg/*.sv)  \
           graycounter.v                        \
           asfifo.v                             \
           pcie2eth_fifo0.sv                    \
           pcie2eth_fifo1.sv                    \
           arb2encap_fifo.sv                    \
           axi_10g_ethernet_0.sv                \
           sfp_refclk_init.sv                   \
           host/host_pio_wr.sv                  \
           ../rtl/eth/pcs_pma_conf.v            \
           ../rtl/eth/eth_mac_conf.v            \
           ../rtl/eth/eth_tlptap.sv             \
           ../rtl/eth/eth_txarb.sv              \
           ../rtl/eth/eth_encap.sv              \
           ../rtl/eth/eth_top.sv

WFLAGS = -Wall -Wno-PINCONNECTEMPTY -Wno-UNUSED -Wno-UNDRIVEN --report-unoptflat
#WFLAGS = -Wall 

all: sim

lint: $(SIM_SRC) $(RTL_SRC)
	verilator $(WFLAGS) -Wall --lint-only --cc --top-module $(sim_top) -sv $(SIM_SRC) $(RTL_SRC)

sim: $(VERILATOR_SRC) $(SIM_SRC) $(RTL_SRC)
	verilator $(WFLAGS) -DSIMULATION --cc --trace --top-module $(sim_top) -sv $(SIM_SRC) $(RTL_SRC) --exe $(VERILATOR_SRC)
	make -j -C obj_dir/ -f V$(sim_top).mk V$(sim_top)

run: sim obj_dir/V$(sim_top)
	obj_dir/V$(sim_top)

.PHONY: clean
clean:
	rm -f wave.vcd
	rm -rf obj_dir

