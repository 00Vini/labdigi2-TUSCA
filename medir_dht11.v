module medir_dht11 #(
  parameter TIMEOUT = 50_000_000 // 1s
) (
  inout dht_bus,
  input clock,
  input reset,
  input medir,
  output [15:0] temperatura,
  output [15:0] umidade,
  output pronto,
  output erro,
  output[2:0] db_estado,
  output db_erro_medida
);
  wire s_start_medida, s_reset_medida, s_pronto_medida, s_erro_medida, s_registra_medida;
  wire s_zera_tentativas, s_zera_timeout, s_conta_tentativas, s_conta_timeout, s_fim_tentativas, s_timeout;

  assign db_erro_medida = s_erro_medida;

  medir_dht11_fd #(
    .TIMEOUT(TIMEOUT)
  ) medir_dht11_fd (
    .dht_bus(dht_bus),
    .clock(clock),
    .reset(reset),
    .reset_medida(s_reset_medida),
    .start_medida(s_start_medida),
    .registra_medida(s_registra_medida),
    .zera_tentativas(s_zera_tentativas),
    .zera_timeout(s_zera_timeout),
    .conta_tentativas(s_conta_tentativas),
    .conta_timeout(s_conta_timeout),
    .fim_tentativas(s_fim_tentativas),
    .timeout(s_timeout),
    .pronto_medida(s_pronto_medida),
    .erro_medida(s_erro_medida),
    .temperatura(temperatura),
    .umidade(umidade)
  );

  medir_dht11_uc medir_dht11_uc (
    .clock(clock),
    .reset(reset),
    .medir(medir),
    .pronto_medida(s_pronto_medida),
    .erro_medida(s_erro_medida),
    .fim_tentativas(s_fim_tentativas),
    .timeout(s_timeout),
    .zera_tentativas(s_zera_tentativas),
    .zera_timeout(s_zera_timeout),
    .conta_tentativas(s_conta_tentativas),
    .conta_timeout(s_conta_timeout),
    .start_medida(s_start_medida),
    .reset_medida(s_reset_medida),
    .registra_medida(s_registra_medida),
    .pronto(pronto),
    .erro(erro),
    .db_estado(db_estado)
  );

endmodule