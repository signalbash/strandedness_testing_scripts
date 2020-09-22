library(tidyverse)
library(stringr)
library(data.table)

library(halpme) #(github: betsig/halpme)

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
    
    paired_end_results = fread(paste0(species[s], "_rnaseq.txt"), data.table = F)
    studies_with_pubs = fread(paste0(species[s], "_paired_end_pubs.txt"), data.table = F)
    
    studies_with_pubs$pub_stranded2 = strv_split(studies_with_pubs$Stranded, "[ ]", 1) %>% strv_split("[(]", 1)
    table(studies_with_pubs$pub_stranded2[!duplicated(studies_with_pubs$study_accession)])
    
    stranded_study_accessions = studies_with_pubs$study_accession[studies_with_pubs$pub_stranded2 %in% c("Stranded", "Unstranded")] %>% unique()
    
    
    strand_results_files = list.files(paste0("data/", species[s] ,"/"), full.names = T, pattern = "strandedness_check")
    strand_results = data.frame(file_path=strand_results_files, 
                                file_name=basename(strand_results_files))
    strand_results$set = strv_split(strand_results$file_name, "_", 2)
    strand_results$n_reads = strv_split(strand_results$file_name, "_", 3) %>% as.numeric()
    strand_results$sample = strv_split2(strand_results$file_name, "000_", "[.]")
    strand_results$study = paired_end_results$study_accession[match(strand_results$sample, paired_end_results$run_accession)]
    strand_results$pub_stranded = studies_with_pubs$pub_stranded2[match(strand_results$study, studies_with_pubs$study_accession)]
    
    table(strand_results$pub_stranded[!duplicated(strand_results$study)])
    
    no_results =
        stranded_study_accessions[which(!(stranded_study_accessions %in%
                                              strand_results$study[strand_results$pub_stranded %in% c("Stranded", "Unstranded")]))]
    
    studies_with_pubs$run_accession[studies_with_pubs$study_accession %in% no_results]
    
    
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
    
    error_files = list.files(paste0("data/", species[s], "/error_files/"), pattern = "_test_", full.names = T)
    single = strand_results[strand_results$n_reads == 1000 & strand_results$set == "full",]
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
    strand_results$test_stranded[strand_results$max_strand_no_fail > 0.75] = "Stranded"
    strand_results$test_stranded[strand_results$max_strand_no_fail <= 0.75] = "Unstranded"
    strand_results$species = species[s]
    strand_results_species = rbind(strand_results_species,strand_results)

}

keep = which(strand_results_species$pub_stranded %in% c("Stranded", "Unstranded") & 
                 strand_results_species$percent_aligned > 0.1 & strand_results_species$set =="full")
strand_results_keep = strand_results_species[keep,]

strand_results_keep$flag = "Passed"
strand_results_keep$flag[which(strand_results_keep$sample %in% 
                             strand_results_keep$sample[which(strand_results_keep$test_stranded != 
                                                            strand_results_keep$pub_stranded)])] = 
    "Failed"
strand_results_keep$flag[which(strand_results_keep$sample %in% 
                             strand_results_keep$sample[which(strand_results_keep$max_strand_no_fail > 0.6 & 
                                                            strand_results_keep$max_strand_no_fail < 0.9)])] = 
    "Failed"

strand_results_keep$species_sci = strand_results_keep$species
strand_results_keep$species_sci[strand_results_keep$species_sci == "human"] = "h. sapiens"
strand_results_keep$species_sci[strand_results_keep$species_sci == "yeast"] = "s. cerevisiae"
strand_results_keep$species_sci[strand_results_keep$species_sci == "arabidopsis"] = "a. thaliana"

write.table(strand_results_keep[,c(18, 5,6,7,4,8:15, 17)], file="hawsh_strandedness_results.txt", sep="\t", row.names = F)


plot_stranded_prop = 
ggplot(strand_results_keep[which(strand_results_keep$flag == "Passed"),], 
       aes(x=factor(n_reads), group=sample, y=max_strand_no_fail)) + 
    #geom_point(data=strand_results_keep[which(strand_results_keep$flag == "Passed"),], col='grey') + 
    #geom_line(data=strand_results_keep[which(strand_results_keep$flag == "Passed"),], col='grey') +
    #geom_point(col='grey') +
    geom_line(col='grey') +
    scale_colour_discrete("Study Accession")+
    #geom_point(data=strand_results_keep[which(strand_results_keep$flag != "Passed"),], aes(col=study)) + 
    geom_line(data=strand_results_keep[which(strand_results_keep$flag != "Passed"),], aes(col=study)) +
    facet_wrap(~species_sci, ncol=3) + theme_figure + 
    scale_x_discrete("Number of reads sampled") + 
    scale_y_continuous("Stranded proportion") + geom_hline(yintercept = c(0.9,0.6), linetype="dashed") +
    theme(axis.text.x = element_text(angle = 90, hjust = 1))

