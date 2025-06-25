//========================
// datapath.sv
//========================
module datapath(
    input logic clk, reset,
    input logic EA, EB, WR, Li, Lj, Ei, Ej, Csel, Bout, Rd,
    input logic [2:0] i_in, j_in,
    input logic init_mode,
    input logic [2:0] init_addr,
    input logic [7:0] init_data,
    output logic [7:0] Data_out,
    output logic AgtB,
    output logic zi, zj,
    output logic [7:0] RAM_dump [0:7] // used by testbench to inspect final RAM state
);

    logic [7:0] RAM [0:7];
    logic [2:0] i, j;
    logic [7:0] Ai, Aj, B;

    // Zero flags indicate when i or j are zero
    assign zi = (i == 3'd0);
    assign zj = (j == 3'd0);

    // Index registers i and j load or increment based on control signals
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            i <= 0;
            j <= 1;
        end else begin
            if (Li) i <= i_in;
            if (Lj) j <= j_in;
            if (Ei) i <= i + 1;
            if (Ej) j <= j + 1;
        end
    end

    // Registers A and B fetch RAM[i] and RAM[j] respectively
    always_ff @(posedge clk) begin
        if (EA) Ai <= RAM[i];
        if (EB) Aj <= RAM[j];
    end

    // B is assigned based on Bout signal; AgtB is comparison flag
    assign B = Bout ? Aj : Ai;
    assign AgtB = (Ai > Aj);

    // RAM update: write mode or preload mode for initialization
    always_ff @(posedge clk) begin
        if (init_mode)
            RAM[init_addr] <= init_data;
        else if (WR) begin
            if (Csel)
                RAM[i] <= B;
            else
                RAM[j] <= B;
        end
    end

    assign Data_out = Rd ? RAM[i] : 8'bZ;

    // Continuous exposure of RAM contents for monitoring in testbench
    genvar idx;
    generate
        for (idx = 0; idx < 8; idx++) begin
            always_comb begin
                RAM_dump[idx] = RAM[idx];
            end
        end
    endgenerate

endmodule