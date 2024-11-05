module interface_dht11_fd (
  input clock,
  input reset,
  input rx_serial,
  input conta_delay_sinal,
  input load_temperatura,
  input load_umidade,
  output fim_delay_sinal,
  output [15:0] temperatura_out,
  output [15:0] umidade_out,
  output medida_ok,
  output fim_recepcao_medida,
  output [2:0] db_estado_recepcao_medida
);

  wire [15:0] medida;
  wire s_erro_medida;

  assign medida_ok = ~s_erro_medida;

  receptor_16 #(
    .BAUD_RATE(9600),
    .CLOCK_HZ(50_000_000),
    .N_BITS(8),
    .PARITY(1)
  ) receptor_medida (
    .clock(clock),
    .reset(reset),
    .rx_serial(rx_serial),
    .data_out(medida),
    .erro(s_erro_medida),
    .pronto(fim_recepcao_medida)
  );

  contador_m #(
    .M(1250),
    .N($clog2(1250))
  ) contador_delay_sinal (
    .clock(clock),
    .zera_as(reset),
    .zera_s(1'b0),
    .conta (conta_delay_sinal),
    .Q(),
    .fim(fim_delay_sinal),
    .meio()
  );

   registrador_n #(.N(16)) reg_temp (
    .clock(clock),
    .clear(reset),
    .enable(load_temperatura),
    .D(medida),
    .Q(temperatura_out)
  );

  registrador_n #(.N(16)) reg_um (
    .clock(clock),
    .clear(reset),
    .enable(load_umidade),
    .D(medida),
    .Q(umidade_out)
  );

endmodule