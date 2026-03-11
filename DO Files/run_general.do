vlib work
vlog *.*sv axi4.v  +define+SVA_MODE
vsim -voptargs=+acc work.axi4_top 

do wave.do
run -all 



