library(ggplot2)
library(cowplot)
library(stringr)
library(halpme)
library(tidyverse)
library(data.table)

theme_figure <- theme_bw()+ theme(text=element_text(size=8),legend.key.size=unit(0.1, "inches"),
                                  panel.grid.major = element_blank(),
                                  panel.grid.minor = element_blank(),
                                  panel.border = element_rect(colour = "black", size=0.5, fill=NA),
                                  axis.line.x = element_blank(),
                                  axis.line.y = element_blank(),
                                  axis.ticks = element_line(size=0.25),
                                  axis.ticks.length = unit(0.05, "cm"),
                                  panel.background = element_blank(),
                                  plot.title = element_text(hjust = 0.5),
                                  strip.background = element_blank(),
                                  strip.text = element_text(size=8, face = "bold"))

species= c("yeast", "human", "arabidopsis")

strand_results_species=NULL
for(s in seq_along(species)){


  strand_results_folders = list.files(paste0(species[s] ,"/simulated_reads/strand_checks/"), full.names = T, pattern = "stranded_test", include.dirs = T)
  if(length(strand_results_folders) > 0){

    for(f in seq_along(strand_results_folders)){
      system(paste0("mv ", strand_results_folders[f], "/strandedness_check.txt ",
                    gsub("stranded_test_", "", strand_results_folders[f]), ".strandedness_check.txt"))
    }

    for(f in seq_along(strand_results_folders)){
      system(paste0("rm -rf ", strand_results_folders[f]))
    }

  }

  strand_results_files = list.files(paste0(species[s] ,"/simulated_reads/strand_checks/"), full.names = T, pattern = "strandedness_check")
  strand_results_files = strand_results_files[str_count(strand_results_files, "_") == 8]

  strand_results = data.frame(file_path=strand_results_files,
                              file_name=basename(strand_results_files))

  strand_results$sample = strv_split(strand_results$file_name, "_", 1)
  strand_results$percent_stranded= as.numeric(strv_split(strand_results$file_name, "_", 2))
  strand_results$resample_n= as.numeric(strv_split(strand_results$file_name, "_", 5))

  strand_results$n_reads = 200000

  strand_results$failed = NA
  strand_results$strand_fwd = NA
  strand_results$strand_rev = NA
  strand_results$max_strand = NA
  strand_results$max_strand_no_fail = NA


  for(i in 1:nrow(strand_results)){
    try({
      hawsh_result = fread(strand_results$file_path[i], sep='\n')
      failed = strv_split(hawsh_result[1,1], ":[ ]", 2) %>% as.numeric()
      str_per = strv_split(hawsh_result[3,1], ":[ ]", 2) %>% as.numeric()
      unstr_per= strv_split(hawsh_result[2,1], ":[ ]", 2) %>% as.numeric()

      max_strand = max(str_per, unstr_per)
      max_nofail = max_strand / (str_per+unstr_per)

      strand_results$failed[i] = failed
      strand_results$strand_fwd[i] = unstr_per
      strand_results$strand_rev[i] = str_per
      strand_results$max_strand[i] = max_strand
      strand_results$max_strand_no_fail[i] = max_nofail

    })
  }

  strand_results$species = species[s]
  strand_results_species = rbind(strand_results_species,strand_results)

}

strand_results_species$species_sci = strand_results_species$species
strand_results_species$species_sci[strand_results_species$species_sci == "human"] = "h. sapiens"
strand_results_species$species_sci[strand_results_species$species_sci == "yeast"] = "s. cerevisiae"
strand_results_species$species_sci[strand_results_species$species_sci == "arabidopsis"] = "a. thaliana"




p1 = ggplot(strand_results_species,
            aes(x=percent_stranded, group=paste0(sample, resample_n), y=max_strand_no_fail)) +
  geom_point() + facet_wrap(~species_sci, ncol=3) + theme_figure +
  scale_y_continuous("how_are_we_stranded_here\nstranded proportion") + scale_x_continuous("Proportion of sample from stranded reads")




Metrics::mae(strand_results_species$max_strand_no_fail[strand_results_species$species == "human"],
             ((strand_results_species$percent_stranded[strand_results_species$species == "human"]/2)+0.5))
