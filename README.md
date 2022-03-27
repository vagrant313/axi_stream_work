# axi_stream_work
This repository will reflect axi stream based IP designs

- tested on Vivado 2020.2
- axi stream keep signal used to address null butes in last data word transmission
- axi stream EMPTY bytes disabled by the KEEP bits are assumed to be all ZEOROs
- axi_tkeep assumed to be all ones, without any zero bit in between  
- testbench covers basic level manual axi stream word generation, tested last word corner cases
