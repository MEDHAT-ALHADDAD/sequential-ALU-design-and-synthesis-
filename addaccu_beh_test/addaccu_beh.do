# Behavioral addaccu_beh.vhd

# Behavioral addaccu
vcom -nolock -reportprogress 300 -work work {addaccu_beh.vhd}

# Testbench
vcom -nolock -reportprogress 300 -work work {addaccu_beh_test.vhd}

# Simulation and waveform plotting
do simulate_beh.do
