module tusca_uc (
  input clock,
  input reset,

  output medir_dht11,
  output conta_delay,
  output zera_delay,
  output receber_config,

  input definir_config,
  input fim_delay,
  input pronto_medida,
  input pronto_config
);

  localparam INICIAL = 3'd0,
             MEDE = 3'd1,
             ESPERA_MEDIDA = 3'd2,
             RESETA_DELAY = 3'd3,
             ESPERA_DELAY = 3'd4,
             ESPERA_CONFIG = 3'd5;

  reg [3:0] Eatual, Eprox;

  always @(posedge clock or posedge reset) begin
    if (reset)
            Eatual <= INICIAL;
        else
            Eatual <= Eprox;
  end

  always @* begin
    case (Eatual)
      INICIAL: Eprox = MEDE;
      MEDE: Eprox = ESPERA_MEDIDA;
      ESPERA_MEDIDA: Eprox = pronto_medida ? RESETA_DELAY : ESPERA_MEDIDA;
      RESETA_DELAY: Eprox = ESPERA_DELAY;
      ESPERA_DELAY: Eprox = fim_delay ? MEDE : (definir_config ? ESPERA_CONFIG : ESPERA_DELAY);
      ESPERA_CONFIG: Eprox = pronto_config ? RESETA_DELAY : ESPERA_CONFIG;
      default: Eprox = INICIAL;
    endcase
  end

  assign receber_config = (Eatual == ESPERA_CONFIG);

  assign conta_delay = (Eatual == ESPERA_DELAY);
  assign zera_delay = (Eatual == RESETA_DELAY);
  assign medir_dht11 = (Eatual == MEDE);

endmodule