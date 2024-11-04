/* --------------------------------------------------------------------------
 *  Arquivo   : contador_cm_uc-PARCIAL.v
 * --------------------------------------------------------------------------
 *  Descricao : unidade de controle do componente contador_cm
 *              
 *              incrementa contagem de cm a cada sinal de tick enquanto
 *              o pulso de entrada permanece ativo
 *              
 * --------------------------------------------------------------------------
 *  Revisoes  :
 *      Data        Versao  Autor             Descricao
 *      07/09/2024  1.0     Edson Midorikawa  versao em Verilog
 * --------------------------------------------------------------------------
 */

module contador_cm_uc (
    input wire clock,
    input wire reset,
    input wire pulso,
    input wire tick,
    output reg zera_tick,
    output reg conta_tick,
    output reg zera_bcd,
    output reg pronto
);

    // Tipos e sinais
    reg [2:0] Eatual, Eprox; // 3 bits são suficientes para os estados

    // Parâmetros para os estados
    parameter inicial = 3'd0;
    parameter prepara = 3'd1;
    parameter conta = 3'd2;
    parameter fim = 3'd3;

    // Memória de estado
    always @(posedge clock, posedge reset) begin
        if (reset)
            Eatual <= inicial;
        else
            Eatual <= Eprox; 
    end

    // Lógica de próximo estado
    always @(*) begin
        case (Eatual)
            inicial: Eprox = pulso ? prepara : inicial;
            prepara: Eprox = conta;
            conta:   Eprox = pulso ? conta : fim;
            fim:     Eprox = inicial;
            default: Eprox = inicial;
        endcase
    end

    always @(*) begin
        conta_tick = Eatual == conta;
        zera_bcd = Eatual == prepara;
        zera_tick = Eatual == prepara;
        pronto = Eatual == fim;
    end


endmodule
