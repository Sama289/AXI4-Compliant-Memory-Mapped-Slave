<<<<<<< HEAD
module axi4_top;

	//--------clock generation-------------
	bit clk;
	// Clock Period
	 parameter  clk_period  = 10 ;
	 parameter  High_period = 0.5 * clk_period ;
	 parameter  Low_period  = 0.5 * clk_period ;

	// Clock Frequency 100 MHz 
	always  
	   begin
	    #Low_period  clk = ~ clk ;
	    #High_period clk = ~ clk ;
	end

	//--------instantiating interface-------------

		// instantiate the interface
		axi4_if axi4if (clk); 

		// Pass the instantiated interface to DUT
		axi4 uut (
		    .ACLK(axi4if.ACLK),
		    .ARESETn(axi4if.ARESETn),

		    // Write address channel
		    .AWADDR(axi4if.AWADDR),
		    .AWLEN(axi4if.AWLEN),
		    .AWSIZE(axi4if.AWSIZE),
		    .AWVALID(axi4if.AWVALID),
		    .AWREADY(axi4if.AWREADY),

		    // Write data channel
		    .WDATA(axi4if.WDATA),
		    .WVALID(axi4if.WVALID),
		    .WLAST(axi4if.WLAST),
		    .WREADY(axi4if.WREADY),

		    // Write response channel
		    .BRESP(axi4if.BRESP),
		    .BVALID(axi4if.BVALID),
		    .BREADY(axi4if.BREADY),

		    // Read address channel
		    .ARADDR(axi4if.ARADDR),
		    .ARLEN(axi4if.ARLEN),
		    .ARSIZE(axi4if.ARSIZE),
		    .ARVALID(axi4if.ARVALID),
		    .ARREADY(axi4if.ARREADY),

		    // Read data channel
		    .RDATA(axi4if.RDATA),
		    .RRESP(axi4if.RRESP),
		    .RVALID(axi4if.RVALID),
		    .RLAST(axi4if.RLAST),
		    .RREADY(axi4if.RREADY)
		);

		// Pass the instantiated interface to TB		
		axi4_tb tb (axi4if.TB);

	 	//Option (1)
		bind axi4 axi4_sva axi4_sva_inst ( // Signals_in_sva_module(design.design_signal)

			.ACLK(axi4.ACLK),
			.ARESETn(axi4.ARESETn),

			// Write address channel
			.AWADDR(axi4.AWADDR), 
			.ARADDR(axi4.ARADDR),
			.AWLEN(axi4.AWLEN),
			.AWSIZE(axi4.AWSIZE),	
			.AWVALID(axi4.AWVALID),
			.AWREADY(axi4.AWREADY),
			
			// Write data channel
			.WDATA(axi4.WDATA),
			.WVALID(axi4.WVALID),
			.WLAST(axi4.WLAST),
			.WREADY(axi4.WREADY),
			
			// Write Response channel
			.BREADY(axi4.BREADY),
			.BVALID(axi4.BVALID),
			.BRESP(axi4.BRESP),
			
			// Read address channel
			.ARLEN(axi4.ARLEN),
			.ARSIZE(axi4.ARSIZE),
			.ARVALID(axi4.ARVALID),
			.ARREADY(axi4.ARREADY),
			
			// Read data channel
			.RREADY(axi4.RREADY),
			.RLAST(axi4.RLAST),
			.RVALID(axi4.RVALID),
			.RDATA(axi4.RDATA),
			.RRESP(axi4.RRESP)
		);


endmodule 

