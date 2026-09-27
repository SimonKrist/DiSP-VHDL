onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /tb_disp_top/s_reset
add wave -noupdate -format Logic /tb_disp_top/s_bit_clk
add wave -noupdate -format Logic /tb_disp_top/s_conv_clk
add wave -noupdate -format Logic /tb_disp_top/s_filter_enable_l
add wave -noupdate -format Logic /tb_disp_top/s_filter_enable_r
add wave -noupdate -format Logic /tb_disp_top/s_lr_clk_rec
add wave -noupdate -format Logic /tb_disp_top/s_lr_clk_pb
add wave -noupdate -format Logic /tb_disp_top/s_data_rec
add wave -noupdate -format Logic /tb_disp_top/s_data_pb
add wave -noupdate -format Logic -radix decimal /tb_disp_top/i_disp_top/s_l_rec
add wave -noupdate -format Logic -radix decimal /tb_disp_top/i_disp_top/s_r_rec
add wave -noupdate -format Logic -radix decimal /tb_disp_top/i_disp_top/s_l_pb
add wave -noupdate -format Logic -radix decimal /tb_disp_top/i_disp_top/s_r_pb
add wave -noupdate -format Logic /tb_disp_top/i_disp_top/s_strobe_rec_l
add wave -noupdate -format Logic /tb_disp_top/i_disp_top/s_strobe_rec_r
add wave -noupdate -format Logic /tb_disp_top/i_disp_top/s_strobe_pb_l
add wave -noupdate -format Logic /tb_disp_top/i_disp_top/s_strobe_pb_r
add wave -noupdate -format Logic /tb_disp_top/i_disp_top/i_convolution_l/s_state
add wave -noupdate -format Logic -radix decimal /tb_disp_top/i_disp_top/i_convolution_l/s_index

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {0 ps}
WaveRestoreZoom {0 ps} {1 ns}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -signalnamewidth 0
configure wave -justifyvalue left