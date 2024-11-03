/*
 *
 */

`timescale 1ns/1ns

module tx_serial_7O1_tb;

    // Declaração de sinais
    reg       clock_in;
    reg       reset_in;
    reg       partida_in;
    reg [6:0] dados_ascii_7_in;
    wire      saida_serial_out;
    wire      pronto_out;

    // Componente a ser testado (Device Under Test -- DUT)
    tx_serial_7O1 dut (
        .clock           ( clock_in         ),
        .reset           ( reset_in         ),
        .partida         ( partida_in       ),
        .dados_ascii     ( dados_ascii_7_in ),
        .saida_serial    ( saida_serial_out ),
        .pronto          ( pronto_out       ),
        .db_clock        (                  ), // Porta aberta (desconectada)
        .db_tick         (                  ), // Porta aberta (desconectada)
        .db_partida      (                  ), // Porta aberta (desconectada)
        .db_saida_serial (                  ), // Porta aberta (desconectada)
        .db_estado       (                  ), // Porta aberta (desconectada)
        .db_contagem     (                  ), // Porta aberta (desconectada)
	.db_desloca      (                  )
    );

    // Configuração do clock
    parameter clockPeriod = 20; // em ns, f=50MHz

    // Gerador de clock
    always #(clockPeriod / 2) clock_in = ~clock_in;

    // Vetor de teste
    reg [6:0] vetor_teste [0:3];
    integer caso;

    // Geração dos sinais de entrada (estímulos)
    initial begin
        $display("Inicio da simulacao");

        // Inicialização do vetor de teste
        vetor_teste[0] = 7'b0110101;  // 35h (5)
        vetor_teste[1] = 7'b1000101;  // 45h (E)
        vetor_teste[2] = 7'b1111110;  // 7Eh (~)
        vetor_teste[3] = 7'b1111111;  // 7Fh (DEL)

        // Valores iniciais
        clock_in   = 1'b0;
        reset_in   = 0;
        caso = 0;

        // Reset
        partida_in = 0;
        @(negedge clock_in); 
        reset_in = 1;
        #(20*clockPeriod);
        reset_in = 0;
        $display("... reset gerado");
        @(negedge clock_in);
        #(50*clockPeriod);

        // Casos de teste
        for (caso = 0; caso < 4; caso = caso + 1) begin
            $display("caso: %0d", caso);

            // Dado de entrada do vetor de teste
            dados_ascii_7_in = vetor_teste[caso];
            #(20*clockPeriod);

            // Acionamento da partida
            @(negedge clock_in);
            partida_in = 1;
            #(25*clockPeriod); 
            partida_in = 0;

            // Espera final da transmissão
            wait (pronto_out == 1'b1);

            // Intervalo entre casos de teste
            #(500*clockPeriod);
        end

        // Fim da simulação
        caso = 99;
        $display("Fim da simulacao");
        #(10*clockPeriod); // Aguarda um pequeno tempo para garantir que o clock pare
        $stop;
    end

endmodule
