module bin2bcd #(
    parameter W = 18,
    parameter N = 24
) (
    input clock, 
    input reset, 
    input start , 
    input [W-1:0] binary, 
    output pronto, 
    output [N-1:0] bcd 
);
    // Estados
    localparam IDLE       = 3'd0,
               INICIALIZA = 3'd1,
               SHIFTA     = 3'd2,
               CORRIGE    = 3'd3,
               FIM        = 3'd4;
    reg [2:0] state, next_state;
               

    // Sinais do fluxo de dados
    reg [W - 1:0] Rbin;
    reg [N-1:0] Rbcd;
    wire [N-1:0] Rbcd_corrigido;
    reg [4:0] counter;

    // Sinais de saída
    assign pronto = (state == FIM);
    assign bcd = Rbcd;

    // Correção do valor
    genvar i;
    generate
        for (i=0; i < N; i = i + 4) begin: modulos_somadores
            assign Rbcd_corrigido[i+:4] = (Rbcd[i+:4] < 5) ? Rbcd[i+:4] : Rbcd[i+:4] + 4'd3;
        end
    endgenerate

    always @(posedge clock) begin
        // Contador
        if (state == INICIALIZA)
            counter <= {$clog2(W){1'b0}};
        else if (state == CORRIGE)
            counter <= counter + 1;
        else
            counter <= counter; 

        // Inicializa valores
        if (state == INICIALIZA) begin
            Rbin <= binary;
            Rbcd <= 0;
        end else if (state == SHIFTA) begin // Shift dos valores
            Rbin <= Rbin << 1;
            Rbcd <= {Rbcd[N-2:0], Rbin[W-1]};
        end else if (state == CORRIGE) // Aplica correção
            Rbcd <= Rbcd_corrigido;
        else if (state == FIM) // Finaliza
            Rbcd <= Rbcd;
    end

    // Transição de estados
    always @* begin
        case (state)
            IDLE:       next_state = start ? INICIALIZA : IDLE;
            INICIALIZA: next_state = SHIFTA;
            SHIFTA:     next_state = (counter == W-1) ? FIM : CORRIGE;
            CORRIGE:    next_state = SHIFTA;
            FIM:        next_state = start ? INICIALIZA : FIM;
        endcase
    end 

    // Estado
    always @(posedge clock or posedge reset) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

endmodule