`timescale 1ns/1ns

module serial_servo_test_tb ();
localparam PERIODO_CONTA = 2000;
localparam BAUD_RATE = 9600;
localparam CLOCK_HZ = 50_000_000;
localparam N_BITS = 7;
localparam PARITY = 1;

reg clock;
reg reset;
reg rxd;
reg transmite;
reg gira;
reg [N_BITS - 1:0] msg = "V";
wire saida_serial;
wire parity_check;
wire pwm;
wire fim_transmissao;
wire [6:0] db_estado, data_out;

    serial_servo_test #(
        .PERIODO_CONTA( PERIODO_CONTA ),
        .BAUD_RATE    ( BAUD_RATE     ),
        .CLOCK_HZ     ( CLOCK_HZ      ),
        .N_BITS       ( N_BITS        ),
        .PARITY       ( PARITY        )
    ) dut (
        .clock(clock),
        .reset(reset),
        .rxd(rxd),
        .transmite(transmite),
        .gira(gira),
        .saida_serial(saida_serial),
        .parity_check(parity_check),
        .pwm(pwm),
        .fim_transmissao(fim_transmissao),
        .data_out(data_out),
        .db_estado(db_estado)
    );

    localparam CLOCK_PERIOD = 20; // f = 50MHz

    // nanasegundos para enviar um bit
    localparam BITS_PNS = 1_000_000_000 * 1/BAUD_RATE;
    // Periodo do sinal de clock em nano segundos
    localparam CLK_PNS = 1_000_000_000 * 1/CLOCK_HZ;
    // Numeros de ciclos de clock por bit de dados
    localparam CLK_P_BIT = BITS_PNS / CLK_PNS;

    // Gerador de clock
    always #(CLOCK_PERIOD/2) clock = ~clock;

    integer i = 0;

    initial begin
        $display("Inicio simulacao");
        clock = 1'b0;
        rxd = 1'b1;
        reset = 1'b0;
        transmite = 1'b0;
        gira = 1'b0;
        @(negedge clock); // espera borda de descida
        // gera sinal de reset
        

        reset = 1;
        #(CLOCK_PERIOD);
        reset = 0;
        #(5 * CLOCK_PERIOD);

        transmite = 1'b1;
        gira = 1'b1;
        #(5 * CLOCK_PERIOD);

        $display("Inicio recepcao");
        // envia start bit
        rxd = 0;
        // espera uart receber start bit
        #(CLK_P_BIT * CLOCK_PERIOD);

        for (i = 0; i < N_BITS; i = i + 1) begin
            @(negedge clock);
            // envia bit
            rxd = msg[i];
            // espera uart receber 
            #(CLK_P_BIT * CLOCK_PERIOD);
        end

        // Envia paridade 
        rxd = ~^(msg);
        // espera uart receber 
        #(CLK_P_BIT * CLOCK_PERIOD);

        $display("Fim recepcao");
        // Sobe rxd e espera transmissão
        rxd = 1'b1;
        #(12 * CLK_P_BIT * CLOCK_PERIOD);
        $stop;
    end

endmodule