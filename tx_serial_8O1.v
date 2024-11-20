/*
 *
 */
 
module tx_serial_8O1 #(
    parameter BAUD_RATE = 9600
) (
    input                   clock           ,
    input                   reset           ,
    input                   partida         , // entradas
    input [7:0]             dados_ascii     ,
    output                  saida_serial    , // saidas
    output                  pronto          ,
    output                  db_clock        , // saidas de depuracao
    output                  db_tick         ,
    output                  db_partida      ,
    output                  db_saida_serial ,
    output                  db_conta        ,
    output                  db_desloca      ,
    output [6:0] 	        db_estado       , 
    output [$clog2(12)-1:0] db_contagem     
);
    localparam CONTAGEM_TICK = (BAUD_RATE == 115200) ? 434 : 5208;

    wire       s_reset        ;
    wire       s_partida      ;
    wire       s_zera         ;
    wire       s_conta        ;
    wire       s_carrega      ;
    wire       s_desloca      ;
    wire       s_tick         ;
    wire       s_fim          ;
    wire       s_saida_serial ;
    wire [3:0] s_estado       ;

    // sinais reset e partida (ativos em alto - GPIO)
    assign s_reset  = reset;
    assign s_partida = partida;
	 
    // fluxo de dados
    tx_serial_8O1_fd U1_FD (
        .clock        ( clock          ),
        .reset        ( s_reset        ),
        .zera         ( s_zera         ),
        .conta        ( s_conta        ),
        .carrega      ( s_carrega      ),
        .desloca      ( s_desloca      ),
        .dados_ascii  ( dados_ascii    ),
        .saida_serial ( s_saida_serial ),
        .fim          ( s_fim          ),
	    .db_contagem  ( db_contagem    )
    );


    // unidade de controle
    tx_serial_uc U2_UC (
        .clock     ( clock        ),
        .reset     ( s_reset      ),
        .partida   ( s_partida    ),
        .tick      ( s_tick       ),
        .fim       ( s_fim        ),
        .zera      ( s_zera       ),
        .conta     ( s_conta      ),
        .carrega   ( s_carrega    ),
        .desloca   ( s_desloca    ),
        .pronto    ( pronto       ),
        .db_estado ( s_estado     )
    );

    // gerador de tick
    // fator de divisao para 9600 bauds (5208=50M/9600) 13 bits
    // fator de divisao para 115.200 bauds (434=50M/115200) 9 bits
    contador_m #(
        .M(CONTAGEM_TICK),
        .N($clog2(CONTAGEM_TICK))
     ) U3_TICK (
        .clock   ( clock  ),
        .zera_as ( 1'b0   ),
        .zera_s  ( s_zera ),
        .conta   ( 1'b1   ),
        .Q       (        ),
        .fim     ( s_tick ),
        .meio    (        )
    );

    // saida serial
    assign saida_serial = s_saida_serial;

    // depuracao
    assign db_clock        = clock;
    assign db_tick         = s_tick;
    assign db_partida      = s_partida;
    assign db_saida_serial = s_saida_serial;
    assign db_conta        = s_conta;
    assign db_desloca      = s_desloca;

    // hexa0
    hexa7seg HEX0 ( 
        .hexa    ( s_estado  ), 
        .display ( db_estado )
    );
  
endmodule
