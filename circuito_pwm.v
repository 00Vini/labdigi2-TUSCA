module circuito_pwm #(    // valores default
    parameter conf_periodo = 1000000, // Período do sinal PWM [1250 => f=4KHz (25us)]
    parameter defasagem = conf_periodo/20, // Defasagem do sinal PWM
    parameter N = 50000
) (
    input        clock,
    input        reset,
    input [$clog2(N) - 1:0] largura,
    output reg   pwm
);

wire [$clog2(N) - 1:0] largura_real;
reg [31:0] contagem; // Contador interno (32 bits) para acomodar conf_periodo
reg [$clog2(N) - 1:0] largura_pwm;

always @(posedge clock or posedge reset) begin
    if (reset) begin
        contagem <= 0;
        pwm <= 0;
        largura_pwm <= defasagem; // Valor inicial da largura do pulso
    end else begin
        // Saída PWM
        pwm <= (contagem < largura_pwm + defasagem);

        // Atualização do contador e da largura do pulso
        if (contagem == conf_periodo - 1) begin
            contagem <= 0;
            largura_pwm <= largura;
            
        end else begin
            contagem <= contagem + 1;
        end
    end
end

endmodule