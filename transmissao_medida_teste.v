module transmissao_medida_teste(
  input reset,
  input clock,
  input transmite,
  input[3:0] temperatura,
  input[3:0] umidade,
  output tx_serial,
  output pronto,
  output[6:0] hex0
);
  
  wire s_transmite;

  transmissao_medida UUT (
    .clock(clock),
    .reset(reset),
    .temperatura({12'b0, temperatura}),
    .umidade({12'b0, umidade}),
    .transmite(s_transmite),
    .tx_serial(tx_serial),
    .pronto(pronto),
    .db_estado(db_estado)
  );

  hexa7seg HEX0 (
    .hexa({1'b0, db_estado}),
    .display(hex0)
  );

  edge_detector ED (
    .clock(clock),
    .reset(reset),
    .sinal(transmite),
    .pulso(s_transmite)
  );

endmodule