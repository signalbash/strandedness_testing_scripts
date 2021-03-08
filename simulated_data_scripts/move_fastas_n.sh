mv simulated_reads/$1_0_NS/sample_01_1.fasta.gz simulated_reads/$1_0_SS_sample_01_$2_1.fasta.gz
mv simulated_reads/$1_0_NS/sample_01_2.fasta.gz simulated_reads/$1_0_SS_sample_01_$2_2.fasta.gz

mv simulated_reads/$1_0_NS/sample_02_1.fasta.gz simulated_reads/$1_0_SS_sample_02_$2_1.fasta.gz
mv simulated_reads/$1_0_NS/sample_02_2.fasta.gz simulated_reads/$1_0_SS_sample_02_$2_2.fasta.gz

mv simulated_reads/$1_0_NS/sample_03_1.fasta.gz simulated_reads/$1_0_SS_sample_03_$2_1.fasta.gz
mv simulated_reads/$1_0_NS/sample_03_2.fasta.gz simulated_reads/$1_0_SS_sample_03_$2_2.fasta.gz

mv simulated_reads/$1_1_SS/sample_01_1.fasta.gz simulated_reads/$1_1_SS_sample_01_$2_1.fasta.gz
mv simulated_reads/$1_1_SS/sample_01_2.fasta.gz simulated_reads/$1_1_SS_sample_01_$2_2.fasta.gz

mv simulated_reads/$1_1_SS/sample_02_1.fasta.gz simulated_reads/$1_1_SS_sample_02_$2_1.fasta.gz
mv simulated_reads/$1_1_SS/sample_02_2.fasta.gz simulated_reads/$1_1_SS_sample_02_$2_2.fasta.gz

mv simulated_reads/$1_1_SS/sample_03_1.fasta.gz simulated_reads/$1_1_SS_sample_03_$2_1.fasta.gz
mv simulated_reads/$1_1_SS/sample_03_2.fasta.gz simulated_reads/$1_1_SS_sample_03_$2_2.fasta.gz


./fasta2q.sh simulated_reads/$1_1_SS_sample_01_$2_1.fasta.gz
mv simulated_reads/$1_1_SS_sample_01_$2_1.fq.gz simulated_reads/$1_1.00_SS_sample_01_$2_1.fq.gz
./fasta2q.sh simulated_reads/$1_1_SS_sample_01_$2_2.fasta.gz
mv simulated_reads/$1_1_SS_sample_01_$2_2.fq.gz simulated_reads/$1_1.00_SS_sample_01_$2_2.fq.gz

./fasta2q.sh simulated_reads/$1_0_SS_sample_01_$2_1.fasta.gz
mv simulated_reads/$1_0_SS_sample_01_$2_1.fq.gz simulated_reads/$1_0.00_SS_sample_01_$2_1.fq.gz
./fasta2q.sh simulated_reads/$1_0_SS_sample_01_$2_2.fasta.gz
mv simulated_reads/$1_0_SS_sample_01_$2_2.fq.gz simulated_reads/$1_0.00_SS_sample_01_$2_2.fq.gz

./fasta2q.sh simulated_reads/$1_1_SS_sample_02_$2_1.fasta.gz
mv simulated_reads/$1_1_SS_sample_02_$2_1.fq.gz simulated_reads/$1_1.00_SS_sample_02_$2_1.fq.gz
./fasta2q.sh simulated_reads/$1_1_SS_sample_02_$2_2.fasta.gz
mv simulated_reads/$1_1_SS_sample_02_$2_2.fq.gz simulated_reads/$1_1.00_SS_sample_02_$2_2.fq.gz

./fasta2q.sh simulated_reads/$1_0_SS_sample_02_$2_1.fasta.gz
mv simulated_reads/$1_0_SS_sample_02_$2_1.fq.gz simulated_reads/$1_0.00_SS_sample_02_$2_1.fq.gz
./fasta2q.sh simulated_reads/$1_0_SS_sample_02_$2_2.fasta.gz
mv simulated_reads/$1_0_SS_sample_02_$2_2.fq.gz simulated_reads/$1_0.00_SS_sample_02_$2_2.fq.gz

./fasta2q.sh simulated_reads/$1_1_SS_sample_03_$2_1.fasta.gz
mv simulated_reads/$1_1_SS_sample_03_$2_1.fq.gz simulated_reads/$1_1.00_SS_sample_03_$2_1.fq.gz
./fasta2q.sh simulated_reads/$1_1_SS_sample_03_$2_2.fasta.gz
mv simulated_reads/$1_1_SS_sample_03_$2_2.fq.gz simulated_reads/$1_1.00_SS_sample_03_$2_2.fq.gz

./fasta2q.sh simulated_reads/$1_0_SS_sample_03_$2_1.fasta.gz
mv simulated_reads/$1_0_SS_sample_03_$2_1.fq.gz simulated_reads/$1_0.00_SS_sample_03_$2_1.fq.gz
./fasta2q.sh simulated_reads/$1_0_SS_sample_03_$2_2.fasta.gz
mv simulated_reads/$1_0_SS_sample_03_$2_2.fq.gz simulated_reads/$1_0.00_SS_sample_03_$2_2.fq.gz
