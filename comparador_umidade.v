module comparador_umidade (
  input [15:0] umidade,
  input [15:0] lim_umidade,

  output rele
);

  wire eq, lt;

  assign rele = (eq | lt);

  comparador_n #(.N(16)) com_float_umidade (
    .A(umidade),
    .B(lim_umidade),
    .eq(eq),
    .gt(),
    .lt(lt)
  );

endmodule