onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /config_manager_tb/clock
add wave -noupdate /config_manager_tb/umidade_lim_out
add wave -noupdate /config_manager_tb/temp_lim4_out
add wave -noupdate /config_manager_tb/temp_lim3_out
add wave -noupdate /config_manager_tb/temp_lim2_out
add wave -noupdate /config_manager_tb/temp_lim1_out
add wave -noupdate /config_manager_tb/rx_serial
add wave -noupdate /config_manager_tb/reset
add wave -noupdate /config_manager_tb/receber_config
add wave -noupdate /config_manager_tb/pronto_config
add wave -noupdate /config_manager_tb/erro_config
add wave -noupdate -divider Loads
add wave -noupdate /config_manager_tb/UUT/config_manager_fd/load_temp4
add wave -noupdate /config_manager_tb/UUT/config_manager_fd/load_temp3
add wave -noupdate /config_manager_tb/UUT/config_manager_fd/load_temp2
add wave -noupdate /config_manager_tb/UUT/config_manager_fd/load_temp1
add wave -noupdate /config_manager_tb/UUT/config_manager_fd/load_lim_um
add wave -noupdate /config_manager_tb/UUT/config_manager_uc/Eatual
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {358812 ns} 0} {{Cursor 2} {418331 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 383
configure wave -valuecolwidth 108
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
WaveRestoreZoom {0 ns} {1387635 ns}