Metrics::mae(strand_results_species$max_strand_no_fail[strand_results_species$species == "yeast"],
             ((strand_results_species$percent_stranded[strand_results_species$species == "yeast"]/2)+0.5))
Metrics::mae(strand_results_species$max_strand_no_fail[strand_results_species$species == "arabidopsis"],
             ((strand_results_species$percent_stranded[strand_results_species$species == "arabidopsis"]/2)+0.5))


strand_results_sim_species_n=NULL
for(s in seq_along(species)){


    strand_results_folders = list.files(paste0(species[s] ,"/simulated_reads/strand_checks_n/"), full.names = T, pattern = "stranded_test", include.dirs = T)
    if(length(strand_results_folders) > 0){

      for(f in seq_along(strand_results_folders)){
        system(paste0("mv ", strand_results_folders[f], "/strandedness_check.txt ",
                      gsub("stranded_test_", "", strand_results_folders[f]), ".strandedness_check.txt"))
      }

      for(f in seq_along(strand_results_folders)){
        system(paste0("rm -rf ", strand_results_folders[f]))
      }

    }

    strand_results_files = list.files(paste0(species[s] ,"/simulated_reads/strand_checks_n/"), full.names = T, pattern = "strandedness_check")
    strand_results_files = strand_results_files[str_count(strand_results_files, "_") == 10]


    strand_results = data.frame(file_path=strand_results_files,
                                file_name=basename(strand_results_files))

    strand_results$sample = strv_split(strand_results$file_name, "_", 1)
    strand_results$percent_stranded= as.numeric(strv_split(strand_results$file_name, "_", 2))
    strand_results$resample_n= as.numeric(strv_split(strand_results$file_name, "_", 5))

    strand_results$n_reads = as.numeric(strv_split(strand_results$file_name, "_", 6))

    strand_results$failed = NA
    strand_results$strand_fwd = NA
    strand_results$strand_rev = NA
    strand_results$max_strand = NA
    strand_results$max_strand_no_fail = NA


    for(i in 1:nrow(strand_results)){
      try({
        hawsh_result = fread(strand_results$file_path[i], sep='\n')
        failed = strv_split(hawsh_result[1,1], ":[ ]", 2) %>% as.numeric()
        str_per = strv_split(hawsh_result[3,1], ":[ ]", 2) %>% as.numeric()
        unstr_per= strv_split(hawsh_result[2,1], ":[ ]", 2) %>% as.numeric()

        max_strand = max(str_per, unstr_per)
        max_nofail = max_strand / (str_per+unstr_per)

        strand_results$failed[i] = failed
        strand_results$strand_fwd[i] = unstr_per
        strand_results$strand_rev[i] = str_per
        strand_results$max_strand[i] = max_strand
        strand_results$max_strand_no_fail[i] = max_nofail

      })
    }

    error_files = list.files(paste0(species[s], "/simulated_reads/error_files_n/"), pattern = "n_checks_", full.names = T)
    #single = strand_results[strand_results$percent_stranded==1,]
    #single$error_file = error_files[match(paste0(single$sample, "_", single$resample_n ), strv_split2(error_files, "n_checks_", "[.]"))]

    all_errors = NULL
    for(i in 1:length(error_files)){

      #if(!is.na(single$error_file[i])){

        error = fread(cmd=paste0("grep -e pseudoaligned -e Results < ", error_files[i]), header=F, sep='\n')
        error = data.frame(V1= error[seq(1,nrow(error), 2),1], V2=error[seq(2,nrow(error), 2),1])
        error$file_name = paste0(strv_split(error[,2], "stranded_test_", 2), ".strandedness_check.txt")

        error$n_reads = strv_split2(error$V1, "processed[ ]", "[ ]reads") %>% gsub(",","", .) %>% as.numeric()
        error$aligned = strv_split2(error$V1, "reads,[ ]", "[ ]reads") %>% gsub(",","", .) %>% as.numeric()
        error$percent_aligned = error$aligned/error$n_reads

        all_errors = rbind(all_errors, error)

      #}

    }

    strand_results = left_join(strand_results, all_errors[,-c(1:2)], by = c('file_name', "n_reads"))


    strand_results$species = species[s]
    strand_results_sim_species_n = rbind(strand_results_sim_species_n,strand_results)

}

strand_results_sim_species_n = strand_results_sim_species_n[!is.na(strand_results_sim_species_n$n_reads),]


