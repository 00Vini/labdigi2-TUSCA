module tusca_tb;

  localparam CLOCK_PERIOD = 20; // f = 50MHz

  reg clock, reset, start, definir_config, gira, rx_serial_medida, rx_serial_config;
  wire medir_dht11_out, erro_config, rele, pwm_ventoinha, pwm_servo;

  task envia_serial;
    input[7:0] msg;
    input wrong_parity;
    input canal; // 0 = config, 1 = medida
    localparam CLK_P_BIT_0 = (1_000_000_000 * 1/115200) / (1_000_000_000 * 1/50_000_000);
    localparam CLK_P_BIT_1 = (1_000_000_000 * 1/9600) / (1_000_000_000 * 1/50_000_000);
    integer i;
    begin: envia_serial
      reg [10:0] msg_final;
      msg_final = {1'b1, wrong_parity ? ^msg : ~(^msg), msg, 1'b0};
      for (i = 0; i < 10; i = i + 1) begin
        @(negedge clock);
        // envia bit
        if (canal == 1) begin
          rx_serial_medida = msg_final[i];
        end
        else begin
          rx_serial_config = msg_final[i];
        end
        // espera uart receber
        if (canal == 1) begin
          #(CLK_P_BIT_1 * CLOCK_PERIOD);
        end
        else begin
          #(CLK_P_BIT_0 * CLOCK_PERIOD);
        end
      end
      rx_serial_medida = 1'b1;
      rx_serial_config = 1'b1;
      if (canal == 1) begin
          #(1*CLK_P_BIT_1 * CLOCK_PERIOD);
        end
        else begin
          #(1*CLK_P_BIT_0 * CLOCK_PERIOD);
        end
    end
  endtask

  task envia_16b;
  input [15:0] msg;
  input canal;
  begin
    envia_serial(msg[7:0], 0, canal);
    envia_serial(msg[15:8], 0, canal);
  end
  endtask

  always #(CLOCK_PERIOD/2) clock = ~clock;

  tusca #(
    .PERIODO_DELAY(3500) //5us 
  ) UUT (
    .clock(clock),
    .reset(reset),
    .start(start),
    .definir_config(definir_config),
    .gira(gira),
    .rx_serial_medida(rx_serial_medida),
    .rx_serial_config(rx_serial_config),
    .medir_dht11_out(medir_dht11_out),
    .erro_config(erro_config),
    .rele(rele),
    .pwm_ventoinha(pwm_ventoinha),
    .pwm_servo(pwm_servo),
    .db_sel(),
    .db_estado(),
    .db_estado_interface_dht11(),
    .db_estado_config_manager(),
    .db_estado_recepcao_config(),
    .db_estado_recepcao_medida(),
    .db_mux(),
    .db_nivel_temperatura(),
    .db_pwm_ventoinha(),
    .db_pwm_servo(),
    .db_rx_serial_config(),
    .db_rx_serial_medida()
  );

  initial begin
    clock = 0;
    rx_serial_config = 1;
    rx_serial_medida = 1;
    definir_config = 0;
    gira = 0;
    
    reset = 1;
    #40;
    reset = 0;

    start = 1;
    #20;
    start = 0;
    #30000;
    envia_16b(16'h2202, 1); // Temperatura
    envia_16b(16'h1234, 1); // Umidade

    definir_config = 1'b1;
    #40;
    definir_config = 1'b0;
    envia_16b(16'h1000, 0);
    envia_16b(16'h2001, 0);
    envia_16b(16'h3002, 0);
    envia_16b(16'h4003, 0);
    envia_16b(16'h1111, 0);

    
    #200000;
    $stop;
  end

endmodule