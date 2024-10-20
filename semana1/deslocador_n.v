/* ------------------------------------------------------------------
 * Arquivo   : deslocador_n.vhd
 * ------------------------------------------------------------------
 * Descricao : deslocador  
 *             > parametro N: numero de bits
 *
 * ------------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     09/09/2021  1.0     Edson Midorikawa  versao inicial em VHDL
 *     27/08/2024  3.0     Edson Midorikawa  conversão para Verilog
 * ------------------------------------------------------------------
 */
 
module deslocador_n #(
    parameter N = 4
) (
    input wire         clock,
    input wire         reset,
    input wire         carrega,
    input wire         desloca,
    input wire         entrada_serial,
    input wire [N-1:0] dados,
    output     [N-1:0] saida
);

    reg [N-1:0] IQ;

    always @(posedge clock, posedge reset) begin
        if (reset) begin
            IQ <= {N{1'b1}}; // Inicializa com todos os bits em '1'
        end else begin
            if (carrega) begin
                IQ <= dados;
            end else if (desloca) begin
                IQ <= {entrada_serial, IQ[N-1:1]}; // Deslocamento à direita
            end else begin
                IQ <= IQ;    // Mantém o valor atual
            end
        end
    end

    assign saida = IQ;

endmodule