# download files

# run kallisto to get read counts for simulating new reads
mkdir -p kallisto_abundance
kallisto quant -i ensembl_index --gtf $2 fastq/$1_1.fastq.gz fastq/$1_2.fastq.gz -o kallisto_abundance/$1

# remove original fastqs
rm fastq/$1_1.fastq.gz
rm fastq/$1_2.fastq.gz

#####

# generate 100% stranded SS_1 and 0% stranded NS_0
Rscript polyester_sim.R -n 200000 -r 3 -s 1 -l 100 $1 $3
./move_fastas.sh $1

mkdir -p simulated_reads/strand_checks/
mkdir -p simulated_reads/error_files/

# shuffle and join (for sample 1-3)
./generate_mixed_files.sh $1 1
./generate_mixed_files.sh $1 2
./generate_mixed_files.sh $1 3

./check_strand_partial.sh $1 1 $2 $3 &>partial_checks_$1_1.txt
./check_strand_partial.sh $1 2 $2 $3 &>partial_checks_$1_2.txt
./check_strand_partial.sh $1 3 $2 $3 &>partial_checks_$1_3.txt

mv stranded_test* simulated_reads/strand_checks/
mv partial_checks_* simulated_reads/error_files/


mkdir -p simulated_reads/strand_checks_n/
mkdir -p simulated_reads/error_files_n/

### run strand checks for 0% and 100% stranded for n1000 - n2000000
./run_simul_n.sh $1 $2 $3
