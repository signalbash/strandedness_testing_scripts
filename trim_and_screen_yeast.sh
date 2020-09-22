#trimgalore-0.6.0
#FastQC-0.11.5
#fastq_screen-0.14.0
#bowtie-2.3.2
#kallisto-0.46.1
#R-4.0.0

mkdir -p yeast_trimmed
mkdir -p yeast_filtered

cat sample_ids.txt | while read FILE 
do
	zcat $FILE_1.fastq.gz | head -n 800000 | gzip > trim_$FILE_1.fastq.gz
	zcat $FILE_2.fastq.gz | head -n 800000 | gzip > trim_$FILE_2.fastq.gz

	fastqc trim_$FILE_1.fastq.gz
	fastqc trim_$FILE_2.fastq.gz

	trim_galore --fastqc --paired trim_$FILE_1.fastq.gz trim_$FILE_2.fastq.gz
	check_strandedness -r1 trim_$FILE_1_val_1.fq.gz -r2 trim_$FILE_2_val_2.fq.gz -fa Saccharomyces_cerevisiae.R64-1-1.cdna.all.fa -g Saccharomyces_cerevisiae.R64-1-1.100.gtf  --bed Saccharomyces_cerevisiae.R64-1-1.100.bed -k ensembl_index
	mv stranded_test_trim_$FILE_1_val_1/strandedness_check.txt yeast_trimmed/$FILE.strandedness_check.txt
	rm -rf stranded_test_trim_$FILE_1_val_1

	rm -f trim_$FILE_*screen*
	rm -f trim_$FILE_*tagged*
	rm -f trim_$FILE_*temp*

	fastq_screen --tag trim_$FILE_1_val_1.fq.gz
	fastq_screen --tag trim_$FILE_2_val_2.fq.gz

	Rscript extract_paired_couples_yeast.R trim_$FILE_1_val_1.tagged.fastq.gz trim_$FILE_2_val_2.tagged.fastq.gz

	gzip trim_$FILE_1_val_1.filtered.fastq
	gzip trim_$FILE_2_val_2.filtered.fastq

	check_strandedness -r1 trim_$FILE_1_val_1.filtered.fastq.gz -r2 trim_$FILE_2_val_2.filtered.fastq.gz -fa Saccharomyces_cerevisiae.R64-1-1.cdna.all.fa -g Saccharomyces_cerevisiae.R64-1-1.100.gtf --bed Saccharomyces_cerevisiae.R64-1-1.100.bed -k ensembl_index
	mv stranded_test_trim_$FILE_1_val_1.filtered/strandedness_check.txt yeast_filtered/$FILE.strandedness_check.txt
	rm -rf stranded_test_trim_$FILE_1_val_1.filtered
done