module receptor_16_fd #(
  parameter BAUD_RATE = 115200,
  parameter CLOCK_HZ = 50_000_000,
  parameter N_BITS = 8,
  parameter PARITY = 1
) (
  input clock,
  input reset,
  input rx_serial,
  input load_data_high,
  input load_data_low,
  output[15:0] data_out,
  output fim_receber,
  output parity_ok
);

  wire[15:0] s_data_in;
  wire[7:0] s_data;
  wire [1:0] etapa;

  rx_serial #(
    .BAUD_RATE(BAUD_RATE),
    .CLOCK_HZ(CLOCK_HZ),
    .N_BITS(N_BITS),
    .PARITY(PARITY)
  ) recep_serial (
      .clock(clock),
      .reset(reset),
      .rxd(rx_serial),
      .parity_check(parity_ok),
      .fim(fim_receber),
      .data(s_data),
      .db_estado()
  );

  double_registrador_n #(
    .N(16)
  ) reg_data (
      .clock(clock),
      .clear(reset),
      .load_high(load_data_high),
      .load_low(load_data_low),
      .load(1'b0),
      .D_half(s_data),
      .D(s_data_in),
      .Q(data_out)
  );
  
endmodule