onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /tb_i2s/reset_i
add wave -noupdate -format Logic /tb_i2s/bit_clk_i
add wave -noupdate -format Logic /tb_i2s/lr_clk_rec_i
add wave -noupdate -format Logic /tb_i2s/lr_clk_pb_i
add wave -noupdate -format Logic /tb_i2s/data_rec_i
add wave -noupdate -format Logic /tb_i2s/data_pb_o
add wave -noupdate -format Logic -radix hexadecimal /tb_i2s/l_rec_o
add wave -noupdate -format Logic -radix hexadecimal /tb_i2s/r_rec_o
add wave -noupdate -format Logic -radix hexadecimal /tb_i2s/l_pb_i
add wave -noupdate -format Logic -radix hexadecimal /tb_i2s/r_pb_i
add wave -noupdate -format Logic /tb_i2s/strobe_rec_l_o
add wave -noupdate -format Logic /tb_i2s/strobe_rec_r_o
add wave -noupdate -format Logic /tb_i2s/strobe_pb_l_o
add wave -noupdate -format Logic /tb_i2s/strobe_pb_r_o
add wave -noupdate -format Logic /tb_i2s/i_i2s/s_current_lr_rec
add wave -noupdate -format Logic /tb_i2s/i_i2s/s_counter_rec
add wave -noupdate -format Logic /tb_i2s/i_i2s/s_shift_reg_rec
add wave -noupdate -format Logic /tb_i2s/i_i2s/s_current_lr_pb
add wave -noupdate -format Logic /tb_i2s/i_i2s/s_counter_pb
add wave -noupdate -format Logic /tb_i2s/i_i2s/s_shift_reg_pb

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {0 ps}
WaveRestoreZoom {0 ps} {1 ns}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -signalnamewidth 0
configure wave -justifyvalue left