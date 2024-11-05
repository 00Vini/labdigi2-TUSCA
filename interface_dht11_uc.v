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
  output load_temperatura,
  output load_umidade,
  output [2:0] db_estado
);

  localparam INICIAL = 3'd0,
              MEDE = 3'd1,
              ESPERA_DELAY_SINAL = 3'd2,
              ESPERA_TEMP = 3'd3,
              ARMAZENA_TEMP = 3'd4,
              ESPERA_UMIDADE = 3'd5,
              ARMAZENA_UMIDADE = 3'd6,
              FIM_MEDIDA = 3'd7;

  reg [2:0] Eatual, Eprox;

  assign db_estado = Eatual;

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
      ESPERA_DELAY_SINAL: Eprox = fim_delay_sinal ? ESPERA_TEMP : ESPERA_DELAY_SINAL;
      ESPERA_TEMP: Eprox = !fim_recepcao_medida ? ESPERA_TEMP : 
                           medida_ok ? ARMAZENA_TEMP : MEDE;
      ARMAZENA_TEMP: Eprox = ESPERA_UMIDADE;
      ESPERA_UMIDADE: Eprox = !fim_recepcao_medida ? ESPERA_UMIDADE : 
                           medida_ok ? ARMAZENA_UMIDADE : MEDE;
      ARMAZENA_UMIDADE: Eprox = FIM_MEDIDA;
      FIM_MEDIDA: Eprox = INICIAL;
      default: Eprox = INICIAL;
    endcase
  end

  assign load_temperatura = (Eatual == ARMAZENA_TEMP);
  assign load_umidade = (Eatual == ARMAZENA_UMIDADE);
  assign conta_delay_sinal = (Eatual == ESPERA_DELAY_SINAL);
  assign pronto_medida = (Eatual == FIM_MEDIDA);
  assign medir_out = (Eatual == ESPERA_DELAY_SINAL);

endmodule