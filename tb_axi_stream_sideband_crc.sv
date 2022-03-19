`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/18/2022 09:09:37 PM
// Design Name: 
// Module Name: tb_axi_stream_sideband_crc
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


module tb_axi_stream_sideband_crc(

    );
    
    parameter DATA_WIDTH = 512;
    parameter KEEP_BYTES = DATA_WIDTH/8;
    parameter CRC_WIDTH  = 32;

    reg                            clk; 
    reg                            srst; 
    
    // AXI-ST signals from source 
    reg                      i_s_tlast; 
    reg   [DATA_WIDTH-1:0]   i_s_tdata; 
    reg   [DATA_WIDTH/8-1:0] i_s_tkeep; 
    reg                      i_s_tvalid; 
    wire                     o_s_tready; 

    reg   [CRC_WIDTH:0]      crc; 
    
    // AXI-ST signals to sink 
    wire                      o_m_tlast; 
    wire   [DATA_WIDTH:0]     o_m_tdata; 
    wire   [DATA_WIDTH/8-1:0] o_m_tkeep; 
    wire                      o_m_tvalid; 
    reg                       i_m_tready; 
    
    
    axi_stream_sideband_crc DUT(
        .clk(clk),
        .srst(srst),
        .i_s_tlast(i_s_tlast),
        .i_s_tdata(i_s_tdata), 
        .i_s_tkeep(i_s_tkeep), 
        .i_s_tvalid(i_s_tvalid),
        .o_s_tready(o_s_tready),
        .crc(crc),
        .o_m_tlast(o_m_tlast), 
        .o_m_tdata(o_m_tdata), 
        .o_m_tkeep(o_m_tkeep), 
        .o_m_tvalid(o_m_tvalid),
        .i_m_tready(i_m_tready)
    );
    
    initial begin
        clk = 1;
        forever begin
         #5 clk = ~clk;
        end
    end
    
    initial begin
        i_s_tlast  = 0;
        i_s_tdata  = {DATA_WIDTH{1'b1}};
        i_s_tkeep  = 0;
        i_s_tvalid = 0;
        //o_s_tready = 1;
        
        #00;  srst = 0;
        #10;  srst = 1;
        #10;  srst = 0;
        
        #10; i_s_tvalid = 1; i_s_tkeep  = {KEEP_BYTES{1'b1}}; 
        #40; i_s_tvalid = 0; i_s_tkeep  = 0;
    end
    
    initial begin
        # 60; i_s_tlast  = 1; i_s_tkeep  = {(KEEP_BYTES-62){1'b1}};
        # 10; i_s_tlast  = 0;

    end
        
endmodule
