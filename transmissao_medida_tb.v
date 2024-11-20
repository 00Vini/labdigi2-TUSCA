module transmite_medida_tb;

  reg clock, reset, transmite;
  reg [15:0] temperatura, umidade;
  wire pronto, tx_serial;

  transmissao_medida UUT (
    .clock(clock),
    .reset(reset),
    .temperatura(temperatura),
    .umidade(umidade),
    .transmite(transmite),
    .tx_serial(tx_serial),
    .pronto(pronto)
  );

  always #5 clock = ~clock;

  initial begin
    clock = 0;
    reset = 0;
    transmite = 0;
    #10 reset = 1;
    #100 reset = 0;
    temperatura = 15'h1524;
    umidade = 15'h095e;
    #100 transmite = 1;
    #100 transmite = 0;
    #420000 $stop;
  end

endmodule