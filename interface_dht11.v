module interface_dht11(
  input clock,
  input reset,
  input medir_dht11,
  input rx_serial,
  output pronto_medida,
  output [15:0] temeperatura_out,
  output [15:0] umidade_out,
  output medir_out,
  output[2:0] db_estado,
  output[2:0] db_estado_recepcao_medida
);

  wire s_conta_delay_sinal, s_fim_delay_sinal, s_medida_ok, s_fim_recepcao_medida, s_load_temperatura, s_load_umidade;

  interface_dht11_fd interface_dht11_fd(
    .clock(clock),
    .reset(reset),
    .rx_serial(rx_serial),
    .conta_delay_sinal(s_conta_delay_sinal),
    .fim_delay_sinal(s_fim_delay_sinal),
    .medida_ok(s_medida_ok),
    .fim_recepcao_medida(s_fim_recepcao_medida),
    .load_temperatura(s_load_temperatura),
    .load_umidade(s_load_umidade),
    .temperatura_out(temeperatura_out),
    .umidade_out(umidade_out),
    .db_estado_recepcao_medida(db_estado_recepcao_medida)
  );

  interface_dht11_uc interface_dht11_uc(
    .clock(clock),
    .reset(reset),
    .medir_dht11(medir_dht11),
    .conta_delay_sinal(s_conta_delay_sinal),
    .pronto_medida(pronto_medida),
    .fim_delay_sinal(s_fim_delay_sinal),
    .medida_ok(s_medida_ok),
    .fim_recepcao_medida(s_fim_recepcao_medida),
    .medir_out(medir_out),
    .load_temperatura(s_load_temperatura),
    .load_umidade(s_load_umidade),
    .db_estado(db_estado)
  );


endmodule