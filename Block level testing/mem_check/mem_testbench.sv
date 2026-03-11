<<<<<<< HEAD
import mem_pkg::*;

// ------------------------------
// Testbench Module
// ------------------------------
module mem_testbench (
    input  logic        clk,
    output logic        rst_n,
    output logic        mem_en,
    output logic        mem_we,
    output logic [9:0]  mem_addr,
    output logic [31:0] mem_wdata,
    input  logic [31:0] mem_rdata
);

    bit [31:0] mem_model [0:1023];
    // Transaction objects
    mem_transaction  wr, rd;

   
    initial begin
        
        reset();

        // Randomized tests
        repeat (5) begin
            wr = new();
            assert(wr.randomize());
            drive(wr);
        end

        // Write to all memory
        for (int i = 0; i < 1024; i++) begin
            wr = new();
            wr.addr = i;
            wr.data = 32'hABCD_0000 + i;
            wr.we   = 1;
            drive(wr);
        end

        // Read all memory
        for (int i = 0; i < 1024; i++) begin
            rd = new();
            rd.addr = i;
            rd.we   = 0;
            drive(rd);
        end

        // Run burst tests
        repeat (5) random_burst();

        $display(" All tests finished");
        $stop;
    end


///////////////
///////////////
///////////////


    // Reset
    task reset();
        rst_n = 0;
        mem_en = 0;
        mem_we = 0;
        mem_addr = 0;
        mem_wdata = 0;
        repeat (2) @(posedge clk);
        rst_n = 1;
    endtask

 


///////////////
///////////////

  
    // Drive Task
    task drive(mem_transaction t);
        @(posedge clk);
        mem_en    <= 1;
        mem_we    <= t.we;
        mem_addr  <= t.addr;
        mem_wdata <= t.data;

        @(posedge clk);
        mem_en    <= 0;
        mem_we    <= 0;

        if (t.we) begin
            $display("[WRITE]:: addr=%0d, data=%h", t.addr, t.data);
            mem_model[t.addr] = t.data;
        end else begin
            @(posedge clk);
            $display("[READ]:: addr=%0d, data=%h, expected=%h", t.addr, mem_rdata, mem_model[t.addr]);
            if (mem_rdata !== mem_model[t.addr]) begin
                $error(" [Mismatch :( ] :: @ addr=%0d: got=%h expected=%h", t.addr, mem_rdata, mem_model[t.addr]);
            end
            else begin
                $display("[MATCH :) ] @ addr %0d", t.addr);
            end

        end

    endtask



///////////////
///////////////

    // Random Burst    
    task random_burst();
        automatic int burst_len = $urandom_range(1, 10);
        automatic int start_addr = $urandom_range(0, 1023 - burst_len);

        $display("\n--- Random Burst Test ---");
        $display("Burst Length = %0d", burst_len);
        $display("Start Addr   = %0d", start_addr);

        for (int i = 0; i < burst_len; i++) begin
            wr = new();
            wr.addr = start_addr + i;
            wr.data = $urandom;
            wr.we   = 1;
            
            drive(wr);
        end

        for (int i = 0; i < burst_len; i++) begin
            rd = new();
            rd.addr = start_addr + i;
            rd.we   = 0;
            
            drive(rd);
        end
    endtask

endmodule

=======
import mem_pkg::*;

// ------------------------------
// Testbench Module
// ------------------------------
module mem_testbench (
    input  logic        clk,
    output logic        rst_n,
    output logic        mem_en,
    output logic        mem_we,
    output logic [9:0]  mem_addr,
    output logic [31:0] mem_wdata,
    input  logic [31:0] mem_rdata
);

    bit [31:0] mem_model [0:1023];
    // Transaction objects
    mem_transaction  wr, rd;

   
    initial begin
        
        reset();

        // Randomized tests
        repeat (5) begin
            wr = new();
            assert(wr.randomize());
            drive(wr);
        end

        // Write to all memory
        for (int i = 0; i < 1024; i++) begin
            wr = new();
            wr.addr = i;
            wr.data = 32'hABCD_0000 + i;
            wr.we   = 1;
            drive(wr);
        end

        // Read all memory
        for (int i = 0; i < 1024; i++) begin
            rd = new();
            rd.addr = i;
            rd.we   = 0;
            drive(rd);
        end

        // Run burst tests
        repeat (5) random_burst();

        $display(" All tests finished");
        $stop;
    end


///////////////
///////////////
///////////////


    // Reset
    task reset();
        rst_n = 0;
        mem_en = 0;
        mem_we = 0;
        mem_addr = 0;
        mem_wdata = 0;
        repeat (2) @(posedge clk);
        rst_n = 1;
    endtask

 


///////////////
///////////////

  
    // Drive Task
    task drive(mem_transaction t);
        @(posedge clk);
        mem_en    <= 1;
        mem_we    <= t.we;
        mem_addr  <= t.addr;
        mem_wdata <= t.data;

        @(posedge clk);
        mem_en    <= 0;
        mem_we    <= 0;

        if (t.we) begin
            $display("[WRITE]:: addr=%0d, data=%h", t.addr, t.data);
            mem_model[t.addr] = t.data;
        end else begin
            @(posedge clk);
            $display("[READ]:: addr=%0d, data=%h, expected=%h", t.addr, mem_rdata, mem_model[t.addr]);
            if (mem_rdata !== mem_model[t.addr]) begin
                $error(" [Mismatch :( ] :: @ addr=%0d: got=%h expected=%h", t.addr, mem_rdata, mem_model[t.addr]);
            end
            else begin
                $display("[MATCH :) ] @ addr %0d", t.addr);
            end

        end

    endtask



///////////////
///////////////

    // Random Burst    
    task random_burst();
        automatic int burst_len = $urandom_range(1, 10);
        automatic int start_addr = $urandom_range(0, 1023 - burst_len);

        $display("\n--- Random Burst Test ---");
        $display("Burst Length = %0d", burst_len);
        $display("Start Addr   = %0d", start_addr);

        for (int i = 0; i < burst_len; i++) begin
            wr = new();
            wr.addr = start_addr + i;
            wr.data = $urandom;
            wr.we   = 1;
            
            drive(wr);
        end

        for (int i = 0; i < burst_len; i++) begin
            rd = new();
            rd.addr = start_addr + i;
            rd.we   = 0;
            
            drive(rd);
        end
    endtask

endmodule

>>>>>>> 7968f542d993b7369b31cb2b1d005d0ea04dc4bd
