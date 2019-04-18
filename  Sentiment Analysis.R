library("readxl")
data1 = read_excel("data.xlsx")

library(textclean)
library(tidyr)
library(tidyverse)
library(tidytext)
library(glue)
library(stringr)

Strengths = gsub("[^A-Za-z///']" , "", data1$`Answer to the question`)
Strengths = gsub("$.*", "", data1$`Answer to the question`)
Strengths = gsub("#.*", "", data1$`Answer to the question`)
Strengths = gsub("%.*", "", data1$`Answer to the question`)
Strengths = replace_number(data1$`Answer to the question`, num.paste = TRUE, remove = TRUE)
head(Strengths,20)

# tokenize
tokens = data_frame(text = data1$`Answer to the question`) %>% unnest_tokens(word, text)

# get the sentiment from the data: 
sentiment_words = tokens %>%
  inner_join(get_sentiments("bing")) %>% # pull out only sentiment words
  count(sentiment) %>% # count the # of positive & negative words
  spread(sentiment, n, fill = 0) %>% # made data wide rather than narrow
  mutate(sentiment = positive - negative) # # of positive words - # of negative owrds

sentiment_words

library(syuzhet)
word.df = as.vector(Strengths)
emotion.df = get_nrc_sentiment(Strengths)
emotion.df2 = cbind(Strengths, emotion.df) ## The output shows us the different emotions present in each of the tweets.
head(emotion.df2)

sent.value = get_sentiment(word.df)
sent.value
most.positive = word.df[sent.value == max(sent.value)]
most.positive
most.negative = word.df[sent.value == min(sent.value)]
most.negative

## Segregating positive and negative comments
positive.comments = word.df[sent.value > 0]
head(positive.comments)
negative.comments = word.df[sent.value < 0]
head(negative.comments)
neutral.comments = word.df[sent.value == 0]
head(neutral.comments)

barplot(colSums(emotion.df), las = 2, ylim = c(0,3000), col = rainbow(10), ylab = 'Count', main = "sentiment analysis using syuzhet")