strand_results_species$species_sci = strand_results_species$species
strand_results_species$species_sci[strand_results_species$species_sci == "human"] = "h. sapiens"
strand_results_species$species_sci[strand_results_species$species_sci == "yeast"] = "s. cerevisiae"
strand_results_species$species_sci[strand_results_species$species_sci == "arabidopsis"] = "a. thaliana"

strand_results_species$flag = "Passed"
strand_results_species$flag[strand_results_species$study %in% strand_results_keep$study[strand_results_keep$flag=="Failed"]] = "Failed"

plot_aligned_to_tx = 
ggplot(strand_results_species[strand_results_species$set=="full" & 
                                  strand_results_species$study %in% 
                                  strand_results_keep$study & strand_results_species$flag=="Passed",], 
       aes(x=factor(n_reads), y=percent_aligned, group=sample)) + 
    geom_line(col='grey') +
    geom_line(data=strand_results_species[which(strand_results_species$flag != "Passed" & 
                                                    strand_results_species$set=="full"),], aes(col=study)) +
    scale_colour_discrete("Study Accession")+
    facet_wrap(~species_sci, ncol=3) + theme_figure + 
    scale_x_discrete("Number of reads sampled") + 
    scale_y_continuous("Proportion aligned to transcriptome") + 
    geom_hline(yintercept = c(0.1), linetype="dashed")+
    theme(axis.text.x = element_text(angle = 90, hjust = 1))



count_files=  list.files("data/yeast/STAR/", pattern = "ic.count", full.names = T)
gtf = fread("Saccharomyces_cerevisiae.R64-1-1.100.gtf")
gtf$gene_id = halpme::strv_split2(gtf$V9, "gene_id ", ";") %>% halpme::remove_quotes()
gtf$gene_biotype = halpme::strv_split2(gtf$V9, "gene_biotype ", ";") %>% halpme::remove_quotes()

alignment_summary = NULL
for(i in seq_along(count_files)){
    
    counts = fread(count_files[i], data.table = F)
    counts$group = ifelse(grepl("intergenic", counts$V1), "Intergenic", "EXONIC")
    counts$group[grepl("SNR", counts$V1, ignore.case = T)] = "SNORNA"
    
    m = match(counts$V1, gtf$gene_id)
    counts$group[!is.na(m)] = gtf$gene_biotype[m[!is.na(m)]]
    
    counts$group[str_sub(counts$V1, 1,2) == "__"] = "notaligned"
    
    count_summary = aggregate(V2 ~ group, counts, sum)
    count_summary$sample = basename(count_files[i]) %>% 
        gsub("STAR_","",.) %>% gsub("_plusintergenic.count.txt", "",.)
    
    alignment_summary = rbind(alignment_summary, count_summary)
    
}


alignment_summary = alignment_summary[alignment_summary$sample %in% strand_results_keep$sample,]
alignment_summary$group = gsub("INTERGENIC", "intergenic",alignment_summary$group)

plot_aligned_to_feat = 
    ggplot(alignment_summary[alignment_summary$group!="notaligned",], 
       aes(x=sample, y=V2, fill=group)) + 
    geom_bar(stat='identity', position='stack') + ggeasy::easy_rotate_x_labels() + 
    scale_fill_brewer(palette = "Paired", "Gene/feature type") + theme_figure + 
    scale_x_discrete("Sample accession")  +
    scale_y_continuous("Number of reads aligned") +
    theme(axis.text.x = element_text(angle = 90, hjust = 1))


trimmed_files =  list.files("data/yeast/yeast_trimmed/", full.names = T)
t.sample = basename(trimmed_files) %>% gsub(".strandedness_check.txt","",.)

trimmed_results = strand_results_keep[strand_results_keep$set == "full" & strand_results_keep$n_reads == 200000,]
trimmed_results = trimmed_results[trimmed_results$sample %in% t.sample,]
trimmed_results$tfile = trimmed_files[match(trimmed_results$sample, t.sample)]

