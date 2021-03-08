check_strandedness -k ensembl_index --gtf $3 --transcripts $4 -r1 simulated_reads/$1_0.00_SS_sample_0$2_1.fq.gz -r2 simulated_reads/$1_0.00_SS_sample_0$2_2.fq.gz
rm -rf stranded_test_$1_0.00_SS_sample_0$2_1/kallisto_strand_test
rm -rf stranded_test_$1_0.00_SS_sample_0$2_1/*.bed
rm -rf stranded_test_$1_0.00_SS_sample_0$2_1/*.fq

check_strandedness -k ensembl_index --gtf $3 --transcripts $4 -r1 simulated_reads/$1_0.05_SS_sample_0$2_1.fq.gz -r2 simulated_reads/$1_0.05_SS_sample_0$2_2.fq.gz
rm -rf stranded_test_$1_0.05_SS_sample_0$2_1/kallisto_strand_test
rm -rf stranded_test_$1_0.05_SS_sample_0$2_1/*.bed
rm -rf stranded_test_$1_0.05_SS_sample_0$2_1/*.fq

check_strandedness -k ensembl_index --gtf $3 --transcripts $4 -r1 simulated_reads/$1_0.10_SS_sample_0$2_1.fq.gz -r2 simulated_reads/$1_0.10_SS_sample_0$2_2.fq.gz
rm -rf stranded_test_$1_0.10_SS_sample_0$2_1/kallisto_strand_test
rm -rf stranded_test_$1_0.10_SS_sample_0$2_1/*.bed
rm -rf stranded_test_$1_0.10_SS_sample_0$2_1/*.fq

check_strandedness -k ensembl_index --gtf $3 --transcripts $4 -r1 simulated_reads/$1_0.20_SS_sample_0$2_1.fq.gz -r2 simulated_reads/$1_0.20_SS_sample_0$2_2.fq.gz
rm -rf stranded_test_$1_0.20_SS_sample_0$2_1/kallisto_strand_test
rm -rf stranded_test_$1_0.20_SS_sample_0$2_1/*.bed
rm -rf stranded_test_$1_0.20_SS_sample_0$2_1/*.fq

check_strandedness -k ensembl_index --gtf $3 --transcripts $4 -r1 simulated_reads/$1_0.30_SS_sample_0$2_1.fq.gz -r2 simulated_reads/$1_0.30_SS_sample_0$2_2.fq.gz
rm -rf stranded_test_$1_0.30_SS_sample_0$2_1/kallisto_strand_test
rm -rf stranded_test_$1_0.30_SS_sample_0$2_1/*.bed
rm -rf stranded_test_$1_0.30_SS_sample_0$2_1/*.fq

check_strandedness -k ensembl_index --gtf $3 --transcripts $4 -r1 simulated_reads/$1_0.40_SS_sample_0$2_1.fq.gz -r2 simulated_reads/$1_0.40_SS_sample_0$2_2.fq.gz
rm -rf stranded_test_$1_0.40_SS_sample_0$2_1/kallisto_strand_test
rm -rf stranded_test_$1_0.40_SS_sample_0$2_1/*.bed
rm -rf stranded_test_$1_0.40_SS_sample_0$2_1/*.fq

check_strandedness -k ensembl_index --gtf $3 --transcripts $4 -r1 simulated_reads/$1_0.50_SS_sample_0$2_1.fq.gz -r2 simulated_reads/$1_0.50_SS_sample_0$2_2.fq.gz
rm -rf stranded_test_$1_0.50_SS_sample_0$2_1/kallisto_strand_test
rm -rf stranded_test_$1_0.50_SS_sample_0$2_1/*.bed
rm -rf stranded_test_$1_0.50_SS_sample_0$2_1/*.fq

check_strandedness -k ensembl_index --gtf $3 --transcripts $4 -r1 simulated_reads/$1_0.60_SS_sample_0$2_1.fq.gz -r2 simulated_reads/$1_0.60_SS_sample_0$2_2.fq.gz
rm -rf stranded_test_$1_0.60_SS_sample_0$2_1/kallisto_strand_test
rm -rf stranded_test_$1_0.60_SS_sample_0$2_1/*.bed
rm -rf stranded_test_$1_0.60_SS_sample_0$2_1/*.fq

check_strandedness -k ensembl_index --gtf $3 --transcripts $4 -r1 simulated_reads/$1_0.70_SS_sample_0$2_1.fq.gz -r2 simulated_reads/$1_0.70_SS_sample_0$2_2.fq.gz
rm -rf stranded_test_$1_0.70_SS_sample_0$2_1/kallisto_strand_test
rm -rf stranded_test_$1_0.70_SS_sample_0$2_1/*.bed
rm -rf stranded_test_$1_0.70_SS_sample_0$2_1/*.fq

check_strandedness -k ensembl_index --gtf $3 --transcripts $4 -r1 simulated_reads/$1_0.80_SS_sample_0$2_1.fq.gz -r2 simulated_reads/$1_0.80_SS_sample_0$2_2.fq.gz
rm -rf stranded_test_$1_0.80_SS_sample_0$2_1/kallisto_strand_test
rm -rf stranded_test_$1_0.80_SS_sample_0$2_1/*.bed
rm -rf stranded_test_$1_0.80_SS_sample_0$2_1/*.fq

check_strandedness -k ensembl_index --gtf $3 --transcripts $4 -r1 simulated_reads/$1_0.90_SS_sample_0$2_1.fq.gz -r2 simulated_reads/$1_0.90_SS_sample_0$2_2.fq.gz
rm -rf stranded_test_$1_0.90_SS_sample_0$2_1/kallisto_strand_test
rm -rf stranded_test_$1_0.90_SS_sample_0$2_1/*.bed
rm -rf stranded_test_$1_0.90_SS_sample_0$2_1/*.fq

check_strandedness -k ensembl_index --gtf $3 --transcripts $4 -r1 simulated_reads/$1_0.95_SS_sample_0$2_1.fq.gz -r2 simulated_reads/$1_0.95_SS_sample_0$2_2.fq.gz
rm -rf stranded_test_$1_0.95_SS_sample_0$2_1/kallisto_strand_test
rm -rf stranded_test_$1_0.95_SS_sample_0$2_1/*.bed
rm -rf stranded_test_$1_0.95_SS_sample_0$2_1/*.fq

check_strandedness -k ensembl_index --gtf $3 --transcripts $4 -r1 simulated_reads/$1_1.00_SS_sample_0$2_1.fq.gz -r2 simulated_reads/$1_1.00_SS_sample_0$2_2.fq.gz
rm -rf stranded_test_$1_1.00_SS_sample_0$2_1/kallisto_strand_test
rm -rf stranded_test_$1_1.00_SS_sample_0$2_1/*.bed
rm -rf stranded_test_$1_1.00_SS_sample_0$2_1/*.fq
