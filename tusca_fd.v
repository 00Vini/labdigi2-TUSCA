module tusca_fd #(
  parameter PERIODO_CONTA = 2000,
  parameter PERIODO_DELAY = 100_000_000 // 2s
) (
  input clock,
  input reset,
  input gira,

  input conta_delay,
  input zera_delay,
  input medir_dht11,
  input receber_config,

  input transmite_medida,
  input rx_serial_medida,
  input rx_serial_config,

  output medir_dht11_out,
  output fim_delay,
  output pronto_medida,
  output erro_medida,
  output pronto_config,
  output erro_config,
  output rele,
  output pwm_ventoinha,
  output pwm_servo,
  output pronto_transmite_medida,
  output tx_serial,
  output[2:0] db_estado_interface_dht11,
  output[2:0] db_estado_config_manager,
  output[2:0] db_estado_recepcao_config,
  output[2:0] db_estado_recepcao_medida,
  output[2:0] db_estado_transmissao_medida,
  output[1:0] db_nivel_temperatura,
  output[15:0] db_temperatura,
  output[15:0] db_umidade,
  output[15:0] db_lim_temp1,
  output[15:0] db_lim_temp2,
  output[15:0] db_lim_temp3,
  output[15:0] db_lim_temp4,
  output[15:0] db_lim_umidade
);

  wire [15:0] s_temp, s_umidade;
  wire [31:0] s_data_medida;
  wire [15:0] s_data_config;
  wire [15:0] s_lim_umidade, s_lim_temp1, s_lim_temp2, s_lim_temp3, s_lim_temp4, s_lim_temp5, s_lim_temp6, s_lim_temp7;
  wire [2:0] s_nivel_temperatura;

  assign db_nivel_temperatura = s_nivel_temperatura;
  assign db_temperatura = s_temp;
  assign db_umidade = s_umidade;
  assign db_lim_temp1 = s_lim_temp1;
  assign db_lim_temp2 = s_lim_temp2;
  assign db_lim_temp3 = s_lim_temp3;
  assign db_lim_temp4 = s_lim_temp4;
  assign db_lim_umidade = s_lim_umidade;

  interface_dht11 interface_dht11 (
    .clock(clock),
    .reset(reset),
    .medir_dht11(medir_dht11),
    .rx_serial(rx_serial_medida),
    .pronto_medida(pronto_medida),
    .erro(erro_medida),
    .temeperatura_out(s_temp),
    .umidade_out(s_umidade),
    .medir_out(medir_dht11_out),
    .db_estado(db_estado_interface_dht11),
    .db_estado_recepcao_medida(db_estado_recepcao_medida)
  );

  config_manager cnf (
    .clock(clock),
    .reset(reset),
    .receber_config(receber_config),
    .rx_serial(rx_serial_config),
    .temp_lim1_out(s_lim_temp1),
    .temp_lim2_out(s_lim_temp2),
    .temp_lim3_out(s_lim_temp3),
    .temp_lim4_out(s_lim_temp4),
    .temp_lim5_out(s_lim_temp5),
    .temp_lim6_out(s_lim_temp6),
    .temp_lim7_out(s_lim_temp7),
    .umidade_lim_out(s_lim_umidade),
    .erro_config(erro_config),
    .pronto_config(pronto_config),
    .db_estado(db_estado_config_manager),
    .db_estado_recepcao_config(db_estado_recepcao_config)
  );
  
  comparador_temperaturas comp_temps (
    .temp(s_temp),
    .lim_temp1(s_lim_temp1),
    .lim_temp2(s_lim_temp2),
    .lim_temp3(s_lim_temp3),
    .lim_temp4(s_lim_temp4),
    .lim_temp5(s_lim_temp5),
    .lim_temp6(s_lim_temp6),
    .lim_temp7(s_lim_temp7),
    .nivel(s_nivel_temperatura)
  );

  comparador_umidade comp_umidade (
    .umidade(s_umidade),
    .lim_umidade(s_lim_umidade),
    .rele(rele)
  );

  controle_ventoinha cont_ventoinha (
    .clock(clock),
    .reset(reset),
    .nivel(s_nivel_temperatura),
    .pwm_ventoinha(pwm_ventoinha)
  );

  contador_m #( 
    .M(PERIODO_DELAY), 
    .N($clog2(PERIODO_DELAY)) 
  ) contador_delay (
    .clock ( clock ),
    .zera_as ( reset ),
    .zera_s  ( zera_delay ),
    .conta   ( conta_delay ),
    .Q       ( ),
    .fim     ( fim_delay ),
    .meio    ( )
  );

  transmissao_medida transmissao (
    .clock ( clock ),
    .reset ( reset ),
    .temperatura ( s_temp ),
    .umidade ( s_umidade ),
    .transmite( transmite_medida ),
    .tx_serial( tx_serial ),
    .pronto( pronto_transmite_medida ),
    .db_estado( db_estado_transmissao )
  );

  controle_servo #( 
    .PERIODO_CONTA(PERIODO_CONTA)
  ) servo (
      .clock ( clock ),
      .reset ( reset ),
      .gira  ( gira  ),
      .pwm   ( pwm_servo   )
  );
  

endmodule