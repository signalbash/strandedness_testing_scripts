check_strandedness -n $2 -k ensembl_index --gtf $3 --transcripts $4 -r1 simulated_reads/$1_0.00_SS_sample_01_$2_1.fq.gz -r2 simulated_reads/$1_0.00_SS_sample_01_$2_2.fq.gz
rm -rf stranded_test_$1_0.00_SS_sample_01_$2_1/kallisto_strand_test
rm -rf stranded_test_$1_0.00_SS_sample_01_$2_1/*.bed
rm -rf stranded_test_$1_0.00_SS_sample_01_$2_1/*.fq

check_strandedness -n $2 -k ensembl_index --gtf $3 --transcripts $4 -r1 simulated_reads/$1_1.00_SS_sample_01_$2_1.fq.gz -r2 simulated_reads/$1_1.00_SS_sample_01_$2_2.fq.gz
rm -rf stranded_test_$1_1.00_SS_sample_01_$2_1/kallisto_strand_test
rm -rf stranded_test_$1_1.00_SS_sample_01_$2_1/*.bed
rm -rf stranded_test_$1_1.00_SS_sample_01_$2_1/*.fq

check_strandedness -n $2 -k ensembl_index --gtf $3 --transcripts $4 -r1 simulated_reads/$1_0.00_SS_sample_02_$2_1.fq.gz -r2 simulated_reads/$1_0.00_SS_sample_02_$2_2.fq.gz
rm -rf stranded_test_$1_0.00_SS_sample_02_$2_1/kallisto_strand_test
rm -rf stranded_test_$1_0.00_SS_sample_02_$2_1/*.bed
rm -rf stranded_test_$1_0.00_SS_sample_02_$2_1/*.fq

check_strandedness -n $2 -k ensembl_index --gtf $3 --transcripts $4 -r1 simulated_reads/$1_1.00_SS_sample_02_$2_1.fq.gz -r2 simulated_reads/$1_1.00_SS_sample_02_$2_2.fq.gz
rm -rf stranded_test_$1_1.00_SS_sample_02_$2_1/kallisto_strand_test
rm -rf stranded_test_$1_1.00_SS_sample_02_$2_1/*.bed
rm -rf stranded_test_$1_1.00_SS_sample_02_$2_1/*.fq

check_strandedness -n $2 -k ensembl_index --gtf $3 --transcripts $4 -r1 simulated_reads/$1_0.00_SS_sample_03_$2_1.fq.gz -r2 simulated_reads/$1_0.00_SS_sample_03_$2_2.fq.gz
rm -rf stranded_test_$1_0.00_SS_sample_03_$2_1/kallisto_strand_test
rm -rf stranded_test_$1_0.00_SS_sample_03_$2_1/*.bed
rm -rf stranded_test_$1_0.00_SS_sample_03_$2_1/*.fq

check_strandedness -n $2 -k ensembl_index --gtf $3 --transcripts $4 -r1 simulated_reads/$1_1.00_SS_sample_03_$2_1.fq.gz -r2 simulated_reads/$1_1.00_SS_sample_03_$2_2.fq.gz
rm -rf stranded_test_$1_1.00_SS_sample_03_$2_1/kallisto_strand_test
rm -rf stranded_test_$1_1.00_SS_sample_03_$2_1/*.bed
rm -rf stranded_test_$1_1.00_SS_sample_0$2_$2_1/*.fq