for(i in seq_along(trimmed_results$tfile)){
    
    hawsh_result = fread(trimmed_results$tfile[i], data.table = F, sep='\n')
    failed = strv_split(hawsh_result[1,1], ":[ ]", 2) %>% as.numeric()
    str_per = strv_split(hawsh_result[3,1], ":[ ]", 2) %>% as.numeric()
    unstr_per= strv_split(hawsh_result[2,1], ":[ ]", 2) %>% as.numeric()
    
    max_strand = max(str_per, unstr_per)
    max_nofail = max_strand / (str_per+unstr_per)
    
    trimmed_results$trim_failed[i] = failed
    trimmed_results$trim_strand_fwd[i] = unstr_per
    trimmed_results$trim_strand_rev[i] = str_per
    trimmed_results$trim_max_strand[i] = max_strand
    trimmed_results$trim_max_strand_no_fail[i] = max_nofail
    
}

plot_trimmed = 
ggplot(trimmed_results, aes(x=max_strand_no_fail, y =trim_max_strand_no_fail)) + 
    geom_point() + 
    geom_abline(slope=1,  linetype='dashed') + theme_figure + 
    scale_x_continuous("Stranded proportion (raw fastq)")+ 
    scale_y_continuous("Stranded proportion (trimmed fastq)")

write.table(trimmed_results[,c(5:18,20:24)], file="yeast_trimmed_results_summary.txt", sep="\t", row.names = F)


filtered_files =  list.files("data/yeast/yeast_filtered/", full.names = T)
t.sample = basename(filtered_files) %>% gsub(".strandedness_check.txt","",.)

filtered_results = strand_results_keep[strand_results_keep$set == "full" & strand_results_keep$n_reads == 200000,]
filtered_results = filtered_results[filtered_results$sample %in% t.sample,]
filtered_results$tfile = filtered_files[match(filtered_results$sample, t.sample)]

for(i in seq_along(filtered_results$tfile)){
    
    hawsh_result = fread(filtered_results$tfile[i], data.table = F, sep='\n')
    failed = strv_split(hawsh_result[1,1], ":[ ]", 2) %>% as.numeric()
    str_per = strv_split(hawsh_result[3,1], ":[ ]", 2) %>% as.numeric()
    unstr_per= strv_split(hawsh_result[2,1], ":[ ]", 2) %>% as.numeric()
    
    max_strand = max(str_per, unstr_per)
    max_nofail = max_strand / (str_per+unstr_per)
    
    filtered_results$filtered_failed[i] = failed
    filtered_results$filtered_strand_fwd[i] = unstr_per
    filtered_results$filtered_strand_rev[i] = str_per
    filtered_results$filtered_max_strand[i] = max_strand
    filtered_results$filtered_max_strand_no_fail[i] = max_nofail
    
}

plot_filtered= 
ggplot(filtered_results, aes(x=max_strand_no_fail, y =filtered_max_strand_no_fail)) + 
    geom_point() + 
    geom_abline(slope=1,  linetype='dashed') + theme_figure + 
    scale_x_continuous("Stranded proportion (raw fastq)")+ 
    scale_y_continuous("Stranded proportion (filtered fastq)")

write.table(filtered_results[,c(5:18,20:24)], file="yeast_filtered_results_summary.txt", sep="\t", row.names = F)

fastqscreen_files = list.files("data/yeast/fastqscreen_results", full.names = T)

t.sample = basename(fastqscreen_files) %>% gsub("_[1-2]_val_[1-2]_screen.txt","",.) %>% gsub("trim_", "",.)
t.read_file =  basename(fastqscreen_files) %>% strv_split2("val_", "_screen")
fastqscreen = data.frame(file = fastqscreen_files, sample=t.sample, read_file=t.read_file)


all_fastqscreen = NULL
for(i in seq_along(fastqscreen_files)){
    
    fqs_result = fread(fastqscreen_files[i], data.table = F, sep='\t')
    aligned_to_sum = rowSums(fqs_result[,c(5,7,9,11)]) / fqs_result$`#Reads_processed`[1] 
    fastqs_aligned = data.frame(species = fqs_result$Genome, prop_aligned = aligned_to_sum)
    fastqs_aligned$sample = fastqscreen$sample[i]
    fastqs_aligned$read_file = fastqscreen$read_file[i]
    
    all_fastqscreen = rbind(all_fastqscreen, fastqs_aligned)
}
all_fastqscreen$flag = "Passed"
all_fastqscreen$flag[all_fastqscreen$sample %in% strand_results_keep$sample[strand_results_keep$flag=="Failed"]] = "Failed"


ggplot(all_fastqscreen[all_fastqscreen$flag == "Passed",], 
       aes(x=species, y=prop_aligned, shape=read_file)) + geom_point()+
    geom_point(data=all_fastqscreen[all_fastqscreen$flag == "Failed",], aes(col=sample))

all_fastqscreen$flag = NULL
all_fastqscreen_wide = pivot_wider(all_fastqscreen, names_from=species, values_from=prop_aligned)
write.table(all_fastqscreen_wide, file="yeast_fastqcscreen_summary.txt", sep='\t', row.names = F)


