vsim work.testbench_beh_comb

add wave -position insertpoint  \
sim:/testbench_beh_comb/sel \
sim:/testbench_beh_comb/clock \
sim:/testbench_beh_comb/a \
sim:/testbench_beh_comb/b \
sim:/testbench_beh_comb/sum \
sim:/testbench_beh_comb/carry \
sim:/testbench_beh_comb/dut/s_temp \
sim:/testbench_beh_comb/dut/reg_out \
sim:/testbench_beh_comb/dut/mux_out 

run -all
