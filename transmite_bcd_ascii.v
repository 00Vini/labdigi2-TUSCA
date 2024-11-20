module transmite_bcd_ascii (
  input clock,
  input reset,
  input[7:0] bcd,
  input transmite_bcd,
  output pronto,
  output tx_serial
);

  wire s_inicio_transmissao_bcd, s_seletor_valor, s_pronto_transmissao_bcd;

  transmite_bcd_ascii_uc U1_UC (
    .clock(clock),
    .reset(reset),
    .transmite_bcd(transmite_bcd),
    .pronto(pronto),
    .inicio_transmissao_bcd(s_inicio_transmissao_bcd),
    .pronto_transmissao_bcd(s_pronto_transmissao_bcd),
    .seletor_valor(s_seletor_valor)
  );

  transmite_bcd_ascii_fd U2_FD (
    .clock(clock),
    .reset(reset),
    .bcd(bcd),
    .seletor_valor(s_seletor_valor),
    .inicio_transmissao_bcd(s_inicio_transmissao_bcd),
    .pronto_transmissao_bcd(s_pronto_transmissao_bcd),
    .tx_serial(tx_serial)
  );


endmodule