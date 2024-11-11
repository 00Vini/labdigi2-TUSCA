module transmissao_medida (
  input clock,
  input reset,
  input [15:0] temperatura,
  input [15:0] umidade,
  input transmite,
  output tx_serial,
  output pronto
);

  wire s_converte_bcd, s_tx_transmite, s_conta_contador, s_zera_contador, s_fim_contador, s_pronto_transmissao, s_pronto_bcd;

  transmissao_medida_fd FD (
    .clock(clock),
    .reset(reset),
    .temperatura(temperatura),
    .umidade(umidade),
    .converte_bcd(s_converte_bcd),
    .tx_transmite(s_tx_transmite),
    .conta_contador(s_conta_contador),
    .zera_contador(s_zera_contador),
    .fim_contador(s_fim_contador),
    .pronto_transmissao(s_pronto_transmissao),
    .pronto_bcd(s_pronto_bcd),
    .tx_serial(tx_serial)
  );

  transmissao_medida_uc UC (
    .clock(clock),
    .reset(reset),
    .transmite(transmite),
    .fim_contador(s_fim_contador),
    .pronto_transmissao(s_pronto_transmissao),
    .pronto_bcd(s_pronto_bcd),
    .zera_contador(s_zera_contador),
    .conta_contador(s_conta_contador),
    .converte_bcd(s_converte_bcd),
    .tx_transmite(s_tx_transmite),
    .pronto(pronto)
  );

endmodule