# axi_stream_work
This repository will reflect axi stream based IP designs

- tested on Vivado 2020.2
- axi stream keep signal used to address null butes in last data word transmission
- axi stream EMPTY bytes disabled by the KEEP bits are assumed to be all ZEOROs
- axi_tkeep assumed to be all ones, without any zero bit in between  
- testbench covers basic level manual axi stream word generation, tested last word corner cases


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
