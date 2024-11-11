module bin2bcd_teste(
  input clock,
  input reset,
  input start,
  input [6:0] bin_teste,
  output[6:0] hex0,
  output [6:0] hex1,
  output pronto
);

  wire s_hex0, s_hex1;

  bin2bcd #(
    .W(7),
    .N(8)
  ) bin2bcd_inst (
    .clock(clock),
    .reset(reset),
    .start(s_start),
    .binary(bin_teste),
    .pronto(pronto),
    .bcd({s_hex1, s_hex0})
  );

  hexa7seg HEX0 (
    .hexa(s_hex0),
    .display(hex0)
  );

  hexa7seg HEX1 (
    .hexa(s_hex1),
    .display(hex1)
  );

  edge_detector ED (
    .clock(clock),
    .reset(reset),
    .sinal(start),
    .pulso(s_start)
  );

endmodule