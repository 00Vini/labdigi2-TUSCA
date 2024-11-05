module double_registrador_n #(parameter N = 8) (
    input            clock,
    input            clear,
    input            load_high,
    input            load_low,
    input            load,
    input  [N/2-1:0] D_half,
    input  [N-1:0]   D,
    output [N-1:0]   Q
);

  reg [N-1:0] IQ;

  always @(posedge clock or posedge clear) begin
      if (clear)
        IQ <= 0;
      else if (load_low)
        IQ <= {IQ[N-1:N/2], D_half};
      else if (load_high)
        IQ <= {D_half, IQ[N/2-1:0]};
      else if (load)
        IQ <= D;

  end

  assign Q = IQ;

endmodule