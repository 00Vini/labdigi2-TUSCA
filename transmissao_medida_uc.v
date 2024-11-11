module transmissao_medida_uc (
  input clock,
  input reset,

  input transmite,
  input fim_contador,
  input pronto_transmissao,
  input pronto_bcd,

  output zera_contador,
  output conta_contador,
  output converte_bcd,
  output tx_transmite,
  output pronto
);

  localparam IDLE = 3'd0,
             PREPARA = 3'd1,
             CONVERTE = 3'd2,
             ESPERA_CONVERTE = 3'd3,
             TRANSMITE = 3'd4,
             ESPERA_TRANSMITE = 3'd5,
             PROXIMO = 3'd6,
             FIM = 3'd7;

  reg [2:0] Eatual, Eprox;

  always @(posedge clock or posedge reset) begin
    if (reset) begin
      Eatual <= IDLE;
    end else begin
      Eatual <= Eprox;
    end
  end

  always @* begin
    case (Eatual)
      IDLE: Eprox = transmite ? PREPARA : IDLE;
      PREPARA: Eprox = CONVERTE;
      CONVERTE: Eprox = ESPERA_CONVERTE;
      ESPERA_CONVERTE: Eprox = pronto_bcd ? TRANSMITE : ESPERA_CONVERTE;
      TRANSMITE: Eprox = ESPERA_TRANSMITE;
      ESPERA_TRANSMITE: Eprox = pronto_transmissao ? PROXIMO : ESPERA_TRANSMITE;
      PROXIMO: Eprox = fim_contador ? FIM : CONVERTE;
      FIM: Eprox = IDLE;
    endcase
  end

  assign zera_contador = Eatual == PREPARA;
  assign conta_contador = Eatual == PROXIMO;
  assign converte_bcd = Eatual == CONVERTE;
  assign tx_transmite = Eatual == TRANSMITE;
  assign pronto = Eatual == FIM;

endmodule