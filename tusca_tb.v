`timescale 1ns/1ns
module tusca_tb;

  reg clk, reset;
  reg[15:0] tmp;
  wire rele, pwm_ventoinha;

  initial begin
    clk = 1'b0;
    
    reset = 1'b1;
    #40
    reset = 1'b0;

    tmp = {8'd18, 8'd5};
    #150000
    tmp = {8'd22, 8'd5};
    #150000
    tmp = {8'd27, 8'd2};
    #150000
    tmp = {8'd23, 8'd5};
    #150000
    tmp = {8'd32, 8'd5};
    #150000
    $stop;
  end

  always begin
    #5 clk = ~clk;
  end

  tusca_fd tusca_fd1 (
    .temp(tmp),
    .clock(clk),
    .reset(reset),
    .gira(1'b0),
    .rele(rele),
    .pwm_ventoinha(pwm_ventoinha)
  );

endmodule
