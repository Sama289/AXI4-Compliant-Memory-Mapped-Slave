<<<<<<< HEAD
module axi4_sva#(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 16,
    parameter MEMORY_DEPTH = 1024
)(
	input bit                     ACLK,
	input bit                     ARESETn,

	// Write address channel
	input logic [axi4if.ADDR_WIDTH_S-1:0] AWADDR,ARADDR,
	input logic [7:0]                     AWLEN,
	input logic [2:0]                     AWSIZE,	
	input logic                           AWVALID,
	input logic                           AWREADY,
	
	// Write data channel
	input logic [axi4if.DATA_WIDTH-1:0]   WDATA,
	input logic                           WVALID,
	input logic                           WLAST,
	input logic                           WREADY,
	
	// Write Response channel
	input logic                           BREADY,
	input logic                           BVALID,
	input logic [1:0]                     BRESP,
	
	// Read address channel
	input logic [7:0]                     ARLEN,
	input logic [2:0]                     ARSIZE,
	input logic                           ARVALID,
	input logic                           ARREADY,
	
	// Read data channel
	input logic                           RREADY,
	input logic                           RLAST,RVALID,
	input logic [31:0]                    RDATA,
	input logic [1:0]                     RRESP
);


    // Beats counters for burst assertions
    logic [8:0] write_beat_count;
    logic [8:0] read_beat_count;
    logic [8:0] num_of_write_beats;
    logic [8:0] num_of_read_beats;

    // Boundary flags for 4KB assertions
    logic write_crossed_4kb;
    logic read_crossed_4kb;
    logic write_addr_in_mem_range;
    logic read_addr_in_mem_range;
    
    // Beat counters and expected values calc
    always_ff @(posedge ACLK or negedge ARESETn) begin
        if (!ARESETn) begin
            write_beat_count <= 0;
            read_beat_count <= 0;
            num_of_write_beats <= 0;
            num_of_read_beats <= 0;
        end
        else begin
            // Write address phase 
            if (AWVALID && AWREADY) begin
                num_of_write_beats <= AWLEN + 1;
                write_beat_count <= 0;
            end            
            // Write data phase 
            if (WVALID && WREADY) begin
                write_beat_count <= write_beat_count + 1;
            end
            // Read address phase 
            if (ARVALID && ARREADY) begin
                num_of_read_beats <= ARLEN + 1;
                read_beat_count <= 0;
            end           
            // Read data phase 
            if (RVALID && RREADY) begin
                read_beat_count <= read_beat_count + 1;
            end

        end
    end
    
    // Flags calc for Boundary crossing detection
    always_comb begin
        write_crossed_4kb = ((AWADDR & 12'hFFF) + ((AWLEN + 1) << AWSIZE)) > 12'hFFF;
        read_crossed_4kb = ((ARADDR & 12'hFFF) + ((ARLEN + 1) << ARSIZE)) > 12'hFFF;
        write_addr_in_mem_range = ((AWADDR >> 2) + (AWLEN + 1)) <= MEMORY_DEPTH;
        read_addr_in_mem_range = ((ARADDR >> 2) + (ARLEN + 1)) <= MEMORY_DEPTH;
    end


 //...................................................... ASSERTIONS ......................................................
 
  `ifdef SVA_MODE

  	//--------------------------------------------------------------------------------------
  	//--------------------------------- PROPERTIES -----------------------------------------
  	//--------------------------------------------------------------------------------------

	    //Reset checker
    	always_comb begin 
            if(!ARESETn)
                assert_rst_n: assert final(AWREADY === 1 && WREADY === 0 && BRESP === 0 && BVALID === 0 && ARREADY === 1 && RDATA === 0 && RRESP === 0 && RLAST === 0 && RVALID ===0);
    	end

    	//Clock Checker
    	bit clk;
     	parameter CLK_PERIOD = 10;
    	always begin
           clk = ACLK;
           #(CLK_PERIOD/2);
           #0;
           clk_check: assert(ACLK == ~clk ) else $error("CLK ASSERTION FAILED !");
    	end

    	//--------------------------------------------------------
    	//------------------------[HANDSHAKES]--------------------
    	//--------------------------------------------------------

			property valid_before_ready (logic VALID, logic READY); 				
				@(posedge ACLK) disable iff (!ARESETn) (VALID && !READY) |=> VALID;
			endproperty

			assert property (valid_before_ready(WVALID, WREADY)) else $error("[HANDSHAKE FAILED]: WVALID dropped before handshake");
			assert property (valid_before_ready(BVALID, BREADY)) else $error("[HANDSHAKE FAILED]: BVALID dropped before handshake");
			assert property (valid_before_ready(RVALID, RREADY)) else $error("[HANDSHAKE FAILED]: RVALID dropped before handshake");
			//-----------

			property ready_before_valid (logic VALID, logic READY); 				
				@(posedge ACLK) disable iff (!ARESETn) (!VALID && READY) |=> READY;
			endproperty

			assert property (ready_before_valid(AWVALID, AWREADY)) else $error("[HANDSHAKE FAILED]: AWREADY dropped before AWVALID arrived");
			assert property (ready_before_valid(ARVALID, ARREADY)) else $error("[HANDSHAKE FAILED]: ARREADY dropped before ARVALID arrived");	
			//-----------

			property done_handshake(logic VALID, logic READY); 										    
				@(posedge ACLK) disable iff (!ARESETn) (VALID && READY) |=> !VALID;
			endproperty
			
			assert property (done_handshake(AWVALID,AWREADY)) else $error("[HANDSHAKE FAILED]: AW done_handshake failed");
			assert property (done_handshake(ARVALID,ARREADY)) else $error("[HANDSHAKE FAILED]: AR done_handshake failed");
			assert property (done_handshake(BVALID,BREADY)) else $error("[HANDSHAKE FAILED]: B done_handshake failed");
			//-----------

			property done_handshake_data_channels (logic VALID, READY, LAST);
			    @(posedge ACLK) disable iff (!ARESETn) (VALID && READY && LAST) |=> !VALID;
			endproperty

			assert property (done_handshake_data_channels(WVALID, WREADY, WLAST)) else $error("WVALID stayed HIGH after WLAST handshake!");
			assert property (done_handshake_data_channels(RVALID, RREADY, RLAST)) else $error("RVALID stayed HIGH after RLAST handshake!");	
			//-----------

			property ctrl_stable (logic VALID, logic READY, logic [axi4if.ADDR_WIDTH_S-1:0] ADDR, logic [7:0] LEN, logic [2:0] SIZE);
				@(posedge ACLK) disable iff (!ARESETn) (VALID && !READY) |=> ($stable(ADDR) && $stable(LEN) && $stable(SIZE) );
			endproperty

			assert property (ctrl_stable(AWVALID, AWREADY, AWADDR, AWLEN, AWSIZE))else $error("[STABILITY FAILED]: AW ctrl changing occur before handhsake");
			assert property (ctrl_stable(ARVALID, ARREADY, ARADDR, ARLEN, ARSIZE))else $error("[STABILITY FAILED]: AR ctrl changing occur before handhsake");
			//-----------

			property wdata_stable_during_valid;
			    @(posedge ACLK) disable iff (!ARESETn) (WVALID && !WREADY) |=> $stable(WDATA);
			endproperty

			assert property (wdata_stable_during_valid) else $error("[STABILITY FAILED]: WDATA changed while WVALID was high");
			//-----------

			property last_on_last_beat (logic VALID, READY, LAST, logic [7:0] beat_count, logic [7:0] num_beats);
				@(posedge ACLK) disable iff (!ARESETn) (VALID && READY && (beat_count == num_beats-1)) |-> LAST;
			endproperty

			assert property (last_on_last_beat ( RVALID, RREADY, RLAST, read_beat_count, num_of_read_beats )) else $error("[LAST HANDSHAKE FAILED :( ]: RLAST not asserted on last Read beat");
			assert property (last_on_last_beat ( WVALID, WREADY, WLAST, write_beat_count, num_of_write_beats)) else $error("[LAST HANDSHAKE FAILED :( ]: WLAST not asserted on last Write beat");
			//-----------

			property no_early_last (logic VALID, READY, LAST, logic [8:0] beat_count, logic [8:0] num_beats);
				@(posedge ACLK) disable iff (!ARESETn) (VALID && READY && (beat_count < num_beats-1))|-> !LAST;
			endproperty

			assert property (no_early_last(RVALID, RREADY, RLAST, read_beat_count, num_of_read_beats )) else $error("[LAST HANDSHAKE FAILED :( ]: RLAST asserted before last READ beat");
			assert property (no_early_last(WVALID, WREADY, WLAST, write_beat_count, num_of_write_beats)) else $error("[LAST HANDSHAKE FAILED :( ]: WLAST asserted before last WRITE beat");

			//-----------

    	//--------------------------------------------------------
    	//-----------------------[BUSRT LENGTH]-------------------
    	//--------------------------------------------------------

	    // Number of data beats should = LEN + 1 //AW, R
	    property beats_match_len(logic VALID, READY, LAST, logic [8:0] beat_count, logic [8:0] num_beats);
	        @(posedge clk) disable iff (!ARESETn)
	        (VALID && READY && LAST) |-> (beat_count == (num_beats - 1));
	    endproperty

	    assert property (beats_match_len(RVALID, RREADY, RLAST, read_beat_count, num_of_read_beats ))  else $error("ASSERTION FAILED: Number of read beats doesn't match RLEN + 1");
	    assert property (beats_match_len(WVALID, WREADY, WLAST, write_beat_count, num_of_write_beats)) else $error("ASSERTION FAILED: Number of write beats doesn't match AWLEN + 1");
		//-----------

    	//--------------------------------------------------------
    	//-----------------------[MEMORY BOUNDARY]----------------
    	//--------------------------------------------------------

    	property okay_response (logic VALID, READY, resp_valid, logic addr_in_range, logic [2:0] RESP);
        	@(posedge ACLK) disable iff (!ARESETn) (resp_valid && (RESP == 2'b00) && $past(VALID && READY)) |-> $past(addr_in_range);
    	endproperty
    
    	assert property (okay_response(AWVALID, AWREADY, BVALID, write_addr_in_mem_range, BRESP)) else $error("ASSERTION FAILED: OKAY response for out-of-range write address");
    	assert property (okay_response(ARVALID, ARREADY, RVALID, read_addr_in_mem_range, RRESP)) else $error("ASSERTION FAILED: OKAY response for out-of-range read address");
    	//-----------

		property boundry_cross_resp (logic VALID, READY, resp_valid, logic crossed, logic [2:0] RESP);
			@(posedge ACLK) disable iff (!ARESETn) (resp_valid && $past(VALID && READY) && $past(crossed)) |-> (RESP == 2'b01);
		endproperty

		assert property (boundry_cross_resp(AWVALID, AWREADY, BVALID, write_crossed_4kb, BRESP)) else $error("[CROSS RESP FAILED]: 4KB boundary crossed should generate SLVERR for write");
		assert property (boundry_cross_resp(ARVALID, ARREADY, RVALID, read_crossed_4kb, RRESP)) else $error("[CROSS RESP FAILED]: 4KB boundary crossed should generate SLVERR for read");
		//-----------

 `endif

 //...................................................... COVERAGE ......................................................
 `ifdef SVA_COV_MODE

     // Monitor successful write transactions
    sequence write_transaction_complete;
        (AWVALID && AWREADY) ##[1:$] (WVALID && WREADY && WLAST) ##[1:$] (BVALID && BREADY);
    endsequence
    
    property write_transaction_completed;
        @(posedge clk) disable iff (!ARESETn) write_transaction_complete;
    endproperty

    // Monitor successful read transactions
    sequence read_transaction_complete;
        (ARVALID && ARREADY) ##[1:$] (RVALID && RREADY && RLAST);
    endsequence
    
    property read_transaction_completed;
        @(posedge clk) disable iff (!ARESETn) read_transaction_complete;
    endproperty
    
    // Monitor error responses
    property write_error_response;
        @(posedge clk) disable iff (!ARESETn)
        (BVALID && BREADY && (BRESP != 2'b00));
    endproperty

    property read_error_response;
        @(posedge clk) disable iff (!ARESETn)
        (RVALID && RREADY && (RRESP != 2'b00));
    endproperty
       
    
    // Monitor boundary crossing scenarios
    property boundary_crossing_write;
        @(posedge clk) disable iff (!ARESETn)
        (AWVALID && AWREADY && write_crossed_4kb);
    endproperty
    
    property boundary_crossing_read;
        @(posedge clk) disable iff (!ARESETn)
        (ARVALID && ARREADY && read_crossed_4kb);
    endproperty

    
    // 1. Handshake Coverage: Check if we exercised all 5  handshakes
    cover_aw_handshake: cover property (@(posedge ACLK) AWVALID && AWREADY);
    cover_w_handshake:  cover property (@(posedge ACLK) WVALID && WREADY);
    cover_ar_handshake: cover property (@(posedge ACLK) ARVALID && ARREADY);
    cover_r_handshake:  cover property (@(posedge ACLK) RVALID && RREADY);
    cover_b_handshake:  cover property (@(posedge ACLK) BVALID && BREADY);


    cover_write_transaction_complete: cover property (write_transaction_completed);
    cover_read_transaction_complete: cover property (read_transaction_completed);

    // 2. Burst Length Coverage: Hit single beats and multi-beats
    cover_single_beat_write: cover property (@(posedge ACLK) (AWVALID && AWREADY && AWLEN == 0));
    cover_multi_beat_write:  cover property (@(posedge ACLK) (AWVALID && AWREADY && AWLEN > 0));
    cover_single_beat_read:  cover property (@(posedge ACLK) (ARVALID && ARREADY && ARLEN == 0));
    cover_multi_beat_read:   cover property (@(posedge ACLK) (ARVALID && ARREADY && ARLEN > 0));


    // 3. Termination Coverage: Ensure we hit the LAST signal correctly
    cover_wlast_handshake: cover property (@(posedge ACLK) (WVALID && WREADY && WLAST));
    cover_rlast_handshake: cover property (@(posedge ACLK) (RVALID && RREADY && RLAST));

    // 4. Boundary & Range Coverage: Confirm we tested the error logic 
    cover_write_4kb_crossed:   cover property (@(posedge ACLK) (AWVALID && AWREADY && write_crossed_4kb));
    cover_read_4kb_crossed:    cover property (@(posedge ACLK) (ARVALID && ARREADY && read_crossed_4kb));
    cover_write_out_of_range: cover property (@(posedge ACLK) (AWVALID && AWREADY && !write_addr_in_mem_range));
    cover_read_out_of_range:  cover property (@(posedge ACLK) (ARVALID && ARREADY && !read_addr_in_mem_range));

    cover_boundary_crossing_write: cover property (boundary_crossing_write);
    cover_boundary_crossing_read: cover property (boundary_crossing_read);

    // 5. Response Coverage: Check if we observed OKAY and SLVERR responses ]
    cover_write_okay_resp:  cover property (@(posedge ACLK) (BVALID && BREADY && BRESP == 2'b00));
    cover_read_okay_resp:   cover property (@(posedge ACLK) (RVALID && RREADY && RRESP == 2'b00));

    cover_write_error_response: cover property (write_error_response);
	cover_read_error_response: cover property (read_error_response); 

 `endif

endmodule









/*  BINDING 

	(axi4_if.dut axi4if);

	// Defining signals to be used in SVA

	    logic                     ACLK;
	    logic                     ARESETn;
	    // Write address channel
	    logic [axi4if.ADDR_WIDTH_S-1:0] AWADDR,ARADDR;
	    logic [7:0]                     AWLEN;
	    logic [2:0]                     AWSIZE;
	    logic                           AWVALID;
		logic                           AWREADY;
		// Write data channel
	    logic [axi4if.DATA_WIDTH-1:0]   WDATA;
	    logic                           WVALID;
	    logic                           WLAST;
		logic                           WREADY;
		// Write Response channel
	    logic                           BREADY;
		logic                           BVALID;
		logic [1:0]                     BRESP;
		// Read address channel
	    logic [7:0]                     ARLEN;
	    logic [2:0]                     ARSIZE;
	    logic                           ARVALID;
		logic                           ARREADY;
		// Read data channel
	    logic                           RREADY;
		logic                           RLAST,RVALID;
		logic [31:0]                    RDATA;
		logic [1:0]                     RRESP;

	// Connecting it to Interface signals 


		assign 	 ACLK   		= axi4if.ACLK 	;
		assign 	 ARESETn    	= axi4if.ARESETn;
		assign 	 AWADDR  		= axi4if.AWADDR	;
	    assign   AWLEN  		= axi4if.AWLEN	;
	    assign   AWSIZE  		= axi4if.AWSIZE	;
	    assign   AWVALID  		= axi4if.AWVALID;
		
		assign 	 WDATA  		= axi4if.WDATA	;
	    assign   WVALID  		= axi4if.WVALID	;
	    assign   WLAST  		= axi4if.WLAST	;
	    
	    assign   BREADY  		= axi4if.BREADY	;
		assign 	 ARADDR  		= axi4if.ARADDR	;
	    assign   ARLEN  		= axi4if.ARLEN	;
	    assign   ARSIZE  		= axi4if.ARSIZE	;
	    assign   ARVALID  		= axi4if.ARVALID;
	    
	    assign   RREADY  		= axi4if.RREADY	;
	    
		assign 	 axi4if.RLAST  	= RLAST	;	
		assign 	 axi4if.ARREADY = ARREADY;
		assign 	 axi4if.BVALID  = BVALID ;
		assign 	 axi4if.RDATA 	= RDATA	 ;
		assign 	 axi4if.WREADY	= WREADY ;
		assign 	 axi4if.AWREADY = AWREADY;
		assign 	 axi4if.BRESP  	= BRESP	 ;
	    assign   axi4if.RRESP  	= RRESP	 ;
	    assign   axi4if.RVALID  = RVALID ;
=======
module axi4_sva#(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 16,
    parameter MEMORY_DEPTH = 1024
)(
	input bit                     ACLK,
	input bit                     ARESETn,

	// Write address channel
	input logic [axi4if.ADDR_WIDTH_S-1:0] AWADDR,ARADDR,
	input logic [7:0]                     AWLEN,
	input logic [2:0]                     AWSIZE,	
	input logic                           AWVALID,
	input logic                           AWREADY,
	
	// Write data channel
	input logic [axi4if.DATA_WIDTH-1:0]   WDATA,
	input logic                           WVALID,
	input logic                           WLAST,
	input logic                           WREADY,
	
	// Write Response channel
	input logic                           BREADY,
	input logic                           BVALID,
	input logic [1:0]                     BRESP,
	
	// Read address channel
	input logic [7:0]                     ARLEN,
	input logic [2:0]                     ARSIZE,
	input logic                           ARVALID,
	input logic                           ARREADY,
	
	// Read data channel
	input logic                           RREADY,
	input logic                           RLAST,RVALID,
	input logic [31:0]                    RDATA,
	input logic [1:0]                     RRESP
);


    // Beats counters for burst assertions
    logic [8:0] write_beat_count;
    logic [8:0] read_beat_count;
    logic [8:0] num_of_write_beats;
    logic [8:0] num_of_read_beats;

    // Boundary flags for 4KB assertions
    logic write_crossed_4kb;
    logic read_crossed_4kb;
    logic write_addr_in_mem_range;
    logic read_addr_in_mem_range;
    
    // Beat counters and expected values calc
    always_ff @(posedge ACLK or negedge ARESETn) begin
        if (!ARESETn) begin
            write_beat_count <= 0;
            read_beat_count <= 0;
            num_of_write_beats <= 0;
            num_of_read_beats <= 0;
        end
        else begin
            // Write address phase 
            if (AWVALID && AWREADY) begin
                num_of_write_beats <= AWLEN + 1;
                write_beat_count <= 0;
            end            
            // Write data phase 
            if (WVALID && WREADY) begin
                write_beat_count <= write_beat_count + 1;
            end
            // Read address phase 
            if (ARVALID && ARREADY) begin
                num_of_read_beats <= ARLEN + 1;
                read_beat_count <= 0;
            end           
            // Read data phase 
            if (RVALID && RREADY) begin
                read_beat_count <= read_beat_count + 1;
            end

        end
    end
    
    // Flags calc for Boundary crossing detection
    always_comb begin
        write_crossed_4kb = ((AWADDR & 12'hFFF) + ((AWLEN + 1) << AWSIZE)) > 12'hFFF;
        read_crossed_4kb = ((ARADDR & 12'hFFF) + ((ARLEN + 1) << ARSIZE)) > 12'hFFF;
        write_addr_in_mem_range = ((AWADDR >> 2) + (AWLEN + 1)) <= MEMORY_DEPTH;
        read_addr_in_mem_range = ((ARADDR >> 2) + (ARLEN + 1)) <= MEMORY_DEPTH;
    end


 //...................................................... ASSERTIONS ......................................................
 
  `ifdef SVA_MODE

  	//--------------------------------------------------------------------------------------
  	//--------------------------------- PROPERTIES -----------------------------------------
  	//--------------------------------------------------------------------------------------

	    //Reset checker
    	always_comb begin 
            if(!ARESETn)
                assert_rst_n: assert final(AWREADY === 1 && WREADY === 0 && BRESP === 0 && BVALID === 0 && ARREADY === 1 && RDATA === 0 && RRESP === 0 && RLAST === 0 && RVALID ===0);
    	end

    	//Clock Checker
    	bit clk;
     	parameter CLK_PERIOD = 10;
    	always begin
           clk = ACLK;
           #(CLK_PERIOD/2);
           #0;
           clk_check: assert(ACLK == ~clk ) else $error("CLK ASSERTION FAILED !");
    	end

    	//--------------------------------------------------------
    	//------------------------[HANDSHAKES]--------------------
    	//--------------------------------------------------------

			property valid_before_ready (logic VALID, logic READY); 				
				@(posedge ACLK) disable iff (!ARESETn) (VALID && !READY) |=> VALID;
			endproperty

			assert property (valid_before_ready(WVALID, WREADY)) else $error("[HANDSHAKE FAILED]: WVALID dropped before handshake");
			assert property (valid_before_ready(BVALID, BREADY)) else $error("[HANDSHAKE FAILED]: BVALID dropped before handshake");
			assert property (valid_before_ready(RVALID, RREADY)) else $error("[HANDSHAKE FAILED]: RVALID dropped before handshake");
			//-----------

			property ready_before_valid (logic VALID, logic READY); 				
				@(posedge ACLK) disable iff (!ARESETn) (!VALID && READY) |=> READY;
			endproperty

			assert property (ready_before_valid(AWVALID, AWREADY)) else $error("[HANDSHAKE FAILED]: AWREADY dropped before AWVALID arrived");
			assert property (ready_before_valid(ARVALID, ARREADY)) else $error("[HANDSHAKE FAILED]: ARREADY dropped before ARVALID arrived");	
			//-----------

			property done_handshake(logic VALID, logic READY); 										    
				@(posedge ACLK) disable iff (!ARESETn) (VALID && READY) |=> !VALID;
			endproperty
			
			assert property (done_handshake(AWVALID,AWREADY)) else $error("[HANDSHAKE FAILED]: AW done_handshake failed");
			assert property (done_handshake(ARVALID,ARREADY)) else $error("[HANDSHAKE FAILED]: AR done_handshake failed");
			assert property (done_handshake(BVALID,BREADY)) else $error("[HANDSHAKE FAILED]: B done_handshake failed");
			//-----------

			property done_handshake_data_channels (logic VALID, READY, LAST);
			    @(posedge ACLK) disable iff (!ARESETn) (VALID && READY && LAST) |=> !VALID;
			endproperty

			assert property (done_handshake_data_channels(WVALID, WREADY, WLAST)) else $error("WVALID stayed HIGH after WLAST handshake!");
			assert property (done_handshake_data_channels(RVALID, RREADY, RLAST)) else $error("RVALID stayed HIGH after RLAST handshake!");	
			//-----------

			property ctrl_stable (logic VALID, logic READY, logic [axi4if.ADDR_WIDTH_S-1:0] ADDR, logic [7:0] LEN, logic [2:0] SIZE);
				@(posedge ACLK) disable iff (!ARESETn) (VALID && !READY) |=> ($stable(ADDR) && $stable(LEN) && $stable(SIZE) );
			endproperty

			assert property (ctrl_stable(AWVALID, AWREADY, AWADDR, AWLEN, AWSIZE))else $error("[STABILITY FAILED]: AW ctrl changing occur before handhsake");
			assert property (ctrl_stable(ARVALID, ARREADY, ARADDR, ARLEN, ARSIZE))else $error("[STABILITY FAILED]: AR ctrl changing occur before handhsake");
			//-----------

			property wdata_stable_during_valid;
			    @(posedge ACLK) disable iff (!ARESETn) (WVALID && !WREADY) |=> $stable(WDATA);
			endproperty

			assert property (wdata_stable_during_valid) else $error("[STABILITY FAILED]: WDATA changed while WVALID was high");
			//-----------

			property last_on_last_beat (logic VALID, READY, LAST, logic [7:0] beat_count, logic [7:0] num_beats);
				@(posedge ACLK) disable iff (!ARESETn) (VALID && READY && (beat_count == num_beats-1)) |-> LAST;
			endproperty

			assert property (last_on_last_beat ( RVALID, RREADY, RLAST, read_beat_count, num_of_read_beats )) else $error("[LAST HANDSHAKE FAILED :( ]: RLAST not asserted on last Read beat");
			assert property (last_on_last_beat ( WVALID, WREADY, WLAST, write_beat_count, num_of_write_beats)) else $error("[LAST HANDSHAKE FAILED :( ]: WLAST not asserted on last Write beat");
			//-----------

			property no_early_last (logic VALID, READY, LAST, logic [8:0] beat_count, logic [8:0] num_beats);
				@(posedge ACLK) disable iff (!ARESETn) (VALID && READY && (beat_count < num_beats-1))|-> !LAST;
			endproperty

			assert property (no_early_last(RVALID, RREADY, RLAST, read_beat_count, num_of_read_beats )) else $error("[LAST HANDSHAKE FAILED :( ]: RLAST asserted before last READ beat");
			assert property (no_early_last(WVALID, WREADY, WLAST, write_beat_count, num_of_write_beats)) else $error("[LAST HANDSHAKE FAILED :( ]: WLAST asserted before last WRITE beat");

			//-----------

    	//--------------------------------------------------------
    	//-----------------------[BUSRT LENGTH]-------------------
    	//--------------------------------------------------------

	    // Number of data beats should = LEN + 1 //AW, R
	    property beats_match_len(logic VALID, READY, LAST, logic [8:0] beat_count, logic [8:0] num_beats);
	        @(posedge clk) disable iff (!ARESETn)
	        (VALID && READY && LAST) |-> (beat_count == (num_beats - 1));
	    endproperty

	    assert property (beats_match_len(RVALID, RREADY, RLAST, read_beat_count, num_of_read_beats ))  else $error("ASSERTION FAILED: Number of read beats doesn't match RLEN + 1");
	    assert property (beats_match_len(WVALID, WREADY, WLAST, write_beat_count, num_of_write_beats)) else $error("ASSERTION FAILED: Number of write beats doesn't match AWLEN + 1");
		//-----------

    	//--------------------------------------------------------
    	//-----------------------[MEMORY BOUNDARY]----------------
    	//--------------------------------------------------------

    	property okay_response (logic VALID, READY, resp_valid, logic addr_in_range, logic [2:0] RESP);
        	@(posedge ACLK) disable iff (!ARESETn) (resp_valid && (RESP == 2'b00) && $past(VALID && READY)) |-> $past(addr_in_range);
    	endproperty
    
    	assert property (okay_response(AWVALID, AWREADY, BVALID, write_addr_in_mem_range, BRESP)) else $error("ASSERTION FAILED: OKAY response for out-of-range write address");
    	assert property (okay_response(ARVALID, ARREADY, RVALID, read_addr_in_mem_range, RRESP)) else $error("ASSERTION FAILED: OKAY response for out-of-range read address");
    	//-----------

		property boundry_cross_resp (logic VALID, READY, resp_valid, logic crossed, logic [2:0] RESP);
			@(posedge ACLK) disable iff (!ARESETn) (resp_valid && $past(VALID && READY) && $past(crossed)) |-> (RESP == 2'b01);
		endproperty

		assert property (boundry_cross_resp(AWVALID, AWREADY, BVALID, write_crossed_4kb, BRESP)) else $error("[CROSS RESP FAILED]: 4KB boundary crossed should generate SLVERR for write");
		assert property (boundry_cross_resp(ARVALID, ARREADY, RVALID, read_crossed_4kb, RRESP)) else $error("[CROSS RESP FAILED]: 4KB boundary crossed should generate SLVERR for read");
		//-----------

 `endif

 //...................................................... COVERAGE ......................................................
 `ifdef SVA_COV_MODE

     // Monitor successful write transactions
    sequence write_transaction_complete;
        (AWVALID && AWREADY) ##[1:$] (WVALID && WREADY && WLAST) ##[1:$] (BVALID && BREADY);
    endsequence
    
    property write_transaction_completed;
        @(posedge clk) disable iff (!ARESETn) write_transaction_complete;
    endproperty

    // Monitor successful read transactions
    sequence read_transaction_complete;
        (ARVALID && ARREADY) ##[1:$] (RVALID && RREADY && RLAST);
    endsequence
    
    property read_transaction_completed;
        @(posedge clk) disable iff (!ARESETn) read_transaction_complete;
    endproperty
    
    // Monitor error responses
    property write_error_response;
        @(posedge clk) disable iff (!ARESETn)
        (BVALID && BREADY && (BRESP != 2'b00));
    endproperty

    property read_error_response;
        @(posedge clk) disable iff (!ARESETn)
        (RVALID && RREADY && (RRESP != 2'b00));
    endproperty
       
    
    // Monitor boundary crossing scenarios
    property boundary_crossing_write;
        @(posedge clk) disable iff (!ARESETn)
        (AWVALID && AWREADY && write_crossed_4kb);
    endproperty
    
    property boundary_crossing_read;
        @(posedge clk) disable iff (!ARESETn)
        (ARVALID && ARREADY && read_crossed_4kb);
    endproperty

    
    // 1. Handshake Coverage: Check if we exercised all 5  handshakes
    cover_aw_handshake: cover property (@(posedge ACLK) AWVALID && AWREADY);
    cover_w_handshake:  cover property (@(posedge ACLK) WVALID && WREADY);
    cover_ar_handshake: cover property (@(posedge ACLK) ARVALID && ARREADY);
    cover_r_handshake:  cover property (@(posedge ACLK) RVALID && RREADY);
    cover_b_handshake:  cover property (@(posedge ACLK) BVALID && BREADY);


    cover_write_transaction_complete: cover property (write_transaction_completed);
    cover_read_transaction_complete: cover property (read_transaction_completed);

    // 2. Burst Length Coverage: Hit single beats and multi-beats
    cover_single_beat_write: cover property (@(posedge ACLK) (AWVALID && AWREADY && AWLEN == 0));
    cover_multi_beat_write:  cover property (@(posedge ACLK) (AWVALID && AWREADY && AWLEN > 0));
    cover_single_beat_read:  cover property (@(posedge ACLK) (ARVALID && ARREADY && ARLEN == 0));
    cover_multi_beat_read:   cover property (@(posedge ACLK) (ARVALID && ARREADY && ARLEN > 0));


    // 3. Termination Coverage: Ensure we hit the LAST signal correctly
    cover_wlast_handshake: cover property (@(posedge ACLK) (WVALID && WREADY && WLAST));
    cover_rlast_handshake: cover property (@(posedge ACLK) (RVALID && RREADY && RLAST));

    // 4. Boundary & Range Coverage: Confirm we tested the error logic 
    cover_write_4kb_crossed:   cover property (@(posedge ACLK) (AWVALID && AWREADY && write_crossed_4kb));
    cover_read_4kb_crossed:    cover property (@(posedge ACLK) (ARVALID && ARREADY && read_crossed_4kb));
    cover_write_out_of_range: cover property (@(posedge ACLK) (AWVALID && AWREADY && !write_addr_in_mem_range));
    cover_read_out_of_range:  cover property (@(posedge ACLK) (ARVALID && ARREADY && !read_addr_in_mem_range));

    cover_boundary_crossing_write: cover property (boundary_crossing_write);
    cover_boundary_crossing_read: cover property (boundary_crossing_read);

    // 5. Response Coverage: Check if we observed OKAY and SLVERR responses ]
    cover_write_okay_resp:  cover property (@(posedge ACLK) (BVALID && BREADY && BRESP == 2'b00));
    cover_read_okay_resp:   cover property (@(posedge ACLK) (RVALID && RREADY && RRESP == 2'b00));

    cover_write_error_response: cover property (write_error_response);
	cover_read_error_response: cover property (read_error_response); 

 `endif

endmodule









/*  BINDING 

	(axi4_if.dut axi4if);

	// Defining signals to be used in SVA

	    logic                     ACLK;
	    logic                     ARESETn;
	    // Write address channel
	    logic [axi4if.ADDR_WIDTH_S-1:0] AWADDR,ARADDR;
	    logic [7:0]                     AWLEN;
	    logic [2:0]                     AWSIZE;
	    logic                           AWVALID;
		logic                           AWREADY;
		// Write data channel
	    logic [axi4if.DATA_WIDTH-1:0]   WDATA;
	    logic                           WVALID;
	    logic                           WLAST;
		logic                           WREADY;
		// Write Response channel
	    logic                           BREADY;
		logic                           BVALID;
		logic [1:0]                     BRESP;
		// Read address channel
	    logic [7:0]                     ARLEN;
	    logic [2:0]                     ARSIZE;
	    logic                           ARVALID;
		logic                           ARREADY;
		// Read data channel
	    logic                           RREADY;
		logic                           RLAST,RVALID;
		logic [31:0]                    RDATA;
		logic [1:0]                     RRESP;

	// Connecting it to Interface signals 


		assign 	 ACLK   		= axi4if.ACLK 	;
		assign 	 ARESETn    	= axi4if.ARESETn;
		assign 	 AWADDR  		= axi4if.AWADDR	;
	    assign   AWLEN  		= axi4if.AWLEN	;
	    assign   AWSIZE  		= axi4if.AWSIZE	;
	    assign   AWVALID  		= axi4if.AWVALID;
		
		assign 	 WDATA  		= axi4if.WDATA	;
	    assign   WVALID  		= axi4if.WVALID	;
	    assign   WLAST  		= axi4if.WLAST	;
	    
	    assign   BREADY  		= axi4if.BREADY	;
		assign 	 ARADDR  		= axi4if.ARADDR	;
	    assign   ARLEN  		= axi4if.ARLEN	;
	    assign   ARSIZE  		= axi4if.ARSIZE	;
	    assign   ARVALID  		= axi4if.ARVALID;
	    
	    assign   RREADY  		= axi4if.RREADY	;
	    
		assign 	 axi4if.RLAST  	= RLAST	;	
		assign 	 axi4if.ARREADY = ARREADY;
		assign 	 axi4if.BVALID  = BVALID ;
		assign 	 axi4if.RDATA 	= RDATA	 ;
		assign 	 axi4if.WREADY	= WREADY ;
		assign 	 axi4if.AWREADY = AWREADY;
		assign 	 axi4if.BRESP  	= BRESP	 ;
	    assign   axi4if.RRESP  	= RRESP	 ;
	    assign   axi4if.RVALID  = RVALID ;
>>>>>>> 7968f542d993b7369b31cb2b1d005d0ea04dc4bd
*/