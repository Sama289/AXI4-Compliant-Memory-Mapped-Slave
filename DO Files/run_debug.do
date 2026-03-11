vlib work
vlog *.*sv axi4.v  +define+DEBUG_STIM 
vsim -voptargs=+acc work.axi4_top 

do wave.do
run -all 



