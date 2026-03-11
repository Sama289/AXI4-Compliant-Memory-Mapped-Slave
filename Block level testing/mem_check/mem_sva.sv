<<<<<<< HEAD
module mem_sva (

    input logic clk,
    input logic rst_n,
    input logic mem_en,
    input logic mem_we,
    input logic [9:0] mem_addr,
    input logic [31:0] mem_wdata,
    input logic [31:0] mem_rdata);

    // Check Reset
    property reset;
        @(posedge clk) (!rst_n) |-> mem_rdata == 0;
    endproperty

    //  Check Address range valid  [0 to 1023]
    property Valid_address;
        @(posedge clk) disable iff (!rst_n) mem_en |-> (mem_addr inside {[0:1023]});
    endproperty

     
    // Check no operation
    property No_Operation_Stable;
        @(posedge clk) (!mem_en && !mem_we) |-> ##1 $stable(mem_rdata);
    endproperty
    

    assert property (reset) else $error("[Assertion failed] :: mem_rdata not zero after reset");
    assert property (Valid_address) else $error(" [Assertion failed] :: Address out of range");
    assert property (No_Operation_Stable)else $error("[Assertion failed] :: Assertion failed: mem_rdata changed during idle (no operation).");    
      
endmodule
=======
module mem_sva (

    input logic clk,
    input logic rst_n,
    input logic mem_en,
    input logic mem_we,
    input logic [9:0] mem_addr,
    input logic [31:0] mem_wdata,
    input logic [31:0] mem_rdata);

    // Check Reset
    property reset;
        @(posedge clk) (!rst_n) |-> mem_rdata == 0;
    endproperty

    //  Check Address range valid  [0 to 1023]
    property Valid_address;
        @(posedge clk) disable iff (!rst_n) mem_en |-> (mem_addr inside {[0:1023]});
    endproperty

     
    // Check no operation
    property No_Operation_Stable;
        @(posedge clk) (!mem_en && !mem_we) |-> ##1 $stable(mem_rdata);
    endproperty
    

    assert property (reset) else $error("[Assertion failed] :: mem_rdata not zero after reset");
    assert property (Valid_address) else $error(" [Assertion failed] :: Address out of range");
    assert property (No_Operation_Stable)else $error("[Assertion failed] :: Assertion failed: mem_rdata changed during idle (no operation).");    
      
endmodule
>>>>>>> 7968f542d993b7369b31cb2b1d005d0ea04dc4bd
