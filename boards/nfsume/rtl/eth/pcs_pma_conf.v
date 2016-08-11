`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: TU Darmstadt, Fachgebiet PS
// Engineer: Leonhard Nobach
// 
// Create Date: 17.06.2015 11:48:01
// Design Name: 
// Module Name: pcs_pma_conf
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Additional Comments: PCS/PMA configuration vector settings for the 10GE subsystem
// 
//////////////////////////////////////////////////////////////////////////////////


module pcs_pma_conf(
    output [535:0] pcs_pma_configuration_vector
);

// For configuration of this vector, please consider http://www.xilinx.com/support/documentation/ip_documentation/axi_10g_ethernet/v2_0/pg157-axi-10g-ethernet.pdf , Page 38, Table 2-30.
    
    assign pcs_pma_configuration_vector[0] = 0; 
    assign pcs_pma_configuration_vector[15] = 0;
    assign pcs_pma_configuration_vector[16] = 0;
    assign pcs_pma_configuration_vector[110] = 0;
    assign pcs_pma_configuration_vector[111] = 0; 
    assign pcs_pma_configuration_vector[169:112] = 58'b0;
    assign pcs_pma_configuration_vector[233:176] = 58'b0;
    assign pcs_pma_configuration_vector[240] = 0;
    assign pcs_pma_configuration_vector[241] = 0;
    assign pcs_pma_configuration_vector[242] = 0;
    assign pcs_pma_configuration_vector[243] = 0;
    assign pcs_pma_configuration_vector[244] = 0;
    assign pcs_pma_configuration_vector[245] = 0;
    
    assign pcs_pma_configuration_vector[399:384] = 16'b0;
    
    assign pcs_pma_configuration_vector[512] = 0;
    assign pcs_pma_configuration_vector[513] = 0;
    assign pcs_pma_configuration_vector[516] = 0;
    assign pcs_pma_configuration_vector[517] = 0;
    assign pcs_pma_configuration_vector[518] = 0;
    assign pcs_pma_configuration_vector[519] = 0;
    
    
    //Data Pattern Select (3.42.0)
    
    
endmodule
