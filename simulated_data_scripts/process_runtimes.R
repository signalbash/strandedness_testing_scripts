library(data.table)
library(tidyverse)
library(stringr)
library(halpme)

time_to_sec = function(time_str){
    
    min = as.numeric(strv_split(time_str, "m", 1))
    sec = as.numeric(strv_split2(time_str, "m", "s"))
    
    return((min*60) + sec)
    
}
all_times = NULL
for (s in c("human", "arabidopsis", "yeast")){
    
    timing = fread(paste0("data/", s, "/simulated_reads/timing_checks.txt"), sep='\n', header=F, data.table = F)
    times = timing[grep("real", timing[,1]),] %>% strv_split("\t", 2) %>% time_to_sec()

    all_times = rbind(all_times, data.frame(species = s, times))    
    
}

all_times$species[all_times$species == "human"] = "h. sapiens"
all_times$species[all_times$species == "yeast"] = "s. cerevisiae"
all_times$species[all_times$species == "arabidopsis"] = "a. thaliana"

aggregate(times ~ species, all_times, median)

write.table(all_times, "Suppl_Table_runtimes.txt", quote=F, row.names = F, sep='\t')
