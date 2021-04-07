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



strand_results_sim_files = list.files(paste0("data/human/simulated_reads/strand_checks/"), full.names = T, pattern = "strandedness_check")
strand_results_sim_files = strand_results_sim_files[str_count(strand_results_sim_files, "_") == 8]
    
strand_results_sim = data.frame(file_path=strand_results_sim_files,
                            file_name=basename(strand_results_sim_files))
    
strand_results_sim$sample = strv_split(strand_results_sim$file_name, "_", 1)
strand_results_sim$percent_stranded= as.numeric(strv_split(strand_results_sim$file_name, "_", 2))
strand_results_sim$resample_n= as.numeric(strv_split(strand_results_sim$file_name, "_", 5))
    
strand_results_sim$n_reads = 200000
    
strand_results_sim$failed = NA
strand_results_sim$strand_fwd = NA
strand_results_sim$strand_rev = NA
strand_results_sim$max_strand = NA
strand_results_sim$max_strand_no_fail = NA
strand_results_sim = strand_results_sim[which(strand_results_sim$percent_stranded == 0 | strand_results_sim$percent_stranded == 1),]    

    
for(i in 1:nrow(strand_results_sim)){
    try({
        hawsh_result = fread(strand_results_sim$file_path[i], sep='\n')
        failed = strv_split(hawsh_result[1,1], ":[ ]", 2) %>% as.numeric()
        str_per = strv_split(hawsh_result[3,1], ":[ ]", 2) %>% as.numeric()
        unstr_per= strv_split(hawsh_result[2,1], ":[ ]", 2) %>% as.numeric()
            
        max_strand = max(str_per, unstr_per)
        max_nofail = max_strand / (str_per+unstr_per)
            
        strand_results_sim$failed[i] = failed
        strand_results_sim$strand_fwd[i] = unstr_per
        strand_results_sim$strand_rev[i] = str_per
        strand_results_sim$max_strand[i] = max_strand
        strand_results_sim$max_strand_no_fail[i] = max_nofail
            
    })
}

write_csv(strand_results_sim, "supp_table_simulated_results.csv")

paired_end_results = fread(paste0("human_rnaseq.txt"), data.table = F)
studies_with_pubs = fread(paste0("human_paired_end_pubs.txt"), data.table = F)
    
studies_with_pubs$pub_stranded2 = strv_split(studies_with_pubs$Stranded, "[ ]", 1) %>% strv_split("[(]", 1)

stranded_study_accessions = studies_with_pubs$study_accession[studies_with_pubs$pub_stranded2 %in% c("Stranded", "Unstranded")] %>% unique()
    
    
strand_results_files = list.files(paste0("data/human/"), full.names = T, pattern = "strandedness_check")
strand_results = data.frame(file_path=strand_results_files, 
                                file_name=basename(strand_results_files))
strand_results$set = strv_split(strand_results$file_name, "_", 2)
strand_results$n_reads = strv_split(strand_results$file_name, "_", 3) %>% as.numeric()
strand_results$sample = strv_split2(strand_results$file_name, "000_", "[.]")
strand_results$study = paired_end_results$study_accession[match(strand_results$sample, paired_end_results$run_accession)]
strand_results$pub_stranded = studies_with_pubs$pub_stranded2[match(strand_results$study, studies_with_pubs$study_accession)]
    

no_results = stranded_study_accessions[which(!(stranded_study_accessions %in%
                                              strand_results$study[strand_results$pub_stranded %in% c("Stranded", "Unstranded")]))]
    
studies_with_pubs$run_accession[studies_with_pubs$study_accession %in% no_results]
    
strand_results$failed = NA
strand_results$strand_fwd = NA
strand_results$strand_rev = NA
strand_results$max_strand = NA
strand_results$max_strand_no_fail = NA
    
strand_results = strand_results[strand_results$n_reads == 200000,]

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
    
error_files = list.files(paste0("data/human/error_files/"), pattern = "_test_", full.names = T)

single = strand_results[strand_results$n_reads == 200000 & strand_results$set == "full",]
single$error_file = error_files[match(single$sample, strv_split2(error_files, "test_", "[.]"))]

