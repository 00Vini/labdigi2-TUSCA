onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /dht11_tb/start
add wave -noupdate /dht11_tb/reset
add wave -noupdate /dht11_tb/error
add wave -noupdate /dht11_tb/dir
add wave -noupdate /dht11_tb/dht_bus_value
add wave -noupdate -radix unsigned /dht11_tb/envia_palavra/i
add wave -noupdate /dht11_tb/dht_bus
add wave -noupdate /dht11_tb/envia_bit/bit
add wave -noupdate -radix binary /dht11_tb/UUT/dht_data
add wave -noupdate /dht11_tb/pronto
add wave -noupdate -radix unsigned /dht11_tb/UUT/state
add wave -noupdate -radix unsigned /dht11_tb/UUT/bit_counter
add wave -noupdate -radix unsigned /dht11_tb/UUT/time_counter
add wave -noupdate -radix hexadecimal /dht11_tb/UUT/dht_data
add wave -noupdate -radix binary /dht11_tb/temperatura
add wave -noupdate -radix binary /dht11_tb/umidade
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 17} {38210 ns} 0} {{Cursor 19} {2182730 ns} 0}
quietly wave cursor active 2
configure wave -namecolwidth 178
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
WaveRestoreZoom {2007443 ns} {4380893 ns}
