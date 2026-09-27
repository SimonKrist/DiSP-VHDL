onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /tb_convolution/reset_i
add wave -noupdate -format Logic /tb_convolution/clk_i
add wave -noupdate -format Logic /tb_convolution/filter_enable_i
add wave -noupdate -format Logic /tb_convolution/strobe_rec_i
add wave -noupdate -format Logic /tb_convolution/strobe_pb_i
add wave -noupdate -format Logic -radix hexadecimal /tb_convolution/rec_i
add wave -noupdate -format Logic -radix hexadecimal /tb_convolution/pb_o
add wave -noupdate -format Logic /tb_convolution/s_bit_clk
add wave -noupdate -format Logic /tb_convolution/i_convolution/s_index
add wave -noupdate -format Logic /tb_convolution/i_convolution/s_accu
add wave -noupdate -format Logic /tb_convolution/i_convolution/s_state
#add wave -noupdate -format Logic /tb_convolution/i_convolution/s_memory
#add wave -noupdate -format Logic /tb_convolution/i_convolution/s_filter

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {0 ps}
WaveRestoreZoom {0 ps} {1 ns}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -signalnamewidth 0
configure wave -justifyvalue left