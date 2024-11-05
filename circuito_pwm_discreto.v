
module circuito_pwm_discreto #( 
    parameter conf_periodo = 1250, // Período do sinal PWM [1250 => f=4KHz (25us)]
    parameter largura_00   = 0,    // Largura do pulso p/ 00 [0 => 0]
    parameter largura_01   = 50,   // Largura do pulso p/ 01 [50 => 1us]
    parameter largura_10   = 500,  // Largura do pulso p/ 10 [500 => 10us]
    parameter largura_11   = 1000  // Largura do pulso p/ 11 [1000 => 20us]
) (
    input        clock,
    input        reset,
    input  [1:0] largura,
    output reg   pwm
);

reg [31:0] contagem; 
reg [31:0] largura_pwm;

always @(posedge clock or posedge reset) begin
    if (reset) begin
        contagem <= 0;
        pwm <= 0;
        largura_pwm <= largura_00; 
    end else begin
        pwm <= (contagem < largura_pwm);

        if (contagem == conf_periodo - 1) begin
            contagem <= 0;
            case (largura)
                2'b00: largura_pwm <= largura_00;
                2'b01: largura_pwm <= largura_01;
                2'b10: largura_pwm <= largura_10;
                2'b11: largura_pwm <= largura_11;
                default: largura_pwm <= largura_00; 
            endcase
        end else begin
            contagem <= contagem + 1;
        end
    end
end

endmodule