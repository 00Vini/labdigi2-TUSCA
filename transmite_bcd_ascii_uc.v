module transmite_bcd_ascii_uc (
  input clock,
  input reset,
  input transmite_bcd,
  input pronto_transmissao_bcd,
  output inicio_transmissao_bcd,
  output seletor_valor,
  output pronto
);

  localparam IDLE = 3'd0,
             TRANSMITE1 = 3'd1,
             ESPERA_TRANSMITE1 = 3'd2,
             TRANSMITE2 = 3'd3,
             ESPERA_TRANSMITE2 = 3'd4,
             FIM = 3'd5;

  reg [2:0] Eatual, Eprox;

  always @(posedge clock or posedge reset) begin
    if (reset)
      Eatual <= IDLE;
    else
      Eatual <= Eprox;
  end

  always @* begin
    case (Eatual)
      IDLE: Eprox = transmite_bcd ? TRANSMITE1 : IDLE;
      TRANSMITE1: Eprox = ESPERA_TRANSMITE1;
      ESPERA_TRANSMITE1: Eprox = pronto_transmissao_bcd ? TRANSMITE2 : ESPERA_TRANSMITE1;
      TRANSMITE2: Eprox = ESPERA_TRANSMITE2;
      ESPERA_TRANSMITE2: Eprox = pronto_transmissao_bcd ? FIM : ESPERA_TRANSMITE2;
      FIM: Eprox = IDLE;
    endcase
  end

  assign seletor_valor = (Eatual == TRANSMITE1 || Eatual == ESPERA_TRANSMITE1) ? 1'b1 :
                         (Eatual == TRANSMITE2 || Eatual == ESPERA_TRANSMITE2) ? 1'b0 : 1'b0;

  assign inicio_transmissao_bcd = (Eatual == TRANSMITE1 || Eatual == TRANSMITE2);
  assign pronto = Eatual == FIM;


endmodule