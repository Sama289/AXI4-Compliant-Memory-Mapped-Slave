<<<<<<< HEAD
interface axi4_if #(
    parameter DATA_WIDTH   = 32,
    parameter DEPTH        = 1024,
    parameter ADDR_WIDTH_S = 16,
    parameter ADDR_WIDTH_M = 10    // For 1024 locations
)
(
    input bit ACLK
);
    bit ARESETn;

    // Memory signals 
    logic                     mem_en;
    logic                     mem_we;
    logic [ADDR_WIDTH_M-1:0]  mem_addr;
    logic [DATA_WIDTH-1:0]    mem_wdata;
    logic [DATA_WIDTH-1:0]    mem_rdata;

    // Slave Signals
    logic [ADDR_WIDTH_S -1:0] AWADDR, ARADDR;
    logic [7:0]               AWLEN, ARLEN;
    logic [2:0]               AWSIZE, ARSIZE;
    logic                     AWVALID, AWREADY;
    logic                     WVALID, WREADY, WLAST;
    logic [DATA_WIDTH-1:0]    WDATA;
    logic                     BVALID, BREADY;
    logic [1:0]               BRESP;
    logic                     ARVALID, ARREADY;
    logic                     RVALID, RREADY, RLAST;
    logic [DATA_WIDTH-1:0]    RDATA;
    logic [1:0]               RRESP;


    modport TB (output AWADDR, AWLEN, AWSIZE, AWVALID,
        output WDATA, WVALID, WLAST,
        output BREADY,
        output ARADDR, ARLEN, ARSIZE, ARVALID,
        output RREADY,
        
        input ACLK, ARESETn,
        input AWREADY,
        input WREADY,
        input BVALID, BRESP,
        input ARREADY,
        input RVALID, RDATA, RRESP, RLAST

    );




endinterface


     /*
    --------------------------------------------------------------------------
    | you can uncomment if you wish to pass the interface to your designs :) |
    -------------------------------------------------------------------------
    modport dut (
        input  ACLK, ARESETn,
        // Write address channel
        input  AWADDR, AWLEN, AWSIZE, AWVALID,
        // Write data channel
        input  WDATA, WVALID, WLAST,
        // Write response channel
        input  BREADY,
        input  ARADDR, ARLEN, ARSIZE, ARVALID,
        input  RREADY,
        output AWREADY, WREADY, BVALID, BRESP,
        output ARREADY, RVALID, RLAST, RDATA, RRESP
    );

    modport dut_mem (
        input clk,
        input rst_n,
        input mem_en,
        input mem_we,
        input mem_addr,
        input mem_wdata,
        output mem_rdata
    );   */
=======
interface axi4_if #(
    parameter DATA_WIDTH   = 32,
    parameter DEPTH        = 1024,
    parameter ADDR_WIDTH_S = 16,
    parameter ADDR_WIDTH_M = 10    // For 1024 locations
)
(
    input bit ACLK
);
    bit ARESETn;

    // Memory signals 
    logic                     mem_en;
    logic                     mem_we;
    logic [ADDR_WIDTH_M-1:0]  mem_addr;
    logic [DATA_WIDTH-1:0]    mem_wdata;
    logic [DATA_WIDTH-1:0]    mem_rdata;

    // Slave Signals
    logic [ADDR_WIDTH_S -1:0] AWADDR, ARADDR;
    logic [7:0]               AWLEN, ARLEN;
    logic [2:0]               AWSIZE, ARSIZE;
    logic                     AWVALID, AWREADY;
    logic                     WVALID, WREADY, WLAST;
    logic [DATA_WIDTH-1:0]    WDATA;
    logic                     BVALID, BREADY;
    logic [1:0]               BRESP;
    logic                     ARVALID, ARREADY;
    logic                     RVALID, RREADY, RLAST;
    logic [DATA_WIDTH-1:0]    RDATA;
    logic [1:0]               RRESP;


    modport TB (output AWADDR, AWLEN, AWSIZE, AWVALID,
        output WDATA, WVALID, WLAST,
        output BREADY,
        output ARADDR, ARLEN, ARSIZE, ARVALID,
        output RREADY,
        
        input ACLK, ARESETn,
        input AWREADY,
        input WREADY,
        input BVALID, BRESP,
        input ARREADY,
        input RVALID, RDATA, RRESP, RLAST

    );




endinterface


     /*
    --------------------------------------------------------------------------
    | you can uncomment if you wish to pass the interface to your designs :) |
    -------------------------------------------------------------------------
    modport dut (
        input  ACLK, ARESETn,
        // Write address channel
        input  AWADDR, AWLEN, AWSIZE, AWVALID,
        // Write data channel
        input  WDATA, WVALID, WLAST,
        // Write response channel
        input  BREADY,
        input  ARADDR, ARLEN, ARSIZE, ARVALID,
        input  RREADY,
        output AWREADY, WREADY, BVALID, BRESP,
        output ARREADY, RVALID, RLAST, RDATA, RRESP
    );

    modport dut_mem (
        input clk,
        input rst_n,
        input mem_en,
        input mem_we,
        input mem_addr,
        input mem_wdata,
        output mem_rdata
    );   */
>>>>>>> 7968f542d993b7369b31cb2b1d005d0ea04dc4bd
   