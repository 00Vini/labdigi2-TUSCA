module serial_servo_test  #(
    parameter PERIODO_CONTA = 2000,
    parameter BAUD_RATE = 9600,
    parameter CLOCK_HZ = 50_000_000,
    parameter N_BITS = 7,
    parameter PARITY = 1 
) (
    input  clock,
    input  reset,
    input  rxd,
    input  transmite,
    input  gira,
    output saida_serial,
    output parity_check,
    output pwm,
    output fim_transmissao,
    output [6:0] data_out,
    output [6:0] db_estado
);

    wire zera;
    wire partida_tx, pronto_tx;
    wire [3:0] estado;
    wire fim_rx;

    serial_servo_test_dp #(
        .PERIODO_CONTA( PERIODO_CONTA ),
        .BAUD_RATE    ( BAUD_RATE     ),
        .CLOCK_HZ     ( CLOCK_HZ      ),
        .N_BITS       ( N_BITS        ),
        .PARITY       ( PARITY        )
    ) DP (
        .clock        ( clock        ),
        .reset        ( reset        ),
        .rxd          ( rxd          ),
        .partida_tx   ( partida_tx   ),
        .gira         ( gira         ),
        .zera         ( zera         ),
        .saida_serial ( saida_serial ),
        .fim_rx       ( fim_rx       ),
        .parity_check ( parity_check ),
        .pronto_tx    ( pronto_tx    ),
        .pwm          ( pwm          ),
        .data_out     ( data_out     )
    ); 

    serial_servo_test_uc UC (
        .clock           ( clock           ),
        .reset           ( reset           ),
        .transmite       ( transmite       ),
        .pronto_tx       ( pronto_tx       ),
        .fim_rx          ( fim_rx          ),
        .partida_tx      ( partida_tx      ),
        .zera            ( zera            ),
        .fim_transmissao ( fim_transmissao ),
        .db_estado       ( estado          )
    );

    hexa7seg estado_HEX (
        .hexa   ( estado    ),
        .display( db_estado )
    );

endmodule