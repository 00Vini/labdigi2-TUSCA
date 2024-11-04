module controle_servo #(
    parameter PERIODO_CONTA = 2000
) (
    input wire  clock,
    input wire  reset,
    input wire  gira,
    output wire pwm
);


wire [31:0] largura;
wire clock_reduzido;

    circuito_pwm #(
        .conf_periodo(1000000), // f=50Hz;T=20ms,
        .N(50000)
    ) gerador_pwm (
        .clock(clock),
        .reset(reset),
        .largura(largura),
        .pwm(pwm)
    );

    contadorg_updown_m #(
        .M(50000),
        .N($clog2(50000))
    ) CONT_UPDOWN (
        .clock   ( clock_reduzido ),
        .zera_as ( reset          ),
        .zera_s  ( 1'b0           ),
        .conta   ( 1'b1           ),
        .Q       ( largura        ),
        .inicio  (                ),
        .fim     (                ),
        .meio    (                ),
        .direcao (                )
    );

    contador_m #( 
        .M(PERIODO_CONTA), 
        .N($clog2(PERIODO_CONTA)) 
    ) dut (
    .clock   ( clock          ),
    .zera_as ( reset          ),
    .zera_s  ( 1'b0           ),
    .conta   ( gira           ),
    .Q       (                ),
    .fim     ( clock_reduzido ),
    .meio    (                )
  );

endmodule