library(quanteda)
library(readtext)
library(readxl)
library(tidyverse)

metadata <- readxl::read_xls(path="./ProQuestDocuments-2019-04-27.xls")

sample <- readtext("ProQuestDocuments-2019-04-27 (1).txt")
corpus <- corpus(sample)

sep_doc <- corpus_segment(corpus, "____________________________________________________________")

# the last document is proQuest info
sep_doc <- corpus(sep_doc[-ndoc(sep_doc)])

docvars(sep_doc, "title") <- metadata$Title
docvars(sep_doc, "date") <- metadata$entryDate
docvars(sep_doc, "pages") <- metadata$pages

doc_feature <- dfm(sep_doc, remove = stopwords("English"), remove_punct = TRUE)

AFINN <- read.csv("./AFINN/AFINN-111.txt", sep = '\t', header = F)

vocab <- 
doc_feature %>% 
  dfm_weight() %>% 
  colnames()

weight_mat <- dfm_weight(doc_feature)

dfm1 <- weight_mat[,vocab%in%AFINN$V1]

dfm1 <- dfm1[,order(colnames(dfm1))]

AFINN <- AFINN[AFINN$V1%in%vocab,]

AFINN <- AFINN[order(AFINN$V1),]

weight <- AFINN$V2%*%t(dfm1)

# summing only the words that counts
docLength <- rowSums(dfm1)

norm_weight <- as.vector(weight) / unlist(docLength)

sep_doc$senti <- norm_weight

head(sep_doc[sep_doc$senti > 1])




