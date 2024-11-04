module controle_ventoinha(
  input clock,
  input reset,
  input [1:0] s_nivel,
  output pwm_ventoinha
);

  circuito_pwm_discreto #(
    .conf_periodo(5000), // 20kHz
    .largura_00(2500),
    .largura_01(3333),
    .largura_10(4166),
    .largura_11(5000)
  ) pwm (
    .clock(clock),
    .reset(reset),
    .largura(s_nivel),
    .pwm(pwm_ventoinha)
  );

endmodule