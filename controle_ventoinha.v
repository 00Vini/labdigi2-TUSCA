module controle_ventoinha(
  input clock,
  input reset,
  input [1:0] s_nivel,
  output pwm_ventoinha
);

  circuito_pwm_discreto #(
    .conf_periodo(2500), // 20kHz
    .largura_00(1250), // 50%
    .largura_01(1666),
    .largura_10(2082),
    .largura_11(2500)
  ) pwm (
    .clock(clock),
    .reset(reset),
    .largura(s_nivel),
    .pwm(pwm_ventoinha)
  );

endmodule