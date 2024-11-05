`timescale 1ns/1ns
module controle_ventoinha_tb;

  reg clk, reset;
  reg[1:0] nivel;
  wire rele, pwm_ventoinha;

  controle_ventoinha UUT (
    .clock(clk),
    .reset(reset),
    .s_nivel(nivel),
    .pwm_ventoinha(pwm_ventoinha)
  );


  initial begin
    clk = 1'b0;
    
    reset = 1'b1;
    #40
    reset = 1'b0;

    nivel = 2'b00;
    #150000
    nivel = 2'b01;
    #150000
    nivel = 2'b10;
    #150000
    nivel = 2'b11;
    #150000
    $stop;
  end

  always begin
    #5 clk = ~clk;
  end

endmodule
