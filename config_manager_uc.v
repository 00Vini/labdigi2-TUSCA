module config_manager_uc (
  input clock,
  input reset,
  input receber_config,

  output load_lim_um,
  output load_temp1,
  output load_temp2,
  output load_temp3,
  output load_temp4,
  output pronto_config,
  output erro_config,

  input fim_recepcao_config,
  input parity_config_ok
);

  localparam INICIAL = 3'd0,
             RECEBE_TEMP1 = 3'd1,
             RECEBE_TEMP2 = 3'd2,
             RECEBE_TEMP3 = 3'd3,
             RECEBE_TEMP4 = 3'd4,
             RECEBE_UMIDADE = 3'd5,
             ERRO           = 3'd6,
             FIM_CONFIG     = 3'd7;

  reg [2:0] Eatual, Eprox;

  always @(posedge clock or posedge reset) begin
    if (reset)
      Eatual <= INICIAL;
    else
      Eatual <= Eprox;
  end

  always @* begin
    case (Eatual)
      INICIAL: Eprox = receber_config ? RECEBE_TEMP1 : INICIAL;
      RECEBE_TEMP1: Eprox = fim_recepcao_config ? (parity_config_ok ? RECEBE_TEMP2 : ERRO) : RECEBE_TEMP1;
      RECEBE_TEMP2: Eprox = fim_recepcao_config ? (parity_config_ok ? RECEBE_TEMP3 : ERRO) : RECEBE_TEMP2;
      RECEBE_TEMP3: Eprox = fim_recepcao_config ? (parity_config_ok ? RECEBE_TEMP4 : ERRO) : RECEBE_TEMP3;
      RECEBE_TEMP4: Eprox = fim_recepcao_config ? (parity_config_ok ? RECEBE_UMIDADE : ERRO) : RECEBE_TEMP4;
      RECEBE_UMIDADE: Eprox = fim_recepcao_config ? (parity_config_ok ? FIM_CONFIG : ERRO) : RECEBE_UMIDADE;
      FIM_CONFIG: Eprox = INICIAL;
      ERRO: Eprox = INICIAL;
      default: Eprox = INICIAL;
    endcase
  end

  assign pronto_config = (Eatual == FIM_CONFIG || Eatual == ERRO);
  assign erro_config = (Eatual == ERRO);
  assign {
    load_temp1,
    load_temp2,
    load_temp3,
    load_temp4,
    load_lim_um
  } = (Eatual == RECEBE_TEMP1)   ? 5'b10000 :
      (Eatual == RECEBE_TEMP2)   ? 5'b01000 :
      (Eatual == RECEBE_TEMP3)   ? 5'b00100 :
      (Eatual == RECEBE_TEMP4)   ? 5'b00010 :
      (Eatual == RECEBE_UMIDADE) ? 5'b00001 :
      5'b00000;

endmodule