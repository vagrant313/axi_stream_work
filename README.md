# axi_stream_work
This repository will reflect axi stream based IP designs

- tested on Vivado 2020.2
- axi stream keep signal used to address null butes in last data word transmission
- axi stream EMPTY bytes disabled by the KEEP bits are assumed to be all ZEROs
- required enabled bytes by the axi_tkeep signal assumed to be all high successively, without any zero bit in between  
- testbench covers basic level manual axi stream word generation, tested last word corner cases

