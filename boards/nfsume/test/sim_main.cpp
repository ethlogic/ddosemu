#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vtestbench.h"
#include "Vtestbench_testbench.h"
#include "obj_dir/Vtestbench_eth_top__C1f_If.h"
#include "Vtestbench_axi_10g_ethernet_0.h"

#include <stdbool.h>
#include <unistd.h>
//#include "axis.h"


#define SFP_CLK               (64/2)        // 6.4 ns (156.25 MHz)
#define PCIE_REF_CLK          (40/2)        // 4 ns (250 MHz)

#define WAVE_FILE_NAME        "wave.vcd"
#define SIM_TIME_RESOLUTION   "100 ps"
#define SIM_TIME              1000000       // 100 us

#define __packed    __attribute__((__packed__))

#define result_tdata    sim->v->eth1_top->axi_10g_ethernet_0_ins->s_axis_tx_tdata
#define result_tkeep    sim->v->eth1_top->axi_10g_ethernet_0_ins->s_axis_tx_tkeep
#define result_tlast    sim->v->eth1_top->axi_10g_ethernet_0_ins->s_axis_tx_tlast
#define result_tvalid   sim->v->eth1_top->axi_10g_ethernet_0_ins->s_axis_tx_tvalid

//static int debug = 1;

static uint64_t t = 0;


/*
 * tick: a tick
 */
static inline void tick(Vtestbench *sim, VerilatedVcdC *tfp)
{
	++t;
	sim->eval();
	tfp->dump(t);
}

/*
 * time_wait
 */
static inline void time_wait(Vtestbench *sim, VerilatedVcdC *tfp, uint32_t n)
{
	t += n;
	sim->eval();
	tfp->dump(t);
}

void pr_tdata(Vtestbench *sim)
{
	uint8_t *p;
	int i;

	if (result_tvalid) {
		printf("t=%u:", (uint32_t)t);
		p = (uint8_t *)&result_tdata;
		for (i = 0; i < 8; i++) {
			printf(" %02X", *(p++));
		}
		printf("\n");
	}
}

void pr_tlast(Vtestbench *sim)
{
	if (result_tlast) {
		printf("\n");
	}
}

/*
 * main
 */
int main(int argc, char **argv)
{
	int ret;

	Verilated::commandArgs(argc, argv);
	Verilated::traceEverOn(true);

	VerilatedVcdC *tfp = new VerilatedVcdC;
	tfp->spTrace()->set_time_resolution(SIM_TIME_RESOLUTION);
	Vtestbench *sim = new Vtestbench;
	sim->trace(tfp, 99);
	tfp->open(WAVE_FILE_NAME);

	sim->cold_reset = 1;
	sim->SFP_CLK_P = 0;
	sim->user_clk = 0;

	// debug
	while (!Verilated::gotFinish()) {
		if ((t % SFP_CLK) == 0) {
			sim->SFP_CLK_P = !sim->SFP_CLK_P;
			if (sim->SFP_CLK_P) {
				pr_tdata(sim);
				pr_tlast(sim);
			}
		}

		if ((t % PCIE_REF_CLK) == 0)
			sim->user_clk = !sim->user_clk;
		
		if (t > SFP_CLK * 0x1f * 2)
			sim->cold_reset = 0;

		if (t > SIM_TIME)
			break;

		tick(sim, tfp);
	}

	tfp->close();
	sim->final();

	return 0;
}

