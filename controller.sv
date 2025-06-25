//========================
// controller.sv
//========================
module controller(
    input logic clk, reset, s,
    input logic AgtB, zi, zj,
    output logic EA, EB, WR, Li, Lj, Ei, Ej, Csel, Bout, Rd,
    output logic done,
    output logic [2:0] i_out, j_out
);

    // FSM states represent steps in selection sort algorithm
    typedef enum logic [3:0] {
        IDLE, INIT, LOAD_I, LOAD_A,
        LOAD_J, LOAD_B, COMPARE, SWAP1, SWAP2,
        NEXT_J, CHECK_J, NEXT_I, CHECK_I, DONE
    } state_t;

    state_t state, next;
    logic [2:0] i, j;

    assign i_out = i;
    assign j_out = j;

    // Current state register
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            state <= IDLE;
        else
            state <= next;
    end

    // i and j index registers update based on current FSM state
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            i <= 0;
            j <= 1;
        end else begin
            case (state)
                LOAD_I: i <= 0;
                NEXT_I: i <= i + 1;
                LOAD_J: j <= i + 1;
                NEXT_J: j <= j + 1;
                default: ;
            endcase
        end
    end

    // FSM next state and control signal logic
    always_comb begin
        EA = 0;
        EB = 0;
        WR = 0;
        Li = 0;
        Lj = 0;
        Ei = 0;
        Ej = 0;
        Csel = 0;
        Bout = 0;
        Rd = 0;
        done = 0;
        next = state;

        case (state)
            IDLE:       if (s) next = INIT;
            INIT:       next = LOAD_I;
            LOAD_I:     begin Li = 1; next = LOAD_A; end
            LOAD_A:     begin EA = 1; next = LOAD_J; end
            LOAD_J:     begin Lj = 1; next = LOAD_B; end
            LOAD_B:     begin EB = 1; next = COMPARE; end
            COMPARE:    next = AgtB ? SWAP1 : CHECK_J;
            SWAP1:      begin Bout = 1; Csel = 1; WR = 1; next = SWAP2; end
            SWAP2:      begin Bout = 0; Csel = 0; WR = 1; EA = 1; next = CHECK_J; end
            CHECK_J:    next = (j == 3'd7) ? CHECK_I : NEXT_J;
            NEXT_J:     begin Ej = 1; next = LOAD_B; end
            CHECK_I:    next = (i == 3'd6) ? DONE : NEXT_I;
            NEXT_I:     begin Ei = 1; next = LOAD_I; end
            DONE:       done = 1;
        endcase
    end
endmodule
