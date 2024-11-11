`timescale 1ns/1ns

module dht11_tb;

  parameter CLOCK_PERIOD = 20;

  wire dht_bus, error, pronto;
  reg start, reset, clock;
  wire [15:0] temperatura, umidade;
  reg dir, dht_bus_value;

  assign dht_bus = dir ? dht_bus_value : 1'bz;

  dht11 UUT (
    .dht_bus(dht_bus),
    .start(start),
    .clock(clock),
    .reset(reset),
    .temperatura(temperatura),
    .umidade(umidade),
    .error(error),
    .pronto(pronto),
    .db_estado()
  );

  always #(CLOCK_PERIOD / 2) clock = ~clock;

  task envia_bit;
  input bit;
    begin
      dir = 1;
      dht_bus_value = 0;
      #50000;
      dht_bus_value = 1;
      if (bit) begin
        #70000;
      end
      else begin
        #27000;
      end
      #600;
    end
  endtask

  task envia_palavra;
  input[39:0] word;
  integer i;
  begin
    for (i = 39; i >= 0; i = i - 1) begin
      envia_bit(word[i]);
    end
  end

  endtask

  initial begin
    clock = 0;
    dir = 0;
    start = 0;
    reset = 0;
    dht_bus_value = 1;

    reset = 1;
    #100;
    reset = 0;
    #100;

    start = 1;
    #20;
    start = 0;
    
    #18000000;
    #20000;
    dir = 1;
    dht_bus_value = 0;
    #80000;
    dht_bus_value = 1;
    #80000;
    envia_palavra(40'h12345abcde);
    #100000;

    dir = 0;
    start = 1;
    #20 start = 0;
    #18000000;
    #20000;
    dir = 1;
    dht_bus_value = 0;
    #80000;
    dht_bus_value = 1;
    #80000;
    envia_palavra(40'h98765fedcb);
    $stop;
  end

endmodule
