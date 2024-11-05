onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /receptor_16_tb/rx_serial
add wave -noupdate /receptor_16_tb/reset
add wave -noupdate /receptor_16_tb/pronto
add wave -noupdate /receptor_16_tb/erro
add wave -noupdate /receptor_16_tb/data_out
add wave -noupdate /receptor_16_tb/CLOCK_PERIOD
add wave -noupdate /receptor_16_tb/clock
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {98000 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 254
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
WaveRestoreZoom {0 ns} {308236 ns}
