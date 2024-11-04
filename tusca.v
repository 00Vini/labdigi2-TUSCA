module tusca(
  input clock,
  input reset,
  input definir_config,
  input gira,
  input rx_serial,

  output medir_dht11_out,
  output erro_config,
  output rele,
  output pwm_ventoinha,
  output pwm_servo
);

  wire s_medir_dht11, s_conta_delay, s_zera_delay, s_receber_config, s_fim_delay, s_pronto_medida, s_pronto_config;

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
    .pronto_config(s_pronto_config)
  );

  tusca_fd fd (
    .clock(clock),
    .reset(reset),
    .gira(gira),
    .rx_serial(rx_serial),
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
    .pwm_servo(pwm_servo)
  );

endmodule