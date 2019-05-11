library(tidyverse)
library(readtext)
library(quanteda)
library(topicmodels)

# read in the data
textlist <- readtext(file = "./New_York_Times_Data")

# deal with one sample document first
sample <- corpus(textlist[1,2])

# separate each txt file into individual documents
sep_doc <- corpus_segment(sample, "____________________________________________________________")

# Create document feature matrix
doc_features <- dfm(sep_doc, 
                    remove=stopwords("english"),
                    stem = T, 
                    remove_punct = T)

# run LDA to discover the possible topics
dtm <- convert(doc_features, to = "topicmodels")
lda <- LDA(dtm, k=10)

lda_terms <- terms(lda, 10)
lda_topics <- topics(lda)

# See what is in the data
kwic(sep_doc, pattern = "China")

library(stringi)
library(LDAvis)

phi <- posterior(lda)$terms
theta <- posterior(lda)$topics
vocab <- colnames(phi)
doc_length <- ntoken(doc_features)
freq_matrix <- data.frame(ST = colnames(dtm),
                          Freq = colSums(as.matrix(dtm)))

json_lda <- LDAvis::createJSON(phi = phi, theta = theta, vocab = vocab,
                               doc.length = doc_length,
                               term.frequency = freq_matrix$Freq)

serVis(json_lda)
