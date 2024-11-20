module config_manager_uc (
  input clock,
  input reset,
  input receber_config,

  output load_lim_um,
  output load_temp1,
  output load_temp2,
  output load_temp3,
  output load_temp4,
  output load_temp5,
  output load_temp6,
  output load_temp7,
  output pronto_config,
  output erro_config,

  input fim_recepcao_config,
  input parity_config_ok,
  output[2:0] db_estado
);

  localparam INICIAL = 4'd0,
             RECEBE_TEMP1 = 4'd1,
             RECEBE_TEMP2 = 4'd2,
             RECEBE_TEMP3 = 4'd3,
             RECEBE_TEMP4 = 4'd4,
             RECEBE_TEMP5 = 4'd5,
             RECEBE_TEMP6 = 4'd6,
             RECEBE_TEMP7 = 4'd7,
             RECEBE_UMIDADE = 4'd8,
             ERRO           = 4'd9,
             FIM_CONFIG     = 4'd10;

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
      INICIAL: Eprox = receber_config ? RECEBE_TEMP1 : INICIAL;
      RECEBE_TEMP1: Eprox = fim_recepcao_config ? (parity_config_ok ? RECEBE_TEMP2 : ERRO) : RECEBE_TEMP1;
      RECEBE_TEMP2: Eprox = fim_recepcao_config ? (parity_config_ok ? RECEBE_TEMP3 : ERRO) : RECEBE_TEMP2;
      RECEBE_TEMP3: Eprox = fim_recepcao_config ? (parity_config_ok ? RECEBE_TEMP4 : ERRO) : RECEBE_TEMP3;
      RECEBE_TEMP4: Eprox = fim_recepcao_config ? (parity_config_ok ? RECEBE_TEMP5 : ERRO) : RECEBE_TEMP4;
      RECEBE_TEMP5: Eprox = fim_recepcao_config ? (parity_config_ok ? RECEBE_TEMP6 : ERRO) : RECEBE_TEMP5;
      RECEBE_TEMP6: Eprox = fim_recepcao_config ? (parity_config_ok ? RECEBE_TEMP7 : ERRO) : RECEBE_TEMP6;
      RECEBE_TEMP7: Eprox = fim_recepcao_config ? (parity_config_ok ? RECEBE_UMIDADE : ERRO) : RECEBE_TEMP7;
      RECEBE_UMIDADE: Eprox = fim_recepcao_config ? (parity_config_ok ? FIM_CONFIG : ERRO) : RECEBE_UMIDADE;
      FIM_CONFIG: Eprox = INICIAL;
      ERRO: Eprox = receber_config ? RECEBE_TEMP1 : ERRO;
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
    load_temp5,
    load_temp6,
    load_temp7,
    load_lim_um
  } = (Eatual == RECEBE_TEMP1)   ? 8'b10000000 :
      (Eatual == RECEBE_TEMP2)   ? 8'b01000000 :
      (Eatual == RECEBE_TEMP3)   ? 8'b00100000 :
      (Eatual == RECEBE_TEMP4)   ? 8'b00010000 :
      (Eatual == RECEBE_TEMP5)   ? 8'b00001000 :
      (Eatual == RECEBE_TEMP6)   ? 8'b00000100 :
      (Eatual == RECEBE_TEMP7)   ? 8'b00000010 :
      (Eatual == RECEBE_UMIDADE) ? 8'b00000001 :
      8'b00000000;

endmodule