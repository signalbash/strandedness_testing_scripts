library(data.table)
library(GenomicRanges)
options(scipen=999)

gtf = fread("Saccharomyces_cerevisiae.R64-1-1.100.gtf", data.table = F)
colnames(gtf) = c('seqnames', "source", 'type','start','end','score','strand', 's2', 'attributes')

gtf_gene = gtf[gtf$type=="gene",]
gtf_exon = gtf[gtf$type=="exon",]



exon_ranges = GenomicRanges::makeGRangesFromDataFrame(gtf_exon, keep.extra.columns = TRUE)
gene_ranges = GenomicRanges::makeGRangesFromDataFrame(gtf_gene, keep.extra.columns = TRUE)


strand(gene_ranges) = "*"
gene_ranges = reduce(gene_ranges)

gr = as.data.frame(gene_ranges)
seqnames = unique(gr$seqnames)


intergenic = NULL
for(i in seq_along(seqnames)){
    
    gr.s = gr[gr$seqnames == seqnames[i],]
    gr.s = arrange(gr.s, start)
    
    gr.s = gr.s %>% 
        mutate(new_start = end+1) %>% 
        mutate(new_end = lead(start)-1) %>% 
        filter(!is.na(new_start) & !is.na(new_end))
    
    gr.s = gr.s[,c(1,6,7,4,5)]
    colnames(gr.s)[2:3] = c("start", 'end')
    
    intergenic = rbind(intergenic, gr.s)
    
    #gr_intergenic = makeGRangesFromDataFrame(rbind(gr.s.p, gr.s.n))
    
    
}
gr_intergenic = makeGRangesFromDataFrame(intergenic)
findOverlaps(gr_intergenic, exon_ranges)
findOverlaps(gr_intergenic, gene_ranges)

gr_intergenic_small = exomeCopy::subdivideGRanges(gr_intergenic, subsize = 1000)

# make BED file for getFASTA
gr_intergenic_bed = as.data.frame(gr_intergenic_small)
gr_intergenic_bed
gr_intergenic_bed$strand = "+"

gr_intergenic_bed$name = paste0("intergenic_", gr_intergenic_bed$seqnames, "-", gr_intergenic_bed$start, "-", gr_intergenic_bed$end)
gr_intergenic_bed$score=0
gr_intergenic_bed$thickStart = gr_intergenic_bed$start
gr_intergenic_bed$thickEnd = gr_intergenic_bed$end
gr_intergenic_bed$rgb = 0
gr_intergenic_bed$blocks = 1
gr_intergenic_bed$blockSize = gr_intergenic_bed$width
gr_intergenic_bed$blockStart = gr_intergenic_bed$start

gr_intergenic_bed = gr_intergenic_bed[,c(1,2,3,6,7,5,8,9,10,11,12,13)]
write.table(gr_intergenic_bed, file = "yeast_intergenic.bed", quote=F, row.names = F, sep='\t', col.names = F)

head(gr_intergenic_bed)

gr_intergenic_gtf = gr_intergenic_bed
gr_intergenic_gtf$source = "INTERGENIC"
gr_intergenic_gtf$type = "exon"
gr_intergenic_gtf$score = "."
gr_intergenic_gtf$s2= "."
gr_intergenic_gtf$attributes = paste0('gene_id "',gr_intergenic_gtf$name, 
                                      '"; transcript_id "', gr_intergenic_gtf$name,  
                                      '"; exon_id "', gr_intergenic_gtf$name, '_E1";')

gr_intergenic_gtf = gr_intergenic_gtf[,c(1,13,14,2,3,5,6,15,16)] 

head(gr_intergenic_gtf)

gr_intergenic_gtf_gene= gr_intergenic_gtf
gr_intergenic_gtf_gene$type = "gene"
gr_intergenic_gtf_gene$attributes = halpme::strv_split(gr_intergenic_gtf_gene$attributes, ' transcript_id "',1)

gr_intergenic_gtf_tx= gr_intergenic_gtf
gr_intergenic_gtf_tx$type = "transcript"
gr_intergenic_gtf_tx$attributes = halpme::strv_split(gr_intergenic_gtf_tx$attributes, ' exon_id "',1)


gr_intergenic_gtf = gr_intergenic_gtf %>% rbind(., gr_intergenic_gtf_gene, gr_intergenic_gtf_tx) %>% 
    arrange(seqnames, start, attributes)

write.table(gr_intergenic_gtf, file = "yeast_intergenic.gtf", quote=F, row.names = F, sep='\t', col.names = F)

