onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /interface_dht11_tb/clock
add wave -noupdate /interface_dht11_tb/umidade_out
add wave -noupdate /interface_dht11_tb/temeperatura_out
add wave -noupdate /interface_dht11_tb/rx_serial
add wave -noupdate /interface_dht11_tb/reset
add wave -noupdate /interface_dht11_tb/pronto_medida
add wave -noupdate /interface_dht11_tb/medir_out
add wave -noupdate /interface_dht11_tb/medir_dht11
add wave -noupdate /interface_dht11_tb/CLOCK_PERIOD
add wave -noupdate /interface_dht11_tb/UUT/interface_dht11_uc/Eatual
add wave -noupdate /interface_dht11_tb/UUT/interface_dht11_fd/rx_serial
add wave -noupdate /interface_dht11_tb/UUT/interface_dht11_fd/recep_medida/UC/current_state
add wave -noupdate /interface_dht11_tb/UUT/interface_dht11_fd/recep_medida/DP/conta_dados/Q
add wave -noupdate /interface_dht11_tb/UUT/interface_dht11_fd/recep_medida/DP/receive_finished
add wave -noupdate /interface_dht11_tb/UUT/interface_dht11_fd/fim_recepcao_medida
add wave -noupdate -radix binary /interface_dht11_tb/UUT/interface_dht11_fd/recep_medida/data
add wave -noupdate /interface_dht11_tb/UUT/interface_dht11_fd/recep_medida/parity_check
add wave -noupdate /interface_dht11_tb/UUT/interface_dht11_fd/recep_medida/DP/parity
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {25070 ns} 0} {{Cursor 3} {70 ns} 0}
quietly wave cursor active 2
configure wave -namecolwidth 497
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {210659 ns}
