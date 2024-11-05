`timescale 1ns/1ns
module interface_dht11_tb;

  localparam CLOCK_PERIOD = 20; // f = 50MHz

  reg clock, reset, medir_dht11, rx_serial;
  wire pronto_medida, medir_out;
  wire [15:0] temeperatura_out, umidade_out;

  task envia_serial;
    input[7:0] msg;
    input wrong_parity;
    localparam CLK_P_BIT = (1_000_000_000 * 1/9600) / (1_000_000_000 * 1/50_000_000);
    integer i;
    begin: envia_serial
      reg [10:0] msg_final;
      msg_final = {1'b1, wrong_parity ? ^msg : ~(^msg), msg, 1'b0};
      for (i = 0; i < 10; i = i + 1) begin
        @(negedge clock);
        // envia bit
        rx_serial = msg_final[i];
        // espera uart receber 
        #(CLK_P_BIT * CLOCK_PERIOD);
      end
      rx_serial = 1'b1;
      #(3 * CLK_P_BIT * CLOCK_PERIOD);
    end
  endtask

  interface_dht11 UUT (
    .clock(clock),
    .reset(reset),
    .medir_dht11(medir_dht11),
    .rx_serial(rx_serial),
    .pronto_medida(pronto_medida),
    .temeperatura_out(temeperatura_out),
    .umidade_out(umidade_out),
    .medir_out(medir_out),
    .db_estado(),
    .db_estado_recepcao_medida()
  );

  always #(CLOCK_PERIOD/2) clock = ~clock;

  initial begin
    clock = 0;
    rx_serial = 1;
    
    reset = 1;
    #40;
    reset = 0;

    medir_dht11 = 1'b1;
    #20;
    medir_dht11 = 1'b0;
    #30000;
    wait (medir_out == 0);
    envia_serial(8'hba, 0);
    envia_serial(8'hde, 0);
    envia_serial(8'h12, 0);
    envia_serial(8'h34, 0);
    #100000;
    $stop;
  end

endmodule
