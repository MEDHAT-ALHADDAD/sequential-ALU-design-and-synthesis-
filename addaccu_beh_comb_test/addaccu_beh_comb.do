# Behavioral addaccu_beh.vhd - Combinational test

# Behavioral addaccu
vcom -nolock -reportprogress 300 -work work {addaccu_beh.vhd}

# Combinational Testbench
vcom -nolock -reportprogress 300 -work work {addaccu_beh_comb_test.vhd}

# Simulation and waveform plotting
do simulate_beh_comb.do
