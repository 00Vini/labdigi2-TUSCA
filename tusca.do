onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tusca_tb/start
add wave -noupdate /tusca_tb/rx_serial_medida
add wave -noupdate /tusca_tb/rx_serial_config
add wave -noupdate /tusca_tb/reset
add wave -noupdate /tusca_tb/rele
add wave -noupdate /tusca_tb/pwm_ventoinha
add wave -noupdate /tusca_tb/pwm_servo
add wave -noupdate /tusca_tb/medir_dht11_out
add wave -noupdate /tusca_tb/gira
add wave -noupdate /tusca_tb/erro_config
add wave -noupdate /tusca_tb/definir_config
add wave -noupdate /tusca_tb/CLOCK_PERIOD
add wave -noupdate /tusca_tb/clock
add wave -noupdate /tusca_tb/UUT/uc/Eatual
add wave -noupdate /tusca_tb/UUT/fd/interface_dht11/interface_dht11_uc/Eatual
add wave -noupdate /tusca_tb/UUT/fd/cnf/config_manager_uc/Eatual
add wave -noupdate /tusca_tb/UUT/fd/s_umidade
add wave -noupdate /tusca_tb/UUT/fd/s_temp
add wave -noupdate /tusca_tb/UUT/fd/s_nivel_temperatura
add wave -noupdate /tusca_tb/UUT/fd/db_nivel_temperatura
add wave -noupdate /tusca_tb/UUT/fd/cnf/umidade_lim_out
add wave -noupdate /tusca_tb/UUT/fd/cnf/temp_lim4_out
add wave -noupdate /tusca_tb/UUT/fd/cnf/temp_lim3_out
add wave -noupdate /tusca_tb/UUT/fd/cnf/temp_lim1_out
add wave -noupdate /tusca_tb/UUT/fd/cnf/temp_lim2_out
add wave -noupdate /tusca_tb/UUT/fd/interface_dht11/pronto_medida
add wave -noupdate /tusca_tb/UUT/fd/interface_dht11/interface_dht11_uc/Eatual
add wave -noupdate /tusca_tb/UUT/fd/interface_dht11/interface_dht11_fd/receptor_medida/receptor_16_fd/recep_serial/UC/current_state
add wave -noupdate /tusca_tb/UUT/fd/cnf/config_manager_fd/load_temp4
add wave -noupdate /tusca_tb/UUT/fd/cnf/config_manager_fd/load_temp3
add wave -noupdate /tusca_tb/UUT/fd/cnf/config_manager_fd/load_temp2
add wave -noupdate /tusca_tb/UUT/fd/cnf/config_manager_fd/load_temp1
add wave -noupdate /tusca_tb/UUT/fd/cnf/config_manager_fd/load_lim_um
add wave -noupdate /tusca_tb/UUT/fd/cnf/config_manager_uc/Eatual
add wave -noupdate /tusca_tb/UUT/fd/comp_temps/temp
add wave -noupdate /tusca_tb/UUT/fd/comp_temps/nivel
add wave -noupdate /tusca_tb/UUT/fd/comp_temps/lim_temp1
add wave -noupdate /tusca_tb/UUT/fd/comp_temps/lim_temp2
add wave -noupdate /tusca_tb/UUT/fd/comp_temps/lim_temp3
add wave -noupdate /tusca_tb/UUT/fd/comp_temps/lim_temp4
add wave -noupdate /tusca_tb/UUT/fd/s_lim_umidade
add wave -noupdate /tusca_tb/UUT/fd/comp_temps/temp
add wave -noupdate /tusca_tb/UUT/fd/comp_temps/nivel
add wave -noupdate /tusca_tb/UUT/fd/comp_temps/lim_temp4
add wave -noupdate /tusca_tb/UUT/fd/comp_temps/lim_temp3
add wave -noupdate /tusca_tb/UUT/fd/comp_temps/lim_temp2
add wave -noupdate /tusca_tb/UUT/fd/comp_temps/lim_temp1
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 4} {2729165 ns} 0} {{Cursor 3} {6189629 ns} 0}
quietly wave cursor active 2
configure wave -namecolwidth 301
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
WaveRestoreZoom {1642994 ns} {6588074 ns}
