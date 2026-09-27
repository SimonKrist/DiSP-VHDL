vsim -t ns -novopt -lib work work.tb_convolution_sim_cfg
view *
do convolution_wave.do
run 200 ms
