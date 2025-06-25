//========================
// top.sv
//========================
module top(
    input logic clk, reset, s,
    input logic init_mode,
    input logic [2:0] init_addr,
    input logic [7:0] init_data,
    output logic done,
    output logic [7:0] RAM_out [0:7] // observable sorted output after done
);
    logic EA, EB, WR, Li, Lj, Ei, Ej, Csel, Bout, Rd;
    logic AgtB, zi, zj;
    logic [2:0] i_out, j_out;
    logic [7:0] Data_out;

    datapath dp(
        .clk(clk), .reset(reset),
        .EA(EA), .EB(EB), .WR(WR), .Li(Li), .Lj(Lj),
        .Ei(Ei), .Ej(Ej), .Csel(Csel), .Bout(Bout), .Rd(Rd),
        .i_in(i_out), .j_in(j_out),
        .init_mode(init_mode), .init_addr(init_addr), .init_data(init_data),
        .Data_out(Data_out),
        .AgtB(AgtB), .zi(zi), .zj(zj),
        .RAM_dump(RAM_out)
    );

    controller ctrl(
        .clk(clk), .reset(reset), .s(s),
        .AgtB(AgtB), .zi(zi), .zj(zj),
        .EA(EA), .EB(EB), .WR(WR), .Li(Li), .Lj(Lj), .Ei(Ei), .Ej(Ej),
        .Csel(Csel), .Bout(Bout), .Rd(Rd), .done(done),
        .i_out(i_out), .j_out(j_out)
    );

endmodule