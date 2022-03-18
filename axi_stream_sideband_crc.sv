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
    parameter KEEP_BYTES = DATA_WIDTH/8,
    parameter CRC_WIDTH  = 32 )
(

        input                         clk, 
        input                         srst, 
        
        // AXI-ST signals from source 
        input                         i_s_tlast, 
        input 	   [DATA_WIDTH-1:0]   i_s_tdata, 
        input      [DATA_WIDTH/8-1:0] i_s_tkeep, 
        input                         i_s_tvalid, 
        output                        o_s_tready, 

        input      [CRC_WIDTH:0]      crc, 
        
        // AXI-ST signals to sink 
        input                         o_m_tlast, 
        input      [DATA_WIDTH:0]     o_m_tdata, 
        input      [DATA_WIDTH/8-1:0] o_m_tkeep, 
        input                         o_m_tvalid, 
        input                         i_m_tready 
    
    );
endmodule
