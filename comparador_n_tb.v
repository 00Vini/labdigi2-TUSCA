module comparador_n_tb;

    reg[15:0] A, B;
    wire eq, gt, lt;

    comparador_n #(.N(16)) UUT (
        .A(A),
        .B(B),
        .eq(eq),
        .gt(gt),
        .lt(lt)
    );

    initial begin
        $monitor("%b %b %b", eq, gt, lt);

        A = {8'd25, 8'd40};

        #100
        B = {8'd25, 8'd50};
    end

endmodule