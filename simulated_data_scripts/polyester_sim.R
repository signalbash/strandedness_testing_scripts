library(optparse)

option_parser = OptionParser(
  usage="%prog [options] <sample_id> <transcripts.fa>",
  option_list = list(
    make_option(c("-n", "--n_reads"), default=200000, help="number of reads to sample"),
    make_option(c("-r", "--n_reps"), default=3, help="number of replicates"),
    make_option(c("-s", "--random_seed"), default=1, help="random seed number"),
    make_option(c("-l", "--read_length"), default=100, help="read length")

  )
)

parsed_args = parse_args(option_parser, positional_arguments = 2)
sample_id = parsed_args$args[1]
transcripts_fa = parsed_args$args[2]
n_reads = as.numeric(parsed_args$options$n_reads)
n_reps = as.numeric(parsed_args$options$n_reps)
seed_n = as.numeric(parsed_args$options$random_seed)
read_len = as.numeric(parsed_args$options$read_length)

library(polyester)
library(Biostrings)
library(data.table)

fastapath = (transcripts_fa)
numtx = count_transcripts(fastapath)

readmat = matrix(0, ncol=n_reps, nrow=numtx)

tids = fread(cmd = paste0("grep '>' ", transcripts_fa), data.table=F, sep='\n', header = F)
tids$tid = halpme::strv_split2(tids[,1], ">", "[ ]")

abundance <- read.delim(paste0("kallisto_abundance/", sample_id , "/abundance.tsv"))

abundance$est_count_sumsum = cumsum(abundance$est_counts)
total_reads = sum(abundance$est_counts)
set.seed(seed_n)

for(j in 1:n_reps){
  sample_reads = sample(total_reads, size=n_reads)
  sample_reads = sort(sample_reads)

  abundance$new_counts=0

  for(i in 1:nrow(abundance)){
    w = which(sample_reads <= abundance$est_count_sumsum[i])
    if(length(w) > 0){
      abundance$new_counts[i] = length(w)
      sample_reads = sample_reads[-w]
    }
  }

  readmat[,j] = as.integer(round(abundance$new_counts))

}

simulate_experiment_countmat(fasta=fastapath,
                             readmat=readmat, 
                             gzip=TRUE,
                             outdir=paste0('simulated_reads/', sample_id, '_1_SS'), 
                             seed=seed_n, paired=TRUE,strand_specific=TRUE, readlen = read_len)

simulate_experiment_countmat(fasta=fastapath,
                             readmat=readmat, 
                             gzip=TRUE,
                             outdir=paste0('simulated_reads/', sample_id, '_0_NS'), 
                             seed=seed_n, paired=TRUE,strand_specific=FALSE, readlen = read_len)
