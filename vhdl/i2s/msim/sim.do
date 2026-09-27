vsim -t ns -novopt -lib work work.tb_i2s_sim_cfg
view *
do i2s_wave.do
run 20 ms
