/*
 * tx_serial_701_fd.v
 */
 
 module tx_serial_8O1_fd (
    input                   clock       ,
    input        	        reset       ,
    input        	        zera        ,
    input                   conta       ,
    input                   carrega     ,
    input                   desloca     ,
    input  [7:0] 	        dados_ascii ,
    output                  saida_serial,
    output                  fim         ,
    output [$clog2(12)-1:0] db_contagem
);

    wire [11:0] s_dados;
    wire [11:0] s_saida;

    // composicao dos dados seriais
    assign s_dados[0]   = 1'b1;             // repouso
    assign s_dados[1]   = 1'b0;             // start bit
    assign s_dados[9:2] = dados_ascii[6:0]; // dado
    assign s_dados[10]   = ~(^dados_ascii[6:0]); // paridade ímpar
    assign s_dados[11]  = 1'b1;             // stop bit
  
    // Instanciação do deslocador_n
    deslocador_n #(
        .N(12) 
    ) U1 (
        .clock         (clock  ),
        .reset         (reset  ),
        .carrega       (carrega),
        .desloca       (desloca),
        .entrada_serial(1'b1   ), 
        .dados         (s_dados),
        .saida         (s_saida)
    );
    
    // Instanciação do contador_m
    contador_m #(
        .M(13),
        .N($clog2(13))
    ) U2 (
        .clock   (clock      ),
        .zera_as (1'b0       ),
        .zera_s  (zera       ),
        .conta   (conta      ),
        .Q       (db_contagem), // porta Q em aberto (desconectada)
        .fim     (fim        ),
        .meio    (           )  // porta meio em aberto (desconectada)
    );
    
    // Saida serial do transmissor
    assign saida_serial = s_saida[0];
  
endmodule
