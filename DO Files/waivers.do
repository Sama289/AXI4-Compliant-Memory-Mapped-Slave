<<<<<<< HEAD
# 1. Waive unused SIZE bits (Locked to 3'd2 for 32-bit words) -> L design not support data strobes WSTB
coverage exclude -du axi4 -toggle {AWSIZE[1]}
coverage exclude -du axi4 -toggle {ARSIZE[1]}
coverage exclude -du axi4 -toggle {AWSIZE[0]}
coverage exclude -du axi4 -toggle {AWSIZE[2]}
coverage exclude -du axi4 -toggle {ARSIZE[0]}
coverage exclude -du axi4 -toggle {ARSIZE[2]}
coverage exclude -du axi4 -toggle {write_size[0]}
coverage exclude -du axi4 -toggle {write_size[2]}
coverage exclude -du axi4 -toggle {read_size[0]}
coverage exclude -du axi4 -toggle {read_size[2]}


# 2. Waive unused RESPONSE bits (Design only uses OKAY=00, SLVERR=10)
coverage exclude -du axi4 -toggle {BRESP[0]}
coverage exclude -du axi4 -toggle {RRESP[0]}

# 3. Waive unused FSM register bits (Max state is 3, requires only 2 bits)
coverage exclude -du axi4 -toggle {write_state[2]}
coverage exclude -du axi4 -toggle {read_state[2]}

# 4. Waive Address Increment constants (Always 4 bytes) -> 3shan 3ndi data 32 bit w size 2
coverage exclude -du axi4 -toggle {write_addr_incr[1]}
coverage exclude -du axi4 -toggle {write_addr_incr[15:3]}
coverage exclude -du axi4 -toggle {read_addr_incr[1]}
coverage exclude -du axi4 -toggle {read_addr_incr[15:3]}


# 5. Waive unreachable condition (WVALID && WREADY) in W_DATA state
# WREADY is hardcoded to 1 before entering W_DATA state , wkda kda el W_addr el awl btygy ya3ni 
coverage exclude -srcfile axi4.v -feccondrow 181 3

# 6. Waive unreachable condition (BREADY && BVALID) in W_RESP state
#  BVALID is hardcoded to 1 before entering W_RESP, wkda kda el W_DATA  btygy l awl brdo
coverage exclude -srcfile axi4.v -feccondrow 216 3 


# 7. Waive Write FSM default state (Statement and Branch)
coverage exclude -src axi4.v -line 223 -code s
coverage exclude -src axi4.v -line 223 -code b

# 8. Waive Read FSM default state (Statement and Branch)
coverage exclude -src axi4.v -line 293 -code s
coverage exclude -src axi4.v -line 293 -code b

# 9. Waive ONLY Row 7 for the first condition on line 111
coverage exclude -srcfile axi4.v -feccondrow 111 7 

# 10. Waive bec Memory is exactly 4KB. Crossing the boundary guarantees the address is out-of-range, masking this condition.
# write_boundary_cross must be 1 (meaning the burst mathematically crossed a 4KB boundary).
# write_addr_valid must be 1 (meaning the current address is inside the memory).
=======
# 1. Waive unused SIZE bits (Locked to 3'd2 for 32-bit words) -> L design not support data strobes WSTB
coverage exclude -du axi4 -toggle {AWSIZE[1]}
coverage exclude -du axi4 -toggle {ARSIZE[1]}
coverage exclude -du axi4 -toggle {AWSIZE[0]}
coverage exclude -du axi4 -toggle {AWSIZE[2]}
coverage exclude -du axi4 -toggle {ARSIZE[0]}
coverage exclude -du axi4 -toggle {ARSIZE[2]}
coverage exclude -du axi4 -toggle {write_size[0]}
coverage exclude -du axi4 -toggle {write_size[2]}
coverage exclude -du axi4 -toggle {read_size[0]}
coverage exclude -du axi4 -toggle {read_size[2]}


# 2. Waive unused RESPONSE bits (Design only uses OKAY=00, SLVERR=10)
coverage exclude -du axi4 -toggle {BRESP[0]}
coverage exclude -du axi4 -toggle {RRESP[0]}

# 3. Waive unused FSM register bits (Max state is 3, requires only 2 bits)
coverage exclude -du axi4 -toggle {write_state[2]}
coverage exclude -du axi4 -toggle {read_state[2]}

# 4. Waive Address Increment constants (Always 4 bytes) -> 3shan 3ndi data 32 bit w size 2
coverage exclude -du axi4 -toggle {write_addr_incr[1]}
coverage exclude -du axi4 -toggle {write_addr_incr[15:3]}
coverage exclude -du axi4 -toggle {read_addr_incr[1]}
coverage exclude -du axi4 -toggle {read_addr_incr[15:3]}


# 5. Waive unreachable condition (WVALID && WREADY) in W_DATA state
# WREADY is hardcoded to 1 before entering W_DATA state , wkda kda el W_addr el awl btygy ya3ni 
coverage exclude -srcfile axi4.v -feccondrow 181 3

# 6. Waive unreachable condition (BREADY && BVALID) in W_RESP state
#  BVALID is hardcoded to 1 before entering W_RESP, wkda kda el W_DATA  btygy l awl brdo
coverage exclude -srcfile axi4.v -feccondrow 216 3 


# 7. Waive Write FSM default state (Statement and Branch)
coverage exclude -src axi4.v -line 223 -code s
coverage exclude -src axi4.v -line 223 -code b

# 8. Waive Read FSM default state (Statement and Branch)
coverage exclude -src axi4.v -line 293 -code s
coverage exclude -src axi4.v -line 293 -code b

# 9. Waive ONLY Row 7 for the first condition on line 111
coverage exclude -srcfile axi4.v -feccondrow 111 7 

# 10. Waive bec Memory is exactly 4KB. Crossing the boundary guarantees the address is out-of-range, masking this condition.
# write_boundary_cross must be 1 (meaning the burst mathematically crossed a 4KB boundary).
# write_addr_valid must be 1 (meaning the current address is inside the memory).
>>>>>>> 7968f542d993b7369b31cb2b1d005d0ea04dc4bd
coverage exclude -srcfile axi4.v -feccondrow 201 4 