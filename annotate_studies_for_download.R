library(rvest)
library(stringr)
library(data.table)


search_pubmed_text = function(pubmed_paragraph_text, search_string){
  locs = str_locate_all(tolower(pubmed_paragraph_text), search_string)
  has_match = which(unlist(lapply(locs, function(x) dim(x)[1] > 0)))
  pubmed_paragraph_text.searched = pubmed_paragraph_text[has_match]
  searched_sentences = unlist(str_split((pubmed_paragraph_text.searched), "[.][ ]"))
  return(str_c(searched_sentences[str_detect(tolower(searched_sentences), search_string)], collapse=";"))
}

for(species in c("yeast","human", "arabidopsis")){
  paired_end_results = fread(paste0(species, "_rnaseq.txt"), data.table = F)
  n_samples_per_study = table(paired_end_results$study_accession) %>% as.data.frame()
  paired_end_results_study = paired_end_results[!duplicated(paired_end_results$study_accession),]
  paired_end_results_study$n_samples = n_samples_per_study$Freq[match(paired_end_results_study$study_accession, n_samples_per_study$Var1)]
  
  # random sort 
  
  paired_end_results_study = paired_end_results_study[which(paired_end_results_study$n_samples >=10 & paired_end_results_study$n_samples <=30),]
  paired_end_results_study = paired_end_results_study[paired_end_results_study$instrument_model %in% c("Illumina HiSeq 2000","Illumina HiSeq 2500","Illumina HiSeq 3000","Illumina HiSeq 4000"),]
  
  set.seed(21)
  paired_end_results_study_random = paired_end_results_study[sample(1:nrow(paired_end_results_study), nrow(paired_end_results_study)),]
  
  paired_end_results_study_random$has_publication = F
  paired_end_results_study_random$publication = NA
  for(i in 1:(min(200, nrow(paired_end_results_study_random)))){
    try({
    prjna = paired_end_results_study_random$study_accession[i]
    
    url = paste0('https://www.ncbi.nlm.nih.gov/bioproject/?term=', prjna)
    #Reading the HTML code from the website
    webpage <- read_html(url)
    
    biopro_table = html_nodes(webpage, "#CombinedTable") %>% html_table(fill=T) %>% .[[1]]
    pub = biopro_table[biopro_table$X1=="Publications",2]
    
    message(pub)
    paired_end_results_study_random$has_publication[i] = ifelse(length(pub)>0, T,F)
    if(paired_end_results_study_random$has_publication[i]){
      paired_end_results_study_random$publication[i] = pub
    }
    })
  }
  
  paired_end_results_has_pub = paired_end_results_study_random[which(paired_end_results_study_random$has_publication == T),]
  paired_end_results_has_pub$strand_text = NA
  paired_end_results_has_pub$direction_text = NA
  paired_end_results_has_pub$library_text = NA
  paired_end_results_has_pub$kit_text = NA
  
  paired_end_results_has_pub$has_doi = F
  paired_end_results_has_pub$has_pubmed = F
  
  for(i in 1:nrow(paired_end_results_has_pub)){
    
    url2 = paste0('https://www.ncbi.nlm.nih.gov/pubmed/?term=',gsub("[ ]","+",str_split(paired_end_results_has_pub$publication[i], "\"")[[1]][2]))
    #url2='https://www.ncbi.nlm.nih.gov/pubmed/?term=Negative+feedback+buffers+effects+of+regulatory+variants'
    webpage2 <- read_html(url2)
    
    hrefs = webpage2 %>%
      rvest::html_nodes("a") %>%
      rvest::html_attr("href")
    
    doi_links = hrefs %>% str_subset(".doi")
    pub_links = hrefs %>% str_subset("https://www.ncbi.nlm.nih.gov/pmc/articles/")
    
    doi_links[1]
    pub_links[1]
    if(length(doi_links) > 0){
      paired_end_results_has_pub$has_doi[i] = doi_links[1]
    }else{
      paired_end_results_has_pub$has_doi[i] = F
    }
    
    if(length(pub_links) > 0){
      paired_end_results_has_pub$has_pubmed[i] = T
      pubmed_paragraph_text <- read_html(pub_links[1])%>%
        rvest::html_nodes("p") %>% 
        html_text() %>% 
        str_replace_all("\t", " ") %>% unlist() %>% 
        str_replace_all("\n", " ") %>% unlist()
      
      paired_end_results_has_pub$strand_text[i] = search_pubmed_text(pubmed_paragraph_text, search_string="strand")
      paired_end_results_has_pub$direction_text[i] = search_pubmed_text(pubmed_paragraph_text, search_string="direction")
      paired_end_results_has_pub$library_text[i] = search_pubmed_text(pubmed_paragraph_text, search_string="librar")
      paired_end_results_has_pub$kit_text[i] = search_pubmed_text(pubmed_paragraph_text, search_string="kit")
    }
    #i=i+1
  }
  
  write.table(paired_end_results_has_pub, paste0(species, "_paired_end_pubs.txt"), sep="\t", row.names = F)
}


### once annotated, create script to download files
for(species in c("yeast","human", "arabidopsis")){
  studies_with_pubs = fread(paste0(species, "_paired_end_pubs.txt"), data.table = F)
  studies_with_pubs = studies_with_pubs[which(!is.na(studies_with_pubs$Stranded) & studies_with_pubs$Stranded != ''),]
  studies_with_pubs = studies_with_pubs[!duplicated(studies_with_pubs$publication),]
  paired_end_results = fread(paste0(species, "_rnaseq.txt"), data.table = F)
  
  keep = vector()
  for(i in 1:nrow(studies_with_pubs)){
    keep = c(keep, which(paired_end_results$study_accession == studies_with_pubs$study_accession[i])[1:3])
  }
  
  download_fastq = paired_end_results[keep,]
  download_fastq = download_fastq[grep("_1.fastq.gz",download_fastq$fastq_ftp),]
  download_fastq$read_1 = halpme::strv_split(download_fastq$fastq_ftp, ";", 1)
  download_fastq$read_2 = halpme::strv_split(download_fastq$fastq_ftp, ";", 2)
  
  download_scripts = paste0('wget ', download_fastq$read_1, "; ", "wget ", download_fastq$read_2, ";")
  write.table(download_scripts, file=paste0(species, "_download.sh"), quote=F, row.names=F, col.names=F,sep='\n')
  
  
}