/*
		// Option (2) Design_inst : bind axi4 axi4_sva axi4_sva_inst ( // Signals_in_sva_module(design_inst.design_signal)

			.ACLK(uut.ACLK),
			.ARESETn(uut.ARESETn),

			// Write address channel
			.AWADDR(uut.AWADDR), 
			.ARADDR(uut.ARADDR),
			.AWLEN(uut.AWLEN),
			.AWSIZE(uut.AWSIZE),	
			.AWVALID(uut.AWVALID),
			.AWREADY(uut.AWREADY),
			
			// Write data channel
			.WDATA(uut.WDATA),
			.WVALID(uut.WVALID),
			.WLAST(uut.WLAST),
			.WREADY(uut.WREADY),
			
			// Write Response channel
			.BREADY(uut.BREADY),
			.BVALID(uut.BVALID),
			.BRESP(uut.BRESP),
			
			// Read address channel
			.ARLEN(uut.ARLEN),
			.ARSIZE(uut.ARSIZE),
			.ARVALID(uut.ARVALID),
			.ARREADY(uut.ARREADY),
			
			// Read data channel
			.RREADY(uut.RREADY),
			.RLAST(uut.RLAST),
			.RVALID(uut.RVALID),
			.RDATA(uut.RDATA),
			.RRESP(uut.RRESP)
		);

		// Option (3) Interface : bind axi4 axi4_sva axi4_sva_inst (axi4if);
		
		// Option (4) msh 3arfa fara2 3n option 3 f eh : bind axi4 axi4_sva axi4_sva_inst ( // Signals_in_sva_module(design_inst.design_signal)

			.ACLK(axi4if.ACLK),
			.ARESETn(axi4if.ARESETn),

			// Write address channel
			.AWADDR(axi4if.AWADDR), 
			.ARADDR(axi4if.ARADDR),
			.AWLEN(axi4if.AWLEN),
			.AWSIZE(axi4if.AWSIZE),	
			.AWVALID(axi4if.AWVALID),
			.AWREADY(axi4if.AWREADY),
			
			// Write data channel
			.WDATA(axi4if.WDATA),
			.WVALID(axi4if.WVALID),
			.WLAST(axi4if.WLAST),
			.WREADY(axi4if.WREADY),
			
			// Write Response channel
			.BREADY(axi4if.BREADY),
			.BVALID(axi4if.BVALID),
			.BRESP(axi4if.BRESP),
			
			// Read address channel
			.ARLEN(axi4if.ARLEN),
			.ARSIZE(axi4if.ARSIZE),
			.ARVALID(axi4if.ARVALID),
			.ARREADY(axi4if.ARREADY),
			
			// Read data channel
			.RREADY(axi4if.RREADY),
			.RLAST(axi4if.RLAST),
			.RVALID(axi4if.RVALID),
			.RDATA(axi4if.RDATA),
			.RRESP(axi4if.RRESP)
		);
*/


















