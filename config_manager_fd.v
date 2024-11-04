module config_manager_fd(
  input clock,
  input reset,
  input rx_serial,

  input load_lim_um,
  input load_temp1,
  input load_temp2,
  input load_temp3,
  input load_temp4,

  output [15:0] temp_lim1_out,
  output [15:0] temp_lim2_out,
  output [15:0] temp_lim3_out,
  output [15:0] temp_lim4_out,
  output [15:0] umidade_lim_out,

  output fim_recepcao_config,
  output parity_config_ok
);

  wire [15:0] s_data_config;

  rx_serial #(
    .BAUD_RATE(115200),
    .CLOCK_HZ(50_000_000),
    .N_BITS(16),
    .PARITY(1)
  ) recep_serial (
      .clock(clock),
      .reset(reset),
      .rxd(rx_serial),
      .parity_check(parity_config_ok),
      .fim(fim_recepcao_config),
      .data(s_data_config),
      .db_estado()
  );

  registrador_n #(.N(16)) reg_lim_umidade (
    .clock(clock),
    .clear(reset),
    .enable(load_lim_um),
    .D(s_data_config),
    .Q(umidade_lim_out)
  );

  registrador_n #(.N(16)) reg_lim_temp1 (
    .clock(clock),
    .clear(reset),
    .enable(load_temp1),
    .D(s_data_config),
    .Q(temp_lim1_out)
  );

  registrador_n #(.N(16)) reg_lim_temp2 (
    .clock(clock),
    .clear(reset),
    .enable(load_temp2),
    .D(s_data_config),
    .Q(temp_lim2_out)
  );

  registrador_n #(.N(16)) reg_lim_temp3 (
    .clock(clock),
    .clear(reset),
    .enable(load_temp3),
    .D(s_data_config),
    .Q(temp_lim3_out)
  );

  registrador_n #(.N(16)) reg_lim_temp4 (
    .clock(clock),
    .clear(reset),
    .enable(load_temp4),
    .D(s_data_config),
    .Q(temp_lim4_out)
  );


endmodule