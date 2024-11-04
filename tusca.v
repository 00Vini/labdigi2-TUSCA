module tusca(
  input clock,
  input reset,
  input definir_config,
  input gira,
  input rx_serial_medida,
  input rx_serial_config,

  output medir_dht11_out,
  output erro_config,
  output rele,
  output pwm_ventoinha,
  output pwm_servo,

  input[2:0] db_sel,
  output [6:0] db_estado,
  output[6:0] db_estado_interface_dht11,
  output[6:0] db_estado_config_manager,
  output[6:0] db_estado_recepcao_config,
  output[6:0] db_estado_recepcao_medida,
  output[6:0] db_mux,
  output[1:0] db_nivel_temperatura
);

  wire s_medir_dht11, s_conta_delay, s_zera_delay, s_receber_config, s_fim_delay, s_pronto_medida, s_pronto_config;

  wire [2:0] s_db_estado, s_db_estado_interface_dht11, s_db_estado_config_manager, s_db_estado_recepcao_config, s_db_estado_recepcao_medida;
  wire [3:0] s_hex5;
  wire [15:0] s_db_temperatura, s_db_umidade, s_db_lim_temp1, s_db_lim_temp2, s_db_lim_temp3, s_db_lim_temp4, s_db_lim_umidade;
  wire [1:0] s_db_nivel_temperatura;

  tusca_uc uc (
    .clock(clock),
    .reset(reset),
    .medir_dht11(s_medir_dht11),
    .conta_delay(s_conta_delay),
    .zera_delay(s_zera_delay),
    .receber_config(s_receber_config),
    .definir_config(definir_config),
    .fim_delay(s_fim_delay),
    .pronto_medida(s_pronto_medida),
    .pronto_config(s_pronto_config),
    .db_estado(s_db_estado)
  );

  tusca_fd fd (
    .clock(clock),
    .reset(reset),
    .gira(gira),
    .rx_serial_config(rx_serial_config),
    .rx_serial_medida(rx_serial_medida),
    .conta_delay(s_conta_delay),
    .zera_delay(s_zera_delay),
    .medir_dht11(s_medir_dht11),
    .receber_config(s_receber_config),
    .medir_dht11_out(medir_dht11_out),
    .fim_delay(s_fim_delay),
    .pronto_medida(s_pronto_medida),
    .pronto_config(s_pronto_config),
    .erro_config(erro_config),
    .rele(rele),
    .pwm_ventoinha(pwm_ventoinha),
    .pwm_servo(pwm_servo),
    .db_estado_interface_dht11(s_db_estado_interface_dht11),
    .db_estado_config_manager(s_db_estado_config_manager),
    .db_estado_recepcao_config(s_db_estado_recepcao_config),
    .db_estado_recepcao_medida(s_db_estado_recepcao_medida),
    .db_nivel_temperatura(s_db_nivel_temperatura),
    .db_temperatura(s_db_temperatura),
    .db_umidade(s_db_umidade),
    .db_lim_temp1(s_db_lim_temp1),
    .db_lim_temp2(s_db_lim_temp2),
    .db_lim_temp3(s_db_lim_temp3),
    .db_lim_temp4(s_db_lim_temp4),
    .db_lim_umidade(s_db_lim_umidade)
  );

  hexa7seg H0 (
    .hexa({1'b0, s_db_estado}),
    .display(db_estado)
  );

  hexa7seg H1 (
    .hexa({1'b0, s_db_estado_config_manager}),
    .display(db_estado_config_manager)
  );

  hexa7seg H2 (
    .hexa({1'b0, s_db_estado_interface_dht11}),
    .display(db_estado_interface_dht11)
  );

  hexa7seg H3 (
    .hexa({1'b0, s_db_estado_recepcao_config}),
    .display(db_estado_recepcao_config)
  );

  hexa7seg H4 (
    .hexa({1'b0, s_db_estado_recepcao_medida}),
    .display(db_estado_recepcao_medida)
  );

  hexa7seg H5 (
    .hexa(s_hex5),
    .display(db_mux)
  );

  assign s_hex5 = (db_sel == 3'b000) ? s_db_temperatura[3:0] : 
                 (db_sel == 3'b001) ? s_db_lim_temp1[3:0] :
                 (db_sel == 3'b010) ? s_db_lim_temp2[3:0] :
                 (db_sel == 3'b011) ? s_db_lim_temp3[3:0] :
                 (db_sel == 3'b100) ? s_db_lim_temp4[3:0] :
                 (db_sel == 3'b101) ? s_db_lim_umidade[3:0] :
                 (db_sel == 3'b110) ? s_db_umidade[3:0] : 4'b0;

endmodule