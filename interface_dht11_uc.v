module interface_dht11_uc (
  input clock,
  input reset,
  input medir_dht11,

  input fim_delay_sinal,
  input medida_ok,
  input fim_recepcao_medida,
  input timeout,
  input fim_tentativas,

  output zera_tentativas,
  output conta_tentativas,
  output conta_timeout,
  output zera_timeout,
  output conta_delay_sinal,
  output pronto_medida,
  output erro,
  output medir_out,
  output load_temperatura,
  output load_umidade,
  output [2:0] db_estado
);

  localparam INICIAL = 4'd0,
              MEDE = 4'd1,
              ESPERA_DELAY_SINAL = 4'd2,
              ESPERA_TEMP = 4'd3,
              ARMAZENA_TEMP = 4'd4,
              ESPERA_UMIDADE = 4'd5,
              ARMAZENA_UMIDADE = 4'd6,
              FIM_MEDIDA = 4'd7,
              ERRO_MEDIDA = 4'd8,
              ERRO_FINAL = 4'd9;

  reg [3:0] Eatual, Eprox;

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
      ESPERA_TEMP: Eprox = (!medida_ok | timeout) ? ERRO_MEDIDA : 
                           !fim_recepcao_medida ? ESPERA_TEMP : ARMAZENA_TEMP; 
      ARMAZENA_TEMP: Eprox = ESPERA_UMIDADE;
      ESPERA_UMIDADE: Eprox = (!medida_ok | timeout) ? ERRO_MEDIDA :
                           !fim_recepcao_medida ? ESPERA_UMIDADE : ARMAZENA_UMIDADE;
      ERRO_MEDIDA: Eprox = fim_tentativas ? ERRO_FINAL : MEDE;
      ERRO_FINAL: Eprox = INICIAL;
      ARMAZENA_UMIDADE: Eprox = FIM_MEDIDA;
      FIM_MEDIDA: Eprox = INICIAL;
      default: Eprox = INICIAL;
    endcase
  end

  assign load_temperatura = (Eatual == ARMAZENA_TEMP);
  assign load_umidade = (Eatual == ARMAZENA_UMIDADE);
  assign conta_delay_sinal = (Eatual == ESPERA_DELAY_SINAL);
  assign pronto_medida = (Eatual == FIM_MEDIDA);
  assign erro = (Eatual == ERRO_FINAL);
  assign medir_out = (Eatual == ESPERA_DELAY_SINAL);
  assign conta_timeout = (Eatual == ESPERA_TEMP || Eatual == ESPERA_UMIDADE);
  assign zera_timeout = (Eatual == MEDE);
  assign zera_tentativas = (Eatual == INICIAL);
  assign conta_tentativas = (Eatual == ERRO_MEDIDA);
  

endmodule