`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/18/2022 06:10:44 PM
// Design Name: 
// Module Name: axi_stream_sideband_crc
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module axi_stream_sideband_crc #(

    parameter DATA_WIDTH = 512,
    parameter KEEP_BYTES = DATA_WIDTH/8 )
(

        Input              clk, 
        Input              srst, 
        
        // AXI-ST signals from source 
        Input              i_tlast, 
        Input 	   [511:0] i_tdata, 
        Input  [512/8-1:0] i_tkeep, 
        Input              i_tvalid, 
        Input              o_tready, 
        Input  [     31:0] crc, 
        
        // AXI-ST signals to sink 
        Input             o_tlast, 
        Input     [511:0] o_tdata, 
        Input [512/8-1:0] o_tkeep, 
        Input             o_tvalid, 
        Input             i_tready 
    
    );
endmodule
