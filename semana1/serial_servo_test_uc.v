module serial_servo_test_uc (
    input  clock,
    input  reset,
    input  transmite,
    input  pronto_tx,
    input  fim_rx,
    output reg partida_tx,
    output reg zera,
    output reg fim_transmissao,
    output reg [3:0] db_estado
);
    // Estados da UC
    parameter inicial     = 4'b0000; 
    parameter preparacao  = 4'b0001; 
    parameter espera      = 4'b0011; 
    parameter transmissao = 4'b0111; 
    parameter final_tx    = 4'b1111;

    // Variaveis de estado
    reg [3:0] Eatual, Eprox;

    // Memoria de estado
    always @(posedge clock or posedge reset) begin
        if (reset)
            Eatual <= inicial;
        else
            Eatual <= Eprox;
    end

    // Logica de proximo estado
    always @* begin
        case (Eatual)
            inicial     : Eprox = transmite ? espera : inicial;
            espera      : Eprox = fim_rx ? preparacao : espera;
            preparacao  : Eprox = transmissao;
            transmissao : Eprox = pronto_tx ? final_tx : transmissao;
            final_tx    : Eprox = inicial;
            default     : Eprox = inicial;
        endcase
    end

    // Logica de saida (maquina de Moore)
    always @* begin
        zera = (Eatual == preparacao);
        partida_tx = (Eatual == transmissao);
        fim_transmissao = (Eatual == pronto_tx);

        // Saida de depuracao (estado)
        case (Eatual)
            inicial     : db_estado = 4'b0000; // 0
            preparacao  : db_estado = 4'b0001; // 1
            espera      : db_estado = 4'b0011; // 3
            transmissao : db_estado = 4'b0111; // 7
            final_tx    : db_estado = 4'b1111; // F
            default     : db_estado = 4'b1110; // E
        endcase
    end

endmodule