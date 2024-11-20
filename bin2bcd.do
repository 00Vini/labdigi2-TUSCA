onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /bin2bcd_tb/start
add wave -noupdate /bin2bcd_tb/dv
add wave -noupdate /bin2bcd_tb/clock
add wave -noupdate -radix unsigned /bin2bcd_tb/bin
add wave -noupdate /bin2bcd_tb/bcd
add wave -noupdate /bin2bcd_tb/UUT/o_DV
add wave -noupdate /bin2bcd_tb/UUT/o_BCD
add wave -noupdate /bin2bcd_tb/UUT/i_Start
add wave -noupdate /bin2bcd_tb/UUT/i_Clock
add wave -noupdate /bin2bcd_tb/UUT/i_Binary
add wave -noupdate /bin2bcd_tb/UUT/r_SM_Main
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1370 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 205
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
WaveRestoreZoom {1320 ns} {1420 ns}
