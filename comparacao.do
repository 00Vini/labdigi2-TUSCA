onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /controle_ventoinha_tb/reset
add wave -noupdate /controle_ventoinha_tb/rele
add wave -noupdate /controle_ventoinha_tb/pwm_ventoinha
add wave -noupdate /controle_ventoinha_tb/nivel
add wave -noupdate /controle_ventoinha_tb/clk
add wave -noupdate -radix decimal /controle_ventoinha_tb/UUT/pwm/largura_11
add wave -noupdate -radix decimal /controle_ventoinha_tb/UUT/pwm/largura_10
add wave -noupdate -radix decimal /controle_ventoinha_tb/UUT/pwm/largura_01
add wave -noupdate -radix decimal /controle_ventoinha_tb/UUT/pwm/largura_00
add wave -noupdate -radix decimal /controle_ventoinha_tb/UUT/pwm/conf_periodo
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {50045 ns} 0} {{Cursor 2} {75045 ns} 0}
quietly wave cursor active 2
configure wave -namecolwidth 361
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
WaveRestoreZoom {0 ns} {327355 ns}
