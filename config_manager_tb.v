`timescale 1ns/1ns

module config_manager_tb;

  localparam CLOCK_PERIOD = 20; // f = 50MHz


  reg clock, reset, receber_config, rx_serial;
  wire erro_config, pronto_config;
  wire [15:0] temp_lim1_out, temp_lim2_out, temp_lim3_out, temp_lim4_out, umidade_lim_out;

  task envia_serial;
    input[15:0] msg;
    input wrong_parity;
    localparam CLK_P_BIT = (1_000_000_000 * 1/115200) / (1_000_000_000 * 1/50_000_000);
    integer i;
    begin: envia_serial
      reg [18:0] msg_final;
      msg_final = {1'b1, wrong_parity ? ^msg : ~(^msg), msg, 1'b0};
      for (i = 0; i < 19; i = i + 1) begin
        @(negedge clock);
        // envia bit
        rx_serial = msg_final[i];
        // espera uart receber 
        #(CLK_P_BIT * CLOCK_PERIOD);
      end
      #(3 * CLK_P_BIT * CLOCK_PERIOD);
    end
  endtask

  config_manager UUT (
    .clock(clock),
    .reset(reset),
    .receber_config(receber_config),
    .rx_serial(rx_serial),
    .temp_lim1_out(temp_lim1_out),
    .temp_lim2_out(temp_lim2_out),
    .temp_lim3_out(temp_lim3_out),
    .temp_lim4_out(temp_lim4_out),
    .umidade_lim_out(umidade_lim_out),
    .erro_config(erro_config),
    .pronto_config(pronto_config),
    .db_estado(),
    .db_estado_recepcao_config()
  );

  always #(CLOCK_PERIOD/2) clock = ~clock;

  initial begin
    clock = 0;
    rx_serial = 1;
    
    reset = 1;
    #40;
    reset = 0;

    receber_config = 1;
    #20;
    receber_config = 0;
    envia_serial(16'h1000, 0);
    envia_serial(16'h2001, 0);
    envia_serial(16'h3002, 0);
    envia_serial(16'h4003, 0);
    envia_serial(16'h5004, 0);

    #1000
    receber_config = 1;
    #20;
    receber_config = 0;
    receber_config = 0;
    envia_serial(16'h1000, 0);
    envia_serial(16'h2001, 1);
    envia_serial(16'h3002, 0);
    envia_serial(16'h4003, 0);
    envia_serial(16'h5004, 0);
    
    #10000;
    $stop;
  end

endmodule