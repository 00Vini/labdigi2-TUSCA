module rx_serial #(
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
    input rxd,
    output parity_check,
    output fim,
    output [N_BITS - 1: 0] data,
    output [2:0] db_estado
);

    wire zera;
    wire counter_finished, counter_half; 
    wire receive_finished;
    wire desloca;
    wire registra_dados, registra_parity;
    wire conta_tick;

    rx_serial_dp #(
        .BAUD_RATE(BAUD_RATE),
        .CLOCK_HZ(CLOCK_HZ),
        .N_BITS(N_BITS),
        .PARITY(PARITY)
    ) DP (
        .clock(clock),
        .reset(reset),
        .zera(zera),
        .rxd(rxd),
        .conta_tick(conta_tick), 
        .registra_dados(registra_dados),
        .registra_parity(registra_parity),
        .desloca(desloca),
        .counter_half(counter_half),
        .counter_finished(counter_finished),
        .receive_finished(receive_finished),
        .s_parity_check(parity_check),
        .data(data)
    );

    rx_serial_uc UC(
        .clock(clock),
        .reset(reset),
        .rxd(rxd),
        .counter_finished(counter_finished),
        .counter_half(counter_half),
        .receive_finished(receive_finished), 
        .conta_tick(conta_tick),
        .registra_dados(registra_dados),
        .registra_parity(registra_parity),
        .desloca(desloca),
        .zera(zera),
        .finished(fim),
        .db_estado(db_estado)
    );



endmodule