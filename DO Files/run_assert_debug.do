vlib work
vlog *.*sv axi4.v  +define+SVA_MODE+SVA_COV_MODE
vsim -voptargs="+acc" -assertdebug work.axi4_top

do wave.do
run -all 



