module comparador_float_sensor (
  input [15:0] valor_a,
  input [15:0] valor_b,
  
  output eq,
  output gt,
  output lt

);

  wire eq_int, lt_int, gt_int;
  wire eq_float, lt_float, gt_float;

  comparador_n comparador_n1 (
    .A(valor_a[15:8]),
    .B(valor_b[15:8]),
    .eq(eq_int),
    .gt(gt_int),
    .lt(lt_int)
  );

  comparador_n comparador_n2 (
    .A(valor_a[7:0]),
    .B(valor_b[7:0]),
    .eq(eq_float),
    .gt(gt_float),
    .lt(lt_float)
  );

  assign eq = eq_int & eq_float;
  assign gt = gt_int | (eq_int & gt_float);
  assign lt = lt_int | (eq_int & lt_float);


endmodule