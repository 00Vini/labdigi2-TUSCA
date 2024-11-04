module comparador_temperaturas (

  input [15:0] temp,

  input [15:0] lim_temp1,
  input [15:0] lim_temp2,
  input [15:0] lim_temp3,
  input [15:0] lim_temp4,

  output [1:0] nivel

);

  wire eq1, eq2, eq3, eq4;
  wire gt1, gt2, gt3, gt4;
  wire lt1, lt2, lt3, lt4;

  comparador_float_sensor comparador_float_sensor1 (
    .valor_a(temp),
    .valor_b(lim_temp1),
    .eq(eq1),
    .gt(gt1),
    .lt(lt1)
  );

  comparador_float_sensor comparador_float_sensor2 (
    .valor_a(temp),
    .valor_b(lim_temp2),
    .eq(eq2),
    .gt(gt2),
    .lt(lt2)
  );

  comparador_float_sensor comparador_float_sensor3 (
    .valor_a(temp),
    .valor_b(lim_temp3),
    .eq(eq3),
    .gt(gt3),
    .lt(lt3)
  );

  comparador_float_sensor comparador_float_sensor4 (
    .valor_a(temp),
    .valor_b(lim_temp4),
    .eq(eq4),
    .gt(gt4),
    .lt(lt4)
  );

  assign nivel = (eq1 | lt1) ? 2'b00 :
                 (eq2 | lt2) ? 2'b01 :
                 (eq3 | lt3) ? 2'b10 :
                 (eq4 | lt4) ? 2'b11 : 2'b11;

endmodule