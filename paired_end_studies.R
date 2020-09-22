library(rvest)
library(stringr)
library(data.table)

paired_end_results = fread("paired_end.txt", data.table = F)

paired_end_results_study = paired_end_results[!duplicated(paired_end_results$study_accession),]

# random sort 

set.seed(21)
paired_end_results_study_random = paired_end_results_study[sample(1:nrow(paired_end_results_study), nrow(paired_end_results_study)),]

paired_end_results_study_random$has_publication = F
paired_end_results_study_random$publication = NA
for(i in 1:200){
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
}

search_pubmed_text = function(pubmed_paragraph_text, search_string){
  locs = str_locate_all(tolower(pubmed_paragraph_text), search_string)
  has_match = which(unlist(lapply(locs, function(x) dim(x)[1] > 0)))
  pubmed_paragraph_text.searched = pubmed_paragraph_text[has_match]
  searched_sentences = unlist(str_split((pubmed_paragraph_text.searched), "[.][ ]"))
  return(str_c(searched_sentences[str_detect(tolower(searched_sentences), search_string)], collapse=";"))
}

paired_end_results_has_pub = paired_end_results_study_random[which(paired_end_results_study_random$has_publication == T),]
paired_end_results_has_pub$strand_text = NA
paired_end_results_has_pub$direction_text = NA
paired_end_results_has_pub$library_text = NA
paired_end_results_has_pub$kit_text = NA

paired_end_results_has_pub$has_doi = F
paired_end_results_has_pub$has_pubmed = F

for(i in 1:50){

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

write.table(paired_end_results_has_pub, "paired_end_pubs.txt", sep="\t", row.names = F)