intergenic_files =  list.files("data/yeast/yeast_intergenic/", full.names = T, pattern = ".strandedness_check.txt")
t.sample = basename(intergenic_files) %>% gsub(".strandedness_check.txt","",.)

intergenic_results = strand_results_keep[strand_results_keep$set == "full" & strand_results_keep$n_reads == 200000,]
intergenic_results = intergenic_results[intergenic_results$sample %in% t.sample,]
intergenic_results$tfile = intergenic_files[match(intergenic_results$sample, t.sample)]

for(i in seq_along(intergenic_results$tfile)){
    
    hawsh_result = fread(intergenic_results$tfile[i], data.table = F, sep='\n')
    failed = strv_split(hawsh_result[1,1], ":[ ]", 2) %>% as.numeric()
    str_per = strv_split(hawsh_result[3,1], ":[ ]", 2) %>% as.numeric()
    unstr_per= strv_split(hawsh_result[2,1], ":[ ]", 2) %>% as.numeric()
    
    max_strand = max(str_per, unstr_per)
    max_nofail = max_strand / (str_per+unstr_per)
    
    intergenic_results$intergenic_failed[i] = failed
    intergenic_results$intergenic_strand_fwd[i] = unstr_per
    intergenic_results$intergenic_strand_rev[i] = str_per
    intergenic_results$intergenic_max_strand[i] = max_strand
    intergenic_results$intergenic_max_strand_no_fail[i] = max_nofail
    
}

intergenic_e = list.files("data/yeast/yeast_intergenic/", pattern = ".sh.e", full.names = T)

intergenic_results$intergenic_aligned = NA

for(i in seq_along(intergenic_e)){
    
    error_file = fread(intergenic_e[i], data.table = F, sep='\n')
    error_file = error_file[grepl("will process", error_file[,1]) | grepl("pseudoaligned", error_file[,1]),]
    sample = strv_split2(error_file[1], "test_", "_1")
    processed = strv_split2(error_file[2], "processed ", " reads") %>% gsub(",","",.) %>% as.numeric()
    aligned = strv_split2(error_file[2], "reads, ", " reads") %>% gsub(",","",.) %>% as.numeric()
    
    m = match(sample, intergenic_results$sample)
    if(!is.na(m)){
        
        intergenic_results$intergenic_aligned[m] = aligned/processed
        
    }
    
}

gg_color_hue <- function(n) {
    hues = seq(15, 375, length = n + 1)
    hcl(h = hues, l = 65, c = 100)[1:n]
}

cols =  gg_color_hue(11)[c(1,9)]

intergenic_results$flag = "Passed"
intergenic_results$flag[intergenic_results$study %in% strand_results_keep$study[strand_results_keep$flag=="Failed"]] = "Failed"

plot_intergenic =  
ggplot(intergenic_results[which(intergenic_results$flag == "Passed"),], 
       aes(x=intergenic_aligned, y=intergenic_max_strand_no_fail)) + 
    geom_point(col="grey") + 
    geom_point(data=intergenic_results[intergenic_results$flag != "Passed",], aes(col=sample)) + 
    scale_color_manual(values=cols, "Sample accession") + theme_figure + 
    scale_x_continuous("Proportion aligned to intergenic regions")+ 
    scale_y_continuous("Stranded proportion (intergenic reads)")


write.table(intergenic_results[,c(5:18,20:25)], file="yeast_intergenic_results_summary.txt", sep="\t", row.names = F)


library(cowplot)
# Main Figure
pdf("Figure_Stranded_Proportions.pdf", height=2.5, width=6.5)
plot_stranded_prop
dev.off()

# S? Not required
plot_aligned_to_tx

pdf("Supp_Figure_Intergenic.pdf", height=3, width=6.5)
ggdraw() +
    draw_plot(plot_aligned_to_feat, 0,0,0.65,1) + 
    draw_plot(plot_intergenic + theme(legend.position = c(0.7,0.7)), 0.65,0.15,0.35,0.75)+
    draw_plot_label(c("A","B"), size=12, x=c(0,0.65), y=c(1,1))   
dev.off()

pdf("Supp_Figure_Filtered.pdf", height=3, width=6.5)
ggdraw() +
    draw_plot(plot_trimmed + ggtitle("Trimmed reads"),  0,0,0.5,1) + 
    draw_plot(plot_filtered + ggtitle("Reads uniquely mapping to yeast only"), 0.5,0,0.5,1)+
    draw_plot_label(c("A","B"), size=12, x=c(0,0.5), y=c(1,1))   
dev.off()



