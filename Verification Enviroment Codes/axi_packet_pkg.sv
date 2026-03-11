<<<<<<< HEAD
package axi_packet_pkg;

    import axi4_enum::*;
    class axi_packet;

        parameter DATA_WIDTH = 32;
        parameter ADDR_WIDTH = 16;
        parameter MEMORY_DEPTH = 1024;
        localparam int INBOUND_MAX = 4095;

        static int total_count = 0; // to total_count created objects of this class 
        int id;
        
        // Signals to randomize for stimulus
        rand axi_we_e               we; 
        rand logic [ADDR_WIDTH-1:0] addr;                                      
        rand logic [7:0]            len;  
        rand logic [2:0]            size;
        rand logic [DATA_WIDTH-1:0] burst[$];  // random WDATA, constraint size of Queue = len+1
        rand addr_bound_e           addr_range;
        rand bit                    ARESET_n;

    	logic [1:0]                 resp;

        //-------------------------------
        //--------- Constrain -----------
        //-------------------------------    		
        
        constraint reset_c {
            ARESET_n dist {0:/10 , 1:/ 90};
        }

        constraint we_c {
            we dist {AXI_READ:/50, AXI_WRITE:/50};
        }


        constraint burst_size_c {
            burst.size() == len + 1;
        }

        constraint addr_bound_c {
            addr_range dist {IN_BOUND:/70, OUT_BOUND:/30};
        }

        constraint addr_c {
            if (addr_range == IN_BOUND) {
                addr dist { 
                  0              :/ 5,
                  [1     : 1365] :/ 30,   // low
                  [1366  : 2730] :/ 35,   // medium
                  [2731  : 4094] :/ 20,   // high
                  4095           :/ 10
                };

            }

            else {
                addr inside { [INBOUND_MAX+1 : (1<<ADDR_WIDTH)-1] };
            }
        }

        constraint size_word_only_c {
            size == 3'd2;   // size = 2 -> 4 bytes per beat
        }

        constraint len_c {
            len dist {
                0         :/ 10,
                [1:7]     :/ 30,
                [8:31]    :/ 30,
                [32:127]  :/ 10,
                [128:254] :/ 10,
                255       :/ 10
            };
        }

        constraint burst_data_pattern_c  {
            foreach (burst[i]) burst[i] dist {
                32'h00000000:/ 5,
                32'hFFFFFFFF:/ 5,
                32'hAAAAAAAA:/5,
                32'h55555555:/5,

                [32'h00000001 : 32'h0FFFFFFF]:/ 30,
                [32'h10000000 : 32'h7FFFFFFF]:/ 30,
                [32'h80000000 : 32'hFFFFFFFE]:/ 20

            };
        }



    	//-------------------------------
    	//--------- Covergroups ---------
    	//-------------------------------
    	
        covergroup axi_cov; 

            addr_cp : coverpoint addr {
              type_option.comment = "Address Ranges Coverage";
              bins low_range    = {[0    : 1365]};
              bins medium_range = {[1366 : 2730]};
              bins high_range   = {[2731 : 4095]};
              bins out_of_range = {[4096 : 8192]};  

            }

            op_cp: coverpoint we {
                type_option.comment = "Op_code Coverage";
                bins read_op  = {AXI_READ};
                bins write_op = {AXI_WRITE};
            } 
              
            RESP_cp : coverpoint resp {
                type_option.comment = "Response Coverage";
                bins okay   = {2'b00};
                bins slverr = {2'b10};
            }

            burst_length_cp : coverpoint len {
              type_option.comment = "Burst Length Ranges Coverage";
              bins single_beat = {0};
              bins short_burst = {[1:7]};
              bins medium_burst = {[8:31]};
              bins long_burst = {[32:127]};
              bins very_long_burst = {[128:254]};
              bins max_burst = {255};
            }


            // Cross Coverage: Ensure different LEN,resp,addr tested for AXI_READ and writes
            type_option.comment = "Cross Coverage";
            LEN_OP_cross    : cross burst_length_cp, op_cp;
            RESP_OP_cross   : cross RESP_cp, op_cp;
            addr_OP_cross   : cross addr_cp, op_cp;
            addr_len_cross  : cross burst_length_cp, addr_cp;
              
        endgroup


        covergroup burst_cov with function sample(int idx,logic [DATA_WIDTH-1:0] data_val);
            type_option.comment = "Data Pattern Coverage";
            burst_data_val_cp : coverpoint data_val {
                bins zeros = {32'h00000000};
                bins ones  = {32'hFFFFFFFF};

                bins low_range  = {[32'h00000001 : 32'h0FFFFFFF]};
                bins mid_range  = {[32'h10000000 : 32'h7FFFFFFF]};
                bins high_range = {[32'h80000000 : 32'hFFFFFFFE]};
                bins alternating_AA = {32'hAAAAAAAA};
                bins alternating_55 = {32'h55555555};
            }

            burst_idx_cp : coverpoint idx {
                bins idx_val [] = {[0:255]};
            }

            idx_data_val_cross : cross burst_data_val_cp, burst_idx_cp;
            //busrt_data_len_cross : cross burst_data_val_cp, burst_length_cp;
        endgroup

    	//-----------------------------------------
    	//--------- Tasks and Functions -----------
    	//-----------------------------------------
            function void sample_burst_cov();
                foreach (burst[i]) begin
                    burst_cov.sample(i, burst[i]);
                end
            endfunction

    		// to keep count and tracking the number of objects created from this class :)
    		function new();
    			id = total_count++;
    			axi_cov = new();
                burst_cov = new();
                $display("\n -------------------------------------------------------------------");
    			$display(" Created Object ID = %0d ; Obj_total_counts = %0d", id, total_count);
    			
    		endfunction 

    		// The Recommended Print task, should help in displaying the stimulus values in the packet
    		function void print();
                $display("[%S] ID = %0d, ADDR_byte = %0d, ADDR_word = %0d LEN = %0d", we.name() , id, addr,(addr/4), len);
            endfunction

    endclass
 	
endpackage : axi_packet_pkg 


        /* // If used , i will rand data and make a dist for it and coverpoint for it w 5las 

            constraint burst_data_pattern_c  {
                foreach (burst[i]) burst[i] == data + i;
            }

            rand logic [DATA_WIDTH-1:0] data;
            constraint data_c  {
                    data dist {
                    32'h00000000:/ 1,
                    32'hFFFFFFFF:/ 1,

                    [32'h00000001 : 32'h0FFFFFFF]:/ 33,
                    [32'h10000000 : 32'h7FFFFFFF]:/ 33,
                    [32'h80000000 : 32'hFFFFFFFE]:/ 32
                  };
            }         

            data_cp : coverpoint data {
                bins zeros = {32'h00000000};
                bins ones  = {32'hFFFFFFFF};

                bins low_range  = {[32'h00000001 : 32'h0FFFFFFF]};
                bins mid_range  = {[32'h10000000 : 32'h7FFFFFFF]};
                bins high_range = {[32'h80000000 : 32'hFFFFFFFE]};
            }

        */

        /* 
            constraint addr_inbound_c {
                if (addr_range == IN_BOUND){
                    addr dist {
                      0              := 0,
                      [1     : 1365] := 3,   // low
                      [1366  : 2730] := 3,   // medium
                      [2731  : 4094] := 3,    // high
                      4095           := 1
                    };
                };
            }
        */
=======
package axi_packet_pkg;

    import axi4_enum::*;
    class axi_packet;

        parameter DATA_WIDTH = 32;
        parameter ADDR_WIDTH = 16;
        parameter MEMORY_DEPTH = 1024;
        localparam int INBOUND_MAX = 4095;

        static int total_count = 0; // to total_count created objects of this class 
        int id;
        
        // Signals to randomize for stimulus
        rand axi_we_e               we; 
        rand logic [ADDR_WIDTH-1:0] addr;                                      
        rand logic [7:0]            len;  
        rand logic [2:0]            size;
        rand logic [DATA_WIDTH-1:0] burst[$];  // random WDATA, constraint size of Queue = len+1
        rand addr_bound_e           addr_range;
        rand bit                    ARESET_n;

    	logic [1:0]                 resp;

        //-------------------------------
        //--------- Constrain -----------
        //-------------------------------    		
        
        constraint reset_c {
            ARESET_n dist {0:/10 , 1:/ 90};
        }

        constraint we_c {
            we dist {AXI_READ:/50, AXI_WRITE:/50};
        }


        constraint burst_size_c {
            burst.size() == len + 1;
        }

        constraint addr_bound_c {
            addr_range dist {IN_BOUND:/70, OUT_BOUND:/30};
        }

        constraint addr_c {
            if (addr_range == IN_BOUND) {
                addr dist { 
                  0              :/ 5,
                  [1     : 1365] :/ 30,   // low
                  [1366  : 2730] :/ 35,   // medium
                  [2731  : 4094] :/ 20,   // high
                  4095           :/ 10
                };

            }

            else {
                addr inside { [INBOUND_MAX+1 : (1<<ADDR_WIDTH)-1] };
            }
        }

        constraint size_word_only_c {
            size == 3'd2;   // size = 2 -> 4 bytes per beat
        }

        constraint len_c {
            len dist {
                0         :/ 10,
                [1:7]     :/ 30,
                [8:31]    :/ 30,
                [32:127]  :/ 10,
                [128:254] :/ 10,
                255       :/ 10
            };
        }

        constraint burst_data_pattern_c  {
            foreach (burst[i]) burst[i] dist {
                32'h00000000:/ 5,
                32'hFFFFFFFF:/ 5,
                32'hAAAAAAAA:/5,
                32'h55555555:/5,

                [32'h00000001 : 32'h0FFFFFFF]:/ 30,
                [32'h10000000 : 32'h7FFFFFFF]:/ 30,
                [32'h80000000 : 32'hFFFFFFFE]:/ 20

            };
        }



    	//-------------------------------
    	//--------- Covergroups ---------
    	//-------------------------------
    	
        covergroup axi_cov; 

            addr_cp : coverpoint addr {
              type_option.comment = "Address Ranges Coverage";
              bins low_range    = {[0    : 1365]};
              bins medium_range = {[1366 : 2730]};
              bins high_range   = {[2731 : 4095]};
              bins out_of_range = {[4096 : 8192]};  

            }

            op_cp: coverpoint we {
                type_option.comment = "Op_code Coverage";
                bins read_op  = {AXI_READ};
                bins write_op = {AXI_WRITE};
            } 
              
            RESP_cp : coverpoint resp {
                type_option.comment = "Response Coverage";
                bins okay   = {2'b00};
                bins slverr = {2'b10};
            }

            burst_length_cp : coverpoint len {
              type_option.comment = "Burst Length Ranges Coverage";
              bins single_beat = {0};
              bins short_burst = {[1:7]};
              bins medium_burst = {[8:31]};
              bins long_burst = {[32:127]};
              bins very_long_burst = {[128:254]};
              bins max_burst = {255};
            }


            // Cross Coverage: Ensure different LEN,resp,addr tested for AXI_READ and writes
            type_option.comment = "Cross Coverage";
            LEN_OP_cross    : cross burst_length_cp, op_cp;
            RESP_OP_cross   : cross RESP_cp, op_cp;
            addr_OP_cross   : cross addr_cp, op_cp;
            addr_len_cross  : cross burst_length_cp, addr_cp;
              
        endgroup


        covergroup burst_cov with function sample(int idx,logic [DATA_WIDTH-1:0] data_val);
            type_option.comment = "Data Pattern Coverage";
            burst_data_val_cp : coverpoint data_val {
                bins zeros = {32'h00000000};
                bins ones  = {32'hFFFFFFFF};

                bins low_range  = {[32'h00000001 : 32'h0FFFFFFF]};
                bins mid_range  = {[32'h10000000 : 32'h7FFFFFFF]};
                bins high_range = {[32'h80000000 : 32'hFFFFFFFE]};
                bins alternating_AA = {32'hAAAAAAAA};
                bins alternating_55 = {32'h55555555};
            }

            burst_idx_cp : coverpoint idx {
                bins idx_val [] = {[0:255]};
            }

            idx_data_val_cross : cross burst_data_val_cp, burst_idx_cp;
            //busrt_data_len_cross : cross burst_data_val_cp, burst_length_cp;
        endgroup

    	//-----------------------------------------
    	//--------- Tasks and Functions -----------
    	//-----------------------------------------
            function void sample_burst_cov();
                foreach (burst[i]) begin
                    burst_cov.sample(i, burst[i]);
                end
            endfunction

    		// to keep count and tracking the number of objects created from this class :)
    		function new();
    			id = total_count++;
    			axi_cov = new();
                burst_cov = new();
                $display("\n -------------------------------------------------------------------");
    			$display(" Created Object ID = %0d ; Obj_total_counts = %0d", id, total_count);
    			
    		endfunction 

    		// The Recommended Print task, should help in displaying the stimulus values in the packet
    		function void print();
                $display("[%S] ID = %0d, ADDR_byte = %0d, ADDR_word = %0d LEN = %0d", we.name() , id, addr,(addr/4), len);
            endfunction

    endclass
 	
endpackage : axi_packet_pkg 


        /* // If used , i will rand data and make a dist for it and coverpoint for it w 5las 

            constraint burst_data_pattern_c  {
                foreach (burst[i]) burst[i] == data + i;
            }

            rand logic [DATA_WIDTH-1:0] data;
            constraint data_c  {
                    data dist {
                    32'h00000000:/ 1,
                    32'hFFFFFFFF:/ 1,

                    [32'h00000001 : 32'h0FFFFFFF]:/ 33,
                    [32'h10000000 : 32'h7FFFFFFF]:/ 33,
                    [32'h80000000 : 32'hFFFFFFFE]:/ 32
                  };
            }         

            data_cp : coverpoint data {
                bins zeros = {32'h00000000};
                bins ones  = {32'hFFFFFFFF};

                bins low_range  = {[32'h00000001 : 32'h0FFFFFFF]};
                bins mid_range  = {[32'h10000000 : 32'h7FFFFFFF]};
                bins high_range = {[32'h80000000 : 32'hFFFFFFFE]};
            }

        */

        /* 
            constraint addr_inbound_c {
                if (addr_range == IN_BOUND){
                    addr dist {
                      0              := 0,
                      [1     : 1365] := 3,   // low
                      [1366  : 2730] := 3,   // medium
                      [2731  : 4094] := 3,    // high
                      4095           := 1
                    };
                };
            }
        */
>>>>>>> 7968f542d993b7369b31cb2b1d005d0ea04dc4bd
