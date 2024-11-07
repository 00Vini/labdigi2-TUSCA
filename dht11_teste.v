module dht11_teste(
    output[6:0] hex0,
    output[6:0] hex1,
    output[6:0] hex2,
    inout dht_bus,
    input clk,
    input reset,
    input start,
    output pronto,
    output error,
    output error_osc
);

    wire [15:0] temperatura, umidade;
    wire s_start;
    wire[3:0] s_db_estado;

    assign error_osc = error;

    dht11 dht11_inst(
        .dht_bus(dht_bus),
        .start(s_start),
        .clock(clk),
        .reset(reset),
        .temperatura(temperatura),
        .umidade(umidade),
        .pronto(pronto),
        .error(error),
        .db_estado(s_db_estado)
    );

    hexa7seg hexa7seg0(
        .hexa(temperatura[11:8]),
        .display(hex0)
    );

    hexa7seg hexa7seg1(
        .hexa(temperatura[15:12]),
        .display(hex1)
    );

    hexa7seg hexa7seg2(
        .hexa(db_estado),
        .display(hex2)
    );

    edge_detector edge_detector_inst(
        .clock(clk),
        .reset(reset),
        .sinal(start),
        .pulso(s_start)
    );



endmodule