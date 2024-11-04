module interface_dht11_uc (
  input clock,
  input reset,
  input medir_dht11,

  input fim_delay_sinal,
  input medida_ok,
  input fim_recepcao_medida,

  output conta_delay_sinal,
  output pronto_medida,
  output medir_out,
  output load_medida
);

  localparam INICIAL = 3'd0,
             MEDE = 3'd1,
             ESPERA_MEDIDA = 3'd2,
             ESPERA_DELAY_SINAL = 3'd3,
             FIM_MEDIDA = 3'd4,
             ARMAZENA_MEDIDA = 3'd5;

  reg [2:0] Eatual, Eprox;

  always @(posedge clock or posedge reset) begin
    if (reset)
      Eatual <= INICIAL;
    else
      Eatual <= Eprox;
  end

  always @* begin
    case (Eatual)
      INICIAL: Eprox = medir_dht11 ? MEDE : INICIAL;
      MEDE: Eprox = ESPERA_DELAY_SINAL;
      ESPERA_DELAY_SINAL: Eprox = fim_delay_sinal ? ESPERA_MEDIDA : ESPERA_DELAY_SINAL;
      ESPERA_MEDIDA: Eprox = fim_recepcao_medida ? (medida_ok ? ARMAZENA_MEDIDA : MEDE) : ESPERA_MEDIDA;
      ARMAZENA_MEDIDA: Eprox = FIM_MEDIDA;
      FIM_MEDIDA: Eprox = INICIAL;
      default: Eprox = INICIAL;
    endcase
  end

  assign load_medida = (Eatual == ARMAZENA_MEDIDA);
  assign conta_delay_sinal = (Eatual == ESPERA_DELAY_SINAL);
  assign pronto_medida = (Eatual == FIM_MEDIDA);
  assign medir_out = (Eatual == MEDE);

endmodule