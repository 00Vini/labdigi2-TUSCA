module comparador_umidade (
  input [15:0] umidade,
  input [15:0] lim_umidade,

  output rele
);

  wire eq, lt;

  assign rele = (eq | lt);

  comparador_float_sensor com_float_umidade (
    .valor_a(umidade),
    .valor_b(lim_umidade),
    .eq(eq),
    .gt(lt),
    .lt()
  );

endmodule