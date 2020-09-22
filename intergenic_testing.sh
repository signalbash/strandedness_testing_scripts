#STAR 2.7.0e
#HTSeq 0.12.4
#bedtools 2.92.1

mkdir -p STAR_alignments
mkdir -p yeast_intergenic

# make the intergenic GTF

Rscript make_intergenic_annotations.R

bedtools getfasta -fi Saccharomyces_cerevisiae.R64-1-1.dna.toplevel.fa -fo yeast_intergenic.fa -bed yeast_intergenic.bed -s -name -split

STAR --runMode genomeGenerate --runThreadN 4 --genomeDir STAR_index --genomeFastaFiles Saccharomyces_cerevisiae.R64-1-1.dna.toplevel.fa --sjdbGTFfile Saccharomyces_cerevisiae.R64-1-1.100.gtf


cat sample_ids.txt | while read FILE 
do

	zcat $FILE_1.fastq.gz | head -n 800000 > sample_$FILE_1.fastq
	zcat $FILE_2.fastq.gz | head -n 800000 > sample_$FILE_2.fastq
	gzip sample_$FILE_1.fastq
	gzip sample_$FILE_2.fastq

	STAR --runThreadN 8 \
	--genomeDir STAR_index \
	--outFileNamePrefix STAR_alignments/STAR_$FILE_ \
	--readFilesIn sample_$FILE_1.fastq.gz sample_$FILE_2.fastq.gz \
	--readFilesCommand zcat \
	--outSAMtype BAM SortedByCoordinate \
	--outReadsUnmapped Fastx \
	--quantMode TranscriptomeSAM
	
	
	htseq-count STAR_alignments/STAR_$FILE_Aligned.sortedByCoord.out.bam yeast_intergenic.gtf > STAR_$FILE_plusintergenic.count.txt
	
	check_strandedness -r1 $FILE_1.fastq.gz -r2 $FILE_2.fastq.gz -fa yeast_intergenic.fa -g yeast_intergenic.gtf -k intergenic_index
	mv stranded_test_$FILE_1/strandedness_check.txt yeast_intergenic/$FILE.strandedness_check.txt
	rm -rf stranded_test_$FILE_1
	

done