seqtk sample -s1 simulated_reads/$1_1_SS_sample_0$2_1.fasta.gz 190000 >> simulated_reads/$1_0.95_SS_sample_0$2_1.fa
seqtk sample -s10 simulated_reads/$1_0_SS_sample_0$2_1.fasta.gz 10000 >> simulated_reads/$1_0.95_SS_sample_0$2_1.fa

seqtk sample -s1 simulated_reads/$1_1_SS_sample_0$2_2.fasta.gz 190000 >> simulated_reads/$1_0.95_SS_sample_0$2_2.fa
seqtk sample -s10 simulated_reads/$1_0_SS_sample_0$2_2.fasta.gz 10000 >> simulated_reads/$1_0.95_SS_sample_0$2_2.fa

seqtk rename simulated_reads/$1_0.95_SS_sample_0$2_1.fa > simulated_reads/$1_0.95_SS_sample_0$2rn_1.fa
mv simulated_reads/$1_0.95_SS_sample_0$2rn_1.fa simulated_reads/$1_0.95_SS_sample_0$2_1.fa
gzip simulated_reads/$1_0.95_SS_sample_0$2_1.fa

fasta2q.sh simulated_reads/$1_0.95_SS_sample_0$2_1.fa
mv simulated_reads/$1_0.95_SS_sample_0$2_1.fa.fq.gz simulated_reads/$1_0.95_SS_sample_0$2_1.fq.gz
rm -f simulated_reads/$1_0.95_SS_sample_0$2_1.fa.gz

seqtk rename simulated_reads/$1_0.95_SS_sample_0$2_2.fa > simulated_reads/$1_0.95_SS_sample_0$2rn_2.fa
mv simulated_reads/$1_0.95_SS_sample_0$2rn_2.fa simulated_reads/$1_0.95_SS_sample_0$2_2.fa
gzip simulated_reads/$1_0.95_SS_sample_0$2_2.fa

fasta2q.sh simulated_reads/$1_0.95_SS_sample_0$2_2.fa
mv simulated_reads/$1_0.95_SS_sample_0$2_2.fa.fq.gz simulated_reads/$1_0.95_SS_sample_0$2_2.fq.gz
rm -f simulated_reads/$1_0.95_SS_sample_0$2_2.fa.gz
seqtk sample -s2 simulated_reads/$1_1_SS_sample_0$2_1.fasta.gz 180000 >> simulated_reads/$1_0.90_SS_sample_0$2_1.fa
seqtk sample -s20 simulated_reads/$1_0_SS_sample_0$2_1.fasta.gz 20000 >> simulated_reads/$1_0.90_SS_sample_0$2_1.fa

seqtk sample -s2 simulated_reads/$1_1_SS_sample_0$2_2.fasta.gz 180000 >> simulated_reads/$1_0.90_SS_sample_0$2_2.fa
seqtk sample -s20 simulated_reads/$1_0_SS_sample_0$2_2.fasta.gz 20000 >> simulated_reads/$1_0.90_SS_sample_0$2_2.fa

seqtk rename simulated_reads/$1_0.90_SS_sample_0$2_1.fa > simulated_reads/$1_0.90_SS_sample_0$2rn_1.fa
mv simulated_reads/$1_0.90_SS_sample_0$2rn_1.fa simulated_reads/$1_0.90_SS_sample_0$2_1.fa
gzip simulated_reads/$1_0.90_SS_sample_0$2_1.fa

fasta2q.sh simulated_reads/$1_0.90_SS_sample_0$2_1.fa
mv simulated_reads/$1_0.90_SS_sample_0$2_1.fa.fq.gz simulated_reads/$1_0.90_SS_sample_0$2_1.fq.gz
rm -f simulated_reads/$1_0.90_SS_sample_0$2_1.fa.gz

seqtk rename simulated_reads/$1_0.90_SS_sample_0$2_2.fa > simulated_reads/$1_0.90_SS_sample_0$2rn_2.fa
mv simulated_reads/$1_0.90_SS_sample_0$2rn_2.fa simulated_reads/$1_0.90_SS_sample_0$2_2.fa
gzip simulated_reads/$1_0.90_SS_sample_0$2_2.fa

