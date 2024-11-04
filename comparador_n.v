module comparador_n #(
  parameter N = 8
) (
  input [N-1:0] A,
  input [N-1:0] B,

  output eq,
  output gt,
  output lt
 
);
  assign eq = A == B;
  assign lt = A < B;
  assign gt = A > B;
endmodule