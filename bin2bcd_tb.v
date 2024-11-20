`timescale 1ns/1ns

module bin2bcd_tb;

  reg[6:0] bin;
  reg start, clock, reset;
  wire [7:0] bcd;
  wire done;

  bin2bcd #(
    .W(7),
    .N(8)
  ) UUT (
    .clock(clock),
    .reset(reset),
    .start(start),
    .binary(bin),
    .pronto(done),
    .bcd(bcd)
  );

  always #10 clock = ~clock;

  initial begin
    clock = 0;
    reset = 0;
    start = 0;

    #100 reset = 1;
    #100 reset = 0;
    #100 bin = 7'd98;
    #100 start = 1;
    #100 start = 0;
    wait (done == 1);
    #100 $stop;
  end

endmodule
