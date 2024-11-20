module tusca_tb;

  localparam CLOCK_PERIOD = 20; // f = 50MHz

  reg clock, reset, start, definir_config, gira, rx_serial_medida, rx_serial_config;
  wire erro_config, rele, pwm_ventoinha, pwm_servo;
  wire dht_bus;
  reg dht_value, dht_dir;

  assign dht_bus = dht_dir ? dht_value : 1'bz;

  task medir_dht11;
  input[39:0] word;
  integer i;
  begin
    dht_dir = 0;
    #18000000;
    wait (dht_bus == 1);
    #20000;
    dht_dir = 1;
    dht_value = 0;
    #80000;
    dht_value = 1;
    #80000;
    for (i = 39; i >= 0; i = i - 1) begin
      dht_value = 0;
      #50000;
      dht_value = 1;
      if (word[i]) begin
        #70000;
      end
      else begin
        #27000;
      end
      #600;
    end
  end
  endtask

  task envia_serial;
    input[7:0] msg;
    input wrong_parity;
    input canal; // 0 = config, 1 = medida
    input[31:0] baud;
    integer i;
    reg[31:0] CLK_P_BIT;
    begin: envia_serial
      reg [10:0] msg_final;
      CLK_P_BIT = (1_000_000_000 * 1/baud) / (1_000_000_000 * 1/50_000_000);
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
        #(CLK_P_BIT * CLOCK_PERIOD);
      end
      rx_serial_medida = 1'b1;
      rx_serial_config = 1'b1;
      #(1*CLK_P_BIT * CLOCK_PERIOD);
    end
  endtask

  task envia_16b;
  input [15:0] msg;
  input canal;
  input wrong_parity;
  begin
    envia_serial(msg[7:0], wrong_parity, canal, canal ? 9600 : 115200);
    envia_serial(msg[15:8], wrong_parity, canal, canal ? 9600 : 115200);
  end
  endtask

  always #(CLOCK_PERIOD/2) clock = ~clock;

  tusca #(
    .PERIODO_DELAY(3500),
    .TIMEOUT(5000000)
  ) UUT (
    .clock(clock),
    .reset(reset),
    .start(start),
    .definir_config(definir_config),
    .gira(gira),
    .rx_serial_medida(rx_serial_medida),
    .rx_serial_config(rx_serial_config),
    .dht_bus(dht_bus),
    .erro_config(erro_config),
    .rele(rele),
    .pwm_ventoinha(pwm_ventoinha),
    .pwm_servo(pwm_servo),
    .db_sel(),
    .db_estado(),
    .db_estado_interface_dht11(),
    .db_estado_config_manager(),
    .db_estado_recepcao_config(),
    .db_estado_transmissao_medida(),
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
    medir_dht11(40'h1234220262);

    #700000 definir_config = 1'b1;
    #40;
    definir_config = 1'b0;
    envia_16b(16'h1000, 0, 0);
    envia_16b(16'h2001, 0, 0);
    envia_16b(16'h3002, 0, 0);
    envia_16b(16'h4003, 0, 0);
    envia_16b(16'h5004, 0, 0);
    envia_16b(16'h6003, 0, 0);
    envia_16b(16'h7008, 0, 0);
    envia_16b(16'h1111, 0, 0);

    medir_dht11(40'h2345aab2ab); // Temperatura


    
    #800000;
    $stop;
  end

endmodule