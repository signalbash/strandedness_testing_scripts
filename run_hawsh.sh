cd yeast
mkdir -p test_results

ls *_1.fastq.gz | sed 's/_1.fastq.gz//g' > sample_ids.txt

cat sample_ids.txt | while read FILE 
do
   for SAMPLESIZE in 1000 2000 10000 20000 100000 200000 1000000 2000000 
     do 
     	check_strandedness -r1 $FILE_1.fastq.gz -r2 $FILE_2.fastq.gz -k ensembl_index -n $SAMPLESIZE --gtf Saccharomyces_cerevisiae.R64-1-1.100.gtf --transcripts Saccharomyces_cerevisiae.R64-1-1.cdna.all.fa --bed Saccharomyces_cerevisiae.R64-1-1.100.bed
     	mv stranded_test_$FILE_1/strandedness_check.txt test_results/ensembl_full_$SAMPLESIZE_$FILE.strandedness_check.txt
     	rm -rf stranded_test_$FILE
     done
done

cd ../human
mkdir -p test_results

ls *_1.fastq.gz | sed 's/_1.fastq.gz//g' > sample_ids.txt

cat sample_ids.txt | while read FILE 
do
   for SAMPLESIZE in 1000 2000 10000 20000 100000 200000 1000000 2000000 
     do 
     	check_strandedness -r1 $FILE_1.fastq.gz -r2 $FILE_2.fastq.gz -k ensembl_index -n $SAMPLESIZE --gtf Saccharomyces_cerevisiae.R64-1-1.100.gtf --transcripts Homo_sapiens.GRCh38.cdna.all.fa --bed Homo_sapiens.GRCh38.100.bed
     	mv stranded_test_$FILE_1/strandedness_check.txt test_results/ensembl_full_$SAMPLESIZE_$FILE.strandedness_check.txt
     	rm -rf stranded_test_$FILE
     done
done

cd ../arabidopsis
mkdir -p test_results

ls *_1.fastq.gz | sed 's/_1.fastq.gz//g' > sample_ids.txt

cat sample_ids.txt | while read FILE 
do
   for SAMPLESIZE in 1000 2000 10000 20000 100000 200000 1000000 2000000 
     do 
     	check_strandedness -r1 $FILE_1.fastq.gz -r2 $FILE_2.fastq.gz -k ensembl_index -n $SAMPLESIZE --gtf Saccharomyces_cerevisiae.R64-1-1.100.gtf --transcripts Arabidopsis_thaliana.TAIR10.cdna.all.fa --bed Arabidopsis_thaliana.TAIR10.47.bed
     	mv stranded_test_$FILE_1/strandedness_check.txt test_results/ensembl_full_$SAMPLESIZE_$FILE.strandedness_check.txt
     	rm -rf stranded_test_$FILE
     done
done