strand_results_sim_species_n$species_sci = strand_results_sim_species_n$species
strand_results_sim_species_n$species_sci[strand_results_sim_species_n$species_sci == "human"] = "h. sapiens"
strand_results_sim_species_n$species_sci[strand_results_sim_species_n$species_sci == "yeast"] = "s. cerevisiae"
strand_results_sim_species_n$species_sci[strand_results_sim_species_n$species_sci == "arabidopsis"] = "a. thaliana"


p2=ggplot(strand_results_sim_species_n,
          aes(x=factor(n_reads), group=paste0(sample, resample_n, percent_stranded), y=max_strand_no_fail, col=factor(percent_stranded))) +
  geom_line() + facet_wrap(~species_sci) + theme_figure + scale_x_discrete("Number of reads") +
  scale_y_continuous("how_are_we_stranded_here\nstranded proportion") + scale_color_discrete("Proportion of sample\nfrom stranded reads") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1), legend.position = c(0.8, 0.8))

p3=
  ggplot(strand_results_sim_species_n[strand_results_sim_species_n$percent_stranded==0,],
         aes(x=factor(n_reads), y=strand_fwd/(strand_fwd+strand_rev))) +
  geom_boxplot() + facet_wrap(~species_sci) + theme_figure + scale_x_discrete("Number of reads") +
  scale_y_continuous("Proportion of reads\naligning in FWD direction") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1), legend.position = "none") + geom_hline(yintercept = 0.5, linetype="dashed")

aggregate(abs(0.5 - (strand_fwd/(strand_fwd+strand_rev)))~ n_reads+percent_stranded+species,
          strand_results_sim_species_n, function(x) sd(x)*100*3) %>% filter(percent_stranded==0)

aggregate(max_strand_no_fail ~ n_reads+species,
          strand_results_sim_species_n[strand_results_sim_species_n$percent_stranded==0,],
          function(x) Metrics::mae(x, 0.5))

Metrics::mae(strand_results_species$max_strand_no_fail[strand_results_species$species == "human"],
             ((strand_results_species$percent_stranded[strand_results_species$species == "human"]/2)+0.5))


var_tests = NULL
species = unique(strand_results_sim_species_n$species_sci)
for (s in species){

  for(n_reads in c(1000, 2000, 10000, 20000,100000, 200000)){

    v = var.test(x=strand_results_sim_species_n$max_strand_no_fail[strand_results_sim_species_n$n_reads==n_reads&
                                                                     strand_results_sim_species_n$percent_stranded==0 &
                                                                     strand_results_sim_species_n$species_sci==s],
                 y= strand_results_sim_species_n$max_strand_no_fail[strand_results_sim_species_n$n_reads==n_reads*10 &
                                                                      strand_results_sim_species_n$percent_stranded==0&
                                                                      strand_results_sim_species_n$species_sci==s],
                 alternative="greater")


    var_tests = rbind(var_tests, data.frame(species = s, number_of_reads_low = n_reads, number_of_reads_high=n_reads*10, p=v$p.value))

  }

}

colnames(var_tests) = c("Species", "Number of reads (low)", "Number of reads (high)", "p-value")
write.table(var_tests, file="Suppl_Table_Ftests_nReads.txt", sep="\t", quote=F, row.names = F)

pdf("suppl_fig_simulated.pdf", height=4,width=6.69)
ggdraw() +
  draw_plot(p3, 0,0.5,1,0.5) +
  draw_plot(p1, 0,0.00,1,0.5)+
  draw_plot_label(c("A","B"), x=c(0,0), y=c(1,0.5), size=12)
dev.off()

p_x = ggplot(strand_results_sim_species_n,
             aes(x=factor(n_reads),
                 group=paste0(sample, resample_n, percent_stranded),
                 y=max_strand_no_fail, col=sample, shape =factor(resample_n))) +
  geom_line() + facet_wrap(~species_sci) + theme_figure + scale_x_discrete("Number of reads") +
  scale_y_continuous("Stranded proportion") + scale_color_discrete("Simulated data\nexpression source") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  geom_hline(yintercept = c(0.9, 0.6), linetype="dashed")

pdf("Fig_simulated.pdf", height=2.5,width=6.69)
p_x
dev.off()




