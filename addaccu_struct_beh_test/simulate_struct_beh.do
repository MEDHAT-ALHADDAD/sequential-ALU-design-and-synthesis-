vsim work.testbench_struct_beh

add wave -position insertpoint  \
sim:/testbench_struct_beh/sel \
sim:/testbench_struct_beh/clock \
sim:/testbench_struct_beh/a \
sim:/testbench_struct_beh/b \
sim:/testbench_struct_beh/dut_struct/reg_out \
sim:/testbench_struct_beh/s_beh \
sim:/testbench_struct_beh/s_struct \
sim:/testbench_struct_beh/c_beh \
sim:/testbench_struct_beh/c_struct \
sim:/testbench_struct_beh/dut_struct/mux_out 

run 640ns
