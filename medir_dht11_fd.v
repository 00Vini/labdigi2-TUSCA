module medir_dht11_fd #(
  parameter TIMEOUT = 50_000_000 // 1s
) (
  inout dht_bus,
  input clock,
  input reset,
  input reset_medida,
  input start_medida,
  input registra_medida,
  input zera_tentativas,
  input zera_timeout,
  input conta_tentativas,
  input conta_timeout,
  output fim_tentativas,
  output timeout,
  output pronto_medida,
  output erro_medida,
  output [15:0] temperatura,
  output [15:0] umidade
);

  wire [15:0] s_temperatura, s_umidade;

  dht11 dht11_module (
    .dht_bus(dht_bus),
    .start(start_medida),
    .clock(clock),
    .reset(reset_medida),
    .temperatura(s_temperatura),
    .umidade(s_umidade),
    .pronto(pronto_medida),
    .error(erro_medida),
    .db_estado()
  );

  registrador_n #(
    .N(16)
  ) reg_temperatura (
    .clock(clock),
    .clear(reset),
    .enable(registra_medida),
    .D(s_temperatura),
    .Q(temperatura)
  );

  registrador_n #(
    .N(16)
  ) reg_umidade (
    .clock(clock),
    .clear(reset),
    .enable(registra_medida),
    .D(s_umidade),
    .Q(umidade)
  );

  contador_m #(
    .M(TIMEOUT), // 1s de timeout
    .N($clog2(TIMEOUT))
  ) contador_delay_medida (
    .clock(clock),
    .zera_as(zera_timeout),
    .zera_s(1'b0),
    .conta (conta_timeout),
    .Q(),
    .fim(timeout),
    .meio()
  );

  contador_m #(
    .M(4), // Tentar medir no máximo 4 vezes
    .N(2)
  ) contador_tentativas (
    .clock(clock),
    .zera_as(reset),
    .zera_s(zera_tentativas),
    .conta (conta_tentativas),
    .Q(),
    .fim(fim_tentativas),
    .meio()
  );



endmodule