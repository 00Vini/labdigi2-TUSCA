module receptor_16 #(
  parameter BAUD_RATE = 115200,
  parameter CLOCK_HZ = 50_000_000,
  parameter N_BITS = 8,
  parameter PARITY = 1
) (
  input clock,
  input reset,
  input rx_serial,
  output[15:0] data_out,
  output erro,
  output pronto,
  output[2:0] db_estado
);

  wire s_parity_ok, s_zera_contador, s_load_data_high, s_load_data_low, s_fim_receber;

  receptor_16_fd #(
    .BAUD_RATE(BAUD_RATE),
    .CLOCK_HZ(CLOCK_HZ),
    .N_BITS(N_BITS),
    .PARITY(PARITY)
  ) receptor_16_fd (
    .clock(clock),
    .reset(reset),
    .rx_serial(rx_serial),
    .load_data_high(s_load_data_high),
    .load_data_low(s_load_data_low),
    .data_out(data_out),
    .fim_receber(s_fim_receber),
    .parity_ok(s_parity_ok)
  );

  receptor_16_uc receptor_16_uc (
    .clock(clock),
    .reset(reset),
    .fim_receber(s_fim_receber),
    .parity_ok(s_parity_ok),
    .load_data_high(s_load_data_high),
    .load_data_low(s_load_data_low),
    .erro(erro),
    .pronto(pronto),
    .db_estado(db_estado)
  );

endmodule