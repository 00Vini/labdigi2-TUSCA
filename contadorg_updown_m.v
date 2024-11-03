/*
 * contadorg_updown_m.v
 */
 
module contadorg_updown_m #(
    parameter M = 50,  // Modulus of the counter
    parameter N = 6     // Number of bits for the output
) (
    input          clock,
    input          zera_as,
    input          zera_s,
    input          conta,
    output [N-1:0] Q,
    output reg     inicio,
    output reg     fim,
    output reg     meio,
    output wire    direcao
);

    reg [N-1:0] IQ; 
    reg         dir;

    always @(posedge clock, posedge zera_as) begin
        if (zera_as) begin
            IQ  <= 0;
            dir <= 0;
        end
        else if (clock) begin
            if (zera_s) begin
                IQ  <= 0;
                dir <= 0;
            end
            else if (conta) begin
                if (dir == 0) begin // Counting up
                    if (IQ == M - 1) begin
                        IQ <= M - 2;
                        dir <= 1; // Change direction to down
                    end else begin
                        IQ <= IQ + 1'b1; 
                    end
                end else begin        // Counting down
                    if (IQ == 0) begin
                        IQ <= 1;
                        dir <= 0; // Change direction to up
                    end else begin
                        IQ <= IQ - 1'b1;
                    end 
                end
            end else 
                IQ <= IQ; // Hold current value if not counting
        end
    end

    // Output assignments
    assign Q = IQ;
    assign direcao = dir;

    always @(*) begin // Combinational logic for inicio, fim, and meio
        inicio = (IQ == 0);
        fim    = (IQ == M - 1);
        meio   = (IQ == M / 2 - 1);
    end

endmodule