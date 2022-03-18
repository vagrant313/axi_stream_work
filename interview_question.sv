
// Q. Please write RTL for this module. In this module RTL will 
// append 32bit crc sideband signal to 512 bit AXI-ST data path and forward to the output.
// You need to stitch crc to the incoming AXI streaming bus such that CRC is appended exactly 
// at the same byte where incoming data is ending. There is a possibility that appending of CRC may take 
// one more cycle at the output for which this module may assert back-pressure to the input stream. I have 
// tried to explain these two cases in detail below. There can be many possibilites to it and the RTL should handle all 
// the possibilities. 

module crc_append (

// clock and reset
Input 			       clock, 
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


//    Case - 1:

//    INPUT (68B packet IN)                 			        OUTPUT(68B packet + 4B CRC OUT))
//    =====                                                   ======

// 511                                   0                    511                                           0
// B63,....................,B4,B3,B2,B1,B0                    B63,............................,B4,B3,B2,B1,B0
// EMPTY,...........,EMPTY,B67,B66,B65,B64                    EMPTY,EMPTY,CRC3,CRC2,CRC1,CRC0,B67,B66,B65,B64

// clock     ___|````|_____|````|_____|`````|____|````|_____|````|____
// i_tlast   __________________________/``````````\___________________
// i_tdata   ---------------<START    >< STOP     >-------------------
// i_tkeep   ---------------<All Ones ><'b1111    >-------------------
// i_tvalid  _______________/`````````````````````\____________________
// o_tready  ____/```````````````````````````````````````````\_________
// crc       -<CRC3,CRC2,CRC1,CRC0                            >--------






//    Case - 2:

//    INPUT  (126B packet IN)                 			                OUTPUT(126B packet + 4B CRC OUT)
//    =====                                                             ======


// 511                                             0                    511                                                   0
// B63,.....................,,,,,....,B4,B3,B2,B1,B0                    B63,....................................,B4,B3,B2,B1,B0
// EMPTY,EMPTY,B125,............,B68,B67,B66,B65,B64                    CRC1,CRC0,B125,....................,B68,B67,B66,B65,B64
//                                                                                                        EMPTY,EMPTY,CRC3,CRC2


// clock     ___|````|_____|````|_____|`````|____|````|_____|````|_____|````|____
// i_tlast   __________________________/``````````\___________________
// i_tdata   ---------------<START    >< STOP      >-------------------
// i_tvalid  _______________/```````````````````````\___________________
// o_tready  ____/`````````````````````````````````````````````````````\________
// crc       -<CRC3,CRC2,CRC1,CRC0                            			  >-------           



endmodule                                                                                            