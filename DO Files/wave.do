<<<<<<< HEAD
onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -height 30 -expand -group Mem /axi4_top/uut/mem_inst/mem_en
add wave -noupdate -height 30 -expand -group Mem /axi4_top/uut/mem_inst/mem_we
add wave -noupdate -height 30 -expand -group Mem -radix unsigned /axi4_top/uut/mem_inst/mem_addr
add wave -noupdate -height 30 -expand -group Mem /axi4_top/uut/mem_inst/mem_wdata
add wave -noupdate -height 30 -expand -group Mem /axi4_top/uut/mem_inst/mem_rdata
add wave -noupdate -height 30 -expand -group Mem -height 30 /axi4_top/uut/mem_inst/memory
add wave -noupdate -height 30 -expand -group Mem /axi4_top/axi4if/ARESETn
add wave -noupdate /axi4_top/axi4if/ACLK
add wave -noupdate -height 25 -expand -group OP -color Magenta -radix ascii -radixenum symbolic -radixshowbase 0 /axi4_top/tb/pkt.we
add wave -noupdate -height 25 -expand -group OP -color Blue -radix ascii -radixenum symbolic -radixshowbase 0 /axi4_top/tb/pkt.addr_range
add wave -noupdate -height 30 -group {WRITE OPERATION} -divider -height 20 Address
add wave -noupdate -height 30 -group {WRITE OPERATION} -color Cyan /axi4_top/axi4if/AWVALID
add wave -noupdate -height 30 -group {WRITE OPERATION} -color Cyan /axi4_top/axi4if/AWREADY
add wave -noupdate -height 30 -group {WRITE OPERATION} -color Thistle -radix unsigned /axi4_top/axi4if/AWADDR
add wave -noupdate -height 30 -group {WRITE OPERATION} -radix unsigned /axi4_top/axi4if/AWLEN
add wave -noupdate -height 30 -group {WRITE OPERATION} /axi4_top/axi4if/AWSIZE
add wave -noupdate -height 30 -group {WRITE OPERATION} -divider -height 20 Data
add wave -noupdate -height 30 -group {WRITE OPERATION} -color Cyan /axi4_top/axi4if/WVALID
add wave -noupdate -height 30 -group {WRITE OPERATION} -color Cyan /axi4_top/axi4if/WREADY
add wave -noupdate -height 30 -group {WRITE OPERATION} -color Thistle /axi4_top/axi4if/WLAST
add wave -noupdate -height 30 -group {WRITE OPERATION} -color {Spring Green} /axi4_top/axi4if/WDATA
add wave -noupdate -height 30 -group {WRITE OPERATION} -divider -height 20 Response
add wave -noupdate -height 30 -group {WRITE OPERATION} -color Cyan /axi4_top/axi4if/BVALID
add wave -noupdate -height 30 -group {WRITE OPERATION} -color Cyan /axi4_top/axi4if/BREADY
add wave -noupdate -height 30 -group {WRITE OPERATION} -color Magenta /axi4_top/axi4if/BRESP
add wave -noupdate -height 30 -expand -group {READ OPERATION} -divider -height 25 Address
add wave -noupdate -height 30 -expand -group {READ OPERATION} -color Pink /axi4_top/axi4if/ARVALID
add wave -noupdate -height 30 -expand -group {READ OPERATION} -color Pink /axi4_top/axi4if/ARREADY
add wave -noupdate -height 30 -expand -group {READ OPERATION} -radix unsigned /axi4_top/axi4if/ARADDR
add wave -noupdate -height 30 -expand -group {READ OPERATION} -radix unsigned /axi4_top/axi4if/ARLEN
add wave -noupdate -height 30 -expand -group {READ OPERATION} /axi4_top/axi4if/ARSIZE
add wave -noupdate -height 30 -expand -group {READ OPERATION} -divider -height 25 DATA
add wave -noupdate -height 30 -expand -group {READ OPERATION} -color Pink /axi4_top/axi4if/RVALID
add wave -noupdate -height 30 -expand -group {READ OPERATION} -color Pink /axi4_top/axi4if/RREADY
add wave -noupdate -height 30 -expand -group {READ OPERATION} -color {Spring Green} /axi4_top/axi4if/RDATA
add wave -noupdate -height 30 -expand -group {READ OPERATION} -color Thistle /axi4_top/axi4if/RLAST
add wave -noupdate -height 30 -expand -group {READ OPERATION} -color Magenta /axi4_top/axi4if/RRESP
add wave -noupdate -height 30 -group COUNTERS -radix unsigned /axi4_top/tb/pass_count
add wave -noupdate -height 30 -group COUNTERS /axi4_top/tb/fail_count
add wave -noupdate -height 30 -expand -group ASSERTIONS_DEBUG /axi4_top/uut/axi4_sva_inst/assert_rst_n
add wave -noupdate -height 30 -expand -group ASSERTIONS_DEBUG /axi4_top/uut/axi4_sva_inst/clk_check
add wave -noupdate /axi4_top/uut/axi4_sva_inst/assert__beats_match_len
add wave -noupdate /axi4_top/uut/axi4_sva_inst/assert__beats_match_len__1
add wave -noupdate /axi4_top/uut/axi4_sva_inst/assert__boundry_cross_resp
add wave -noupdate /axi4_top/uut/axi4_sva_inst/assert__boundry_cross_resp__1
add wave -noupdate /axi4_top/uut/axi4_sva_inst/assert__ctrl_stable
add wave -noupdate /axi4_top/uut/axi4_sva_inst/assert__ctrl_stable__1
add wave -noupdate /axi4_top/uut/axi4_sva_inst/assert__done_handshake
add wave -noupdate /axi4_top/uut/axi4_sva_inst/assert__done_handshake__1
add wave -noupdate /axi4_top/uut/axi4_sva_inst/assert__done_handshake__2
add wave -noupdate /axi4_top/uut/axi4_sva_inst/assert__done_handshake_data_channels
add wave -noupdate /axi4_top/uut/axi4_sva_inst/assert__done_handshake_data_channels__1
add wave -noupdate /axi4_top/uut/axi4_sva_inst/assert__last_on_last_beat
add wave -noupdate /axi4_top/uut/axi4_sva_inst/assert__last_on_last_beat__1
add wave -noupdate /axi4_top/uut/axi4_sva_inst/assert__no_early_last
add wave -noupdate /axi4_top/uut/axi4_sva_inst/assert__no_early_last__1
add wave -noupdate /axi4_top/uut/axi4_sva_inst/assert__okay_response
add wave -noupdate /axi4_top/uut/axi4_sva_inst/assert__okay_response__1
add wave -noupdate /axi4_top/uut/axi4_sva_inst/assert__ready_before_valid
add wave -noupdate /axi4_top/uut/axi4_sva_inst/assert__ready_before_valid__1
add wave -noupdate /axi4_top/uut/axi4_sva_inst/assert__valid_before_ready
add wave -noupdate /axi4_top/uut/axi4_sva_inst/assert__valid_before_ready__1
add wave -noupdate /axi4_top/uut/axi4_sva_inst/assert__valid_before_ready__2
add wave -noupdate /axi4_top/uut/axi4_sva_inst/assert__wdata_stable_during_valid
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {47610 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 125
configure wave -valuecolwidth 141
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {47594 ns} {48042 ns}
=======
onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -height 30 -expand -group Mem /axi4_top/uut/mem_inst/mem_en
add wave -noupdate -height 30 -expand -group Mem /axi4_top/uut/mem_inst/mem_we
add wave -noupdate -height 30 -expand -group Mem -radix unsigned /axi4_top/uut/mem_inst/mem_addr
add wave -noupdate -height 30 -expand -group Mem /axi4_top/uut/mem_inst/mem_wdata
add wave -noupdate -height 30 -expand -group Mem /axi4_top/uut/mem_inst/mem_rdata
add wave -noupdate -height 30 -expand -group Mem -height 30 /axi4_top/uut/mem_inst/memory
add wave -noupdate -height 30 -expand -group Mem /axi4_top/axi4if/ARESETn
add wave -noupdate /axi4_top/axi4if/ACLK
add wave -noupdate -height 25 -expand -group OP -color Magenta -radix ascii -radixenum symbolic -radixshowbase 0 /axi4_top/tb/pkt.we
add wave -noupdate -height 25 -expand -group OP -color Blue -radix ascii -radixenum symbolic -radixshowbase 0 /axi4_top/tb/pkt.addr_range
add wave -noupdate -height 30 -group {WRITE OPERATION} -divider -height 20 Address
add wave -noupdate -height 30 -group {WRITE OPERATION} -color Cyan /axi4_top/axi4if/AWVALID
add wave -noupdate -height 30 -group {WRITE OPERATION} -color Cyan /axi4_top/axi4if/AWREADY
add wave -noupdate -height 30 -group {WRITE OPERATION} -color Thistle -radix unsigned /axi4_top/axi4if/AWADDR
add wave -noupdate -height 30 -group {WRITE OPERATION} -radix unsigned /axi4_top/axi4if/AWLEN
add wave -noupdate -height 30 -group {WRITE OPERATION} /axi4_top/axi4if/AWSIZE
add wave -noupdate -height 30 -group {WRITE OPERATION} -divider -height 20 Data
add wave -noupdate -height 30 -group {WRITE OPERATION} -color Cyan /axi4_top/axi4if/WVALID
add wave -noupdate -height 30 -group {WRITE OPERATION} -color Cyan /axi4_top/axi4if/WREADY
add wave -noupdate -height 30 -group {WRITE OPERATION} -color Thistle /axi4_top/axi4if/WLAST
add wave -noupdate -height 30 -group {WRITE OPERATION} -color {Spring Green} /axi4_top/axi4if/WDATA
add wave -noupdate -height 30 -group {WRITE OPERATION} -divider -height 20 Response
add wave -noupdate -height 30 -group {WRITE OPERATION} -color Cyan /axi4_top/axi4if/BVALID
add wave -noupdate -height 30 -group {WRITE OPERATION} -color Cyan /axi4_top/axi4if/BREADY
add wave -noupdate -height 30 -group {WRITE OPERATION} -color Magenta /axi4_top/axi4if/BRESP
add wave -noupdate -height 30 -expand -group {READ OPERATION} -divider -height 25 Address
add wave -noupdate -height 30 -expand -group {READ OPERATION} -color Pink /axi4_top/axi4if/ARVALID
add wave -noupdate -height 30 -expand -group {READ OPERATION} -color Pink /axi4_top/axi4if/ARREADY
add wave -noupdate -height 30 -expand -group {READ OPERATION} -radix unsigned /axi4_top/axi4if/ARADDR
add wave -noupdate -height 30 -expand -group {READ OPERATION} -radix unsigned /axi4_top/axi4if/ARLEN
add wave -noupdate -height 30 -expand -group {READ OPERATION} /axi4_top/axi4if/ARSIZE
add wave -noupdate -height 30 -expand -group {READ OPERATION} -divider -height 25 DATA
add wave -noupdate -height 30 -expand -group {READ OPERATION} -color Pink /axi4_top/axi4if/RVALID
add wave -noupdate -height 30 -expand -group {READ OPERATION} -color Pink /axi4_top/axi4if/RREADY
add wave -noupdate -height 30 -expand -group {READ OPERATION} -color {Spring Green} /axi4_top/axi4if/RDATA
add wave -noupdate -height 30 -expand -group {READ OPERATION} -color Thistle /axi4_top/axi4if/RLAST
add wave -noupdate -height 30 -expand -group {READ OPERATION} -color Magenta /axi4_top/axi4if/RRESP
add wave -noupdate -height 30 -group COUNTERS -radix unsigned /axi4_top/tb/pass_count
add wave -noupdate -height 30 -group COUNTERS /axi4_top/tb/fail_count
add wave -noupdate -height 30 -expand -group ASSERTIONS_DEBUG /axi4_top/uut/axi4_sva_inst/assert_rst_n
add wave -noupdate -height 30 -expand -group ASSERTIONS_DEBUG /axi4_top/uut/axi4_sva_inst/clk_check
add wave -noupdate /axi4_top/uut/axi4_sva_inst/assert__beats_match_len
add wave -noupdate /axi4_top/uut/axi4_sva_inst/assert__beats_match_len__1
add wave -noupdate /axi4_top/uut/axi4_sva_inst/assert__boundry_cross_resp
add wave -noupdate /axi4_top/uut/axi4_sva_inst/assert__boundry_cross_resp__1
add wave -noupdate /axi4_top/uut/axi4_sva_inst/assert__ctrl_stable
add wave -noupdate /axi4_top/uut/axi4_sva_inst/assert__ctrl_stable__1
add wave -noupdate /axi4_top/uut/axi4_sva_inst/assert__done_handshake
add wave -noupdate /axi4_top/uut/axi4_sva_inst/assert__done_handshake__1
add wave -noupdate /axi4_top/uut/axi4_sva_inst/assert__done_handshake__2
add wave -noupdate /axi4_top/uut/axi4_sva_inst/assert__done_handshake_data_channels
add wave -noupdate /axi4_top/uut/axi4_sva_inst/assert__done_handshake_data_channels__1
add wave -noupdate /axi4_top/uut/axi4_sva_inst/assert__last_on_last_beat
add wave -noupdate /axi4_top/uut/axi4_sva_inst/assert__last_on_last_beat__1
add wave -noupdate /axi4_top/uut/axi4_sva_inst/assert__no_early_last
add wave -noupdate /axi4_top/uut/axi4_sva_inst/assert__no_early_last__1
add wave -noupdate /axi4_top/uut/axi4_sva_inst/assert__okay_response
add wave -noupdate /axi4_top/uut/axi4_sva_inst/assert__okay_response__1
add wave -noupdate /axi4_top/uut/axi4_sva_inst/assert__ready_before_valid
add wave -noupdate /axi4_top/uut/axi4_sva_inst/assert__ready_before_valid__1
add wave -noupdate /axi4_top/uut/axi4_sva_inst/assert__valid_before_ready
add wave -noupdate /axi4_top/uut/axi4_sva_inst/assert__valid_before_ready__1
add wave -noupdate /axi4_top/uut/axi4_sva_inst/assert__valid_before_ready__2
add wave -noupdate /axi4_top/uut/axi4_sva_inst/assert__wdata_stable_during_valid
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {47610 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 125
configure wave -valuecolwidth 141
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {47594 ns} {48042 ns}
>>>>>>> 7968f542d993b7369b31cb2b1d005d0ea04dc4bd
