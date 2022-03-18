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

        input                            clk, 
        input                            srst, 
        
        // AXI-ST signals from source 
        input   wire                      i_s_tlast, 
        input 	wire   [DATA_WIDTH-1:0]   i_s_tdata, 
        input   wire   [DATA_WIDTH/8-1:0] i_s_tkeep, 
        input   wire                      i_s_tvalid, 
        output  reg                       o_s_tready, 

        input   wire   [CRC_WIDTH:0]      crc, 
        
        // AXI-ST signals to sink 
        output   reg                      o_m_tlast, 
        output   reg   [DATA_WIDTH:0]     o_m_tdata, 
        output   reg   [DATA_WIDTH/8-1:0] o_m_tkeep, 
        output   reg                      o_m_tvalid, 
        input   wire                     i_m_tready 
    
    );

    reg [15:0]bytes_in_word;

    integer i, byte_count;


    always@(*) begin
        
        if (i_s_tvalid) begin
        
            byte_count = 0;

            for (i=0; i <= KEEP_BYTES; i++) begin
                if(i_s_tkeep[i])
                    byte_count = byte_count + 1;
                else
                    byte_count = byte_count; 
            end
         end   
         else begin
            bytes_in_word = byte_count; 
         end
            
    end

endmodule