all_errors = NULL
for(i in 1:nrow(single)){
    
    if(!is.na(single$error_file[i])){
        
        error = fread(cmd=paste0("grep pseudoaligned < ", single$error_file[i]), header=F, sep='\n')
        error = error[!grepl("warn", error$V1),]
        if(nrow(error) == 48){
            error$sample = rep(c(1,2,3), each = 16)
            #error$reads = 
            error$n_reads = strv_split2(error$V1, "processed[ ]", "[ ]reads") %>% gsub(",","", .) %>% as.numeric()
            error$aligned = strv_split2(error$V1, "reads,[ ]", "[ ]reads") %>% gsub(",","", .) %>% as.numeric()
            error$percent_aligned = error$aligned/error$n_reads
            error$set = rep(rep(c("full", "pc"), 8), 3)
            
            sample_ids = single$sample[i] %>% str_replace("SRR", "") %>% as.numeric() -c(2,1,0)
            sample_ids = paste0("SRR", sample_ids)
            
            error$sample = sample_ids[error$sample]
            all_errors = rbind(all_errors, error)
        }else{
            message(i)
        }
        
    }
    
}

strand_results = left_join(strand_results, all_errors[,-1], by = c('sample',"n_reads", "set"))


strand_results$test_stranded = NA
strand_results$test_stranded[strand_results$max_strand_no_fail > 0.9] = "Stranded"
strand_results$test_stranded[strand_results$max_strand_no_fail <= 0.6] = "Unstranded"


keep = which(strand_results$pub_stranded %in% c("Stranded", "Unstranded") & 
                 strand_results$percent_aligned > 0.1 & strand_results$set =="full")
strand_results_keep = strand_results[keep,]

strand_results_keep$flag = "Passed"
strand_results_keep$flag[which(strand_results_keep$sample %in% 
                                   strand_results_keep$sample[which(strand_results_keep$test_stranded != 
                                                                        strand_results_keep$pub_stranded)])] = 
    "Failed"
strand_results_keep$flag[which(strand_results_keep$sample %in% 
                                   strand_results_keep$sample[which(strand_results_keep$max_strand_no_fail > 0.6 & 
                                                                        strand_results_keep$max_strand_no_fail < 0.9)])] = 
    "Failed"



strand_results_sim$group = ifelse(strand_results_sim$percent_stranded ==0, "Unstranded\nSimulated", "Stranded\nSimulated")
strand_results_keep$group = ifelse(strand_results_keep$pub_stranded =="Unstranded", "Unstranded\nReal", "Stranded\nReal")

strand_results_all = plyr::rbind.fill(strand_results_keep, strand_results_sim)
strand_results_all$group = factor(strand_results_all$group, levels = c("Stranded\nSimulated","Unstranded\nSimulated","Stranded\nReal","Unstranded\nReal"))

pdf("figure1.pdf", height=2.5, width=3.386)
ggplot(strand_results_all[which(strand_results_all$pub_stranded == strand_results_all$test_stranded | !is.na(strand_results_all$percent_stranded)),], 
       aes(x=group, y=max_strand_no_fail)) +
    geom_jitter(alpha=0.3, width=0.2) +
    geom_jitter(data =strand_results_keep[strand_results_keep$pub_stranded != strand_results_keep$test_stranded,], aes(col=study) , width=0.2, alpha=0.5) +
    scale_colour_discrete("Study Accession")+
    theme_figure + 
    scale_x_discrete("Sample group") + 
    annotate("text", x=0.5, y=0.93, label = " Stranded", hjust=0, col="grey50", size=2, vjust=0.5)+
    annotate("text", x=0.5, y=0.57, label = " Unstranded", hjust=0, col="grey50", size=2, vjust=0.5)+
    scale_y_continuous("Stranded proportion") + geom_hline(yintercept = c(0.9,0.6), linetype="dashed", col="grey50") +
    theme(legend.position = "bottom") +guides(col = guide_legend(nrow=1, title.position = "top", title.hjust = 0.5))
    #theme(axis.text.x = element_text(angle = 90, hjust = 1))
dev.off()

