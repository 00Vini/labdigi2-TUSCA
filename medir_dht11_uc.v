module medir_dht11_uc(
  input clock,
  input reset,
  input medir,
  input pronto_medida,
  input erro_medida,
  input fim_tentativas,
  input timeout,
  output zera_tentativas,
  output zera_timeout,
  output conta_tentativas,
  output conta_timeout,
  output start_medida,
  output reset_medida,
  output registra_medida,
  output pronto,
  output erro,
  output [2:0] db_estado
);

  localparam INICIAL = 3'd0,
             PREPARA = 3'd1,
             MEDIR = 3'd2,
             ESPERA_MEDIDA = 3'd3,
             ARMAZENAR = 3'd4,
             FIM_MEDIR = 3'd5,
             ERRO_MEDIR = 3'd6,
             ERRO_FINAL = 3'd7;

  reg[2:0] Eprox, Eatual;

  assign db_estado = Eatual;

  always @(posedge clock or posedge reset) begin
    if (reset)
            Eatual <= INICIAL;
        else
            Eatual <= Eprox;
  end

  always @* begin
    case (Eatual)
      INICIAL:       Eprox = medir ? PREPARA : INICIAL;
      PREPARA:       Eprox = MEDIR;
      MEDIR:         Eprox = ESPERA_MEDIDA;
      ESPERA_MEDIDA: Eprox = pronto_medida            ? ARMAZENAR     : 
                             !(timeout | erro_medida) ? ESPERA_MEDIDA : 
                             fim_tentativas           ? ERRO_FINAL    : ERRO_MEDIR;

      ERRO_MEDIR: Eprox = PREPARA;
      ARMAZENAR:  Eprox = FIM_MEDIR;
      ERRO_FINAL: Eprox = INICIAL;
      FIM_MEDIR:  Eprox = INICIAL;
      default:    Eprox = INICIAL;
    endcase
  end


  assign start_medida = (Eatual == MEDIR);
  
  assign reset_medida = (Eatual == PREPARA);
  assign zera_tentativas = (Eatual == INICIAL);
  assign zera_timeout = (Eatual == PREPARA);
  
  assign registra_medida = (Eatual == ARMAZENAR);

  assign conta_tentativas = (Eatual == ERRO_MEDIR);
  assign conta_timeout = (Eatual == ESPERA_MEDIDA);

  assign pronto = (Eatual == FIM_MEDIR);
  assign erro = (Eatual == ERRO_FINAL);


endmodule