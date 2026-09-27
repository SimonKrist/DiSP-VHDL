vsim -t ns -novopt -lib work work.tb_disp_top_sim_cfg
view *
do disp_top_wave.do
run 200 ms
