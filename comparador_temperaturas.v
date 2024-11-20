module comparador_temperaturas (

  input [15:0] temp,

  input [15:0] lim_temp1,
  input [15:0] lim_temp2,
  input [15:0] lim_temp3,
  input [15:0] lim_temp4,
  input [15:0] lim_temp5,
  input [15:0] lim_temp6,
  input [15:0] lim_temp7,

  output [2:0] nivel

);

  wire[15:0] lim_temps[0:6];
  assign lim_temps[0] = lim_temp1;
  assign lim_temps[1] = lim_temp2;
  assign lim_temps[2] = lim_temp3;
  assign lim_temps[3] = lim_temp4;
  assign lim_temps[4] = lim_temp5;
  assign lim_temps[5] = lim_temp6;
  assign lim_temps[6] = lim_temp7;
  wire[6:0] eqs;
  wire[6:0] gts;
  wire[6:0] lts;

  generate
    genvar i;
    for (i = 0; i < 7; i = i + 1) begin : gendgenerate
      comparador_n #(.N(16)) comparador_float_sensor (
        .A(temp),
        .B(lim_temps[i]),
        .eq(eqs[i]),
        .gt(gts[i]),
        .lt(lts[i])
      );
    end
  endgenerate

  assign nivel = (eqs[0] | lts[0]) ? 3'b000 :
                 (eqs[1] | lts[1]) ? 3'b001 :
                 (eqs[2] | lts[2]) ? 3'b010 :
                 (eqs[3] | lts[3]) ? 3'b011 :
                 (eqs[4] | lts[4]) ? 3'b100 :
                 (eqs[5] | lts[5]) ? 3'b101 :
                 (eqs[6] | lts[6]) ? 3'b110 : 3'b111;

endmodule