fasta2q.sh simulated_reads/$1_0.90_SS_sample_0$2_2.fa
mv simulated_reads/$1_0.90_SS_sample_0$2_2.fa.fq.gz simulated_reads/$1_0.90_SS_sample_0$2_2.fq.gz
rm -f simulated_reads/$1_0.90_SS_sample_0$2_2.fa.gz
seqtk sample -s3 simulated_reads/$1_1_SS_sample_0$2_1.fasta.gz 160000 >> simulated_reads/$1_0.80_SS_sample_0$2_1.fa
seqtk sample -s30 simulated_reads/$1_0_SS_sample_0$2_1.fasta.gz 40000 >> simulated_reads/$1_0.80_SS_sample_0$2_1.fa

seqtk sample -s3 simulated_reads/$1_1_SS_sample_0$2_2.fasta.gz 160000 >> simulated_reads/$1_0.80_SS_sample_0$2_2.fa
seqtk sample -s30 simulated_reads/$1_0_SS_sample_0$2_2.fasta.gz 40000 >> simulated_reads/$1_0.80_SS_sample_0$2_2.fa

seqtk rename simulated_reads/$1_0.80_SS_sample_0$2_1.fa > simulated_reads/$1_0.80_SS_sample_0$2rn_1.fa
mv simulated_reads/$1_0.80_SS_sample_0$2rn_1.fa simulated_reads/$1_0.80_SS_sample_0$2_1.fa
gzip simulated_reads/$1_0.80_SS_sample_0$2_1.fa

fasta2q.sh simulated_reads/$1_0.80_SS_sample_0$2_1.fa
mv simulated_reads/$1_0.80_SS_sample_0$2_1.fa.fq.gz simulated_reads/$1_0.80_SS_sample_0$2_1.fq.gz
rm -f simulated_reads/$1_0.80_SS_sample_0$2_1.fa.gz

seqtk rename simulated_reads/$1_0.80_SS_sample_0$2_2.fa > simulated_reads/$1_0.80_SS_sample_0$2rn_2.fa
mv simulated_reads/$1_0.80_SS_sample_0$2rn_2.fa simulated_reads/$1_0.80_SS_sample_0$2_2.fa
gzip simulated_reads/$1_0.80_SS_sample_0$2_2.fa

fasta2q.sh simulated_reads/$1_0.80_SS_sample_0$2_2.fa
mv simulated_reads/$1_0.80_SS_sample_0$2_2.fa.fq.gz simulated_reads/$1_0.80_SS_sample_0$2_2.fq.gz
rm -f simulated_reads/$1_0.80_SS_sample_0$2_2.fa.gz
seqtk sample -s4 simulated_reads/$1_1_SS_sample_0$2_1.fasta.gz 140000 >> simulated_reads/$1_0.70_SS_sample_0$2_1.fa
seqtk sample -s40 simulated_reads/$1_0_SS_sample_0$2_1.fasta.gz 60000 >> simulated_reads/$1_0.70_SS_sample_0$2_1.fa

seqtk sample -s4 simulated_reads/$1_1_SS_sample_0$2_2.fasta.gz 140000 >> simulated_reads/$1_0.70_SS_sample_0$2_2.fa
seqtk sample -s40 simulated_reads/$1_0_SS_sample_0$2_2.fasta.gz 60000 >> simulated_reads/$1_0.70_SS_sample_0$2_2.fa

seqtk rename simulated_reads/$1_0.70_SS_sample_0$2_1.fa > simulated_reads/$1_0.70_SS_sample_0$2rn_1.fa
mv simulated_reads/$1_0.70_SS_sample_0$2rn_1.fa simulated_reads/$1_0.70_SS_sample_0$2_1.fa
gzip simulated_reads/$1_0.70_SS_sample_0$2_1.fa

fasta2q.sh simulated_reads/$1_0.70_SS_sample_0$2_1.fa
mv simulated_reads/$1_0.70_SS_sample_0$2_1.fa.fq.gz simulated_reads/$1_0.70_SS_sample_0$2_1.fq.gz
rm -f simulated_reads/$1_0.70_SS_sample_0$2_1.fa.gz

seqtk rename simulated_reads/$1_0.70_SS_sample_0$2_2.fa > simulated_reads/$1_0.70_SS_sample_0$2rn_2.fa
mv simulated_reads/$1_0.70_SS_sample_0$2rn_2.fa simulated_reads/$1_0.70_SS_sample_0$2_2.fa
gzip simulated_reads/$1_0.70_SS_sample_0$2_2.fa

