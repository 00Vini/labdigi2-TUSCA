module rx_serial_dp #(
    // Comprimento de uma palavra a ser enviada para a UART
    // Baud Rate
    parameter BAUD_RATE = 9600,
    // Frequencia do sinal de clock utilizado no sistema
    parameter CLOCK_HZ = 50_000_000,
    // numero de data bits por transmissao
    parameter N_BITS = 8,
    // PARITY = 1 --> Odd
    parameter PARITY = 1 
) (
    input clock,
    input reset,
    input zera,
    input rxd,
    input conta_tick, 
    input registra_dados,
    input registra_parity,
    input desloca,
    output counter_half,
    output counter_finished,
    output receive_finished,
    output parity_check,
    output [N_BITS - 1: 0] data
);

    // Quantidade de nanosegundos para enviar 1 bit
    localparam BITS_PNS = 1_000_000_000 * 1/BAUD_RATE;
    // Periodo do sinal de clock em nano segundos
    localparam CLK_PNS = 1_000_000_000 * 1/CLOCK_HZ;
    // Numeros de ciclos de clock por bit de dados
    localparam CLK_P_BIT = BITS_PNS / CLK_PNS;
    // Tamanho registrador de contagem
    localparam COUNTER_LEN = $clog2(CLK_P_BIT);
    // Tamanho do registrador de contagem de bits recebidos
    localparam DATA_LEN = $clog2(N_BITS);

    wire [N_BITS - 1: 0] current_data; // dados recebidos
    wire sample;
    wire parity, s_parity_check;
    wire [$clog2(CLK_P_BIT) - 1:0] q; 
    assign parity = PARITY ? ~^current_data : ^current_data;
    assign s_parity_check = parity ~^ sample; // parity_check = 0 -> falha

    contador_m #( 
        .M(CLK_P_BIT), 
        .N($clog2(CLK_P_BIT)) 
    ) contador_tick (
        .clock   ( clock            ),
        .zera_as ( zera             ),
        .zera_s  ( 1'b0             ),
        .conta   ( conta_tick       ),
        .Q       ( q                ),
        .fim     ( counter_finished ),
        .meio    ( counter_half     )
    );

    contador_m #( 
        .M(N_BITS), 
        .N($clog2(N_BITS)) 
    ) conta_dados (
        .clock   ( clock            ),
        .zera_as ( zera             ),
        .zera_s  ( 1'b0             ),
        .conta   ( desloca          ),
        .Q       (                  ),
        .fim     ( receive_finished ),
        .meio    (                  )
    );

    // Instanciação do deslocador_n
    deslocador_n #(
        .N(N_BITS) 
    ) U1 (
        .clock         ( clock                ),
        .reset         ( reset                ),
        .carrega       ( zera                 ),
        .desloca       ( desloca              ),
        .entrada_serial( sample               ), 
        .dados         ( {N_BITS {1'b0}}      ),
        .saida         ( current_data         )
    );

    registrador_n #(
        .N(1)
    ) reg_sample (
        .clock (clock),
        .clear (zera),
        .enable(counter_half),
        .D     (rxd),
        .Q     (sample)
    );

    registrador_n #(
        .N(1)
    ) reg_parity_check (
        .clock ( clock           ),
        .clear ( zera            ),
        .enable( registra_parity ),
        .D     ( s_parity_check  ),
        .Q     ( parity_check    )
    );

    registrador_n #(
        .N(N_BITS)
    ) reg_dados (
        .clock (clock),
        .clear (zera),
        .enable(registra_dados),
        .D     (current_data),
        .Q     (data)
    );


endmodule