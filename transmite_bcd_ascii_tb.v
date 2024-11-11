`timescale 1ns/1ns

module transmite_bcd_ascii_tb;

  reg clock, reset, transmite_bcd;
  reg [7:0] bcd;
  wire pronto, tx_serial;

  transmite_bcd_ascii UUT (
    .clock(clock),
    .reset(reset),
    .bcd(bcd),
    .transmite_bcd(transmite_bcd),
    .pronto(pronto),
    .tx_serial(tx_serial)
  );

  always #5 clock = ~clock;

  initial begin
    clock = 0;
    reset = 0;
    transmite_bcd = 0;
    #100 reset = 1;
    #100 reset = 0;
    bcd = 8'h32; //0011 0010
    #100 transmite_bcd = 1;
    #100 transmite_bcd = 0;
    #250000 $stop;
  end

endmodule