fasta2q.sh simulated_reads/$1_0.70_SS_sample_0$2_2.fa
mv simulated_reads/$1_0.70_SS_sample_0$2_2.fa.fq.gz simulated_reads/$1_0.70_SS_sample_0$2_2.fq.gz
rm -f simulated_reads/$1_0.70_SS_sample_0$2_2.fa.gz
seqtk sample -s5 simulated_reads/$1_1_SS_sample_0$2_1.fasta.gz 120000 >> simulated_reads/$1_0.60_SS_sample_0$2_1.fa
seqtk sample -s50 simulated_reads/$1_0_SS_sample_0$2_1.fasta.gz 80000 >> simulated_reads/$1_0.60_SS_sample_0$2_1.fa

seqtk sample -s5 simulated_reads/$1_1_SS_sample_0$2_2.fasta.gz 120000 >> simulated_reads/$1_0.60_SS_sample_0$2_2.fa
seqtk sample -s50 simulated_reads/$1_0_SS_sample_0$2_2.fasta.gz 80000 >> simulated_reads/$1_0.60_SS_sample_0$2_2.fa

seqtk rename simulated_reads/$1_0.60_SS_sample_0$2_1.fa > simulated_reads/$1_0.60_SS_sample_0$2rn_1.fa
mv simulated_reads/$1_0.60_SS_sample_0$2rn_1.fa simulated_reads/$1_0.60_SS_sample_0$2_1.fa
gzip simulated_reads/$1_0.60_SS_sample_0$2_1.fa

fasta2q.sh simulated_reads/$1_0.60_SS_sample_0$2_1.fa
mv simulated_reads/$1_0.60_SS_sample_0$2_1.fa.fq.gz simulated_reads/$1_0.60_SS_sample_0$2_1.fq.gz
rm -f simulated_reads/$1_0.60_SS_sample_0$2_1.fa.gz

seqtk rename simulated_reads/$1_0.60_SS_sample_0$2_2.fa > simulated_reads/$1_0.60_SS_sample_0$2rn_2.fa
mv simulated_reads/$1_0.60_SS_sample_0$2rn_2.fa simulated_reads/$1_0.60_SS_sample_0$2_2.fa
gzip simulated_reads/$1_0.60_SS_sample_0$2_2.fa

fasta2q.sh simulated_reads/$1_0.60_SS_sample_0$2_2.fa
mv simulated_reads/$1_0.60_SS_sample_0$2_2.fa.fq.gz simulated_reads/$1_0.60_SS_sample_0$2_2.fq.gz
rm -f simulated_reads/$1_0.60_SS_sample_0$2_2.fa.gz
seqtk sample -s6 simulated_reads/$1_1_SS_sample_0$2_1.fasta.gz 100000 >> simulated_reads/$1_0.50_SS_sample_0$2_1.fa
seqtk sample -s60 simulated_reads/$1_0_SS_sample_0$2_1.fasta.gz 100000 >> simulated_reads/$1_0.50_SS_sample_0$2_1.fa

seqtk sample -s6 simulated_reads/$1_1_SS_sample_0$2_2.fasta.gz 100000 >> simulated_reads/$1_0.50_SS_sample_0$2_2.fa
seqtk sample -s60 simulated_reads/$1_0_SS_sample_0$2_2.fasta.gz 100000 >> simulated_reads/$1_0.50_SS_sample_0$2_2.fa

seqtk rename simulated_reads/$1_0.50_SS_sample_0$2_1.fa > simulated_reads/$1_0.50_SS_sample_0$2rn_1.fa
mv simulated_reads/$1_0.50_SS_sample_0$2rn_1.fa simulated_reads/$1_0.50_SS_sample_0$2_1.fa
gzip simulated_reads/$1_0.50_SS_sample_0$2_1.fa

fasta2q.sh simulated_reads/$1_0.50_SS_sample_0$2_1.fa
mv simulated_reads/$1_0.50_SS_sample_0$2_1.fa.fq.gz simulated_reads/$1_0.50_SS_sample_0$2_1.fq.gz
rm -f simulated_reads/$1_0.50_SS_sample_0$2_1.fa.gz

