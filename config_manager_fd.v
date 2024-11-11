module config_manager_fd(
  input clock,
  input reset,
  input rx_serial,

  input load_lim_um,
  input load_temp1,
  input load_temp2,
  input load_temp3,
  input load_temp4,
  input load_temp5,
  input load_temp6,
  input load_temp7,

  output [15:0] temp_lim1_out,
  output [15:0] temp_lim2_out,
  output [15:0] temp_lim3_out,
  output [15:0] temp_lim4_out,
  output [15:0] temp_lim5_out,
  output [15:0] temp_lim6_out,
  output [15:0] temp_lim7_out,
  output [15:0] umidade_lim_out,

  output fim_recepcao_config,
  output parity_config_ok,
  output [2:0] db_estado_recepcao_config
);

  wire [15:0] s_data_config;
  wire s_parity_error;
  wire [7:0] loads;

  wire [15:0] configs[0:7];
  assign loads = {load_temp1, load_temp2, load_temp3, load_temp4, load_temp5, load_temp6, load_temp7, load_lim_um};
  assign temp_lim1_out = configs[0];
  assign temp_lim2_out = configs[1];
  assign temp_lim3_out = configs[2];
  assign temp_lim4_out = configs[3];
  assign temp_lim5_out = configs[4];
  assign temp_lim6_out = configs[5];
  assign temp_lim7_out = configs[6];
  assign umidade_lim_out = configs[7];

  assign parity_config_ok = ~s_parity_error;

  receptor_16 receptor_config (
    .clock(clock),
    .reset(reset),
    .rx_serial(rx_serial),
    .data_out(s_data_config),
    .erro(s_parity_error),
    .pronto(fim_recepcao_config),
    .db_estado(db_estado_recepcao_config)
  );
  
  generate
    genvar i;
    for (i = 0; i < 8; i = i + 1) begin : genload
      registrador_n #(.N(16)) reg_load (
        .clock(clock),
        .clear(reset),
        .enable(loads[7-i]),
        .D(s_data_config),
        .Q(configs[i])
      );
    end
  endgenerate  


endmodule