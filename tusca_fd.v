module tusca_fd #(
  parameter PERIODO_CONTA = 2000
) (
  input [15:0] temp,
  input [15:0] umidade,
  input clock,
  input reset,
  input gira,

  output rele,
  output pwm_ventoinha,
  output pwm_servo
);

  wire [15:0] s_temp, s_umidade;
  wire [15:0] s_lim_umidade, s_lim_temp1, s_lim_temp2, s_lim_temp3, s_lim_temp4;
  wire [1:0] s_nivel_temperatura;

  comparador_temperaturas comp_temps (
    .temp(s_temp),
    .lim_temp1(s_lim_temp1),
    .lim_temp2(s_lim_temp2),
    .lim_temp3(s_lim_temp3),
    .lim_temp4(s_lim_temp4),
    .nivel(s_nivel_temperatura)
  );

  comparador_umidade comp_umidade (
    .umidade(s_umidade),
    .lim_umidade(s_lim_umidade),
    .rele(rele)
  );

  controle_ventoinha cont_ventoinha (
    .clock(clock),
    .reset(reset),
    .s_nivel(s_nivel_temperatura),
    .pwm_ventoinha(pwm_ventoinha)
  );

  controle_servo #( 
    .PERIODO_CONTA(PERIODO_CONTA)
  ) servo (
      .clock ( clock ),
      .reset ( reset ),
      .gira  ( gira  ),
      .pwm   ( pwm_servo   )
  );

  registrador_n #(.N(16)) reg_temp (
    .clock(clock),
    .clear(reset),
    .enable(1'b1),
    .D(temp), // 25.8C
    .Q(s_temp)
  );

  registrador_n #(.N(16)) reg_um (
    .clock(clock),
    .clear(reset),
    .enable(1'b1),
    .D(umidade),
    .Q(s_umidade)
  );

  registrador_n #(.N(16)) reg_lim_umidade (
    .clock(clock),
    .clear(reset),
    .enable(1'b1),
    .D({8'd48, 8'd2}), // 48.2
    .Q(s_lim_umidade)
  );

  registrador_n #(.N(16)) reg_lim_temp1 (
    .clock(clock),
    .clear(reset),
    .enable(1'b1),
    .D({8'd20, 8'd0}), // 20.0C
    .Q(s_lim_temp1)
  );

  registrador_n #(.N(16)) reg_lim_temp2 (
    .clock(clock),
    .clear(reset),
    .enable(1'b1),
    .D({8'd23, 8'd3}), // 23.3C
    .Q(s_lim_temp2)
  );

  registrador_n #(.N(16)) reg_lim_temp3 (
    .clock(clock),
    .clear(reset),
    .enable(1'b1),
    .D({8'd26, 8'd6}), // 26.6C
    .Q(s_lim_temp3)
  );

  registrador_n #(.N(16)) reg_lim_temp4 (
    .clock(clock),
    .clear(reset),
    .enable(1'b1),
    .D({8'd30, 8'd0}), // 30.0C
    .Q(s_lim_temp4)
  );
  

endmodule