seqtk rename simulated_reads/$1_0.50_SS_sample_0$2_2.fa > simulated_reads/$1_0.50_SS_sample_0$2rn_2.fa
mv simulated_reads/$1_0.50_SS_sample_0$2rn_2.fa simulated_reads/$1_0.50_SS_sample_0$2_2.fa
gzip simulated_reads/$1_0.50_SS_sample_0$2_2.fa

fasta2q.sh simulated_reads/$1_0.50_SS_sample_0$2_2.fa
mv simulated_reads/$1_0.50_SS_sample_0$2_2.fa.fq.gz simulated_reads/$1_0.50_SS_sample_0$2_2.fq.gz
rm -f simulated_reads/$1_0.50_SS_sample_0$2_2.fa.gz
seqtk sample -s7 simulated_reads/$1_1_SS_sample_0$2_1.fasta.gz 80000 >> simulated_reads/$1_0.40_SS_sample_0$2_1.fa
seqtk sample -s70 simulated_reads/$1_0_SS_sample_0$2_1.fasta.gz 120000 >> simulated_reads/$1_0.40_SS_sample_0$2_1.fa

seqtk sample -s7 simulated_reads/$1_1_SS_sample_0$2_2.fasta.gz 80000 >> simulated_reads/$1_0.40_SS_sample_0$2_2.fa
seqtk sample -s70 simulated_reads/$1_0_SS_sample_0$2_2.fasta.gz 120000 >> simulated_reads/$1_0.40_SS_sample_0$2_2.fa

seqtk rename simulated_reads/$1_0.40_SS_sample_0$2_1.fa > simulated_reads/$1_0.40_SS_sample_0$2rn_1.fa
mv simulated_reads/$1_0.40_SS_sample_0$2rn_1.fa simulated_reads/$1_0.40_SS_sample_0$2_1.fa
gzip simulated_reads/$1_0.40_SS_sample_0$2_1.fa

fasta2q.sh simulated_reads/$1_0.40_SS_sample_0$2_1.fa
mv simulated_reads/$1_0.40_SS_sample_0$2_1.fa.fq.gz simulated_reads/$1_0.40_SS_sample_0$2_1.fq.gz
rm -f simulated_reads/$1_0.40_SS_sample_0$2_1.fa.gz

seqtk rename simulated_reads/$1_0.40_SS_sample_0$2_2.fa > simulated_reads/$1_0.40_SS_sample_0$2rn_2.fa
mv simulated_reads/$1_0.40_SS_sample_0$2rn_2.fa simulated_reads/$1_0.40_SS_sample_0$2_2.fa
gzip simulated_reads/$1_0.40_SS_sample_0$2_2.fa

fasta2q.sh simulated_reads/$1_0.40_SS_sample_0$2_2.fa
mv simulated_reads/$1_0.40_SS_sample_0$2_2.fa.fq.gz simulated_reads/$1_0.40_SS_sample_0$2_2.fq.gz
rm -f simulated_reads/$1_0.40_SS_sample_0$2_2.fa.gz
seqtk sample -s8 simulated_reads/$1_1_SS_sample_0$2_1.fasta.gz 60000 >> simulated_reads/$1_0.30_SS_sample_0$2_1.fa
seqtk sample -s80 simulated_reads/$1_0_SS_sample_0$2_1.fasta.gz 140000 >> simulated_reads/$1_0.30_SS_sample_0$2_1.fa

seqtk sample -s8 simulated_reads/$1_1_SS_sample_0$2_2.fasta.gz 60000 >> simulated_reads/$1_0.30_SS_sample_0$2_2.fa
seqtk sample -s80 simulated_reads/$1_0_SS_sample_0$2_2.fasta.gz 140000 >> simulated_reads/$1_0.30_SS_sample_0$2_2.fa

seqtk rename simulated_reads/$1_0.30_SS_sample_0$2_1.fa > simulated_reads/$1_0.30_SS_sample_0$2rn_1.fa
mv simulated_reads/$1_0.30_SS_sample_0$2rn_1.fa simulated_reads/$1_0.30_SS_sample_0$2_1.fa
gzip simulated_reads/$1_0.30_SS_sample_0$2_1.fa

fasta2q.sh simulated_reads/$1_0.30_SS_sample_0$2_1.fa
mv simulated_reads/$1_0.30_SS_sample_0$2_1.fa.fq.gz simulated_reads/$1_0.30_SS_sample_0$2_1.fq.gz
rm -f simulated_reads/$1_0.30_SS_sample_0$2_1.fa.gz

