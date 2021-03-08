# generate 100% stranded SS_1 and 0% stranded NS_0 for different read sizes
Rscript polyester_sim.R -n 1000 -r 3 -s 1 -l 100 $1 $4
./move_fastas_n.sh $1 1000
./check_strand_n.sh $1 1000 $3 $4 &>simulated_reads/n_checks_$1_1000.txt
rm -f simulated_reads/$1_0.00_SS_sample_*_1000_*

Rscript polyester_sim.R -n 2000 -r 3 -s 1 -l 100 $1 $4
./move_fastas_n.sh $1 2000
./check_strand_n.sh $1 2000 $3 $4 &>simulated_reads/n_checks_$1_2000.txt
rm -f simulated_reads/$1_0.00_SS_sample_*_2000_*

Rscript polyester_sim.R -n 10000 -r 3 -s 1 -l 100 $1 $4
./move_fastas_n.sh $1 10000
./check_strand_n.sh $1 10000 $3 $4 &>simulated_reads/n_checks_$1_10000.txt
rm -f simulated_reads/$1_0.00_SS_sample_*_10000_*

Rscript polyester_sim.R -n 20000 -r 3 -s 1 -l 100 $1 $4
./move_fastas_n.sh $1 20000
./check_strand_n.sh $1 20000 $3 $4 &>simulated_reads/n_checks_$1_20000.txt
rm -f simulated_reads/$1_0.00_SS_sample_*_20000_*

Rscript polyester_sim.R -n 100000 -r 3 -s 1 -l 100 $1 $4
./move_fastas_n.sh $1 100000
./check_strand_n.sh $1 100000 $3 $4 &>simulated_reads/n_checks_$1_100000.txt
rm -f simulated_reads/$1_0.00_SS_sample_*_100000_*

Rscript polyester_sim.R -n 200000 -r 3 -s 1 -l 100 $1 $4
./move_fastas_n.sh $1 200000
./check_strand_n.sh $1 200000 $3 $4 &>simulated_reads/n_checks_$1_200000.txt
rm -f simulated_reads/$1_0.00_SS_sample_*_200000_*

Rscript polyester_sim.R -n 1000000 -r 3 -s 1 -l 100 $1 $4
./move_fastas_n.sh $1 1000000
./check_strand_n.sh $1 1000000 $3 $4 &>simulated_reads/n_checks_$1_1000000.txt
rm -f simulated_reads/$1_0.00_SS_sample_*_1000000_*

Rscript polyester_sim.R -n 2000000 -r 3 -s 1 -l 100 $1 $4
./move_fastas_n.sh $1 2000000
./check_strand_n.sh $1 2000000 $3 $4 &>simulated_reads/n_checks_$1_2000000.txt
rm -f simulated_reads/$1_0.00_SS_sample_*_2000000_*

mv stranded_test_$1* simulated_reads/strand_checks_n/
mv simulated_reads/n_checks simulated_reads/error_files_n/
