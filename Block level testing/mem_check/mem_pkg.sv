<<<<<<< HEAD
package mem_pkg;

// ------------------------------
// Packet 
// ------------------------------
class mem_transaction;
    rand bit [9:0] addr;
    rand bit we;
    rand bit [31:0] data;

    static int total_count = 0;
    int id;

    constraint c_valid_addr { addr < 1024; }

    function new();
        id = total_count++;
        $display("Created object id = %0d", id);
    endfunction
    
endclass

=======
package mem_pkg;

// ------------------------------
// Packet 
// ------------------------------
class mem_transaction;
    rand bit [9:0] addr;
    rand bit we;
    rand bit [31:0] data;

    static int total_count = 0;
    int id;

    constraint c_valid_addr { addr < 1024; }

    function new();
        id = total_count++;
        $display("Created object id = %0d", id);
    endfunction
    
endclass

>>>>>>> 7968f542d993b7369b31cb2b1d005d0ea04dc4bd
endpackage