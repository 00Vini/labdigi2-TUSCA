
module circuito_pwm_discreto #( 
    parameter conf_periodo,
    parameter largura_000,
    parameter largura_001,
    parameter largura_010,
    parameter largura_011,
    parameter largura_100,
    parameter largura_101,
    parameter largura_110,
    parameter largura_111
) (
    input        clock,
    input        reset,
    input  [2:0] largura,
    output reg   pwm
);

reg [31:0] contagem; 
reg [31:0] largura_pwm;

always @(posedge clock or posedge reset) begin
    if (reset) begin
        contagem <= 0;
        pwm <= 0;
        largura_pwm <= largura_000; 
    end else begin
        pwm <= (contagem < largura_pwm);

        if (contagem == conf_periodo - 1) begin
            contagem <= 0;
            case (largura)
                3'b000: largura_pwm <= largura_000;
                3'b001: largura_pwm <= largura_001;
                3'b010: largura_pwm <= largura_010;
                3'b011: largura_pwm <= largura_011;
                3'b100: largura_pwm <= largura_100;
                3'b101: largura_pwm <= largura_101;
                3'b110: largura_pwm <= largura_110;
                3'b111: largura_pwm <= largura_111;
                default: largura_pwm <= largura_000; 
            endcase
        end else begin
            contagem <= contagem + 1;
        end
    end
end

endmodule