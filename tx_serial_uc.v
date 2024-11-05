/* ----------------------------------------------------------------
 * Arquivo   : tx_serial_uc.v
 * Projeto   : Experiencia 2 - Comunicacao Serial Assincrona
 * ----------------------------------------------------------------
 * Descricao : unidade de controle do circuito da experiencia 2 
 * > implementa superamostragem (tick)
 * > independente da configuracao de transmissao (7O1, 8N2, etc)
 * ----------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     09/09/2021  1.0     Edson Midorikawa  versao inicial em VHDL
 *     27/08/2024  4.0     Edson Midorikawa  conversao para Verilog
 * ----------------------------------------------------------------
 */

module tx_serial_uc ( 
    input      clock    ,
    input      reset    ,
    input      partida  ,
    input      tick     ,
    input      fim      ,
    output reg zera     ,
    output reg conta    ,
    output reg carrega  ,
    output reg desloca  ,
    output reg pronto   ,
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
            inicial     : Eprox = partida ? preparacao : inicial;
            preparacao  : Eprox = espera;
            espera      : Eprox = tick ? transmissao : ( fim ? final_tx : espera );
            transmissao : Eprox = fim ? final_tx : espera;
            final_tx    : Eprox = inicial;
            default     : Eprox = inicial;
        endcase
    end

    // Logica de saida (maquina de Moore)
    always @* begin
        carrega = (Eatual == preparacao) ? 1'b1 : 1'b0;
        zera    = (Eatual == preparacao) ? 1'b1 : 1'b0;
        desloca = (Eatual == transmissao) ? 1'b1 : 1'b0;
        conta   = (Eatual == transmissao) ? 1'b1 : 1'b0;
        pronto  = (Eatual == final_tx) ? 1'b1 : 1'b0;

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
