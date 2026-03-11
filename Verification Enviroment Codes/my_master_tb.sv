<<<<<<< HEAD

/*
reset_c
we_c
addr_bound_c dist
addr_c ranges
size_word_only_c
len_c dist
burst_data_pattern_c

*/

import axi_packet_pkg::*;
import axi4_enum::*;

module axi4_tb (axi4_if.TB axi_if_tb);

    bit clk;
    logic [axi_if_tb.ADDR_WIDTH_S-1:0] start_addr_byte, last_addr_byte;
    logic [axi_if_tb.DATA_WIDTH-1:0] gm_mem [0:axi_if_tb.DEPTH-1];
    logic [axi_if_tb.DATA_WIDTH-1:0] dut_data;
    logic [axi_if_tb.DATA_WIDTH-1:0] expected_queue[$]; 
    logic [axi_if_tb.DATA_WIDTH-1:0] actual_queue[$];
    logic [1:0] RESP_GM;


    int beat_count;
    int bytes_per_beat;
    int base_word_index;   
    int i;

    bit trans_pass ;    
    int pass_count = 0;
    int fail_count = 0;


    assign clk = axi_if_tb.ACLK ; 
    axi_packet pkt;

////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////// [TEST SCENARIO] ////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////

 
    initial begin

        axi_if_tb.RREADY  = 0;
        axi_if_tb.ARVALID = 0;
        axi_if_tb.AWVALID = 0;
        axi_if_tb.WVALID  = 0;
        axi_if_tb.WLAST   = 0;
        axi_if_tb.BREADY  = 0;

        axi_if_tb.AWLEN   = 0;
        axi_if_tb.AWSIZE  = 0;
        axi_if_tb.AWADDR  = 0;

        axi_if_tb.ARLEN   = 0;
        axi_if_tb.ARSIZE  = 0;
        axi_if_tb.ARADDR  = 0;

        // Initialize Golden Model memory to zeros to match DUT SRAM behavior
        foreach (gm_mem[i]) begin
            gm_mem[i] = '0;
        end

        repeat(2) reset();


        $display("\n------------------------------------------------------------------------------------------------------------------------");
        $display("-------------------------------------------------------- [DIRECT] -------------------------------------------------------");
        $display("--------------------------------------------------------------------------------------------------------------------------");

        $display("\n ------------------------- DIRECTED WRITE TEST ------------------------- ");
        pkt = new();

        pkt.we         = AXI_WRITE;
        pkt.addr       = 'h40;      
        pkt.size       = 3'd2;      
        pkt.len        = 7'd0;      
        pkt.addr_range = IN_BOUND;  

        // Single data beat
        pkt.burst = new[1];
        pkt.burst[0] = 32'hA5A5_1234;

        drive_stim(pkt);      
        golden_model(pkt);    
        @(negedge clk);
        check_result();       

        $display("\n -------------------------  DIRECTED READ TEST ------------------------- ");
        pkt = new();
        
        // Read back from the same address
        pkt.we         = AXI_READ;
        pkt.addr       = 'h40;
        pkt.size       = 3'd2;
        pkt.len        = 7'd0;
        pkt.addr_range = IN_BOUND;

        // burst array not really used for READ, but size=1 is okay
        pkt.burst = new[1];
        drive_stim(pkt);      
        golden_model(pkt);    
        @(negedge clk);
        check_result();  




   //--------------------------------------------- CRT ---------------------------------------------
       

    // ------------------ WRITE OPERATIONS ------------------

        $display("\n------------------------------------------------------------------------------------------------------------------------");
        $display("--------------------------------------- [INBOUND SMALL BURST WRITE TEST] -------------------------------------------------");
        $display("--------------------------------------------------------------------------------------------------------------------------");

        repeat (10) begin
        pkt = new();
        pkt.reset_c.constraint_mode(0); // off

        pkt.size.rand_mode(0); //off
        pkt.addr_range.rand_mode(0);
        pkt.len.rand_mode(0);
        pkt.we.rand_mode(0);
            
        pkt.we         = AXI_WRITE;
        pkt.addr_range = IN_BOUND;
        pkt.size       = 3'd2;
        pkt.len        = 7'd2;
            generate_stimulus(pkt);
            drive_stim(pkt);
            golden_model(pkt);
            @(negedge clk);
            check_result();
        end

        $display("\n------------------------------------------------------------------------------------------------------------------------");
        $display("--------------------------------------- [INBOUND BURST WRITE TEST] -------------------------------------------------------");
        $display("--------------------------------------------------------------------------------------------------------------------------");

        repeat (10) begin
            pkt = new();
            pkt.reset_c.constraint_mode(0); // off

            pkt.size.rand_mode(0); //off
            pkt.addr_range.rand_mode(0);
            pkt.len.rand_mode(1);
            pkt.we.rand_mode(0);
            
            pkt.we         = AXI_WRITE;
            pkt.addr_range = IN_BOUND;
            pkt.size       = 3'd2;
            generate_stimulus(pkt);
            drive_stim(pkt);
            golden_model(pkt);
            @(negedge clk);
            check_result();
        end

        $display("\n------------------------------------------------------------------------------------------------------------------------");
        $display("--------------------------------------- [ BURST WRITE TEST] -------------------------------------------------------");
        $display("--------------------------------------------------------------------------------------------------------------------------");

        repeat (20) begin
            pkt = new();
            pkt.reset_c.constraint_mode(0); // off

            pkt.size.rand_mode(0); //off
            pkt.len.rand_mode(1);
            pkt.we.rand_mode(0);
            
            pkt.we         = AXI_WRITE;
            pkt.size       = 3'd2;
            generate_stimulus(pkt);
            drive_stim(pkt);
            golden_model(pkt);
            @(negedge clk);
            check_result();
        end
//...................................................................................................................................................................
        $display("\n------------------------------------------------------------------------------------------------------------------------");
        $display("--------------------------------------- [ INBOUND BURST READ TEST] -------------------------------------------------------");
        $display("--------------------------------------------------------------------------------------------------------------------------");

        repeat (10) begin
            pkt = new();
            pkt.reset_c.constraint_mode(0); // off

            pkt.size.rand_mode(0); //off
            pkt.addr_range.rand_mode(0);
            pkt.len.rand_mode(1);
            pkt.we.rand_mode(0);
            
            pkt.we         = AXI_READ;
            pkt.addr_range = IN_BOUND;
            pkt.size       = 3'd2;
            generate_stimulus(pkt);
            drive_stim(pkt);
            golden_model(pkt);
            @(negedge clk);
            check_result();
        end

        $display("\n------------------------------------------------------------------------------------------------------------------------");
        $display("--------------------------------------- [ BURST READ TEST] -------------------------------------------------------");
        $display("--------------------------------------------------------------------------------------------------------------------------");

        repeat (10) begin
            pkt = new();
            pkt.reset_c.constraint_mode(0); // off

            pkt.size.rand_mode(0); //off
            pkt.len.rand_mode(1);
            pkt.we.rand_mode(0);
            
            pkt.we         = AXI_READ;
            pkt.size       = 3'd2;
            generate_stimulus(pkt);
            drive_stim(pkt);
            golden_model(pkt);
            @(negedge clk);
            check_result();

        end
//...................................................................................................................................................................
        $display("\n------------------------------------------------------------------------------------------------------------------------");
        $display("--------------------------------------- [  RANDOM ] ------------------------------------------------------------------");
        $display("--------------------------------------------------------------------------------------------------------------------------");

        repeat (100) begin
            pkt = new();
            pkt.reset_c.constraint_mode(0); // off

            pkt.size.rand_mode(1); 
            pkt.len.rand_mode(1);
            pkt.we.rand_mode(1);

            generate_stimulus(pkt);
            drive_stim(pkt);
            golden_model(pkt);
            @(negedge clk);
            check_result();

        end
        
        $display("\n------------------------------------------------------------------------------------------------------------------------");
        $display("--------------------------------------- [ TOTAL RANDOM ] ------------------------------------------------------------------");
        $display("--------------------------------------------------------------------------------------------------------------------------");

        repeat (300) begin
            pkt = new();
            pkt.reset_c.constraint_mode(1); // on

            pkt.size.rand_mode(1); //on
            pkt.len.rand_mode(1);
            pkt.we.rand_mode(1);
            
            
            generate_stimulus(pkt);
            drive_stim(pkt);
            golden_model(pkt);
            @(negedge clk);
            check_result();

        end

        
        `ifdef RUN_ADVANCED_TESTS
            mid_fight_reset(); 
            #10;
            back_to_back_pkts(); 
            #10;
            for_fn_cov();
            //#10;
            //write_cross_condition_hit();
        `endif


        $display("\n --------------------------------------------------------------");
        $display(" Pass count :) = %0d | Error Count :( = %0d",  pass_count, fail_count );
        $display("--------------------------------------------------------------");      

        
        #1;
        $stop;

    end


////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////// [TASKS] ////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////

    task reset();
        axi_if_tb.ARESETn = 0;
        @(negedge clk);
        axi_if_tb.ARESETn = 1;
    endtask







///////////////
///////////////
///////////////






    task automatic generate_stimulus(ref axi_packet pkt);
        assert(pkt.randomize()) else $fatal("Randomization failed!");
        pkt.print();
    endtask







