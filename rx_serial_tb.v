`timescale 1ns/1ns

module rx_serial_tb;
    localparam BAUD_RATE = 9600;
    localparam CLOCK_HZ = 50_000_000;
    localparam PARITY = 1;
    localparam N_BITS = 8;

    // sinais de entrada para o circuito em teste
    reg clk_in;
    reg rxd_in;
    reg reset_in;
    reg [N_BITS - 1:0] msg = "V";
    wire [N_BITS - 1:0] data_out;
    wire finished_out;


    // unidade em teste
    rx_serial # (
        .BAUD_RATE ( BAUD_RATE ),
        .CLOCK_HZ  ( CLOCK_HZ  ),
        .N_BITS    ( N_BITS    ),
        .PARITY    ( PARITY    )
    ) dut (
        .clock       (clk_in),
        .reset       (reset_in),
        .rxd         (rxd_in),
        .parity_check(parity_check),
        .fim         (finished_out),
        .data        (data_out)
    );

    localparam CLOCK_PERIOD = 20; // f = 50MHz

    // nanasegundos para enviar um bit
    localparam BITS_PNS = 1_000_000_000 * 1/BAUD_RATE;
    // Periodo do sinal de clock em nano segundos
    localparam CLK_PNS = 1_000_000_000 * 1/CLOCK_HZ;
    // Numeros de ciclos de clock por bit de dados
    localparam CLK_P_BIT = BITS_PNS / CLK_PNS;


    // Gerador de clock
    always #(CLOCK_PERIOD/2) clk_in = ~clk_in;

    integer i = 0;

    initial begin
        $display("inicio da simulacao");

        // Condicoes iniciais
        clk_in   = 0;
        rxd_in   = 1;
        reset_in = 0;
        @(negedge clk_in); // espera borda de descida
        // gera sinal de reset
        reset_in = 1;
        #(CLOCK_PERIOD);
        reset_in = 0;
        #(5 * CLOCK_PERIOD);

        @(negedge clk_in);
        // envia start bit
        rxd_in = 0;
        // espera uart receber start bit
        #(CLK_P_BIT * CLOCK_PERIOD);
    

        for (i = 0; i < 8; i = i + 1) begin
            @(negedge clk_in);
            // envia bit
            rxd_in = msg[i];
            // espera uart receber 
            #(CLK_P_BIT * CLOCK_PERIOD);
        end
        
        // Envia paridade 
        rxd_in = ~^(msg);
        // espera uart receber 
        #(CLK_P_BIT * CLOCK_PERIOD);

        rxd_in = 1'b1;
        #(3 * CLK_P_BIT * CLOCK_PERIOD);

        // envia start bit
        rxd_in = 0;
        // espera uart receber start bit
        #(CLK_P_BIT * CLOCK_PERIOD);

        msg = "{";
        for (i = 0; i < 8; i = i + 1) begin
            @(negedge clk_in);
            // envia bit
            rxd_in = msg[i];
            // espera uart receber 
            #(CLK_P_BIT * CLOCK_PERIOD);
        end

        // Envia paridade 
        rxd_in = ^(msg);
        // espera uart receber 
        #(CLK_P_BIT * CLOCK_PERIOD);
        rxd_in = 1'b1;
        #(CLK_P_BIT * CLOCK_PERIOD);

        $display("fim da simulacao");
        $stop;
    end


    
endmodule