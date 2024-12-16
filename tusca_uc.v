module tusca_uc (
  input clock,
  input reset,
  input start,

  output medir_dht11,
  output conta_delay,
  output zera_delay,
  output transmite_medida,

  input definir_config,
  input fim_delay,
  input pronto_medida,
  input erro_medida,
  input pronto_config,
  input pronto_transmissao_medida,
  
  output [3:0] db_estado
);

  localparam INICIAL = 4'd0,
             MEDE = 4'd1,
             ESPERA_MEDIDA = 4'd2,
             RESETA_DELAY = 4'd3,
             ESPERA_DELAY = 4'd4,
             PEDIR_CONFIG = 4'd5,
             ESPERA_CONFIG = 4'd6,
             TRANSMITE_MEDIDA = 4'd7,
             ESPERA_TRANSMISSAO = 4'd8;

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
      INICIAL: Eprox = start ? MEDE : INICIAL;
      MEDE: Eprox = ESPERA_MEDIDA;
      ESPERA_MEDIDA: Eprox = pronto_medida ? TRANSMITE_MEDIDA : 
                             erro_medida   ? RESETA_DELAY : 
                             definir_config ? PEDIR_CONFIG : ESPERA_MEDIDA;
      TRANSMITE_MEDIDA: Eprox = ESPERA_TRANSMISSAO;
      ESPERA_TRANSMISSAO: Eprox = pronto_transmissao_medida ? RESETA_DELAY : ESPERA_TRANSMISSAO;
      RESETA_DELAY: Eprox = ESPERA_DELAY;
      ESPERA_DELAY: Eprox = fim_delay ? MEDE : (definir_config ? PEDIR_CONFIG : ESPERA_DELAY);
      PEDIR_CONFIG: Eprox = ESPERA_CONFIG;
      ESPERA_CONFIG: Eprox = pronto_config ? RESETA_DELAY : ESPERA_CONFIG;
      default: Eprox = INICIAL;
    endcase
  end

  assign conta_delay = (Eatual == ESPERA_DELAY);
  assign zera_delay = (Eatual == RESETA_DELAY);
  assign medir_dht11 = (Eatual == MEDE);
  assign transmite_medida = (Eatual == TRANSMITE_MEDIDA);

endmodule