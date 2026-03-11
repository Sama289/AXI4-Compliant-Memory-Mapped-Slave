<<<<<<< HEAD
module axi4_memory #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 10,    // For 1024 locations
    parameter DEPTH = 1024
)(
    input  wire                     clk,
    input  wire                     rst_n,
    
    input  wire                     mem_en,
    input  wire                     mem_we,
    input  wire [ADDR_WIDTH-1:0]    mem_addr,
    input  wire [DATA_WIDTH-1:0]    mem_wdata,
    output reg  [DATA_WIDTH-1:0]    mem_rdata
);

    // Memory array
    reg [DATA_WIDTH-1:0] memory [0:DEPTH-1];
    
    
    integer j;
    
    // Memory write
    always @(posedge clk /*or negedge rst_n*/) begin //making active low reset signal asynchronous 
        if (!rst_n)
            mem_rdata <= 0;
       // BUG HERE (1) :: else if (!mem_en) begin: When mem_en is high we should use memory 
        else if (mem_en) begin //FIXED_(1)
            if (mem_we)
                memory[mem_addr] <= mem_wdata;
            else 
               // BUG HERE (2) ::mem_rdata <= memory[mem_addr] & 'hF0 ; :unwanted Masking for read data so read back data  will be inaccurate.
               mem_rdata <= memory[mem_addr] ; //FIXED_(2)
        end
    end
    
    // Initialize memory
    initial begin
        for (j = 0; j < DEPTH; j = j + 1)
            memory[j] = 0;
    end

endmodule




=======
module axi4_memory #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 10,    // For 1024 locations
    parameter DEPTH = 1024
)(
    input  wire                     clk,
    input  wire                     rst_n,
    
    input  wire                     mem_en,
    input  wire                     mem_we,
    input  wire [ADDR_WIDTH-1:0]    mem_addr,
    input  wire [DATA_WIDTH-1:0]    mem_wdata,
    output reg  [DATA_WIDTH-1:0]    mem_rdata
);

    // Memory array
    reg [DATA_WIDTH-1:0] memory [0:DEPTH-1];
    
    
    integer j;
    
    // Memory write
    always @(posedge clk /*or negedge rst_n*/) begin //making active low reset signal asynchronous 
        if (!rst_n)
            mem_rdata <= 0;
       // BUG HERE (1) :: else if (!mem_en) begin: When mem_en is high we should use memory 
        else if (mem_en) begin //FIXED_(1)
            if (mem_we)
                memory[mem_addr] <= mem_wdata;
            else 
               // BUG HERE (2) ::mem_rdata <= memory[mem_addr] & 'hF0 ; :unwanted Masking for read data so read back data  will be inaccurate.
               mem_rdata <= memory[mem_addr] ; //FIXED_(2)
        end
    end
    
    // Initialize memory
    initial begin
        for (j = 0; j < DEPTH; j = j + 1)
            memory[j] = 0;
    end

endmodule




>>>>>>> 7968f542d993b7369b31cb2b1d005d0ea04dc4bd
