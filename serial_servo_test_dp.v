module serial_servo_test_dp #(
    parameter PERIODO_CONTA = 2000,
    // Comprimento de uma palavra a ser enviada para a UART
    // Baud Rate
    parameter BAUD_RATE = 9600,
    // Frequencia do sinal de clock utilizado no sistema
    parameter CLOCK_HZ = 50_000_000,
    // numero de data bits por transmissao
    parameter N_BITS = 7,
    // PARITY = 1 --> Odd
    parameter PARITY = 1 
) (
    input  clock,
    input  reset,
    input  rxd,
    input  partida_tx,
    input  gira,
    input  zera,
    output saida_serial,
    output fim_rx,
    output parity_check,
    output pronto_tx,
    output pwm,
    output [6:0] data_out,
    output [2:0] db_estado_rx
);

    wire [6:0] data;

    assign data_out = data;

    rx_serial # (
        .BAUD_RATE ( BAUD_RATE ),
        .CLOCK_HZ  ( CLOCK_HZ  ),
        .N_BITS    ( N_BITS    ),
        .PARITY    ( PARITY    )
    ) rx (
        .clock       ( clock        ),
        .reset       ( reset        ),
        .rxd         ( rxd          ),
        .parity_check( parity_check ),
        .fim         ( fim_rx       ),
        .data        ( data     ),
        .db_estado   (db_estado_rx)
    );

    tx_serial_7O1 #(
        .BAUD_RATE(BAUD_RATE)
    ) tx (
        .clock           ( clock        ),
        .reset           ( zera         ),
        .partida         ( partida_tx   ),
        .dados_ascii     ( data     ),
        .saida_serial    ( saida_serial ), 
        .pronto          ( pronto_tx    ),
        .db_clock        (              ), 
        .db_tick         (              ),
        .db_partida      (              ),
        .db_saida_serial (              ),
        .db_conta        (              ),
        .db_desloca      (              ),
        .db_estado       (              ),
        .db_contagem     (              ) 
    );

    controle_servo #( 
        .PERIODO_CONTA(PERIODO_CONTA)
    ) servo (
        .clock ( clock ),
        .reset ( reset ),
        .gira  ( gira  ),
        .pwm   ( pwm   )
    );

endmodule