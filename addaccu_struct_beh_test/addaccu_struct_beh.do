# Structural addaccu_struct.vhd

# Structural addaccu
vcom -nolock -reportprogress 300 -work work {accu.vhd}
vcom -nolock -reportprogress 300 -work work {alu.vhd}
vcom -nolock -reportprogress 300 -work work {mux.vhd}
vcom -nolock -reportprogress 300 -work work {addaccu_struct.vhd}

# Behavioral addaccu, used to verify the operation of the structural model
vcom -nolock -reportprogress 300 -work work {addaccu_beh.vhd}

# Testbench
vcom -nolock -reportprogress 300 -work work {addaccu_struct_beh_test.vhd}

# Simulation and waveform plotting
do simulate_struct_beh.do
