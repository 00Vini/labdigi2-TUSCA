onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /transmite_bcd_ascii_tb/UUT/tx_serial
add wave -noupdate /transmite_bcd_ascii_tb/UUT/pronto
add wave -noupdate /transmite_bcd_ascii_tb/UUT/transmite_bcd
add wave -noupdate /transmite_bcd_ascii_tb/UUT/s_pronto_transmissao_bcd
add wave -noupdate /transmite_bcd_ascii_tb/UUT/s_inicio_transmissao_bcd
add wave -noupdate /transmite_bcd_ascii_tb/UUT/U2_FD/inicio_transmissao_bcd
add wave -noupdate /transmite_bcd_ascii_tb/UUT/U2_FD/transmite/U2_UC/partida
add wave -noupdate /transmite_bcd_ascii_tb/UUT/U2_FD/transmite/U2_UC/Eatual
add wave -noupdate /transmite_bcd_ascii_tb/UUT/U1_UC/Eatual
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {305 ns} 0} {{Cursor 2} {109348 ns} 0}
quietly wave cursor active 2
configure wave -namecolwidth 406
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
WaveRestoreZoom {6383 ns} {132827 ns}
