module config_manager(
  input clock,
  input reset,
  input receber_config,
  input rx_serial,
  output [15:0] temp_lim1_out,
  output [15:0] temp_lim2_out,
  output [15:0] temp_lim3_out,
  output [15:0] temp_lim4_out,
  output [15:0] temp_lim5_out,
  output [15:0] temp_lim6_out,
  output [15:0] temp_lim7_out,
  output [15:0] umidade_lim_out,
  output erro_config,
  output pronto_config,
  output [2:0] db_estado,
  output [2:0] db_estado_recepcao_config
);

  wire s_load_lim_um, s_load_temp1, s_load_temp2, s_load_temp3, s_load_temp4, s_load_temp5, s_load_temp6, s_load_temp7;
  wire s_fim_recepcao_config, s_parity_config_ok;

  config_manager_fd config_manager_fd (
    .clock(clock),
    .reset(reset),
    .rx_serial(rx_serial),
    .load_lim_um(s_load_lim_um),
    .load_temp1(s_load_temp1),
    .load_temp2(s_load_temp2),
    .load_temp3(s_load_temp3),
    .load_temp4(s_load_temp4),
    .load_temp5(s_load_temp5),
    .load_temp6(s_load_temp6),
    .load_temp7(s_load_temp7),
    .temp_lim1_out(temp_lim1_out),
    .temp_lim2_out(temp_lim2_out),
    .temp_lim3_out(temp_lim3_out),
    .temp_lim4_out(temp_lim4_out),
    .temp_lim5_out(temp_lim5_out),
    .temp_lim6_out(temp_lim6_out),
    .temp_lim7_out(temp_lim7_out),
    .umidade_lim_out(umidade_lim_out),
    .fim_recepcao_config(s_fim_recepcao_config),
    .parity_config_ok(s_parity_config_ok),
    .db_estado_recepcao_config(db_estado_recepcao_config)
  );

  config_manager_uc config_manager_uc (
    .clock(clock),
    .reset(reset),
    .receber_config(receber_config),
    .load_lim_um(s_load_lim_um),
    .load_temp1(s_load_temp1),
    .load_temp2(s_load_temp2),
    .load_temp3(s_load_temp3),
    .load_temp4(s_load_temp4),
    .load_temp5(s_load_temp5),
    .load_temp6(s_load_temp6),
    .load_temp7(s_load_temp7),
    .pronto_config(pronto_config),
    .erro_config(erro_config),
    .fim_recepcao_config(s_fim_recepcao_config),
    .parity_config_ok(s_parity_config_ok),
    .db_estado(db_estado)
  );

endmodule