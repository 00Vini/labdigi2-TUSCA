module rx_serial_uc (
    input clock,
    input reset,
    input rxd,
    input counter_finished,
    input counter_half,
    input receive_finished, 
    output reg conta_tick,
    output reg registra_dados,
    output reg registra_parity,
    output reg desloca,
    output reg zera,
    output reg finished
);

    localparam IDLE = 3'b000;
    localparam ARRANGE = 3'b001;
    localparam START = 3'b010;
    localparam RECEIVE = 3'b011;
    localparam SHIFT_DATA = 3'b100;
    localparam PARITY = 3'b101;
    localparam FINISH = 3'b110;

    reg[2:0] current_state;
    reg[2:0] next_state;

    // Memoria de estado
    always @(posedge clock or posedge reset) begin
        if (reset)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // Logica de proximo estado
    always @* begin
        case (current_state)
            IDLE: next_state = rxd ? IDLE : ARRANGE;
            ARRANGE: next_state = START;
            START: next_state = counter_finished ? RECEIVE : START;
            RECEIVE: next_state = counter_finished ? SHIFT_DATA : RECEIVE;
            SHIFT_DATA: next_state =  receive_finished? PARITY : RECEIVE;
            PARITY: next_state = counter_finished ? FINISH : PARITY;
            FINISH: next_state = counter_half ? IDLE : FINISH;
            default: next_state = IDLE;
        endcase
    end

    // Logica de saida (maquina de Moore)
    always @* begin
        conta_tick = (current_state == START) || (current_state == RECEIVE) || (current_state == PARITY) || (current_state == FINISH) ;
        zera = (current_state == ARRANGE);
        registra_dados = (current_state == FINISH);
        registra_parity = (current_state == FINISH);
        finished = (current_state == FINISH);
        desloca = (current_state == SHIFT_DATA);
    end


endmodule