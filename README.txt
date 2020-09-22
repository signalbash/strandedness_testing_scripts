## R version 4.0.2 unless otherwise specified
## Note that some steps require manual annotation to proceed

# get 20 studies & make download scripts
./get_paired_end_ENA_CURL.sh
Rscript paired_end_studies.R
Rscript annotate_studies_for_download.R

#run hawsh on 1000 to 2000000 txs
./run_hawsh.sh

### YEAST ONLY ###
# fastqc/fastqscreen removal of reads mapping to other species/multimappers
./trim_and_screen_yeast.sh
## uses extract_paired_couples_yeast.R within script

# STAR alignment to genome + read counting to genes and intergenic regions/strand biases
./intergenic_testing.sh

# make plots
Rscript make_plots.R
