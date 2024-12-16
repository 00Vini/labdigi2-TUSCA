module tusca #(
  parameter PERIODO_CONTA = 2000,
  parameter PERIODO_DELAY = 50_000_000, // 2s
  TIMEOUT = 50_000_000 // 1s
) (
  input clock,
  input reset,
  input start,
  input gira,
  input rx_serial,

  inout dht_bus,

  output erro_config,
  output rele,
  output pwm_ventoinha,
  output pwm_servo,
  output tx_serial,

  input[2:0] db_sel,
  output [6:0] db_estado,
  output[6:0] db_estado_interface_dht11,
  output[6:0] db_estado_config_manager,
  output[6:0] db_estado_recepcao_config,
  output[6:0] db_estado_transmissao_medida,
  output[6:0] db_mux,
  output[6:0] db_nivel_temperatura,
  output db_pwm_ventoinha,
  output db_pwm_servo,
  output db_rele,
  output db_rx_serial,
  output db_tx_serial,
  output db_erro_medida,
  output db_erro_medir
);

  wire s_medir_dht11, s_conta_delay, s_zera_delay, s_receber_config, s_fim_delay, 
       s_pronto_medida, s_pronto_config, s_start, s_definir_config, s_erro_medida, 
       s_transmite_medida, s_pronto_transmissao_medida, s_rele;

  wire [2:0] s_db_estado_interface_dht11, s_db_estado_recepcao_config, s_db_estado_transmissao_medida;
  wire [2:0] s_db_nivel_temperatura;
  wire [3:0] s_hex5, s_db_estado, s_db_estado_config_manager;
  wire [15:0] s_db_temperatura, s_db_umidade, s_db_lim_temp1, s_db_lim_temp2, s_db_lim_temp3, s_db_lim_temp4, s_db_lim_umidade;

  assign s_definir_config = ~db_rx_serial;
  assign s_receber_config = ~db_rx_serial;
  assign rele = ~s_rele;

  tusca_uc uc (
    .clock(clock),
    .reset(reset),
    .start(s_start),
    .medir_dht11(s_medir_dht11),
    .conta_delay(s_conta_delay),
    .zera_delay(s_zera_delay),
    .definir_config(s_definir_config),
    .transmite_medida(s_transmite_medida),
    .fim_delay(s_fim_delay),
    .pronto_medida(s_pronto_medida),
    .erro_medida(s_erro_medida),
    .pronto_config(s_pronto_config),
    .pronto_transmissao_medida(s_pronto_transmissao_medida),
    .db_estado(s_db_estado)
  );

  tusca_fd #(
    .PERIODO_CONTA(PERIODO_CONTA),
    .PERIODO_DELAY(PERIODO_DELAY),
    .TIMEOUT(TIMEOUT)
  ) fd (
    .clock(clock),
    .reset(reset),
    .gira(gira),
    .rx_serial(rx_serial),
    .conta_delay(s_conta_delay),
    .zera_delay(s_zera_delay),
    .medir_dht11(s_medir_dht11),
    .receber_config(s_receber_config),
    .dht_bus(dht_bus),
    .transmite_medida(s_transmite_medida),
    .pronto_transmite_medida(s_pronto_transmissao_medida),
    .fim_delay(s_fim_delay),
    .pronto_medida(s_pronto_medida),
    .erro_medida(s_erro_medida),
    .pronto_config(s_pronto_config),
    .erro_config(erro_config),
    .rele(s_rele),
    .pwm_ventoinha(pwm_ventoinha),
    .pwm_servo(pwm_servo),
    .tx_serial(tx_serial),
    .db_estado_interface_dht11(s_db_estado_interface_dht11),
    .db_estado_config_manager(s_db_estado_config_manager),
    .db_estado_recepcao_config(s_db_estado_recepcao_config),
    .db_estado_transmissao_medida(s_db_estado_transmissao_medida),
    .db_nivel_temperatura(s_db_nivel_temperatura),
    .db_temperatura(s_db_temperatura),
    .db_umidade(s_db_umidade),
    .db_lim_temp1(s_db_lim_temp1),
    .db_lim_temp2(s_db_lim_temp2),
    .db_lim_temp3(s_db_lim_temp3),
    .db_lim_temp4(s_db_lim_temp4),
    .db_lim_umidade(s_db_lim_umidade),
    .db_erro_medida(db_erro_medida),
    .db_erro_medir(db_erro_medir)
  );

  assign db_pwm_servo = pwm_servo;
  assign db_pwm_ventoinha = pwm_ventoinha;
  assign db_rx_serial = rx_serial;
  assign db_rele = rele;
  assign db_tx_serial = tx_serial;

  hexa7seg H0 (
    .hexa(s_db_estado),
    .display(db_estado)
  );

  hexa7seg H1 (
    .hexa(s_db_estado_config_manager),
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
    .hexa({1'b0, s_db_estado_transmissao_medida }),
    .display(db_estado_transmissao_medida)
  );

  hexa7seg H5 (
    .hexa(s_hex5),
    .display(db_mux)
  );

  hexa7seg EXT_HEX (
    .hexa({1'b0, s_db_nivel_temperatura}),
    .display(db_nivel_temperatura)
  );

  edge_detector ed_start (
    .clock(clock),
    .reset(reset),
    .sinal(start),
    .pulso(s_start)
  );

  assign s_hex5 = (db_sel == 3'b000) ? s_db_temperatura[3:0] : 
                 (db_sel == 3'b001) ? s_db_lim_temp1[3:0] :
                 (db_sel == 3'b010) ? s_db_lim_temp2[3:0] :
                 (db_sel == 3'b011) ? s_db_lim_temp3[3:0] :
                 (db_sel == 3'b100) ? s_db_lim_temp4[3:0] :
                 (db_sel == 3'b101) ? s_db_lim_umidade[3:0] :
                 (db_sel == 3'b110) ? s_db_umidade[3:0] : 4'b0;

endmodule