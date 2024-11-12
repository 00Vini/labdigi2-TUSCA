module transmite_bcd_ascii_fd(
  input clock,
  input reset,
  input [7:0] bcd,
  input seletor_valor,
  input inicio_transmissao_bcd,
  output pronto_transmissao_bcd,
  output tx_serial
);

  wire[6:0] s_valor_ascii;

  assign s_valor_ascii = seletor_valor == 1'b1 ? {3'b011, bcd[7:4]} : {3'b011, bcd[3:0]};

  tx_serial_7O1 #(
    .BAUD_RATE(115200)
  ) transmite (
    .clock(clock),
    .reset(reset),
    .partida(inicio_transmissao_bcd),
    .dados_ascii(s_valor_ascii),
    .saida_serial(tx_serial),
    .pronto(pronto_transmissao_bcd)
  );

endmodule