<<<<<<< HEAD
module top;
    logic clk;
    logic rst_n;
    logic mem_en;
    logic mem_we;
    logic [9:0] mem_addr;
    logic [31:0] mem_wdata;
    logic [31:0] mem_rdata;

    // Clock Generation
    initial clk = 0;
    always #5 clk = ~clk;

    // DUT
    axi4_memory dut (
        .clk(clk),
        .rst_n(rst_n),
        .mem_en(mem_en),
        .mem_we(mem_we),
        .mem_addr(mem_addr),
        .mem_wdata(mem_wdata),
        .mem_rdata(mem_rdata)
    );

    // Assertions
    mem_sva checkers (
        .clk(clk),
        .rst_n(rst_n),
        .mem_en(mem_en),
        .mem_we(mem_we),
        .mem_addr(mem_addr),
        .mem_wdata(mem_wdata),
        .mem_rdata(mem_rdata)
    );

    // Testbench
    mem_testbench tb (
        .clk(clk),
        .rst_n(rst_n),
        .mem_en(mem_en),
        .mem_we(mem_we),
        .mem_addr(mem_addr),
        .mem_wdata(mem_wdata),
        .mem_rdata(mem_rdata)
    );

endmodule

=======
module top;
    logic clk;
    logic rst_n;
    logic mem_en;
    logic mem_we;
    logic [9:0] mem_addr;
    logic [31:0] mem_wdata;
    logic [31:0] mem_rdata;

    // Clock Generation
    initial clk = 0;
    always #5 clk = ~clk;

    // DUT
    axi4_memory dut (
        .clk(clk),
        .rst_n(rst_n),
        .mem_en(mem_en),
        .mem_we(mem_we),
        .mem_addr(mem_addr),
        .mem_wdata(mem_wdata),
        .mem_rdata(mem_rdata)
    );

    // Assertions
    mem_sva checkers (
        .clk(clk),
        .rst_n(rst_n),
        .mem_en(mem_en),
        .mem_we(mem_we),
        .mem_addr(mem_addr),
        .mem_wdata(mem_wdata),
        .mem_rdata(mem_rdata)
    );

    // Testbench
    mem_testbench tb (
        .clk(clk),
        .rst_n(rst_n),
        .mem_en(mem_en),
        .mem_we(mem_we),
        .mem_addr(mem_addr),
        .mem_wdata(mem_wdata),
        .mem_rdata(mem_rdata)
    );

endmodule

>>>>>>> 7968f542d993b7369b31cb2b1d005d0ea04dc4bd
