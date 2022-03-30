`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module axi_stream_sideband_crc  #(

    parameter DATA_WIDTH = 512,
    parameter KEEP_BYTES = DATA_WIDTH/8,
    parameter CRC_WIDTH  = 32 )
  (

    input                        clk,
    input                        srst,

    // AXI-ST signals from source
    input   wire                      i_s_tlast,
    input 	wire   [DATA_WIDTH-1:0]   i_s_tdata,
    input   wire   [DATA_WIDTH/8-1:0] i_s_tkeep,
    input   wire                      i_s_tvalid,
    output  reg                       o_s_tready,

    input   wire   [CRC_WIDTH-1:0]      crc,

    // AXI-ST signals to sink
    output   reg                      o_m_tlast,
    output   reg   [DATA_WIDTH-1:0]   o_m_tdata,
    output   reg   [DATA_WIDTH/8-1:0] o_m_tkeep,
    output   reg                      o_m_tvalid,
    input    wire                     i_m_tready

  );


  logic                      o_m_tlast_reg;
  logic   [DATA_WIDTH-1:0]   o_m_tdata_reg;
  logic   [DATA_WIDTH/8-1:0] o_m_tkeep_reg;
  logic                      o_m_tvalid_reg;
  logic                      o_s_tready_reg;

  logic   [DATA_WIDTH-1:0]   crc_long_reg    = '0;
  logic   [KEEP_BYTES-1:0]   keep_long_reg   = '0;
  logic   [CRC_WIDTH-1:0]    crc_reg;
  int     crc_overflow = -1;

  //FSM States   
  enum { IDLE, // wait for tvalid
         READ, // passthrough input words
         EXTD // extend crc to another word with backpressue
       } state,next;


  //rotate states synchronously
  always @(posedge clk)
  begin
    if(srst)  state <= IDLE;
    else      state <= next;
  end


  // state switching and outputs defined in a single comb block  
  always @(*)
  begin

    next = state;

    case(state)

      IDLE: begin
        o_m_tlast_reg  = '0;
        o_m_tdata_reg  = '0;
        o_m_tkeep_reg  = '0;
        o_m_tvalid_reg = '0;
        o_s_tready_reg = '1;

        if(i_s_tvalid && o_s_tready)
        begin
          o_m_tlast_reg  = '0;
          o_m_tdata_reg  = i_s_tdata;
          o_m_tkeep_reg  = i_s_tkeep;
          o_m_tvalid_reg = '1;
          o_s_tready_reg = '1;

          next = READ;
        end
        else
          next = IDLE;
      end

      READ: begin

        if(!(i_s_tlast)) begin
          o_m_tlast_reg  = '0;
          o_m_tvalid_reg = '1;
          o_s_tready_reg = '1;

          o_m_tdata_reg = i_s_tdata;
          o_m_tkeep_reg = i_s_tkeep;

          next = READ;
        end

        else if(i_s_tlast && crc_overflow >= 4 ) begin
          o_m_tlast_reg  = '1;
          o_m_tvalid_reg = '1;
          o_s_tready_reg = '1;

          o_m_tdata_reg = crc_long_reg  | i_s_tdata;
          o_m_tkeep_reg = keep_long_reg | i_s_tkeep;

          next = IDLE;
        end
        else begin
          o_m_tlast_reg  = '0;
          o_m_tvalid_reg = '1;
          o_s_tready_reg = '1;

          o_m_tdata_reg = crc_long_reg  | i_s_tdata;
          o_m_tkeep_reg = '1;

          next = EXTD;
        end
      end

      EXTD: begin

        if(crc_overflow < 4 ) begin
          o_m_tlast_reg  = '1;
          o_m_tvalid_reg = '1;
          o_s_tready_reg = '0;

          o_m_tdata_reg = crc_reg >>  (crc_overflow*8);
          o_m_tkeep_reg = 4'b1111 >>  (crc_overflow);

          next = IDLE;
        end
        else
          next = IDLE;
      end

      default:
        next = IDLE;

    endcase

  end

  // synchronous Output connections to avoid glitsches

  always @(posedge clk )
  begin
    if(srst) begin
      o_m_tlast  <= '0;
      o_m_tvalid <= '0;
      o_m_tdata  <= '0;
      o_m_tkeep  <= '0;
      o_s_tready <= '0;
      crc_reg    <= '0;
    end
    else if(i_m_tready) begin
      o_m_tlast   <= o_m_tlast_reg;
      o_m_tvalid  <= o_m_tvalid_reg;
      o_m_tdata   <= o_m_tdata_reg;
      o_m_tkeep   <= o_m_tkeep_reg;
      o_s_tready  <= o_s_tready_reg;
      crc_reg     <= crc;

    end

  ///////////////////////////////////////////////
  //                                           //
  //  Tracking logic for last word bytes count //
  //                                           //
  ///////////////////////////////////////////////

  int keep_valid_index;

  always@* begin

    keep_valid_index = 0;
    crc_long_reg    = crc;
    keep_long_reg   = {{(KEEP_BYTES-4){1'b0}}, 4'b1111};

    if (i_s_tlast) begin

      for (keep_valid_index=0; keep_valid_index < KEEP_BYTES; keep_valid_index++)
      begin
        if(i_s_tkeep[keep_valid_index]) begin

          crc_long_reg  = crc_long_reg << 8;

          crc_overflow  = (KEEP_BYTES-keep_valid_index-1);

          keep_long_reg =  keep_long_reg << 1;
        end
      end
    end
  end


endmodule