///////////////
///////////////
///////////////






   
task automatic drive_stim(ref axi_packet pkt);
        int beat_count = pkt.len + 1;
        int i;

        expected_queue.delete();
        actual_queue.delete();

        if(pkt.we == AXI_WRITE)begin
            //----------------------- WRITE -------------------------
            
            // 1.Write Address Channel (drive negedge, handshake posedge)
            axi_if_tb.AWVALID = 1;
            axi_if_tb.AWLEN   = pkt.len;
            axi_if_tb.AWSIZE  = pkt.size;
            axi_if_tb.AWADDR  = pkt.addr;

            do @(posedge clk); while (!axi_if_tb.AWREADY);
            $display("[WRITE] @%0t AW handshake done, AWREADY = %0b",$time(), axi_if_tb.AWREADY);
            
            // Deassert AWVALID on next negedge  (address phase complete)
            @(negedge clk);
            axi_if_tb.AWVALID = 0;
    
            // 2.Write Data Channel
            $display("[WRITE] @%0t Start Writing ...", $time());
            for (i = 0; i < beat_count; i++)begin
                
                // Randomly stall before sending the next beat (Master Delay)
                axi_if_tb.WVALID = 0;
                repeat ($urandom_range(0, 2)) @(negedge clk);

                // Drive data on negedge, then wait for ready on posedge(s)
                axi_if_tb.WVALID = 1;
                axi_if_tb.WDATA = pkt.burst[i];
                axi_if_tb.WLAST = (i == beat_count-1);

                // Handshake on posedge WREADY
                do @(posedge clk); 
                while (!axi_if_tb.WREADY); 
            end

            // After last beat handshake, drop WVALID/WLAST
            @(negedge clk);
            axi_if_tb.WVALID = 0;
            axi_if_tb.WLAST  = 0;

            // 3. Write RESP Channel
            // Randomly delay asserting BREADY to test Slave stalling
            axi_if_tb.BREADY = 0;
            repeat ($urandom_range(0, 3)) @(negedge clk);
            axi_if_tb.BREADY = 1;

            do @(posedge clk);
            while (!axi_if_tb.BVALID);
            $display("[WRITE] @%0t :: BVALID seen = %0b", $time(), axi_if_tb.BVALID);
            
            @(negedge clk);
            if (axi_if_tb.BRESP == 2'b00)
                $display("[WRITE] @%0t :: RESPONSE = %0b (OKAY=00 expected)",$time(), axi_if_tb.BRESP);
            else
                $display("[WRITE] @%0t :: RESPONSE = %0b (SLVERR=10 expected)",$time(), axi_if_tb.BRESP);
            
            axi_if_tb.BREADY = 0;
            $display("[WRITE_OP DRIVE COMPLETED] @%0t :: Addr=%0d | Burst_beats =%0d | LEN =%0d ",$time(), pkt.addr, beat_count, pkt.len);
            $display("--------------");
        end

        else begin
        //----------------------- Read -------------------------

            // 1. Address Read
            axi_if_tb.ARADDR = pkt.addr;
            axi_if_tb.ARLEN  = pkt.len;
            axi_if_tb.ARSIZE = pkt.size;    
            axi_if_tb.ARVALID = 1; 

            do @(posedge clk); while (!axi_if_tb.ARREADY);
            $display("[READ] @%0t :: AR handshake done, ARREADY = %0b",$time(), axi_if_tb.ARREADY);
                    
            @(negedge clk); 
            axi_if_tb.ARVALID = 0;

            // address handshake done
            $display("[READ] @%0t :: Start Reading Data ", $time());
            for (i = 0; i < beat_count; i++)begin  

                // Randomly delay asserting RREADY to make the Slave wait
                axi_if_tb.RREADY = 0;
                repeat ($urandom_range(0, 2)) @(negedge clk);
                axi_if_tb.RREADY = 1;

                // Wait for next valid beat
                do @(posedge clk);
                while (!axi_if_tb.RVALID);

                actual_queue.push_back(axi_if_tb.RDATA);
                
                `ifdef DEBUG_STIM
                    $display("[READ] @%0t READ[%0d] :: DATA = 0x%0h | RLAST = %0b",$time(), i, axi_if_tb.RDATA, axi_if_tb.RLAST);
                `endif
                
                if (axi_if_tb.RLAST) begin
                    break;
                end

            end

            @(negedge clk);
            axi_if_tb.RREADY = 0;
            $display("[READ] @%0t :: Finished Reading Data, beats = %0d",$time(), actual_queue.size());
            $display("--------------");
        end

        `ifdef DEBUG_STIM
            foreach (actual_queue[j]) begin
                $display(" actual_queue[%0d] = 0x%0h", j, actual_queue[j]);
            end
        `endif
        
    endtask







///////////////
///////////////
///////////////






   
    task automatic golden_model(ref axi_packet pkt);
        
        beat_count     = pkt.len + 1;           // Number of beats and bytes per beat
        bytes_per_beat = 1 << pkt.size;         // =4 for size=2 (word)

        start_addr_byte = pkt.addr;             // AXI address is in bytes
        last_addr_byte  = start_addr_byte + beat_count*bytes_per_beat;


        base_word_index = start_addr_byte >> $clog2(axi_if_tb.DATA_WIDTH/8);
        // Compute base word index (byte -> word address)
        // With 32-bit data, this is same as: base_word_index = start_addr_byte >> 2;
        // Word size = DATA_WIDTH/8 bytes = 4 for 32-bit data,
        // so shift by 2 bits to get word index.


        // Default: assume OKAY
        RESP_GM   = 2'b00;
        pkt.resp  = 2'b00;                     // so coverage in axi_packet can see it

        //------------------- 4KB Boundry check (depth = 1024 words) ---------------

        // Total memory bytes = DEPTH * (DATA_WIDTH/8) = 1024*4 = 4096
        // Out of range / burst crosses the 4KB area OR word index range is NOT inside memory
        if ( (start_addr_byte >= axi_if_tb.DEPTH * (axi_if_tb.DATA_WIDTH/8) ) || (base_word_index + beat_count > axi_if_tb.DEPTH) ) begin
            
            RESP_GM  = 2'b10;  // SLVERR
            pkt.resp = 2'b10;

            if (pkt.we == AXI_READ) begin
                // Spec: error read returns zerost 
                for (i = 0; i < beat_count; i++) begin
                    expected_queue.push_back('0);
                    `ifdef DEBUG_STIM
                        $display("[GM][READ] @%0t :: mem[%0d] | expected_queue[%0d] = 0x%0h",$time(),base_word_index + i, i, gm_mem[base_word_index + i]);
                    `endif 
                end
                
            end
            // For write errors: we DO NOT update gm_mem at all
            
            if (base_word_index + beat_count > axi_if_tb.DEPTH) begin
                $display("[GM][SLVERR] @%0t :: word index overflow base=%0d | beats=%0d",$time(), base_word_index, beat_count);
            end else begin
                $display("[GM][SLVERR] @%0t :: addr=0x%0d | len=%0d (bytes_per_beat=%0d)",$time(), pkt.addr, beat_count, bytes_per_beat);
            end

            return; // do not fall through to the case

        end


        case (pkt.we)
            //------------------- Write Operation ---------------
            AXI_WRITE: begin

                for (i = 0; i < beat_count; i++) begin
                    gm_mem[base_word_index + i] = pkt.burst[i];
                    `ifdef DEBUG_STIM
                        $display("[GM][WRITE] @%0t :: mem[%0d] = 0x%0h",$time(),base_word_index + i, pkt.burst[i]);
                    `endif
                end
                RESP_GM  = 2'b00;
                pkt.resp = 2'b00;

            end

            //------------------- Read Operation ---------------
            AXI_READ : begin
                $display("--------------");
                for (i = 0; i < beat_count; i++) begin
                    dut_data = axi4_top.uut.mem_inst.memory[base_word_index + i];
                    expected_queue.push_back(dut_data); 
                    `ifdef DEBUG_STIM
                        $display("[GM][READ] @%0t :: mem[%0d] | expected_queue[%0d] = 0x%0h",$time(),base_word_index + i, i, gm_mem[base_word_index + i]);
                    `endif 
                end
                RESP_GM  = 2'b00;
                pkt.resp = 2'b00;

            end
        endcase 

        $display("[GM DONE] @%0t :: op= %s | addr= %0d | beats= %0d | RESP_GM=%0b",$time(),pkt.we.name(),pkt.addr, beat_count, RESP_GM);
        $display("--------------");
    endtask







///////////////
///////////////
///////////////






   
    task automatic check_result();
        trans_pass = 1;

        //------------------------------- READ -------------------------------
        if(pkt.we == AXI_READ) begin 

            // --- DATA ----
            if (!(expected_queue == actual_queue)) begin
                trans_pass = 0;
                $error("[FAILED READ DATA] @%0t | expected_queue != actual_queue", $time());
            end
            else begin
                $display("[PASSED READ DATA] @%0t", $time());
                foreach (actual_queue[j]) begin
                    $display(" actual_queue[%0d] = 0x%0h | expected_queue[%0d] = 0x%0h", j, actual_queue[j],j, expected_queue[j]);
                end
            end

            // --- RESP ---
            if (RESP_GM !== axi_if_tb.RRESP) begin
                trans_pass = 0;
                $error("[FAILED READ RESPONSE] @%0t :: RRESP = %0b | GM = %0b",$time(), axi_if_tb.RRESP, RESP_GM);
            end
            else begin
                $display("[PASSED READ RESPONSE] @%0t :: RRESP = %0b | GM = %0b",$time(), axi_if_tb.RRESP, RESP_GM);
            end

            //--- Counter ---
            if (trans_pass) begin
                pass_count++;
                $display("\n [PASSED READ TRANSACTION] @%0t :: pass_count = %0d", $time(), pass_count);
            end
            else begin
                fail_count++;
                $error("[FAILED READ TRANSACTION] @%0t :: fail_count = %0d", $time(), fail_count);
            end
        
        end

        //------------------------------- WRITE ------------------------------- 
        else begin
            // --- RESP ---   
            if (RESP_GM !== axi_if_tb.BRESP) begin
                trans_pass = 0;
                $error("[FAILED WRITE RESPONSE] @%0t :: BRESP = %0b | GM = %0b \n",$time(), axi_if_tb.BRESP, RESP_GM);
            end
            else begin
                $display("[PASSED WRITE RESPONSE] @%0t :: BRESP = %0b | GM = %0b",$time(), axi_if_tb.BRESP, RESP_GM);
            end

            // --- DATA ----

            // Only if we expect OKAY (RESP_GM == 2'b00), check DUT memory
            if (RESP_GM == 2'b00) begin
                $display("[MEM CHECK] @%0t :: Checking DUT memory for this WRITE",$time());

                for (int k = 0; k < beat_count; k++) begin
                    int idx = base_word_index + k;

                    // backdoor read from DUT memory
                    dut_data = axi4_top.uut.mem_inst.memory[idx];

                    if (dut_data !== gm_mem[idx]) begin
                        trans_pass = 0;
                        $error("\n [MEM MISMATCH] @%0t idx=%0d | DUT=0x%0h | GM=0x%0h ",$time(), idx, dut_data, gm_mem[idx]);
                    end
                    else begin
                        `ifdef DEBUG_STIM
                            $display("[MEM OK] @%0t idx=%0d data=0x%0h",$time(), idx, dut_data);
                        `endif
                    end
                end

            end

            //--- Counter ---

            if (trans_pass) begin
                pass_count++;
                $display("\n[PASSED WRITE TRANSACTION] @%0t | pass_count = %0d \n", $time(), pass_count);
            end
            else begin
                fail_count++;
                $error("[FAILED WRITE TRANSACTION] @%0t | fail_count = %0d", $time(), fail_count);
            end


        end

        pkt.axi_cov.sample();     // transaction-level coverage
        pkt.sample_burst_cov();   // per-beat data coverage    

    endtask








///////////////
///////////////
///////////////






   
    task mid_fight_reset;
        $display("\n----------------------------------------------------------------------------------");
        $display("-------------------- [ MID-FLIGHT RESET TEST (FORK...JOIN) ] ---------------------");
        $display("----------------------------------------------------------------------------------");

        // Clear the bus to ensure a clean start
        axi_if_tb.AWVALID = 0;
        axi_if_tb.WVALID  = 0;
        axi_if_tb.ARVALID = 0;
        @(posedge clk);

        // ---------------------------------------------------------
        // 1. Reset from W_ADDR -> W_IDLE 
        // ---------------------------------------------------------
        $display("[TEST] :: Asserting reset during W_ADDR state");
        fork
            begin // Thread 1: Drive Address Phase
                axi_if_tb.AWADDR  = 'h80;
                axi_if_tb.AWLEN   = 4;
                axi_if_tb.AWSIZE  = 2;
                axi_if_tb.AWVALID = 1;
                
                @(posedge clk iff axi_if_tb.AWREADY == 1);
                axi_if_tb.AWVALID = 0; 
            end
            
            begin // Thread 2: Monitor and Reset
                // Wait for the exact moment the AW handshake occurs
                @(posedge clk iff (axi_if_tb.AWVALID && axi_if_tb.AWREADY));
                
                #2; // Give it a tiny delay to let the FSM step into W_ADDR 
                axi_if_tb.ARESETn = 0; 
                $display("[TEST] :: Reset triggered mid-flight (W_ADDR)!");
                
                #10;
                axi_if_tb.ARESETn = 1; // Release reset
            end
        join
        @(posedge clk); // recover cycle before the next test :)
        $display("[TEST] :: OUT FROM FORK [1] W_ADDR -> W_IDLE");

        // ---------------------------------------------------------
        // 2. Reset from W_DATA -> W_IDLE
        // ---------------------------------------------------------
        $display("[TEST] :: Asserting reset during W_DATA state...");
        fork
            begin // Thread 1: Drive Address Phase
                axi_if_tb.AWADDR  = 'h90;
                axi_if_tb.AWVALID = 1;
                
                @(posedge clk iff axi_if_tb.AWREADY == 1);
                axi_if_tb.AWVALID = 0;
            end
            
            begin // Thread 2: Monitor and Reset
                @(posedge clk iff (axi_if_tb.AWVALID && axi_if_tb.AWREADY));
                // The FSM takes 1 clock cycle to move from W_ADDR to W_DATA
                // So we wait one extra clock edge here :) , 2a2l yom f el axi :)
                @(posedge clk); 
                
                #2; // ehtyaty but the FSM should be in W_DATA now 
                axi_if_tb.ARESETn = 0; 
                $display("[TEST] :: Reset triggered mid-flight (W_DATA)!");
                
                #10;
                axi_if_tb.ARESETn = 1;
            end
        join
        @(posedge clk);
        $display("[TEST] :: OUT FROM FORK [2] W_DATA -> W_IDLE");

        // ---------------------------------------------------------
        // 3. Reset from R_ADDR -> R_IDLE
        // ---------------------------------------------------------
        $display("[TEST] :: Asserting reset during R_ADDR state...");
        fork
            begin // Thread 1: Drive Read Address Phase
                axi_if_tb.ARADDR  = 'hA0;
                axi_if_tb.ARLEN   = 4;
                axi_if_tb.ARSIZE  = 2;
                axi_if_tb.ARVALID = 1;
                
                @(posedge clk iff axi_if_tb.ARREADY == 1);
                axi_if_tb.ARVALID = 0;
            end
            
            begin // Thread 2: Monitor and Reset
                @(posedge clk iff (axi_if_tb.ARVALID && axi_if_tb.ARREADY));
                
                #2;
                axi_if_tb.ARESETn = 0; 
                $display("[TEST] :: Reset triggered mid-flight (R_ADDR)!");
                
                #10;
                axi_if_tb.ARESETn = 1;
            end
        join
        @(posedge clk);
        $display("[TEST] :: OUT FROM FORK [3] R_ADDR -> R_IDLE");        
        $display("----------------------------------------------------------------------------------");

    endtask









///////////////
///////////////
///////////////






   
    task automatic back_to_back_pkts();

        axi_packet pkt1, pkt2; // For Writes
        axi_packet pkt3, pkt4; // For Reads
        
        // Local flags for checker counters 
        bit pkt1_pass, pkt2_pass, pkt3_pass, pkt4_pass;
        
        // Variables to capture Write Responses
        logic [1:0] bresp1, bresp2;

        $display("[TEST] :: BACK-TO-BACK FORKS TEST ");



        // 1. WRITE PIPELINING (Hit AWVALID=1 & AWREADY=0, WVALID=1 & WREADY=0)
        $display("\n------------------------------------------------------------------------------------------------------------------------");
        $display("--------------------------------------- [ [WRITE] :: BACK-TO-BACK FORKS TEST ] --------------------------------------------");
        $display("--------------------------------------------------------------------------------------------------------------------------\n");
        $display("[TEST] :: !! WRITE BACK-TO-BACK FORKS WILL START !! ");

        // Generate two randomized valid write packets
        pkt1 = new();
        pkt1.reset_c.constraint_mode(0);
        pkt1.we = AXI_WRITE;
        pkt1.addr_range = IN_BOUND;
        generate_stimulus(pkt1);

        pkt2 = new(); 
        pkt2.reset_c.constraint_mode(0); 
        pkt2.we = AXI_WRITE; 
        pkt2.addr_range = IN_BOUND;
        generate_stimulus(pkt2);

        //------------------------------- DRIVING WRITE, PACKETS IN 3 THREADS FOR 3 CHANNELS --------------------------------
        fork
            // -- Thread 1, AW (Address Write) Channel  --
            begin
                $display("[TEST] :: WRITE BACK-TO-BACK FORK[1] (Address Write) TEST ");
                
                // Drive pkt1 Address
                @(negedge clk);
                axi_if_tb.AWADDR  = pkt1.addr;
                axi_if_tb.AWLEN   = pkt1.len;
                axi_if_tb.AWSIZE  = pkt1.size;
                axi_if_tb.AWVALID = 1;
                do @(posedge clk); while(!axi_if_tb.AWREADY);
                
                // Drive pkt2 Address immediately (AWREADY is 0 here 3shan l dut busy in WDATA State)
                @(negedge clk);
                axi_if_tb.AWADDR  = pkt2.addr;
                axi_if_tb.AWLEN   = pkt2.len;
                axi_if_tb.AWSIZE  = pkt2.size;
                axi_if_tb.AWVALID = 1;  
                do @(posedge clk); while(!axi_if_tb.AWREADY);
                
                @(negedge clk);
                axi_if_tb.AWVALID = 0;
                $display("[TEST] (Address Write) :: WRITE BACK-TO-BACK FORK[1]  5lsnaaaaaa ");
            end

            // -- Thread 2: W (Data Write) Channel Master --
            begin
                $display("[TEST] (Data Write) :: WRITE BACK-TO-BACK FORK[2] TEST ");
                
                // Drive pkt1 Data 
                for (int i = 0; i <= pkt1.len; i++) begin
                    @(negedge clk);
                    axi_if_tb.WDATA  = pkt1.burst[i];
                    axi_if_tb.WLAST  = (i == pkt1.len);
                    axi_if_tb.WVALID = 1;
                    do @(posedge clk); while(!axi_if_tb.WREADY);
                end

                // pkt2 Data Packet immediately
                for (int i = 0; i <= pkt2.len; i++) begin
                    @(negedge clk);
                    axi_if_tb.WDATA  = pkt2.burst[i];
                    axi_if_tb.WLAST  = (i == pkt2.len);
                    axi_if_tb.WVALID = 1;
                    do @(posedge clk); while(!axi_if_tb.WREADY);
                end
                
                @(negedge clk);
                axi_if_tb.WVALID = 0;
                axi_if_tb.WLAST  = 0;
                $display("[TEST] :: WRITE BACK-TO-BACK FORK[2] (Data Write) TEST  5lsnaaaaaaaa");
            end

            // -- Thread 3: B (Write Response) Channel Master --
            begin
                $display("[TEST] (Write Response):: WRITE BACK-TO-BACK FORK[3]  TEST ");
                @(negedge clk);
                axi_if_tb.BREADY = 1;
                
                // Wait for 1st response handshake
                do @(posedge clk); while(!axi_if_tb.BVALID);
                bresp1 = axi_if_tb.BRESP; // Capture 1st Response
                
                // Wait for 2nd response handshake
                do @(posedge clk); while(!axi_if_tb.BVALID);
                bresp2 = axi_if_tb.BRESP; // Capture 2nd Response
                
                @(negedge clk);
                axi_if_tb.BREADY = 0;
            end
        join


        //------------------------------- CHECKING THE PACKETS --------------------------------
        golden_model(pkt1);
        // PKT 1
        pkt1_pass = 1;
        if (bresp1 !== pkt1.resp) pkt1_pass = 0; // Check BRESP
        for (int k = 0; k <= pkt1.len; k++) begin
            int idx = (pkt1.addr >> 2) + k;
            if (axi4_top.uut.mem_inst.memory[idx] !== gm_mem[idx]) pkt1_pass = 0;
        end
        if (pkt1_pass) begin
            pass_count++;
            $display("\n[PASSED WRITE TRANSACTION] @%0t | Packet (%0d) | pass_count = %0d \n", $time(), pkt1.id, pass_count);
        end else begin
            fail_count++;
            $error("[FAILED WRITE TRANSACTION] @%0t| Packet (%0d) |  fail_count = %0d", $time(), pkt1.id, fail_count);
        end

        golden_model(pkt2);
        // PKT 2
        pkt2_pass = 1;
        if (bresp2 !== pkt2.resp) pkt2_pass = 0; // Check BRESP
        for (int k = 0; k <= pkt2.len; k++) begin
            int idx = (pkt2.addr >> 2) + k;
            if (axi4_top.uut.mem_inst.memory[idx] !== gm_mem[idx]) pkt2_pass = 0;
        end
        if (pkt2_pass) begin
            pass_count++;
            $display("\n[PASSED WRITE TRANSACTION] @%0t | Packet (%0d) | pass_count = %0d \n", $time(), pkt2.id, pass_count);
        end else begin
            fail_count++;
            $error("[FAILED WRITE TRANSACTION] @%0t| Packet (%0d) |  fail_count = %0d", $time(), pkt2.id, fail_count);
        end

    //......................................................................................................................................................................

        // 2. READ PIPELINING (Hit ARVALID=1 & ARREADY=0)
        $display("\n------------------------------------------------------------------------------------------------------------------------");
        $display("--------------------------------------- [ [READ] :: BACK-TO-BACK FORKS TEST ] --------------------------------------------");
        $display("--------------------------------------------------------------------------------------------------------------------------\n");
        $display("[TEST] :: !! READ BACK-TO-BACK FORKS WILL START !! ");

        // Generate two randomized valid read packets
        pkt3 = new();
        pkt3.reset_c.constraint_mode(0);
        pkt3.we = AXI_READ;
        pkt3.addr_range = IN_BOUND;
        generate_stimulus(pkt3);

        pkt4 = new();
        pkt4.reset_c.constraint_mode(0);
        pkt4.we = AXI_READ;
        pkt4.addr_range = IN_BOUND;
        generate_stimulus(pkt4);


        fork
            // -- Thread 1: AR (Address Read) Channel Master --
            begin
                $display("[TEST] (Address Read) :: READ BACK-TO-BACK FORK[1]  TEST ");
                
                $display("[TEST] (Address Read) :: Drive 1st Read Address");
                @(negedge clk);
                axi_if_tb.ARADDR  = pkt3.addr;
                axi_if_tb.ARLEN   = pkt3.len;
                axi_if_tb.ARSIZE  = pkt3.size;
                axi_if_tb.ARVALID = 1;
                do @(posedge clk); while(!axi_if_tb.ARREADY);
                
                $display("[TEST] (Address Read) :: Blast 2nd Read Address immediately");
                @(negedge clk);
                axi_if_tb.ARADDR  = pkt4.addr;
                axi_if_tb.ARLEN   = pkt4.len;
                axi_if_tb.ARSIZE  = pkt4.size;
                axi_if_tb.ARVALID = 1; 
                do @(posedge clk); while(!axi_if_tb.ARREADY);
                
                @(negedge clk);
                axi_if_tb.ARVALID = 0;
                $display("[TEST] (Address Read) :: READ BACK-TO-BACK FORK[1]  TEST 5lsnaaaaaaaa");
            end

            // -- Thread 2: R (Data Read) Channel Master --
            begin
                $display("[TEST] (Data Read) :: READ BACK-TO-BACK FORK[2]  TEST  ");
                @(negedge clk);
                axi_if_tb.RREADY = 1;
                

                // Check 1st Read Data Packet 
                $display("[TEST] (Data Read) :: Check PKT3 ");
                pkt3_pass = 1;
                for (int i = 0; i <= pkt3.len; i++) begin
                    do @(posedge clk); while(!axi_if_tb.RVALID);
                    if (axi_if_tb.RDATA !== axi4_top.uut.mem_inst.memory[(pkt3.addr >> 2) + i]) pkt3_pass = 0;
                    
                end
                golden_model(pkt3);
                if (axi_if_tb.RRESP !== pkt3.resp) pkt3_pass = 0; // Check RRESP


                if (pkt3_pass) begin
                    pass_count++;
                    $display("\n[PASSED READ TRANSACTION] @%0t | Packet (%0d) | pass_count = %0d \n", $time(), pkt3.id, pass_count);
                end
                else begin
                    fail_count++;
                    $error("[FAILED READ TRANSACTION] @%0t| Packet (%0d) |  fail_count = %0d", $time(), pkt3.id, fail_count);
                end



                // Check 2nd Read Data Packet
                $display("[TEST] (Data Read) :: Check PKT4 ");
                pkt4_pass = 1;
                for (int i = 0; i <= pkt4.len; i++) begin
                    do @(posedge clk); while(!axi_if_tb.RVALID);
                    if (axi_if_tb.RDATA !== axi4_top.uut.mem_inst.memory[(pkt4.addr >> 2) + i] ) pkt4_pass = 0;
                end 
                golden_model(pkt4);
                if (axi_if_tb.RRESP !== pkt4.resp) pkt4_pass = 0; // Check RRESP


                if (pkt4_pass) begin
                    pass_count++;
                    $display("\n[PASSED READ TRANSACTION] @%0t | Packet (%0d) | pass_count = %0d \n", $time(), pkt4.id, pass_count);
                end 
                else begin
                    fail_count++;
                    $error("[FAILED READ TRANSACTION] @%0t| Packet (%0d) |  fail_count = %0d", $time(), pkt4.id, fail_count);
                end

                
                @(negedge clk);
                axi_if_tb.RREADY = 0;
                $display("[TEST] :: READ BACK-TO-BACK FORK[2] (Data Read) TEST 5lsnaaaaaaaa ");
            end
        join

        $display("[TEST] BACK TO BACK FORKS DONEEEEE YAYYYYY !! ;)");
    endtask








///////////////
///////////////
///////////////





task write_cross_condition_hit;
        $display("\n ------------------------------------------------------------------------------- ");
        $display(" ------------------ BOUNDARY CROSS WRITE TEST ------------------------------------ ");
        $display(" --------------------------------------------------------------------------------- ");
        
        // 1. Setup the packet right at the 4KB edge bzbt 
        pkt = new();
        pkt.we         = AXI_WRITE;
        pkt.addr       = 32'hFFFC; // 4092 - 4 bytes before the 4096 boundary
        pkt.len        = 7'd1;     // Burst of 2 beats (will cross the boundary)
        pkt.size       = 3'd2;     // 4 bytes per beat
        pkt.addr_range = OUT_BOUND;
        
        // 2. Give it 2 beats of data
        pkt.burst = new[2];
        pkt.burst[0] = 32'hDEAD_BEEF; // This writes to 0x0FFC (OK)
        pkt.burst[1] = 32'hCAFE_BABE; // This tries to write to 0x1000 (SLVERR!)

        // 3. Drive, Golden Model, and Check
        drive_stim(pkt);      
        golden_model(pkt);    
        @(negedge clk);
        check_result();

    endtask


    // task write_cross_condition_hit;
    //     $display("\n ----------------------------------------------------------------------------------------- ");
    //     $display(" ------------------ COVERAGE HACK: EARLY WLAST ON BOUNDARY CROSS ------------------------- ");
    //     $display(" ----------------------------------------------------------------------------------------- ");
        
    //     // 1. Drive Address Phase (LEN = 1 means 2 beats, starting at 0x0FFC)
    //     axi_if_tb.AWVALID = 1;
    //     axi_if_tb.AWADDR  = 32'h0FFC; // 4092
    //     axi_if_tb.AWLEN   = 1;        // Expecting 2 beats
    //     axi_if_tb.AWSIZE  = 2;
        
    //     do @(posedge clk); while (!axi_if_tb.AWREADY);
    //     @(negedge clk);
    //     axi_if_tb.AWVALID = 0;

    //     // 2. Drive Data Phase but ASSERT WLAST EARLY! 
    //     // We assert WLAST on the very first beat while write_burst_cnt is still 1
    //     axi_if_tb.WVALID = 1;
    //     axi_if_tb.WDATA  = 32'hDEAD_BEEF;
    //     axi_if_tb.WLAST  = 1; // <--- Early WLAST
        
    //     do @(posedge clk); while (!axi_if_tb.WREADY);
    //     @(negedge clk);
    //     axi_if_tb.WVALID = 0;
    //     axi_if_tb.WLAST  = 0;

    //     // 3. Wait for SLVERR Response
    //     axi_if_tb.BREADY = 1;
    //     do @(posedge clk); while (!axi_if_tb.BVALID);
    //     @(negedge clk);
    //     axi_if_tb.BREADY = 0;

    //     pkt = new();
    //     pkt.we         = AXI_WRITE;
    //     pkt.addr       = axi_if_tb.AWADDR;
    //     pkt.len   = axi_if_tb.AWLEN;
    //     pkt.size  = axi_if_tb.AWSIZE;
    //     pkt.addr_range = OUT_BOUND;
    //     pkt.burst = new[1];
    //     pkt.burst[0] = axi_if_tb.WDATA;
    //     golden_model(pkt);    
    //     @(negedge clk);
    //     check_result();

    // endtask



///////////////
///////////////
///////////////



   
    task for_fn_cov;
        $display("\n ----------------------------------------------------------------------------------------- ");
        $display(" ------------------ DIRECTED WRITE TEST: SINGLE BEAT OUT OF RANGE -------------------------- ");
        $display(" ----------------------------------------------------------------------------------------- ");
        pkt = new();

        pkt.we         = AXI_WRITE; 
        pkt.addr       = 32'h1000;  // Address 4096 (Awel byte barra el 4KB memory bta3ty)
        pkt.size       = 3'd2;      // 4 bytes per beat
        pkt.len        = 7'd0;      // length = 0 ya3ny Single Beat
        pkt.addr_range = OUT_BOUND; 

        // Data array size = 1 (Single beat)
        pkt.burst = new[1];
        pkt.burst[0] = 32'hDEAD_BEEF;

        // Execute the transaction
        drive_stim(pkt);      
        golden_model(pkt);    
        @(negedge clk);
        check_result();
    endtask


endmodule













/*

// Old driv with no delays that cause a holes in code coverage , 

    task automatic drive_stim(ref axi_packet pkt);
        int beat_count = pkt.len + 1;
        int i;

        expected_queue.delete();
        actual_queue.delete();
        
        if(pkt.we == AXI_WRITE)begin
            //----------------------- WRITE -------------------------
            
            // 1.Write Address Channel (drive negedge, handshake posedge)
            axi_if_tb.AWVALID = 1;
            axi_if_tb.AWLEN   = pkt.len;
            axi_if_tb.AWSIZE  = pkt.size;
            axi_if_tb.AWADDR  = pkt.addr;

            
            do @(posedge clk); while (!axi_if_tb.AWREADY); // Wait for a posedge where AWREADY is high
            $display("[WRITE] @%0t AW handshake done, AWREADY = %0b",$time(), axi_if_tb.AWREADY);
            
            // Deassert AWVALID on next negedge  (address phase complete)
            @(negedge clk);   
            axi_if_tb.AWVALID = 0;
    
            // 2.Write Data Channel
            axi_if_tb.WVALID  = 1;
            axi_if_tb.BREADY  = 1;
            $display("[WRITE] @%0t Start Writing ...", $time());
            for (i = 0; i < beat_count; i++)begin
                // Drive data on negedge, then wait for ready on posedge(s)
                @(negedge clk);
                axi_if_tb.WDATA = pkt.burst[i];
                axi_if_tb.WLAST = (i == beat_count-1);

                // Handshake on posedge WREADY
                //do @(posedge clk); while (!axi_if_tb.WREADY); 
            end

            // After last beat handshake, drop WVALID/WLAST
            @(negedge clk);
            axi_if_tb.WVALID = 0;
            axi_if_tb.WLAST  = 0;

            // 3. Write RESP Channel
            do @(posedge clk); while (!axi_if_tb.BVALID);
            $display("[WRITE] @%0t :: BVALID seen = %0b", $time(), axi_if_tb.BVALID);
            
            @(negedge clk); 
            if (axi_if_tb.BRESP == 2'b00)
                $display("[WRITE] @%0t :: RESPONSE = %0b (OKAY=00 expected)",$time(), axi_if_tb.BRESP);
            else
                $display("[WRITE] @%0t :: RESPONSE = %0b (SLVERR=10 expected)",$time(), axi_if_tb.BRESP);

            axi_if_tb.BREADY = 0;
            $display("[WRITE_OP DRIVE COMPLETED] @%0t :: Addr=%0d | Burst_beats =%0d | LEN =%0d ",$time(), pkt.addr, beat_count, pkt.len);
            $display("--------------");
        end

        else begin
        //----------------------- Read -------------------------

            // 1. Address Read
            axi_if_tb.ARADDR = pkt.addr;
            axi_if_tb.ARLEN  = pkt.len;
            axi_if_tb.ARSIZE = pkt.size;    
            axi_if_tb.ARVALID = 1; 

            do @(posedge clk); while (!axi_if_tb.ARREADY);
            $display("[READ] @%0t :: AR handshake done, ARREADY = %0b",$time(), axi_if_tb.ARREADY);
                    
            @(negedge clk); 
            axi_if_tb.ARVALID = 0; // address handshake done
            axi_if_tb.RREADY  = 1; // Now ready to accept data

            do @(posedge clk); while (!axi_if_tb.RVALID);
            $display("[READ] @%0t :: First RVALID = %0b",$time(), axi_if_tb.RVALID);
            
            $display("[READ] @%0t :: Start Reading Data ", $time());
            for (i = 0; i < beat_count; i++)begin  

                actual_queue.push_back(axi_if_tb.RDATA); // At this posedge we already know RVALID==1
                `ifdef DEBUG_STIM
                    $display("[READ] @%0t READ[%0d] :: DATA = 0x%0h | RLAST = %0b",$time(), i, axi_if_tb.RDATA, axi_if_tb.RLAST);
                `endif
                if (axi_if_tb.RLAST) begin
                    break;
                end

                // Wait for next valid beat
                do @(posedge clk); while (!axi_if_tb.RVALID);

            end

            @(negedge clk);
            axi_if_tb.RREADY = 0;
            $display("[READ] @%0t :: Finished Reading Data, beats = %0d",$time(), actual_queue.size());
            $display("--------------");
        end

        `ifdef DEBUG_STIM
            foreach (actual_queue[j]) begin
                $display(" actual_queue[%0d] = 0x%0h", j, actual_queue[j]);
            end
        `endif
        
    endtask
*/


=======

/*
reset_c
we_c
addr_bound_c dist
addr_c ranges
size_word_only_c
len_c dist
burst_data_pattern_c

*/

import axi_packet_pkg::*;
import axi4_enum::*;

module axi4_tb (axi4_if.TB axi_if_tb);

    bit clk;
    logic [axi_if_tb.ADDR_WIDTH_S-1:0] start_addr_byte, last_addr_byte;
    logic [axi_if_tb.DATA_WIDTH-1:0] gm_mem [0:axi_if_tb.DEPTH-1];
    logic [axi_if_tb.DATA_WIDTH-1:0] dut_data;
    logic [axi_if_tb.DATA_WIDTH-1:0] expected_queue[$]; 
    logic [axi_if_tb.DATA_WIDTH-1:0] actual_queue[$];
    logic [1:0] RESP_GM;


    int beat_count;
    int bytes_per_beat;
    int base_word_index;   
    int i;

    bit trans_pass ;    
    int pass_count = 0;
    int fail_count = 0;


    assign clk = axi_if_tb.ACLK ; 
    axi_packet pkt;

////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////// [TEST SCENARIO] ////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////

 
    initial begin

        axi_if_tb.RREADY  = 0;
        axi_if_tb.ARVALID = 0;
        axi_if_tb.AWVALID = 0;
        axi_if_tb.WVALID  = 0;
        axi_if_tb.WLAST   = 0;
        axi_if_tb.BREADY  = 0;

        axi_if_tb.AWLEN   = 0;
        axi_if_tb.AWSIZE  = 0;
        axi_if_tb.AWADDR  = 0;

        axi_if_tb.ARLEN   = 0;
        axi_if_tb.ARSIZE  = 0;
        axi_if_tb.ARADDR  = 0;

        // Initialize Golden Model memory to zeros to match DUT SRAM behavior
        foreach (gm_mem[i]) begin
            gm_mem[i] = '0;
        end

        repeat(2) reset();


        $display("\n------------------------------------------------------------------------------------------------------------------------");
        $display("-------------------------------------------------------- [DIRECT] -------------------------------------------------------");
        $display("--------------------------------------------------------------------------------------------------------------------------");

        $display("\n ------------------------- DIRECTED WRITE TEST ------------------------- ");
        pkt = new();

        pkt.we         = AXI_WRITE;
        pkt.addr       = 'h40;      
        pkt.size       = 3'd2;      
        pkt.len        = 7'd0;      
        pkt.addr_range = IN_BOUND;  

        // Single data beat
        pkt.burst = new[1];
        pkt.burst[0] = 32'hA5A5_1234;

        drive_stim(pkt);      
        golden_model(pkt);    
        @(negedge clk);
        check_result();       

        $display("\n -------------------------  DIRECTED READ TEST ------------------------- ");
        pkt = new();
        
        // Read back from the same address
        pkt.we         = AXI_READ;
        pkt.addr       = 'h40;
        pkt.size       = 3'd2;
        pkt.len        = 7'd0;
        pkt.addr_range = IN_BOUND;

        // burst array not really used for READ, but size=1 is okay
        pkt.burst = new[1];
        drive_stim(pkt);      
        golden_model(pkt);    
        @(negedge clk);
        check_result();  




   //--------------------------------------------- CRT ---------------------------------------------
       

    // ------------------ WRITE OPERATIONS ------------------

        $display("\n------------------------------------------------------------------------------------------------------------------------");
        $display("--------------------------------------- [INBOUND SMALL BURST WRITE TEST] -------------------------------------------------");
        $display("--------------------------------------------------------------------------------------------------------------------------");

        repeat (10) begin
        pkt = new();
        pkt.reset_c.constraint_mode(0); // off

        pkt.size.rand_mode(0); //off
        pkt.addr_range.rand_mode(0);
        pkt.len.rand_mode(0);
        pkt.we.rand_mode(0);
            
        pkt.we         = AXI_WRITE;
        pkt.addr_range = IN_BOUND;
        pkt.size       = 3'd2;
        pkt.len        = 7'd2;
            generate_stimulus(pkt);
            drive_stim(pkt);
            golden_model(pkt);
            @(negedge clk);
            check_result();
        end

        $display("\n------------------------------------------------------------------------------------------------------------------------");
        $display("--------------------------------------- [INBOUND BURST WRITE TEST] -------------------------------------------------------");
        $display("--------------------------------------------------------------------------------------------------------------------------");

        repeat (10) begin
            pkt = new();
            pkt.reset_c.constraint_mode(0); // off

            pkt.size.rand_mode(0); //off
            pkt.addr_range.rand_mode(0);
            pkt.len.rand_mode(1);
            pkt.we.rand_mode(0);
            
            pkt.we         = AXI_WRITE;
            pkt.addr_range = IN_BOUND;
            pkt.size       = 3'd2;
            generate_stimulus(pkt);
            drive_stim(pkt);
            golden_model(pkt);
            @(negedge clk);
            check_result();
        end

        $display("\n------------------------------------------------------------------------------------------------------------------------");
        $display("--------------------------------------- [ BURST WRITE TEST] -------------------------------------------------------");
        $display("--------------------------------------------------------------------------------------------------------------------------");

        repeat (20) begin
            pkt = new();
            pkt.reset_c.constraint_mode(0); // off

            pkt.size.rand_mode(0); //off
            pkt.len.rand_mode(1);
            pkt.we.rand_mode(0);
            
            pkt.we         = AXI_WRITE;
            pkt.size       = 3'd2;
            generate_stimulus(pkt);
            drive_stim(pkt);
            golden_model(pkt);
            @(negedge clk);
            check_result();
        end
//...................................................................................................................................................................
        $display("\n------------------------------------------------------------------------------------------------------------------------");
        $display("--------------------------------------- [ INBOUND BURST READ TEST] -------------------------------------------------------");
        $display("--------------------------------------------------------------------------------------------------------------------------");

        repeat (10) begin
            pkt = new();
            pkt.reset_c.constraint_mode(0); // off

            pkt.size.rand_mode(0); //off
            pkt.addr_range.rand_mode(0);
            pkt.len.rand_mode(1);
            pkt.we.rand_mode(0);
            
            pkt.we         = AXI_READ;
            pkt.addr_range = IN_BOUND;
            pkt.size       = 3'd2;
            generate_stimulus(pkt);
            drive_stim(pkt);
            golden_model(pkt);
            @(negedge clk);
            check_result();
        end

        $display("\n------------------------------------------------------------------------------------------------------------------------");
        $display("--------------------------------------- [ BURST READ TEST] -------------------------------------------------------");
        $display("--------------------------------------------------------------------------------------------------------------------------");

        repeat (10) begin
            pkt = new();
            pkt.reset_c.constraint_mode(0); // off

            pkt.size.rand_mode(0); //off
            pkt.len.rand_mode(1);
            pkt.we.rand_mode(0);
            
            pkt.we         = AXI_READ;
            pkt.size       = 3'd2;
            generate_stimulus(pkt);
            drive_stim(pkt);
            golden_model(pkt);
            @(negedge clk);
            check_result();

        end
//...................................................................................................................................................................
        $display("\n------------------------------------------------------------------------------------------------------------------------");
        $display("--------------------------------------- [  RANDOM ] ------------------------------------------------------------------");
        $display("--------------------------------------------------------------------------------------------------------------------------");

        repeat (100) begin
            pkt = new();
            pkt.reset_c.constraint_mode(0); // off

            pkt.size.rand_mode(1); 
            pkt.len.rand_mode(1);
            pkt.we.rand_mode(1);

            generate_stimulus(pkt);
            drive_stim(pkt);
            golden_model(pkt);
            @(negedge clk);
            check_result();

        end
        
        $display("\n------------------------------------------------------------------------------------------------------------------------");
        $display("--------------------------------------- [ TOTAL RANDOM ] ------------------------------------------------------------------");
        $display("--------------------------------------------------------------------------------------------------------------------------");

        repeat (300) begin
            pkt = new();
            pkt.reset_c.constraint_mode(1); // on

            pkt.size.rand_mode(1); //on
            pkt.len.rand_mode(1);
            pkt.we.rand_mode(1);
            
            
            generate_stimulus(pkt);
            drive_stim(pkt);
            golden_model(pkt);
            @(negedge clk);
            check_result();

        end

        
        `ifdef RUN_ADVANCED_TESTS
            mid_fight_reset(); 
            #10;
            back_to_back_pkts(); 
            #10;
            for_fn_cov();
            //#10;
            //write_cross_condition_hit();
        `endif


        $display("\n --------------------------------------------------------------");
        $display(" Pass count :) = %0d | Error Count :( = %0d",  pass_count, fail_count );
        $display("--------------------------------------------------------------");      

        
        #1;
        $stop;

    end


////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////// [TASKS] ////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////

    task reset();
        axi_if_tb.ARESETn = 0;
        @(negedge clk);
        axi_if_tb.ARESETn = 1;
    endtask







///////////////
///////////////
///////////////






    task automatic generate_stimulus(ref axi_packet pkt);
        assert(pkt.randomize()) else $fatal("Randomization failed!");
        pkt.print();
    endtask







///////////////
///////////////
///////////////






   
task automatic drive_stim(ref axi_packet pkt);
        int beat_count = pkt.len + 1;
        int i;

        expected_queue.delete();
        actual_queue.delete();

        if(pkt.we == AXI_WRITE)begin
            //----------------------- WRITE -------------------------
            
            // 1.Write Address Channel (drive negedge, handshake posedge)
            axi_if_tb.AWVALID = 1;
            axi_if_tb.AWLEN   = pkt.len;
            axi_if_tb.AWSIZE  = pkt.size;
            axi_if_tb.AWADDR  = pkt.addr;

            do @(posedge clk); while (!axi_if_tb.AWREADY);
            $display("[WRITE] @%0t AW handshake done, AWREADY = %0b",$time(), axi_if_tb.AWREADY);
            
            // Deassert AWVALID on next negedge  (address phase complete)
            @(negedge clk);
            axi_if_tb.AWVALID = 0;
    
            // 2.Write Data Channel
            $display("[WRITE] @%0t Start Writing ...", $time());
            for (i = 0; i < beat_count; i++)begin
                
                // Randomly stall before sending the next beat (Master Delay)
                axi_if_tb.WVALID = 0;
                repeat ($urandom_range(0, 2)) @(negedge clk);

                // Drive data on negedge, then wait for ready on posedge(s)
                axi_if_tb.WVALID = 1;
                axi_if_tb.WDATA = pkt.burst[i];
                axi_if_tb.WLAST = (i == beat_count-1);

                // Handshake on posedge WREADY
                do @(posedge clk); 
                while (!axi_if_tb.WREADY); 
            end

            // After last beat handshake, drop WVALID/WLAST
            @(negedge clk);
            axi_if_tb.WVALID = 0;
            axi_if_tb.WLAST  = 0;

            // 3. Write RESP Channel
            // Randomly delay asserting BREADY to test Slave stalling
            axi_if_tb.BREADY = 0;
            repeat ($urandom_range(0, 3)) @(negedge clk);
            axi_if_tb.BREADY = 1;

            do @(posedge clk);
            while (!axi_if_tb.BVALID);
            $display("[WRITE] @%0t :: BVALID seen = %0b", $time(), axi_if_tb.BVALID);
            
            @(negedge clk);
            if (axi_if_tb.BRESP == 2'b00)
                $display("[WRITE] @%0t :: RESPONSE = %0b (OKAY=00 expected)",$time(), axi_if_tb.BRESP);
            else
                $display("[WRITE] @%0t :: RESPONSE = %0b (SLVERR=10 expected)",$time(), axi_if_tb.BRESP);
            
            axi_if_tb.BREADY = 0;
            $display("[WRITE_OP DRIVE COMPLETED] @%0t :: Addr=%0d | Burst_beats =%0d | LEN =%0d ",$time(), pkt.addr, beat_count, pkt.len);
            $display("--------------");
        end

        else begin
        //----------------------- Read -------------------------

            // 1. Address Read
            axi_if_tb.ARADDR = pkt.addr;
            axi_if_tb.ARLEN  = pkt.len;
            axi_if_tb.ARSIZE = pkt.size;    
            axi_if_tb.ARVALID = 1; 

            do @(posedge clk); while (!axi_if_tb.ARREADY);
            $display("[READ] @%0t :: AR handshake done, ARREADY = %0b",$time(), axi_if_tb.ARREADY);
                    
            @(negedge clk); 
            axi_if_tb.ARVALID = 0;

            // address handshake done
            $display("[READ] @%0t :: Start Reading Data ", $time());
            for (i = 0; i < beat_count; i++)begin  

                // Randomly delay asserting RREADY to make the Slave wait
                axi_if_tb.RREADY = 0;
                repeat ($urandom_range(0, 2)) @(negedge clk);
                axi_if_tb.RREADY = 1;

                // Wait for next valid beat
                do @(posedge clk);
                while (!axi_if_tb.RVALID);

                actual_queue.push_back(axi_if_tb.RDATA);
                
                `ifdef DEBUG_STIM
                    $display("[READ] @%0t READ[%0d] :: DATA = 0x%0h | RLAST = %0b",$time(), i, axi_if_tb.RDATA, axi_if_tb.RLAST);
                `endif
                
                if (axi_if_tb.RLAST) begin
                    break;
                end

            end

            @(negedge clk);
            axi_if_tb.RREADY = 0;
            $display("[READ] @%0t :: Finished Reading Data, beats = %0d",$time(), actual_queue.size());
            $display("--------------");
        end

        `ifdef DEBUG_STIM
            foreach (actual_queue[j]) begin
                $display(" actual_queue[%0d] = 0x%0h", j, actual_queue[j]);
            end
        `endif
        
    endtask







///////////////
///////////////
///////////////






   
    task automatic golden_model(ref axi_packet pkt);
        
        beat_count     = pkt.len + 1;           // Number of beats and bytes per beat
        bytes_per_beat = 1 << pkt.size;         // =4 for size=2 (word)

        start_addr_byte = pkt.addr;             // AXI address is in bytes
        last_addr_byte  = start_addr_byte + beat_count*bytes_per_beat;


        base_word_index = start_addr_byte >> $clog2(axi_if_tb.DATA_WIDTH/8);
        // Compute base word index (byte -> word address)
        // With 32-bit data, this is same as: base_word_index = start_addr_byte >> 2;
        // Word size = DATA_WIDTH/8 bytes = 4 for 32-bit data,
        // so shift by 2 bits to get word index.


        // Default: assume OKAY
        RESP_GM   = 2'b00;
        pkt.resp  = 2'b00;                     // so coverage in axi_packet can see it

        //------------------- 4KB Boundry check (depth = 1024 words) ---------------

        // Total memory bytes = DEPTH * (DATA_WIDTH/8) = 1024*4 = 4096
        // Out of range / burst crosses the 4KB area OR word index range is NOT inside memory
        if ( (start_addr_byte >= axi_if_tb.DEPTH * (axi_if_tb.DATA_WIDTH/8) ) || (base_word_index + beat_count > axi_if_tb.DEPTH) ) begin
            
            RESP_GM  = 2'b10;  // SLVERR
            pkt.resp = 2'b10;

            if (pkt.we == AXI_READ) begin
                // Spec: error read returns zerost 
                for (i = 0; i < beat_count; i++) begin
                    expected_queue.push_back('0);
                    `ifdef DEBUG_STIM
                        $display("[GM][READ] @%0t :: mem[%0d] | expected_queue[%0d] = 0x%0h",$time(),base_word_index + i, i, gm_mem[base_word_index + i]);
                    `endif 
                end
                
            end
            // For write errors: we DO NOT update gm_mem at all
            
            if (base_word_index + beat_count > axi_if_tb.DEPTH) begin
                $display("[GM][SLVERR] @%0t :: word index overflow base=%0d | beats=%0d",$time(), base_word_index, beat_count);
            end else begin
                $display("[GM][SLVERR] @%0t :: addr=0x%0d | len=%0d (bytes_per_beat=%0d)",$time(), pkt.addr, beat_count, bytes_per_beat);
            end

            return; // do not fall through to the case

        end


        case (pkt.we)
            //------------------- Write Operation ---------------
            AXI_WRITE: begin

                for (i = 0; i < beat_count; i++) begin
                    gm_mem[base_word_index + i] = pkt.burst[i];
                    `ifdef DEBUG_STIM
                        $display("[GM][WRITE] @%0t :: mem[%0d] = 0x%0h",$time(),base_word_index + i, pkt.burst[i]);
                    `endif
                end
                RESP_GM  = 2'b00;
                pkt.resp = 2'b00;

            end

            //------------------- Read Operation ---------------
            AXI_READ : begin
                $display("--------------");
                for (i = 0; i < beat_count; i++) begin
                    dut_data = axi4_top.uut.mem_inst.memory[base_word_index + i];
                    expected_queue.push_back(dut_data); 
                    `ifdef DEBUG_STIM
                        $display("[GM][READ] @%0t :: mem[%0d] | expected_queue[%0d] = 0x%0h",$time(),base_word_index + i, i, gm_mem[base_word_index + i]);
                    `endif 
                end
                RESP_GM  = 2'b00;
                pkt.resp = 2'b00;

            end
        endcase 

        $display("[GM DONE] @%0t :: op= %s | addr= %0d | beats= %0d | RESP_GM=%0b",$time(),pkt.we.name(),pkt.addr, beat_count, RESP_GM);
        $display("--------------");
    endtask







///////////////
///////////////
///////////////






   
    task automatic check_result();
        trans_pass = 1;

        //------------------------------- READ -------------------------------
        if(pkt.we == AXI_READ) begin 

            // --- DATA ----
            if (!(expected_queue == actual_queue)) begin
                trans_pass = 0;
                $error("[FAILED READ DATA] @%0t | expected_queue != actual_queue", $time());
            end
            else begin
                $display("[PASSED READ DATA] @%0t", $time());
                foreach (actual_queue[j]) begin
                    $display(" actual_queue[%0d] = 0x%0h | expected_queue[%0d] = 0x%0h", j, actual_queue[j],j, expected_queue[j]);
                end
            end

            // --- RESP ---
            if (RESP_GM !== axi_if_tb.RRESP) begin
                trans_pass = 0;
                $error("[FAILED READ RESPONSE] @%0t :: RRESP = %0b | GM = %0b",$time(), axi_if_tb.RRESP, RESP_GM);
            end
            else begin
                $display("[PASSED READ RESPONSE] @%0t :: RRESP = %0b | GM = %0b",$time(), axi_if_tb.RRESP, RESP_GM);
            end

            //--- Counter ---
            if (trans_pass) begin
                pass_count++;
                $display("\n [PASSED READ TRANSACTION] @%0t :: pass_count = %0d", $time(), pass_count);
            end
            else begin
                fail_count++;
                $error("[FAILED READ TRANSACTION] @%0t :: fail_count = %0d", $time(), fail_count);
            end
        
        end

        //------------------------------- WRITE ------------------------------- 
        else begin
            // --- RESP ---   
            if (RESP_GM !== axi_if_tb.BRESP) begin
                trans_pass = 0;
                $error("[FAILED WRITE RESPONSE] @%0t :: BRESP = %0b | GM = %0b \n",$time(), axi_if_tb.BRESP, RESP_GM);
            end
            else begin
                $display("[PASSED WRITE RESPONSE] @%0t :: BRESP = %0b | GM = %0b",$time(), axi_if_tb.BRESP, RESP_GM);
            end

            // --- DATA ----

            // Only if we expect OKAY (RESP_GM == 2'b00), check DUT memory
            if (RESP_GM == 2'b00) begin
                $display("[MEM CHECK] @%0t :: Checking DUT memory for this WRITE",$time());

                for (int k = 0; k < beat_count; k++) begin
                    int idx = base_word_index + k;

                    // backdoor read from DUT memory
                    dut_data = axi4_top.uut.mem_inst.memory[idx];

                    if (dut_data !== gm_mem[idx]) begin
                        trans_pass = 0;
                        $error("\n [MEM MISMATCH] @%0t idx=%0d | DUT=0x%0h | GM=0x%0h ",$time(), idx, dut_data, gm_mem[idx]);
                    end
                    else begin
                        `ifdef DEBUG_STIM
                            $display("[MEM OK] @%0t idx=%0d data=0x%0h",$time(), idx, dut_data);
                        `endif
                    end
                end

            end

            //--- Counter ---

            if (trans_pass) begin
                pass_count++;
                $display("\n[PASSED WRITE TRANSACTION] @%0t | pass_count = %0d \n", $time(), pass_count);
            end
            else begin
                fail_count++;
                $error("[FAILED WRITE TRANSACTION] @%0t | fail_count = %0d", $time(), fail_count);
            end


        end

        pkt.axi_cov.sample();     // transaction-level coverage
        pkt.sample_burst_cov();   // per-beat data coverage    

    endtask








///////////////
///////////////
///////////////






   
    task mid_fight_reset;
        $display("\n----------------------------------------------------------------------------------");
        $display("-------------------- [ MID-FLIGHT RESET TEST (FORK...JOIN) ] ---------------------");
        $display("----------------------------------------------------------------------------------");

        // Clear the bus to ensure a clean start
        axi_if_tb.AWVALID = 0;
        axi_if_tb.WVALID  = 0;
        axi_if_tb.ARVALID = 0;
        @(posedge clk);

        // ---------------------------------------------------------
        // 1. Reset from W_ADDR -> W_IDLE 
        // ---------------------------------------------------------
        $display("[TEST] :: Asserting reset during W_ADDR state");
        fork
            begin // Thread 1: Drive Address Phase
                axi_if_tb.AWADDR  = 'h80;
                axi_if_tb.AWLEN   = 4;
                axi_if_tb.AWSIZE  = 2;
                axi_if_tb.AWVALID = 1;
                
                @(posedge clk iff axi_if_tb.AWREADY == 1);
                axi_if_tb.AWVALID = 0; 
            end
            
            begin // Thread 2: Monitor and Reset
                // Wait for the exact moment the AW handshake occurs
                @(posedge clk iff (axi_if_tb.AWVALID && axi_if_tb.AWREADY));
                
                #2; // Give it a tiny delay to let the FSM step into W_ADDR 
                axi_if_tb.ARESETn = 0; 
                $display("[TEST] :: Reset triggered mid-flight (W_ADDR)!");
                
                #10;
                axi_if_tb.ARESETn = 1; // Release reset
            end
        join
        @(posedge clk); // recover cycle before the next test :)
        $display("[TEST] :: OUT FROM FORK [1] W_ADDR -> W_IDLE");

        // ---------------------------------------------------------
        // 2. Reset from W_DATA -> W_IDLE
        // ---------------------------------------------------------
        $display("[TEST] :: Asserting reset during W_DATA state...");
        fork
            begin // Thread 1: Drive Address Phase
                axi_if_tb.AWADDR  = 'h90;
                axi_if_tb.AWVALID = 1;
                
                @(posedge clk iff axi_if_tb.AWREADY == 1);
                axi_if_tb.AWVALID = 0;
            end
            
            begin // Thread 2: Monitor and Reset
                @(posedge clk iff (axi_if_tb.AWVALID && axi_if_tb.AWREADY));
                // The FSM takes 1 clock cycle to move from W_ADDR to W_DATA
                // So we wait one extra clock edge here :) , 2a2l yom f el axi :)
                @(posedge clk); 
                
                #2; // ehtyaty but the FSM should be in W_DATA now 
                axi_if_tb.ARESETn = 0; 
                $display("[TEST] :: Reset triggered mid-flight (W_DATA)!");
                
                #10;
                axi_if_tb.ARESETn = 1;
            end
        join
        @(posedge clk);
        $display("[TEST] :: OUT FROM FORK [2] W_DATA -> W_IDLE");

        // ---------------------------------------------------------
        // 3. Reset from R_ADDR -> R_IDLE
        // ---------------------------------------------------------
        $display("[TEST] :: Asserting reset during R_ADDR state...");
        fork
            begin // Thread 1: Drive Read Address Phase
                axi_if_tb.ARADDR  = 'hA0;
                axi_if_tb.ARLEN   = 4;
                axi_if_tb.ARSIZE  = 2;
                axi_if_tb.ARVALID = 1;
                
                @(posedge clk iff axi_if_tb.ARREADY == 1);
                axi_if_tb.ARVALID = 0;
            end
            
            begin // Thread 2: Monitor and Reset
                @(posedge clk iff (axi_if_tb.ARVALID && axi_if_tb.ARREADY));
                
                #2;
                axi_if_tb.ARESETn = 0; 
                $display("[TEST] :: Reset triggered mid-flight (R_ADDR)!");
                
                #10;
                axi_if_tb.ARESETn = 1;
            end
        join
        @(posedge clk);
        $display("[TEST] :: OUT FROM FORK [3] R_ADDR -> R_IDLE");        
        $display("----------------------------------------------------------------------------------");

    endtask









///////////////
///////////////
///////////////






   
    task automatic back_to_back_pkts();

        axi_packet pkt1, pkt2; // For Writes
        axi_packet pkt3, pkt4; // For Reads
        
        // Local flags for checker counters 
        bit pkt1_pass, pkt2_pass, pkt3_pass, pkt4_pass;
        
        // Variables to capture Write Responses
        logic [1:0] bresp1, bresp2;

        $display("[TEST] :: BACK-TO-BACK FORKS TEST ");



        // 1. WRITE PIPELINING (Hit AWVALID=1 & AWREADY=0, WVALID=1 & WREADY=0)
        $display("\n------------------------------------------------------------------------------------------------------------------------");
        $display("--------------------------------------- [ [WRITE] :: BACK-TO-BACK FORKS TEST ] --------------------------------------------");
        $display("--------------------------------------------------------------------------------------------------------------------------\n");
        $display("[TEST] :: !! WRITE BACK-TO-BACK FORKS WILL START !! ");

        // Generate two randomized valid write packets
        pkt1 = new();
        pkt1.reset_c.constraint_mode(0);
        pkt1.we = AXI_WRITE;
        pkt1.addr_range = IN_BOUND;
        generate_stimulus(pkt1);

        pkt2 = new(); 
        pkt2.reset_c.constraint_mode(0); 
        pkt2.we = AXI_WRITE; 
        pkt2.addr_range = IN_BOUND;
        generate_stimulus(pkt2);

        //------------------------------- DRIVING WRITE, PACKETS IN 3 THREADS FOR 3 CHANNELS --------------------------------
        fork
            // -- Thread 1, AW (Address Write) Channel  --
            begin
                $display("[TEST] :: WRITE BACK-TO-BACK FORK[1] (Address Write) TEST ");
                
                // Drive pkt1 Address
                @(negedge clk);
                axi_if_tb.AWADDR  = pkt1.addr;
                axi_if_tb.AWLEN   = pkt1.len;
                axi_if_tb.AWSIZE  = pkt1.size;
                axi_if_tb.AWVALID = 1;
                do @(posedge clk); while(!axi_if_tb.AWREADY);
                
                // Drive pkt2 Address immediately (AWREADY is 0 here 3shan l dut busy in WDATA State)
                @(negedge clk);
                axi_if_tb.AWADDR  = pkt2.addr;
                axi_if_tb.AWLEN   = pkt2.len;
                axi_if_tb.AWSIZE  = pkt2.size;
                axi_if_tb.AWVALID = 1;  
                do @(posedge clk); while(!axi_if_tb.AWREADY);
                
                @(negedge clk);
                axi_if_tb.AWVALID = 0;
                $display("[TEST] (Address Write) :: WRITE BACK-TO-BACK FORK[1]  5lsnaaaaaa ");
            end

            // -- Thread 2: W (Data Write) Channel Master --
            begin
                $display("[TEST] (Data Write) :: WRITE BACK-TO-BACK FORK[2] TEST ");
                
                // Drive pkt1 Data 
                for (int i = 0; i <= pkt1.len; i++) begin
                    @(negedge clk);
                    axi_if_tb.WDATA  = pkt1.burst[i];
                    axi_if_tb.WLAST  = (i == pkt1.len);
                    axi_if_tb.WVALID = 1;
                    do @(posedge clk); while(!axi_if_tb.WREADY);
                end

                // pkt2 Data Packet immediately
                for (int i = 0; i <= pkt2.len; i++) begin
                    @(negedge clk);
                    axi_if_tb.WDATA  = pkt2.burst[i];
                    axi_if_tb.WLAST  = (i == pkt2.len);
                    axi_if_tb.WVALID = 1;
                    do @(posedge clk); while(!axi_if_tb.WREADY);
                end
                
                @(negedge clk);
                axi_if_tb.WVALID = 0;
                axi_if_tb.WLAST  = 0;
                $display("[TEST] :: WRITE BACK-TO-BACK FORK[2] (Data Write) TEST  5lsnaaaaaaaa");
            end

            // -- Thread 3: B (Write Response) Channel Master --
            begin
                $display("[TEST] (Write Response):: WRITE BACK-TO-BACK FORK[3]  TEST ");
                @(negedge clk);
                axi_if_tb.BREADY = 1;
                
                // Wait for 1st response handshake
                do @(posedge clk); while(!axi_if_tb.BVALID);
                bresp1 = axi_if_tb.BRESP; // Capture 1st Response
                
                // Wait for 2nd response handshake
                do @(posedge clk); while(!axi_if_tb.BVALID);
                bresp2 = axi_if_tb.BRESP; // Capture 2nd Response
                
                @(negedge clk);
                axi_if_tb.BREADY = 0;
            end
        join


        //------------------------------- CHECKING THE PACKETS --------------------------------
        golden_model(pkt1);
        // PKT 1
        pkt1_pass = 1;
        if (bresp1 !== pkt1.resp) pkt1_pass = 0; // Check BRESP
        for (int k = 0; k <= pkt1.len; k++) begin
            int idx = (pkt1.addr >> 2) + k;
            if (axi4_top.uut.mem_inst.memory[idx] !== gm_mem[idx]) pkt1_pass = 0;
        end
        if (pkt1_pass) begin
            pass_count++;
            $display("\n[PASSED WRITE TRANSACTION] @%0t | Packet (%0d) | pass_count = %0d \n", $time(), pkt1.id, pass_count);
        end else begin
            fail_count++;
            $error("[FAILED WRITE TRANSACTION] @%0t| Packet (%0d) |  fail_count = %0d", $time(), pkt1.id, fail_count);
        end

        golden_model(pkt2);
        // PKT 2
        pkt2_pass = 1;
        if (bresp2 !== pkt2.resp) pkt2_pass = 0; // Check BRESP
        for (int k = 0; k <= pkt2.len; k++) begin
            int idx = (pkt2.addr >> 2) + k;
            if (axi4_top.uut.mem_inst.memory[idx] !== gm_mem[idx]) pkt2_pass = 0;
        end
        if (pkt2_pass) begin
            pass_count++;
            $display("\n[PASSED WRITE TRANSACTION] @%0t | Packet (%0d) | pass_count = %0d \n", $time(), pkt2.id, pass_count);
        end else begin
            fail_count++;
            $error("[FAILED WRITE TRANSACTION] @%0t| Packet (%0d) |  fail_count = %0d", $time(), pkt2.id, fail_count);
        end

    //......................................................................................................................................................................

        // 2. READ PIPELINING (Hit ARVALID=1 & ARREADY=0)
        $display("\n------------------------------------------------------------------------------------------------------------------------");
        $display("--------------------------------------- [ [READ] :: BACK-TO-BACK FORKS TEST ] --------------------------------------------");
        $display("--------------------------------------------------------------------------------------------------------------------------\n");
        $display("[TEST] :: !! READ BACK-TO-BACK FORKS WILL START !! ");

        // Generate two randomized valid read packets
        pkt3 = new();
        pkt3.reset_c.constraint_mode(0);
        pkt3.we = AXI_READ;
        pkt3.addr_range = IN_BOUND;
        generate_stimulus(pkt3);

        pkt4 = new();
        pkt4.reset_c.constraint_mode(0);
        pkt4.we = AXI_READ;
        pkt4.addr_range = IN_BOUND;
        generate_stimulus(pkt4);


        fork
            // -- Thread 1: AR (Address Read) Channel Master --
            begin
                $display("[TEST] (Address Read) :: READ BACK-TO-BACK FORK[1]  TEST ");
                
                $display("[TEST] (Address Read) :: Drive 1st Read Address");
                @(negedge clk);
                axi_if_tb.ARADDR  = pkt3.addr;
                axi_if_tb.ARLEN   = pkt3.len;
                axi_if_tb.ARSIZE  = pkt3.size;
                axi_if_tb.ARVALID = 1;
                do @(posedge clk); while(!axi_if_tb.ARREADY);
                
                $display("[TEST] (Address Read) :: Blast 2nd Read Address immediately");
                @(negedge clk);
                axi_if_tb.ARADDR  = pkt4.addr;
                axi_if_tb.ARLEN   = pkt4.len;
                axi_if_tb.ARSIZE  = pkt4.size;
                axi_if_tb.ARVALID = 1; 
                do @(posedge clk); while(!axi_if_tb.ARREADY);
                
                @(negedge clk);
                axi_if_tb.ARVALID = 0;
                $display("[TEST] (Address Read) :: READ BACK-TO-BACK FORK[1]  TEST 5lsnaaaaaaaa");
            end

            // -- Thread 2: R (Data Read) Channel Master --
            begin
                $display("[TEST] (Data Read) :: READ BACK-TO-BACK FORK[2]  TEST  ");
                @(negedge clk);
                axi_if_tb.RREADY = 1;
                

                // Check 1st Read Data Packet 
                $display("[TEST] (Data Read) :: Check PKT3 ");
                pkt3_pass = 1;
                for (int i = 0; i <= pkt3.len; i++) begin
                    do @(posedge clk); while(!axi_if_tb.RVALID);
                    if (axi_if_tb.RDATA !== axi4_top.uut.mem_inst.memory[(pkt3.addr >> 2) + i]) pkt3_pass = 0;
                    
                end
                golden_model(pkt3);
                if (axi_if_tb.RRESP !== pkt3.resp) pkt3_pass = 0; // Check RRESP


                if (pkt3_pass) begin
                    pass_count++;
                    $display("\n[PASSED READ TRANSACTION] @%0t | Packet (%0d) | pass_count = %0d \n", $time(), pkt3.id, pass_count);
                end
                else begin
                    fail_count++;
                    $error("[FAILED READ TRANSACTION] @%0t| Packet (%0d) |  fail_count = %0d", $time(), pkt3.id, fail_count);
                end



                // Check 2nd Read Data Packet
                $display("[TEST] (Data Read) :: Check PKT4 ");
                pkt4_pass = 1;
                for (int i = 0; i <= pkt4.len; i++) begin
                    do @(posedge clk); while(!axi_if_tb.RVALID);
                    if (axi_if_tb.RDATA !== axi4_top.uut.mem_inst.memory[(pkt4.addr >> 2) + i] ) pkt4_pass = 0;
                end 
                golden_model(pkt4);
                if (axi_if_tb.RRESP !== pkt4.resp) pkt4_pass = 0; // Check RRESP


                if (pkt4_pass) begin
                    pass_count++;
                    $display("\n[PASSED READ TRANSACTION] @%0t | Packet (%0d) | pass_count = %0d \n", $time(), pkt4.id, pass_count);
                end 
                else begin
                    fail_count++;
                    $error("[FAILED READ TRANSACTION] @%0t| Packet (%0d) |  fail_count = %0d", $time(), pkt4.id, fail_count);
                end

                
                @(negedge clk);
                axi_if_tb.RREADY = 0;
                $display("[TEST] :: READ BACK-TO-BACK FORK[2] (Data Read) TEST 5lsnaaaaaaaa ");
            end
        join

        $display("[TEST] BACK TO BACK FORKS DONEEEEE YAYYYYY !! ;)");
    endtask








///////////////
///////////////
///////////////





task write_cross_condition_hit;
        $display("\n ------------------------------------------------------------------------------- ");
        $display(" ------------------ BOUNDARY CROSS WRITE TEST ------------------------------------ ");
        $display(" --------------------------------------------------------------------------------- ");
        
        // 1. Setup the packet right at the 4KB edge bzbt 
        pkt = new();
        pkt.we         = AXI_WRITE;
        pkt.addr       = 32'hFFFC; // 4092 - 4 bytes before the 4096 boundary
        pkt.len        = 7'd1;     // Burst of 2 beats (will cross the boundary)
        pkt.size       = 3'd2;     // 4 bytes per beat
        pkt.addr_range = OUT_BOUND;
        
        // 2. Give it 2 beats of data
        pkt.burst = new[2];
        pkt.burst[0] = 32'hDEAD_BEEF; // This writes to 0x0FFC (OK)
        pkt.burst[1] = 32'hCAFE_BABE; // This tries to write to 0x1000 (SLVERR!)

        // 3. Drive, Golden Model, and Check
        drive_stim(pkt);      
        golden_model(pkt);    
        @(negedge clk);
        check_result();

    endtask


    // task write_cross_condition_hit;
    //     $display("\n ----------------------------------------------------------------------------------------- ");
    //     $display(" ------------------ COVERAGE HACK: EARLY WLAST ON BOUNDARY CROSS ------------------------- ");
    //     $display(" ----------------------------------------------------------------------------------------- ");
        
    //     // 1. Drive Address Phase (LEN = 1 means 2 beats, starting at 0x0FFC)
    //     axi_if_tb.AWVALID = 1;
    //     axi_if_tb.AWADDR  = 32'h0FFC; // 4092
    //     axi_if_tb.AWLEN   = 1;        // Expecting 2 beats
    //     axi_if_tb.AWSIZE  = 2;
        
    //     do @(posedge clk); while (!axi_if_tb.AWREADY);
    //     @(negedge clk);
    //     axi_if_tb.AWVALID = 0;

    //     // 2. Drive Data Phase but ASSERT WLAST EARLY! 
    //     // We assert WLAST on the very first beat while write_burst_cnt is still 1
    //     axi_if_tb.WVALID = 1;
    //     axi_if_tb.WDATA  = 32'hDEAD_BEEF;
    //     axi_if_tb.WLAST  = 1; // <--- Early WLAST
        
    //     do @(posedge clk); while (!axi_if_tb.WREADY);
    //     @(negedge clk);
    //     axi_if_tb.WVALID = 0;
    //     axi_if_tb.WLAST  = 0;

    //     // 3. Wait for SLVERR Response
    //     axi_if_tb.BREADY = 1;
    //     do @(posedge clk); while (!axi_if_tb.BVALID);
    //     @(negedge clk);
    //     axi_if_tb.BREADY = 0;

    //     pkt = new();
    //     pkt.we         = AXI_WRITE;
    //     pkt.addr       = axi_if_tb.AWADDR;
    //     pkt.len   = axi_if_tb.AWLEN;
    //     pkt.size  = axi_if_tb.AWSIZE;
    //     pkt.addr_range = OUT_BOUND;
    //     pkt.burst = new[1];
    //     pkt.burst[0] = axi_if_tb.WDATA;
    //     golden_model(pkt);    
    //     @(negedge clk);
    //     check_result();

    // endtask



///////////////
///////////////
///////////////



   
    task for_fn_cov;
        $display("\n ----------------------------------------------------------------------------------------- ");
        $display(" ------------------ DIRECTED WRITE TEST: SINGLE BEAT OUT OF RANGE -------------------------- ");
        $display(" ----------------------------------------------------------------------------------------- ");
        pkt = new();

        pkt.we         = AXI_WRITE; 
        pkt.addr       = 32'h1000;  // Address 4096 (Awel byte barra el 4KB memory bta3ty)
        pkt.size       = 3'd2;      // 4 bytes per beat
        pkt.len        = 7'd0;      // length = 0 ya3ny Single Beat
        pkt.addr_range = OUT_BOUND; 

        // Data array size = 1 (Single beat)
        pkt.burst = new[1];
        pkt.burst[0] = 32'hDEAD_BEEF;

        // Execute the transaction
        drive_stim(pkt);      
        golden_model(pkt);    
        @(negedge clk);
        check_result();
    endtask


endmodule













/*

// Old driv with no delays that cause a holes in code coverage , 

    task automatic drive_stim(ref axi_packet pkt);
        int beat_count = pkt.len + 1;
        int i;

        expected_queue.delete();
        actual_queue.delete();
        
        if(pkt.we == AXI_WRITE)begin
            //----------------------- WRITE -------------------------
            
            // 1.Write Address Channel (drive negedge, handshake posedge)
            axi_if_tb.AWVALID = 1;
            axi_if_tb.AWLEN   = pkt.len;
            axi_if_tb.AWSIZE  = pkt.size;
            axi_if_tb.AWADDR  = pkt.addr;

            
            do @(posedge clk); while (!axi_if_tb.AWREADY); // Wait for a posedge where AWREADY is high
            $display("[WRITE] @%0t AW handshake done, AWREADY = %0b",$time(), axi_if_tb.AWREADY);
            
            // Deassert AWVALID on next negedge  (address phase complete)
            @(negedge clk);   
            axi_if_tb.AWVALID = 0;
    
            // 2.Write Data Channel
            axi_if_tb.WVALID  = 1;
            axi_if_tb.BREADY  = 1;
            $display("[WRITE] @%0t Start Writing ...", $time());
            for (i = 0; i < beat_count; i++)begin
                // Drive data on negedge, then wait for ready on posedge(s)
                @(negedge clk);
                axi_if_tb.WDATA = pkt.burst[i];
                axi_if_tb.WLAST = (i == beat_count-1);

                // Handshake on posedge WREADY
                //do @(posedge clk); while (!axi_if_tb.WREADY); 
            end

            // After last beat handshake, drop WVALID/WLAST
            @(negedge clk);
            axi_if_tb.WVALID = 0;
            axi_if_tb.WLAST  = 0;

            // 3. Write RESP Channel
            do @(posedge clk); while (!axi_if_tb.BVALID);
            $display("[WRITE] @%0t :: BVALID seen = %0b", $time(), axi_if_tb.BVALID);
            
            @(negedge clk); 
            if (axi_if_tb.BRESP == 2'b00)
                $display("[WRITE] @%0t :: RESPONSE = %0b (OKAY=00 expected)",$time(), axi_if_tb.BRESP);
            else
                $display("[WRITE] @%0t :: RESPONSE = %0b (SLVERR=10 expected)",$time(), axi_if_tb.BRESP);

            axi_if_tb.BREADY = 0;
            $display("[WRITE_OP DRIVE COMPLETED] @%0t :: Addr=%0d | Burst_beats =%0d | LEN =%0d ",$time(), pkt.addr, beat_count, pkt.len);
            $display("--------------");
        end

        else begin
        //----------------------- Read -------------------------

            // 1. Address Read
            axi_if_tb.ARADDR = pkt.addr;
            axi_if_tb.ARLEN  = pkt.len;
            axi_if_tb.ARSIZE = pkt.size;    
            axi_if_tb.ARVALID = 1; 

            do @(posedge clk); while (!axi_if_tb.ARREADY);
            $display("[READ] @%0t :: AR handshake done, ARREADY = %0b",$time(), axi_if_tb.ARREADY);
                    
            @(negedge clk); 
            axi_if_tb.ARVALID = 0; // address handshake done
            axi_if_tb.RREADY  = 1; // Now ready to accept data

            do @(posedge clk); while (!axi_if_tb.RVALID);
            $display("[READ] @%0t :: First RVALID = %0b",$time(), axi_if_tb.RVALID);
            
            $display("[READ] @%0t :: Start Reading Data ", $time());
            for (i = 0; i < beat_count; i++)begin  

                actual_queue.push_back(axi_if_tb.RDATA); // At this posedge we already know RVALID==1
                `ifdef DEBUG_STIM
                    $display("[READ] @%0t READ[%0d] :: DATA = 0x%0h | RLAST = %0b",$time(), i, axi_if_tb.RDATA, axi_if_tb.RLAST);
                `endif
                if (axi_if_tb.RLAST) begin
                    break;
                end

                // Wait for next valid beat
                do @(posedge clk); while (!axi_if_tb.RVALID);

            end

            @(negedge clk);
            axi_if_tb.RREADY = 0;
            $display("[READ] @%0t :: Finished Reading Data, beats = %0d",$time(), actual_queue.size());
            $display("--------------");
        end

        `ifdef DEBUG_STIM
            foreach (actual_queue[j]) begin
                $display(" actual_queue[%0d] = 0x%0h", j, actual_queue[j]);
            end
        `endif
        
    endtask
*/


>>>>>>> 7968f542d993b7369b31cb2b1d005d0ea04dc4bd
