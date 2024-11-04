/* --------------------------------------------------------------------------
 *  Arquivo   : interface_hcsr04_fd-PARCIAL.v
 * --------------------------------------------------------------------------
 *  Descricao : CODIGO PARCIAL DO fluxo de dados do circuito de interface  
 *              com sensor ultrassonico de distancia
 *              
 * --------------------------------------------------------------------------
 *  Revisoes  :
 *      Data        Versao  Autor             Descricao
 *      07/09/2024  1.0     Edson Midorikawa  versao em Verilog
 * --------------------------------------------------------------------------
 */
 
module interface_hcsr04_fd #(
    parameter MODULO_TIMEOUT = 1  
) (
    input wire         clock,
    input wire         reset,
    input wire         pulso,
    input wire         zera,
    input wire         conta_timeout,
    input wire         gera,
    input wire         registra,
    output wire        fim_medida,
    output wire        trigger,
    output wire        fim_timeout,
    output wire        fim,
    output wire [11:0] distancia
);

    // Sinais internos
    wire [11:0] s_medida;

    // (U1) pulso de 10us (500 clocks)
    gerador_pulso #(
        .largura(500) 
    ) gerador_trigger (
        .clock (clock  ),
        .reset (zera   ),
        .gera  (gera   ),
        .para  (1'b0   ), 
        .pulso (trigger  ),
        .pronto(       ) // (desconectado)
    );

    // (U2) medida em cm (R=2941 clocks)
    contador_cm #(
        .R(2941), 
        .N(12)
    ) contador_distancia (
        .clock  (clock          ),
        .reset  (zera           ),
        .pulso  (pulso          ), // echo
        .digito2(s_medida[11:8] ),
        .digito1(s_medida[7:4]  ),
        .digito0(s_medida[3:0]  ),
        .fim    (fim            ), // fim da resolução
        .pronto (fim_medida     ) //  medida completa
    );

    // (U3) registrador
    registrador_n #(
        .N(12)
    ) reg_distancia (
        .clock  (clock     ),
        .clear  (reset     ),
        .enable (registra  ),
        .D      (s_medida  ),
        .Q      (distancia )
    );

    // Contador para timeout
    contador_m #( 
      .M ( MODULO_TIMEOUT         ), 
      .N ( $clog2(MODULO_TIMEOUT) )
    ) contador_timer_echo (
    .clock   ( clock            ),
    .zera_as ( zera             ),
    .zera_s  ( 1'b0             ),
    .conta   ( conta_timeout    ),
    .Q       (                  ),
    .fim     ( fim_timeout      ),
    .meio    (                  )
  );

endmodule
