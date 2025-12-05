module booth_algo_tb();

    reg  i_clk;
    reg  i_rst;

    reg  [3:0] i_multiplier;
    reg  [3:0] i_multiplicand;
    wire [8:0] o_multiplied_out;

    booth_algo inst_booth_algo(.i_clk(i_clk), .i_rst(i_rst), .i_multiplier(i_multiplier),
                               .i_multiplicand(i_multiplicand), .o_multiplied_out(o_multiplied_out)
                               );
    
    initial begin
        i_clk = 1;
        forever #20 i_clk = ~i_clk;
    end

    initial begin
        i_rst = 0;
        i_multiplier = 0;
        i_multiplicand = 0;
        #40
        i_rst = 1;
        i_multiplier = 4'd7;
        i_multiplicand = 4'd9;
        #5000;
        $finish;
    end

endmodule