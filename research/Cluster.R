library(tidyverse)
library(readtext)
library(quanteda)
library(topicmodels)
library(stringr)

# read in the data
textlist <- readtext(file = "./New_York_Times_Data")


# deal with one sample document first
sample <- corpus(textlist[1,2])
text <- textlist[1,2]

sep_text <- str_split(text, pattern = boundary(type="line_break"))


# separate each txt file into individual documents
sep_doc <- corpus_segment(sample, "____________________________________________________________")

# Create document feature matrix
doc_features <- dfm(sep_doc, 
                    remove=stopwords("english"),
                    stem = T, 
                    remove_punct = T)
