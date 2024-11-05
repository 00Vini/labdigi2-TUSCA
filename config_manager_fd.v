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
  output parity_config_ok,
  output [2:0] db_estado_recepcao_config
);

  wire [15:0] s_data_config;
  wire s_parity_error;

  assign parity_config_ok = ~s_parity_error;

  receptor_16 receptor_config (
    .clock(clock),
    .reset(reset),
    .rx_serial(rx_serial),
    .data_out(s_data_config),
    .erro(s_parity_error),
    .pronto(fim_recepcao_config)
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