seqtk rename simulated_reads/$1_0.30_SS_sample_0$2_2.fa > simulated_reads/$1_0.30_SS_sample_0$2rn_2.fa
mv simulated_reads/$1_0.30_SS_sample_0$2rn_2.fa simulated_reads/$1_0.30_SS_sample_0$2_2.fa
gzip simulated_reads/$1_0.30_SS_sample_0$2_2.fa

fasta2q.sh simulated_reads/$1_0.30_SS_sample_0$2_2.fa
mv simulated_reads/$1_0.30_SS_sample_0$2_2.fa.fq.gz simulated_reads/$1_0.30_SS_sample_0$2_2.fq.gz
rm -f simulated_reads/$1_0.30_SS_sample_0$2_2.fa.gz
seqtk sample -s9 simulated_reads/$1_1_SS_sample_0$2_1.fasta.gz 40000 >> simulated_reads/$1_0.20_SS_sample_0$2_1.fa
seqtk sample -s90 simulated_reads/$1_0_SS_sample_0$2_1.fasta.gz 160000 >> simulated_reads/$1_0.20_SS_sample_0$2_1.fa

seqtk sample -s9 simulated_reads/$1_1_SS_sample_0$2_2.fasta.gz 40000 >> simulated_reads/$1_0.20_SS_sample_0$2_2.fa
seqtk sample -s90 simulated_reads/$1_0_SS_sample_0$2_2.fasta.gz 160000 >> simulated_reads/$1_0.20_SS_sample_0$2_2.fa

seqtk rename simulated_reads/$1_0.20_SS_sample_0$2_1.fa > simulated_reads/$1_0.20_SS_sample_0$2rn_1.fa
mv simulated_reads/$1_0.20_SS_sample_0$2rn_1.fa simulated_reads/$1_0.20_SS_sample_0$2_1.fa
gzip simulated_reads/$1_0.20_SS_sample_0$2_1.fa

fasta2q.sh simulated_reads/$1_0.20_SS_sample_0$2_1.fa
mv simulated_reads/$1_0.20_SS_sample_0$2_1.fa.fq.gz simulated_reads/$1_0.20_SS_sample_0$2_1.fq.gz
rm -f simulated_reads/$1_0.20_SS_sample_0$2_1.fa.gz

seqtk rename simulated_reads/$1_0.20_SS_sample_0$2_2.fa > simulated_reads/$1_0.20_SS_sample_0$2rn_2.fa
mv simulated_reads/$1_0.20_SS_sample_0$2rn_2.fa simulated_reads/$1_0.20_SS_sample_0$2_2.fa
gzip simulated_reads/$1_0.20_SS_sample_0$2_2.fa

fasta2q.sh simulated_reads/$1_0.20_SS_sample_0$2_2.fa
mv simulated_reads/$1_0.20_SS_sample_0$2_2.fa.fq.gz simulated_reads/$1_0.20_SS_sample_0$2_2.fq.gz
rm -f simulated_reads/$1_0.20_SS_sample_0$2_2.fa.gz
seqtk sample -s10 simulated_reads/$1_1_SS_sample_0$2_1.fasta.gz 20000 >> simulated_reads/$1_0.10_SS_sample_0$2_1.fa
seqtk sample -s100 simulated_reads/$1_0_SS_sample_0$2_1.fasta.gz 180000 >> simulated_reads/$1_0.10_SS_sample_0$2_1.fa

seqtk sample -s10 simulated_reads/$1_1_SS_sample_0$2_2.fasta.gz 20000 >> simulated_reads/$1_0.10_SS_sample_0$2_2.fa
seqtk sample -s100 simulated_reads/$1_0_SS_sample_0$2_2.fasta.gz 180000 >> simulated_reads/$1_0.10_SS_sample_0$2_2.fa

seqtk rename simulated_reads/$1_0.10_SS_sample_0$2_1.fa > simulated_reads/$1_0.10_SS_sample_0$2rn_1.fa
mv simulated_reads/$1_0.10_SS_sample_0$2rn_1.fa simulated_reads/$1_0.10_SS_sample_0$2_1.fa
gzip simulated_reads/$1_0.10_SS_sample_0$2_1.fa

