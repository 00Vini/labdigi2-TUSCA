module reg_medida (
    input clk,
    input reset,
    input enable,
    input [15:0] Din,
    output reg [15:0] Dout
);

    always @ (posedge clk or posedge reset) begin

        if (reset) begin
            Dout <= 16'b0;
        end
        else begin
            if(enable && ((Dout[15:11] == Din[15:11]) || Dout == 16'b0)) begin
                Dout <= Din;
            end else begin
                Dout <= Dout;
            end
        end

    end

endmodule