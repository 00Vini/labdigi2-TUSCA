module interface_dht11_fd (
  input clock,
  input reset,
  input rx_serial,
  input conta_delay_sinal,
  input load_medida,
  output fim_delay_sinal,
  output temperatura_out,
  output [15:0] umidade_out,
  output [15:0] medida_ok,
  output fim_recepcao_medida
);

  wire [31:0] medida;

  rx_serial #(
    .BAUD_RATE(9600),
    .CLOCK_HZ(50_000_000),
    .N_BITS(32),
    .PARITY(1)
  ) recep_medida (
      .clock(clock),
      .reset(reset),
      .rxd(rx_serial),
      .parity_check(medida_ok),
      .fim(fim_recepcao_medida),
      .data(medida),
      .db_estado()
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
    .enable(load_medida),
    .D(medida[15:0]),
    .Q(temperatura_out)
  );

  registrador_n #(.N(16)) reg_um (
    .clock(clock),
    .clear(reset),
    .enable(load_medida),
    .D(medida[31:16]),
    .Q(umidade_out)
  );

endmodule