fasta2q.sh simulated_reads/$1_0.10_SS_sample_0$2_1.fa
mv simulated_reads/$1_0.10_SS_sample_0$2_1.fa.fq.gz simulated_reads/$1_0.10_SS_sample_0$2_1.fq.gz
rm -f simulated_reads/$1_0.10_SS_sample_0$2_1.fa.gz

seqtk rename simulated_reads/$1_0.10_SS_sample_0$2_2.fa > simulated_reads/$1_0.10_SS_sample_0$2rn_2.fa
mv simulated_reads/$1_0.10_SS_sample_0$2rn_2.fa simulated_reads/$1_0.10_SS_sample_0$2_2.fa
gzip simulated_reads/$1_0.10_SS_sample_0$2_2.fa

fasta2q.sh simulated_reads/$1_0.10_SS_sample_0$2_2.fa
mv simulated_reads/$1_0.10_SS_sample_0$2_2.fa.fq.gz simulated_reads/$1_0.10_SS_sample_0$2_2.fq.gz
rm -f simulated_reads/$1_0.10_SS_sample_0$2_2.fa.gz
seqtk sample -s11 simulated_reads/$1_1_SS_sample_0$2_1.fasta.gz 10000 >> simulated_reads/$1_0.05_SS_sample_0$2_1.fa
seqtk sample -s110 simulated_reads/$1_0_SS_sample_0$2_1.fasta.gz 190000 >> simulated_reads/$1_0.05_SS_sample_0$2_1.fa

seqtk sample -s11 simulated_reads/$1_1_SS_sample_0$2_2.fasta.gz 10000 >> simulated_reads/$1_0.05_SS_sample_0$2_2.fa
seqtk sample -s110 simulated_reads/$1_0_SS_sample_0$2_2.fasta.gz 190000 >> simulated_reads/$1_0.05_SS_sample_0$2_2.fa

seqtk rename simulated_reads/$1_0.05_SS_sample_0$2_1.fa > simulated_reads/$1_0.05_SS_sample_0$2rn_1.fa
mv simulated_reads/$1_0.05_SS_sample_0$2rn_1.fa simulated_reads/$1_0.05_SS_sample_0$2_1.fa
gzip simulated_reads/$1_0.05_SS_sample_0$2_1.fa

fasta2q.sh simulated_reads/$1_0.05_SS_sample_0$2_1.fa
mv simulated_reads/$1_0.05_SS_sample_0$2_1.fa.fq.gz simulated_reads/$1_0.05_SS_sample_0$2_1.fq.gz
rm -f simulated_reads/$1_0.05_SS_sample_0$2_1.fa.gz

seqtk rename simulated_reads/$1_0.05_SS_sample_0$2_2.fa > simulated_reads/$1_0.05_SS_sample_0$2rn_2.fa
mv simulated_reads/$1_0.05_SS_sample_0$2rn_2.fa simulated_reads/$1_0.05_SS_sample_0$2_2.fa
gzip simulated_reads/$1_0.05_SS_sample_0$2_2.fa

fasta2q.sh simulated_reads/$1_0.05_SS_sample_0$2_2.fa
mv simulated_reads/$1_0.05_SS_sample_0$2_2.fa.fq.gz simulated_reads/$1_0.05_SS_sample_0$2_2.fq.gz
rm -f simulated_reads/$1_0.05_SS_sample_0$2_2.fa.gz

### rename & convert original files

fasta2q.sh simulated_reads/$1_1_SS_sample_0$2_1.fasta.gz
mv simulated_reads/$1_1_SS_sample_0$2_1.fq.gz simulated_reads/$1_1.00_SS_sample_0$2_1.fq.gz
fasta2q.sh simulated_reads/$1_1_SS_sample_0$2_2.fasta.gz
mv simulated_reads/$1_1_SS_sample_0$2_2.fq.gz simulated_reads/$1_1.00_SS_sample_0$2_2.fq.gz

fasta2q.sh simulated_reads/$1_0_SS_sample_0$2_1.fasta.gz
mv simulated_reads/$1_0_SS_sample_0$2_1.fq.gz simulated_reads/$1_0.00_SS_sample_0$2_1.fq.gz
fasta2q.sh simulated_reads/$1_0_SS_sample_0$2_2.fasta.gz
mv simulated_reads/$1_0_SS_sample_0$2_2.fq.gz simulated_reads/$1_0.00_SS_sample_0$2_2.fq.gz
