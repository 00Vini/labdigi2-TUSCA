module transmissao_medida_fd(
  input clock,
  input reset,
  input [15:0] temperatura,
  input [15:0] umidade,
  input converte_bcd,
  input tx_transmite,
  
  input conta_contador,
  input zera_contador,

  output fim_contador,
  output tx_serial,
  output pronto_transmissao,
  output pronto_bcd
);

  wire [6:0] s_medida;
  wire [7:0] s_dado_bcd;
  wire [1:0] seletor_dado;

  assign s_medida = seletor_dado == 2'b00 ? {1'b0, temperatura[14:8]} :
                    seletor_dado == 2'b01 ? {1'b0, temperatura[6:0]} :
                    seletor_dado == 2'b10 ? {1'b0, umidade[14:8]} : 
                    seletor_dado == 2'b11 ? {1'b0, umidade[6:0]} : 7'b0;


  contador_m #(
    .M(4),
    .N(2)
  ) contador (
    .clock(clock),
    .zera_as(reset),
    .zera_s(zera_contador),
    .conta(conta_contador),
    .Q(seletor_dado),
    .fim(fim_contador),
    .meio()
  );

  bin2bcd #(
    .W(7),
    .N(8)
  ) conversor_bcd (
    .clock(clock),
    .reset(reset),
    .start(converte_bcd),
    .binary(s_medida),
    .pronto(pronto_bcd),
    .bcd(s_dado_bcd)
  );

  transmite_bcd_ascii transmite_bcd (
    .clock(clock),
    .reset(reset),
    .bcd(s_dado_bcd),
    .transmite_bcd(tx_transmite),
    .pronto(pronto_transmissao),
    .tx_serial(tx_serial)
  );



endmodule