//========================
// testbench.sv
//========================
module testbench;
    logic clk, reset, s, done;
    logic init_mode;
    logic [2:0] init_addr;
    logic [7:0] init_data;
    logic [7:0] RAM_out [0:7];

    top uut (
        .clk(clk), .reset(reset), .s(s), .done(done),
        .init_mode(init_mode), .init_addr(init_addr), .init_data(init_data),
        .RAM_out(RAM_out)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        reset = 1; s = 0; init_mode = 1;

        // Load unsorted values into RAM
        init_addr = 0; init_data = 8'd90; #10;
        init_addr = 1; init_data = 8'd25; #10;
        init_addr = 2; init_data = 8'd60; #10;
        init_addr = 3; init_data = 8'd15; #10;
        init_addr = 4; init_data = 8'd30; #10;
        init_addr = 5; init_data = 8'd75; #10;
        init_addr = 6; init_data = 8'd45; #10;
        init_addr = 7; init_data = 8'd10; #10;

        init_mode = 0; reset = 0; #10;

        // Start sorting process
        s = 1; #10; s = 0;

        // Wait for sorting to complete
        wait (done);
        $display("\nSorting complete. Sorted RAM contents:");
        for (int i = 0; i < 8; i++) begin
            $display("RAM[%0d] = %0d", i, RAM_out[i]);
        end
        $stop;
    end
endmodule