/*module axi4_top;

    // -------- Clock Generation ----------
    bit clk;
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // -------- Instantiate Interface ----------
    axi4_if axi4if (clk); 

    // -------- Instantiate DUT (AXI4 Slave) ----------
    axi4 uut (
        // Clock & Reset
        .ACLK    (axi4if.ACLK),
        .ARESETn (axi4if.ARESETn),

        // Write Address Channel
        .AWADDR  (axi4if.AWADDR),
        .AWLEN   (axi4if.AWLEN),
        .AWSIZE  (axi4if.AWSIZE),
        .AWVALID (axi4if.AWVALID),
        .AWREADY (axi4if.AWREADY),

        // Write Data Channel
        .WDATA   (axi4if.WDATA),
        .WVALID  (axi4if.WVALID),
        .WLAST   (axi4if.WLAST),
        .WREADY  (axi4if.WREADY),

        // Write Response Channel
        .BRESP   (axi4if.BRESP),
        .BVALID  (axi4if.BVALID),
        .BREADY  (axi4if.BREADY),

        // Read Address Channel
        .ARADDR  (axi4if.ARADDR),
        .ARLEN   (axi4if.ARLEN),
        .ARSIZE  (axi4if.ARSIZE),
        .ARVALID (axi4if.ARVALID),
        .ARREADY (axi4if.ARREADY),

        // Read Data Channel
        .RDATA   (axi4if.RDATA),
        .RRESP   (axi4if.RRESP),
        .RVALID  (axi4if.RVALID),
        .RLAST   (axi4if.RLAST),
        .RREADY  (axi4if.RREADY)
    );

    // -------- Instantiate Testbench ----------
    axi4_tb tb (axi4if);

endmodule*/
=======
module axi4_top;

	//--------clock generation-------------
	bit clk;
	// Clock Period
	 parameter  clk_period  = 10 ;
	 parameter  High_period = 0.5 * clk_period ;
	 parameter  Low_period  = 0.5 * clk_period ;

	// Clock Frequency 100 MHz 
	always  
	   begin
	    #Low_period  clk = ~ clk ;
	    #High_period clk = ~ clk ;
	end

	//--------instantiating interface-------------

		// instantiate the interface
		axi4_if axi4if (clk); 

		// Pass the instantiated interface to DUT
		axi4 uut (
		    .ACLK(axi4if.ACLK),
		    .ARESETn(axi4if.ARESETn),

		    // Write address channel
		    .AWADDR(axi4if.AWADDR),
		    .AWLEN(axi4if.AWLEN),
		    .AWSIZE(axi4if.AWSIZE),
		    .AWVALID(axi4if.AWVALID),
		    .AWREADY(axi4if.AWREADY),

		    // Write data channel
		    .WDATA(axi4if.WDATA),
		    .WVALID(axi4if.WVALID),
		    .WLAST(axi4if.WLAST),
		    .WREADY(axi4if.WREADY),

		    // Write response channel
		    .BRESP(axi4if.BRESP),
		    .BVALID(axi4if.BVALID),
		    .BREADY(axi4if.BREADY),

		    // Read address channel
		    .ARADDR(axi4if.ARADDR),
		    .ARLEN(axi4if.ARLEN),
		    .ARSIZE(axi4if.ARSIZE),
		    .ARVALID(axi4if.ARVALID),
		    .ARREADY(axi4if.ARREADY),

		    // Read data channel
		    .RDATA(axi4if.RDATA),
		    .RRESP(axi4if.RRESP),
		    .RVALID(axi4if.RVALID),
		    .RLAST(axi4if.RLAST),
		    .RREADY(axi4if.RREADY)
		);

		// Pass the instantiated interface to TB		
		axi4_tb tb (axi4if.TB);

	 	//Option (1)
		bind axi4 axi4_sva axi4_sva_inst ( // Signals_in_sva_module(design.design_signal)

			.ACLK(axi4.ACLK),
			.ARESETn(axi4.ARESETn),

			// Write address channel
			.AWADDR(axi4.AWADDR), 
			.ARADDR(axi4.ARADDR),
			.AWLEN(axi4.AWLEN),
			.AWSIZE(axi4.AWSIZE),	
			.AWVALID(axi4.AWVALID),
			.AWREADY(axi4.AWREADY),
			
			// Write data channel
			.WDATA(axi4.WDATA),
			.WVALID(axi4.WVALID),
			.WLAST(axi4.WLAST),
			.WREADY(axi4.WREADY),
			
			// Write Response channel
			.BREADY(axi4.BREADY),
			.BVALID(axi4.BVALID),
			.BRESP(axi4.BRESP),
			
			// Read address channel
			.ARLEN(axi4.ARLEN),
			.ARSIZE(axi4.ARSIZE),
			.ARVALID(axi4.ARVALID),
			.ARREADY(axi4.ARREADY),
			
			// Read data channel
			.RREADY(axi4.RREADY),
			.RLAST(axi4.RLAST),
			.RVALID(axi4.RVALID),
			.RDATA(axi4.RDATA),
			.RRESP(axi4.RRESP)
		);


endmodule 

