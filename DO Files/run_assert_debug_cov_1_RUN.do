vlib work
vlog *.*sv axi4.v +define+SVA_MODE+SVA_COV_MODE+RUN_ADVANCED_TESTS +cover -covercells

# Generate one random seed
set seed [expr {int(rand() * 1000000)}]
set ucdb_file "cov_run.ucdb"

puts "Running simulation with random seed: $seed"

vsim -voptargs=+acc -assertdebug work.axi4_top -coverage +ntb_random_seed=$seed -do "
      do waivers.do
    coverage save -onexit $ucdb_file
    do wave.do
    run -all
"

puts "Generating coverage report"
vcover report $ucdb_file -details -output cov_report.txt
vcover report $ucdb_file -details -html -output cov_report

puts "Simulation completed , Check Coverage report now :)"
puts "Text report: cov_report.txt"
puts "HTML report: cov_report/index.html"