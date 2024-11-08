module controle_ventoinha(
  input clock,
  input reset,
  input [2:0] nivel,
  output pwm_ventoinha
);

  circuito_pwm_discreto #(
    .conf_periodo(2500), // 20kHz
    .largura_000(313),  // ~12.5%
    .largura_001(625),  // 25%
    .largura_010(939),  // 37.5%
    .largura_011(1250), // 50%
    .largura_100(1562), // ~62.5% 
    .largura_101(1875), // 75% 
    .largura_110(2187), // 87.5%
    .largura_111(2500)  // 100%
  ) pwm (
    .clock(clock),
    .reset(reset),
    .largura(nivel),
    .pwm(pwm_ventoinha)
  );

endmodule