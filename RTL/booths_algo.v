module booth_algo(
    input wire i_clk,
    input wire i_rst,

    input [3:0] i_multiplier,
    input [3:0] i_multiplicand,
    output reg[8:0] o_multiplied_out
);

reg signed [3:0] r_A;
reg r_Qn_1;
reg  [3:0] r_Qr;                          // Multiplier
reg signed [3:0] r_M;                     // Multiplicand

reg signed [8:0] r_temp_out;
reg [2:0] r_count;

reg [4:0] next_state;
reg [4:0] present_state;

parameter S0_START_STATE = 5'b00001;
parameter S1_LOAD_STATE = 5'b00010;
parameter S2_COMPARISON_STATE = 5'b00100;
parameter S3_SHIFT_STATE = 5'b01000;
parameter S4_STOP_STATE = 5'b10000;

always@(*)begin
    case(present_state)
        S0_START_STATE : begin
            r_A = 'h0;
            r_Qn_1 = 0;
            r_Qr = 'h0;
            r_count = 'd4;
            o_multiplied_out = 'h0;
            next_state = S1_LOAD_STATE;
        end

        S1_LOAD_STATE : begin
            r_A = 'h0;
            r_Qn_1 = 0;
            r_M = i_multiplicand;
            r_Qr = i_multiplier;
            next_state = S2_COMPARISON_STATE;
        end

        S2_COMPARISON_STATE : begin
            if({r_Qr[0], r_Qn_1} == 2'b10)begin
                r_A = r_A - r_M;
                r_temp_out = {r_A, r_Qr, r_Qn_1};
                next_state = S3_SHIFT_STATE;
            end
            if({r_Qr[0], r_Qn_1} == 2'b01)begin
                r_A = r_A + r_M;
                r_temp_out = {r_A, r_Qr, r_Qn_1};
                next_state = S3_SHIFT_STATE;
            end
            if(({r_Qr[0], r_Qn_1} == 2'b00) ||({r_Qr[0], r_Qn_1} == 2'b11) )begin
                r_A = r_A;
                r_temp_out = {r_A, r_Qr, r_Qn_1};
                next_state = S3_SHIFT_STATE;
            end
        end
        S3_SHIFT_STATE : begin
            r_temp_out = (r_temp_out >>> 1);
            r_A = r_temp_out[8:5];
            r_Qr = r_temp_out[4:1];
            r_Qn_1 = r_temp_out[0];
            r_count = r_count - 1;
                if(r_count == 0)begin
                    next_state = S4_STOP_STATE;
                end
                else begin
                    next_state = S2_COMPARISON_STATE;
                end
        end

        S4_STOP_STATE : begin
                o_multiplied_out = r_temp_out >>> 1;
                next_state = S0_START_STATE;
        end
    endcase
end

always@(posedge i_clk or negedge i_rst)begin
    if(!i_rst)begin
        present_state <= S0_START_STATE;
    end
    else begin
        present_state <= next_state;
    end
end

endmodule
