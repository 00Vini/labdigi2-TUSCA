`timescale 1ns / 1ns

module controle_servo_tb ();
    reg  clock;
    reg  reset;
    reg  gira;
    wire pwm;

    controle_servo #(
        .PERIODO_CONTA(2000)
    ) dut (
        .clock(clock),
        .reset(reset),
        .gira (gira),
        .pwm  (pwm)
    );

    // Configuração do clock
    parameter clockPeriod = 20; // em ns, f=50MHz

    // Gerador de clock
    always #(clockPeriod / 2) clock = ~clock;

    initial begin
        $display("Inicio simulacao");
        clock = 1'b0;
        reset = 1'b0;
        gira = 1'b0;

        #(2*clockPeriod);

        $display("Reset");
        reset = 1'b1;
        #(clockPeriod);
        reset = 1'b0;
        #(clockPeriod);

        $display("Giro = 1");
        gira = 1'b1;
        #(40_000_000);

        $display("Giro = 0");
        gira = 1'b0;
        #(3 * 20_000_000);

        $display("Fim da simulacao");
        $stop;
    end

endmodule