/*
		// Option (2) Design_inst : bind axi4 axi4_sva axi4_sva_inst ( // Signals_in_sva_module(design_inst.design_signal)

			.ACLK(uut.ACLK),
			.ARESETn(uut.ARESETn),

			// Write address channel
			.AWADDR(uut.AWADDR), 
			.ARADDR(uut.ARADDR),
			.AWLEN(uut.AWLEN),
			.AWSIZE(uut.AWSIZE),	
			.AWVALID(uut.AWVALID),
			.AWREADY(uut.AWREADY),
			
			// Write data channel
			.WDATA(uut.WDATA),
			.WVALID(uut.WVALID),
			.WLAST(uut.WLAST),
			.WREADY(uut.WREADY),
			
			// Write Response channel
			.BREADY(uut.BREADY),
			.BVALID(uut.BVALID),
			.BRESP(uut.BRESP),
			
			// Read address channel
			.ARLEN(uut.ARLEN),
			.ARSIZE(uut.ARSIZE),
			.ARVALID(uut.ARVALID),
			.ARREADY(uut.ARREADY),
			
			// Read data channel
			.RREADY(uut.RREADY),
			.RLAST(uut.RLAST),
			.RVALID(uut.RVALID),
			.RDATA(uut.RDATA),
			.RRESP(uut.RRESP)
		);

		// Option (3) Interface : bind axi4 axi4_sva axi4_sva_inst (axi4if);
		
		// Option (4) msh 3arfa fara2 3n option 3 f eh : bind axi4 axi4_sva axi4_sva_inst ( // Signals_in_sva_module(design_inst.design_signal)

			.ACLK(axi4if.ACLK),
			.ARESETn(axi4if.ARESETn),

			// Write address channel
			.AWADDR(axi4if.AWADDR), 
			.ARADDR(axi4if.ARADDR),
			.AWLEN(axi4if.AWLEN),
			.AWSIZE(axi4if.AWSIZE),	
			.AWVALID(axi4if.AWVALID),
			.AWREADY(axi4if.AWREADY),
			
			// Write data channel
			.WDATA(axi4if.WDATA),
			.WVALID(axi4if.WVALID),
			.WLAST(axi4if.WLAST),
			.WREADY(axi4if.WREADY),
			
			// Write Response channel
			.BREADY(axi4if.BREADY),
			.BVALID(axi4if.BVALID),
			.BRESP(axi4if.BRESP),
			
			// Read address channel
			.ARLEN(axi4if.ARLEN),
			.ARSIZE(axi4if.ARSIZE),
			.ARVALID(axi4if.ARVALID),
			.ARREADY(axi4if.ARREADY),
			
			// Read data channel
			.RREADY(axi4if.RREADY),
			.RLAST(axi4if.RLAST),
			.RVALID(axi4if.RVALID),
			.RDATA(axi4if.RDATA),
			.RRESP(axi4if.RRESP)
		);
*/


















/*module axi4_top;

    // -------- Clock Generation ----------
    bit clk;
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // -------- Instantiate Interface ----------
    axi4_if axi4if (clk); 

    // -------- Instantiate DUT (AXI4 Slave) ----------
    axi4 uut (
        // Clock & Reset
        .ACLK    (axi4if.ACLK),
        .ARESETn (axi4if.ARESETn),

        // Write Address Channel
        .AWADDR  (axi4if.AWADDR),
        .AWLEN   (axi4if.AWLEN),
        .AWSIZE  (axi4if.AWSIZE),
        .AWVALID (axi4if.AWVALID),
        .AWREADY (axi4if.AWREADY),

        // Write Data Channel
        .WDATA   (axi4if.WDATA),
        .WVALID  (axi4if.WVALID),
        .WLAST   (axi4if.WLAST),
        .WREADY  (axi4if.WREADY),

        // Write Response Channel
        .BRESP   (axi4if.BRESP),
        .BVALID  (axi4if.BVALID),
        .BREADY  (axi4if.BREADY),

        // Read Address Channel
        .ARADDR  (axi4if.ARADDR),
        .ARLEN   (axi4if.ARLEN),
        .ARSIZE  (axi4if.ARSIZE),
        .ARVALID (axi4if.ARVALID),
        .ARREADY (axi4if.ARREADY),

        // Read Data Channel
        .RDATA   (axi4if.RDATA),
        .RRESP   (axi4if.RRESP),
        .RVALID  (axi4if.RVALID),
        .RLAST   (axi4if.RLAST),
        .RREADY  (axi4if.RREADY)
    );

    // -------- Instantiate Testbench ----------
    axi4_tb tb (axi4if);

endmodule*/
>>>>>>> 7968f542d993b7369b31cb2b1d005d0ea04dc4bd
