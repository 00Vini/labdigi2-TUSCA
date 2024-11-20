onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /transmite_medida_tb/transmite
add wave -noupdate /transmite_medida_tb/umidade
add wave -noupdate /transmite_medida_tb/temperatura
add wave -noupdate /transmite_medida_tb/UUT/FD/seletor_dado
add wave -noupdate /transmite_medida_tb/UUT/FD/transmite_bcd/U2_FD/s_valor_ascii
add wave -noupdate /transmite_medida_tb/tx_serial
add wave -noupdate /transmite_medida_tb/pronto
add wave -noupdate -divider depuracao
add wave -noupdate /transmite_medida_tb/UUT/FD/fim_contador
add wave -noupdate /transmite_medida_tb/UUT/FD/conta_contador
add wave -noupdate /transmite_medida_tb/UUT/FD/s_medida
add wave -noupdate /transmite_medida_tb/UUT/UC/Eatual
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {440366 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 411
configure wave -valuecolwidth 38
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
WaveRestoreZoom {0 ns} {453582 ns}
