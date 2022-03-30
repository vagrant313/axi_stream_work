`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_axi_stream_sideband_crc (

    );
    
    parameter DATA_WIDTH = 512;
    parameter KEEP_BYTES = DATA_WIDTH/8;
    parameter CRC_WIDTH  = 32;

    reg                            clk; 
    reg                            srst; 
    
    // AXI-ST signals from source 
    reg                      i_s_tlast; 
    reg                      i_s_tlast1; 
    reg   [DATA_WIDTH-1:0]   i_s_tdata; 
    reg   [DATA_WIDTH/8-1:0] i_s_tkeep; 
    reg                      i_s_tvalid; 
    wire                     o_s_tready; 

    reg   [CRC_WIDTH-1:0]      crc; 
    
    // AXI-ST signals to sink 
    wire                      o_m_tlast; 
    wire   [DATA_WIDTH-1:0]   o_m_tdata; 
    wire   [DATA_WIDTH/8-1:0] o_m_tkeep; 
    wire                      o_m_tvalid; 
    reg                       i_m_tready; 
    
    
    axi_stream_sideband_crc  DUT(
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
    
    parameter PERIOD = 20;
    
    initial begin
        #(PERIOD/2)  clk = 1;
        forever begin
         #(PERIOD/2) clk = ~clk;
        end
    end
    
    
    
    initial begin
        i_s_tlast  = 0;
        i_s_tdata  = {{(DATA_WIDTH-64){1'b1}}, 64'hDEAD_BEEF_DEAD_BEEF};
        i_s_tkeep  = 0;
        i_s_tvalid = 0;
        i_m_tready = 1;
        
                
        // reset 
        #00;  srst = 0;
        #(PERIOD*2);  
        srst = 1;
        #(PERIOD*4);
        srst = 0;
        

        //////////////////////////////////////////////////////////
        //
        //create 4 words packet to test first CASE
        //
        //////////////////////////////////////////////////////////
        #00; crc        = 32'hCECDCBCA;
        
        #(PERIOD*4) 
        i_s_tvalid = 1; 
        i_s_tkeep  = {(KEEP_BYTES){1'b1}};
        i_s_tdata  = {64'hDEAD_BEEF_DEAD_BEEF,{(DATA_WIDTH-64){1'b1}}};

        #(PERIOD*1)
        i_s_tvalid = 1;
        i_s_tkeep  = {(KEEP_BYTES){1'b1}};
        i_s_tdata  = {64'hDEAD_BEEF_DEAD_BEEF,{(DATA_WIDTH-64){1'b0}}};

        #(PERIOD*1) 
        i_s_tvalid = 1;
        i_s_tkeep  = {(KEEP_BYTES){1'b1}};
        i_s_tdata  = {64'hDEAD_BEEF_DEAD_BEEF,{(DATA_WIDTH-64){1'b1}}};

        #(PERIOD*1) 
        i_s_tvalid = 1;
        i_s_tkeep  = {8'b0000_0011, {(KEEP_BYTES-8){1'b1}} };
        i_s_tdata  = {64'h0000_0000_0000_BEEF,{(DATA_WIDTH-64){1'b1}}};
        i_s_tlast  = 1; 

        #(PERIOD*1); i_s_tvalid = 0; i_s_tkeep  = 0; i_s_tlast  = 0; i_s_tkeep  = {(KEEP_BYTES){1'b0}};


        ////////////////////////////////////////////////////////
        //
        //4 words packet, test 2nd CASE with last 4 bytes empty
        //
        ////////////////////////////////////////////////////////
        #00; crc        = 32'hABCDEF45;
 
       #(PERIOD*4) 
         i_s_tvalid = 1; 
         i_s_tkeep  = {(KEEP_BYTES){1'b1}};
         i_s_tdata  = {64'hDEAD_BEEF_DEAD_BEEF,{(DATA_WIDTH-64){1'b1}}};
 
         #(PERIOD*1)
         i_s_tvalid = 1;
         i_s_tkeep  = {(KEEP_BYTES){1'b1}};
         i_s_tdata  = {64'hDEAD_BEEF_DEAD_BEEF,{(DATA_WIDTH-64){1'b0}}};
 
         #(PERIOD*1) 
         i_s_tvalid = 1;
         i_s_tkeep  = {(KEEP_BYTES){1'b1}};
         i_s_tdata  = {64'hDEAD_BEEF_DEAD_BEEF,{(DATA_WIDTH-64){1'b1}}};
 
         #(PERIOD*1) 
         i_s_tvalid = 1;
         i_s_tkeep  = {8'b0000_1111, {(KEEP_BYTES-8){1'b1}} };
         i_s_tdata  = {64'h0000_0000_0000_BEEF,{(DATA_WIDTH-64){1'b1}}};
         i_s_tlast  = 1; 
 
         #(PERIOD*1); i_s_tvalid = 0; i_s_tkeep  = 0; i_s_tlast  = 0; i_s_tkeep  = {(KEEP_BYTES){1'b0}};


        //////////////////////////////////////////////////////////
        //
        //4 words packet, test 2nd CASE with only last byte empty
        //
        //////////////////////////////////////////////////////////
        #00; crc        = 32'h12CDEF23;

       #(PERIOD*4) 
        i_s_tvalid = 1; 
        i_s_tkeep  = {(KEEP_BYTES){1'b1}};
        i_s_tdata  = {64'hDEAD_BEEF_DEAD_BEEF,{(DATA_WIDTH-64){1'b1}}};

        #(PERIOD*1)
        i_s_tvalid = 1;
        i_s_tkeep  = {(KEEP_BYTES){1'b1}};
        i_s_tdata  = {64'hDEAD_BEEF_DEAD_BEEF,{(DATA_WIDTH-64){1'b0}}};

        #(PERIOD*1) 
        i_s_tvalid = 1;
        i_s_tkeep  = {(KEEP_BYTES){1'b1}};
        i_s_tdata  = {64'hDEAD_BEEF_DEAD_BEEF,{(DATA_WIDTH-64){1'b1}}};

        #(PERIOD*1) 
        i_s_tvalid = 1;
        i_s_tkeep  = {8'b0111_1111, {(KEEP_BYTES-8){1'b1}} };
        i_s_tdata  = {64'h0000_0000_0000_BEEF,{(DATA_WIDTH-64){1'b1}}};
        i_s_tlast  = 1; 

        #(PERIOD*1); i_s_tvalid = 0; i_s_tkeep  = 0; i_s_tlast  = 0; i_s_tkeep  = {(KEEP_BYTES){1'b0}};

        ////////////////////////////////////////////////////////////
        //
        //4 words packet, test 2nd CASE with all last bytes filled
        //
        ////////////////////////////////////////////////////////////
        #00; crc        = 32'h34CDEF11;

       #(PERIOD*4) 
         i_s_tvalid = 1; 
         i_s_tkeep  = {(KEEP_BYTES){1'b1}};
         i_s_tdata  = {64'hDEAD_BEEF_DEAD_BEEF,{(DATA_WIDTH-64){1'b1}}};
 
         #(PERIOD*1)
         i_s_tvalid = 1;
         i_s_tkeep  = {(KEEP_BYTES){1'b1}};
         i_s_tdata  = {64'hDEAD_BEEF_DEAD_BEEF,{(DATA_WIDTH-64){1'b0}}};
 
         #(PERIOD*1) 
         i_s_tvalid = 1;
         i_s_tkeep  = {(KEEP_BYTES){1'b1}};
         i_s_tdata  = {64'hDEAD_BEEF_DEAD_BEEF,{(DATA_WIDTH-64){1'b1}}};
 
         #(PERIOD*1) 
         i_s_tvalid = 1;
         i_s_tkeep  = {8'b1111_1111, {(KEEP_BYTES-8){1'b1}} };
         i_s_tdata  = {64'h0000_0000_0000_BEEF,{(DATA_WIDTH-64){1'b1}}};
         i_s_tlast  = 1; 
 
         #(PERIOD*1); i_s_tvalid = 0; i_s_tkeep  = 0; i_s_tlast  = 0; i_s_tkeep  = {(KEEP_BYTES){1'b0}};
        

    end
    
        
endmodule
