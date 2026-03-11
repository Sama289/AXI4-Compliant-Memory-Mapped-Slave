vlib work
vlog *.*sv axi4.v +define+SVA_MODE+SVA_COV_MODE+RUN_ADVANCED_TESTS +cover -covercells

for {set i 0} {$i < 3} {incr i} {
  set seed [expr {int(rand() * 1000000)}]
  set ucdb_file "cov_run${i}.ucdb"
 
  puts "Running simulation $i with random seed: $seed"
 
  if {$i < 2} {
    # For all runs except the last one, quit after saving coverage
    vsim -voptargs=+acc -assertdebug work.axi4_top -coverage +ntb_random_seed=$seed -do "
      do waivers.do
      coverage save -onexit $ucdb_file
      do wave.do
      run -all
      quit -sim
    "
  } else {
    # For the last run, don't quit the simulation, 3shan lw f haga a3rf a debug 
    vsim -voptargs=+acc -assertdebug work.axi4_top -coverage +ntb_random_seed=$seed -do "
      do waivers.do
      coverage save -onexit $ucdb_file
      do wave.do
      run -all
    "
  }
}

puts "Merging coverage databases now "
vcover merge merged_cov.ucdb cov_run*.ucdb

puts "Generating coverage reports now"
do waivers.do
vcover report merged_cov.ucdb -details -all -output cov_report.txt
vcover report merged_cov.ucdb -details -html -output cov_report

puts "Coverage analysis completed :)"
puts "Text report: cov_report.txt"
puts "HTML report: cov_report/index.html"
puts "Last simulation is still running for interactive debugging "