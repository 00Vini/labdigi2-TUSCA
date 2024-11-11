module receptor_16_uc(
  input clock,
  input reset,
  input receber_config,
  input fim_receber,
  input parity_ok,
  
  output load_data_high,
  output load_data_low,
  output erro,
  output pronto,
  output [2:0] db_estado
);

  localparam RECEBE_1 = 3'd0,
             RECEBE_2 = 3'd1,
             CARREGA_1 = 3'd2,
             CARREGA_2 = 3'd3,
             FIM = 3'd4,
             ERRO = 3'd5;

  reg [2:0] Eatual, Eprox;

  assign db_estado = Eatual;

  always @(posedge clock or posedge reset) begin
    if (reset)
      Eatual <= RECEBE_1;
    else
      Eatual <= Eprox;
  end

  always @* begin
    case (Eatual)
      RECEBE_1: Eprox = !fim_receber ? RECEBE_1 : 
                      parity_ok ? CARREGA_1 : ERRO;
      CARREGA_1: Eprox = RECEBE_2;
      RECEBE_2: Eprox = !fim_receber ? RECEBE_2 : 
                      parity_ok ? CARREGA_2 : ERRO;
      CARREGA_2: Eprox = FIM;
      FIM: Eprox = RECEBE_1;
      ERRO: Eprox = RECEBE_1;
      default: Eprox = RECEBE_1;
    endcase
  end

  assign load_data_low = (Eatual == CARREGA_1);
  assign load_data_high = (Eatual == CARREGA_2);
  assign pronto = (Eatual == FIM);
  assign erro = (Eatual == ERRO);

endmodule