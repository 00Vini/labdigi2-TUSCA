/* --------------------------------------------------------------------------
 *  Arquivo   : interface_hcsr04.v
 * --------------------------------------------------------------------------
 *  Descricao : circuito de interface com sensor ultrassonico de distancia
 *              
 * --------------------------------------------------------------------------
 *  Revisoes  :
 *      Data        Versao  Autor             Descricao
 *      07/09/2024  1.0     Edson Midorikawa  versao em Verilog
 * --------------------------------------------------------------------------
 */
 
module interface_hcsr04 #(
    parameter MODULO_TIMEOUT = 50_000_000 // 1s
) (
    input wire         clock,
    input wire         reset,
    input wire         medir,
    input wire         echo,
    output wire        trigger,
    output wire [11:0] medida,
    output wire        pronto,
    output wire [3:0]  db_estado
);

    // Sinais internos
    wire        s_zera;
    wire        s_gera;
    wire        s_registra;
    wire        s_fim_medida;
    wire        s_conta_timeout;
    wire        s_fim_timeout;
    wire [11:0] s_medida;

    // Unidade de controle
    interface_hcsr04_uc UC (
        .clock        (clock          ),
        .reset        (reset          ),
        .medir        (medir          ),
        .echo         (echo           ),
        .fim_timeout  (s_fim_timeout  ),
        .fim_medida   (s_fim_medida   ),
        .zera         (s_zera         ),
        .conta_timeout(s_conta_timeout),
        .gera         (s_gera         ),
        .registra     (s_registra     ),
        .pronto       (pronto         ),
        .db_estado    (db_estado      )
    );

    // Fluxo de dados
    interface_hcsr04_fd #(
        .MODULO_TIMEOUT(MODULO_TIMEOUT)
    ) FD (
        .clock        (clock          ),
        .reset        (reset          ),
        .pulso        (echo           ), 
        .zera         (s_zera         ),
        .conta_timeout(s_conta_timeout),
        .gera         (s_gera         ),
        .registra     (s_registra     ),
        .fim_medida   (s_fim_medida   ),
        .trigger      (trigger        ),
        .fim_timeout  (s_fim_timeout  ),
        .fim          (               ),
        .distancia    (s_medida       )
    );

    // Saída
    assign medida = s_medida; 

endmodule
