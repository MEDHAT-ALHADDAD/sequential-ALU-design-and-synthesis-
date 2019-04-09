vsim work.testbench_beh

add wave -position insertpoint  \
sim:/testbench_beh/sel \
sim:/testbench_beh/a \
sim:/testbench_beh/clock \
sim:/testbench_beh/b_test \
sim:/testbench_beh/b \
sim:/testbench_beh/dut/reg_out \
sim:/testbench_beh/sum \
sim:/testbench_beh/carry \
sim:/testbench_beh/dut/s_temp \
sim:/testbench_beh/dut/mux_out 

run 1650ns
