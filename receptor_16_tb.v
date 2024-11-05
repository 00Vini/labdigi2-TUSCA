`timescale 1ns/1ns

module receptor_16_tb;

  localparam CLOCK_PERIOD = 20; // 50 MHz

  reg clock, reset, rx_serial;
  wire[15:0] data_out;
  wire pronto, erro;

  task envia_serial;
    input[7:0] msg;
    input wrong_parity;
    localparam CLK_P_BIT = (1_000_000_000 * 1/115200) / (1_000_000_000 * 1/50_000_000);
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

  receptor_config receptor_config (
    .clock(clock),
    .reset(reset),
    .rx_serial(rx_serial),
    .data_out(data_out),
    .erro(erro),
    .pronto(pronto)
  );

  always #(CLOCK_PERIOD/2) clock = ~clock;

  initial begin
    clock = 0;
    rx_serial = 1;
    reset = 0;

    reset = 1;
    #40;
    reset = 0;
    #1000;

    // Esperado: 2c88
    envia_serial(8'h88, 0);
    envia_serial(8'h2c, 0);

    #1000;
    $stop;
  end


endmodule