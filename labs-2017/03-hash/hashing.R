# load libraries
library(rvest) # web scraping
library(stringr) # string manipulation
library(dplyr) # data manipulation
library(tidyr) # tidy data
library(purrr) # functional programming
library(scales) # formatting for rmd output
library(ggplot2) # plots
library(numbers) # divisors function
library(textreuse) # detecting text reuse and 
# document similarity

# get beatles lyrics 
links <- read_html("http://www.metrolyrics.com/beatles-lyrics.html") %>% # lyrics site
  html_nodes("td a") # get all links to all songs

# get all the links to song lyrics
tibble(name = links %>% html_text(trim = TRUE) %>% str_replace(" Lyrics", ""), # get song names
       url = links %>% html_attr("href")) -> songs # get links

# get beatles lyrics 
links <- read_html("http://www.metrolyrics.com/beatles-lyrics.html") %>% # lyrics site
  html_nodes("td a") # get all links to all songs

# get all the links to song lyrics
tibble(name = links %>% html_text(trim = TRUE) %>% str_replace(" Lyrics", ""), # get song names
       url = links %>% html_attr("href")) -> songs # get links

# function to extract lyric text from individual sites
get_lyrics <- function(url){
  test <- try(url %>% read_html(), silent=T)
  if ("try-error" %in% class(test)) {
    # if you can't go to the link, return NA
    return(NA)
  } else
    url %>% read_html() %>%
      html_nodes(".verse") %>% # this is the text
      html_text() -> words
    
    words %>%
    paste(collapse = ' ') %>% # paste all paragraphs together as one string
      str_replace_all("[\r\n]" , ". ") %>% # remove newline chars
      return()
}

# get all the lyrics
# remove duplicates and broken links
songs %>%
  mutate(lyrics = (map_chr(url, get_lyrics))) %>%
  filter(nchar(lyrics) > 0) %>% #remove broken links
  group_by(name) %>% 
  mutate(num_copy = n()) %>%
  filter(num_copy == 1) %>% # remove exact duplicates (by name)
  select(-num_copy) -> songs 
  
# get k = 5 shingles for "Eleanor Rigby"
best_song <- songs %>% filter(name == "Eleanor Rigby") # this song is the best
shingles <- tokenize_ngrams(best_song$lyrics, n = 5) # shingle the lyrics

# inspect results
head(shingles) 

# add shingles to each song
# note mutate adds new variables and preserves existing
songs %>%
  mutate(shingles = (map(lyrics, tokenize_ngrams, n = 3))) -> songs
  
# create all pairs to compare then get the jacard similarity of each
# start by first getting all possible combinations
song_sim <- expand.grid(song1 = seq_len(nrow(songs)), song2 = seq_len(nrow(songs))) %>%
  filter(song1 < song2) %>% # don't need to compare the same things twice
  group_by(song1, song2) %>% # converts to a grouped table
  mutate(jaccard_sim = jaccard_similarity(songs$shingles[song1][[1]], 
                                          songs$shingles[song2][[1]])) %>%
  ungroup() %>%  # Undoes the grouping
  mutate(song1 = songs$name[song1],    
         song2 = songs$name[song2]) # store the names, not "id"

# inspect results
summary(song_sim)  

#Heat plot of the Jaccard similarity scores for the pairwise comparison of #each song. This plot has each song on the $x$ and $y$ axis, the colors then #correspond to the similarity score of that pair. Light blue indicates higher #similarity and dark blue lower similarity. It appears there are a few pairings #with high similarity

# plot of similarity scores
ggplot(song_sim) + # use ggplot2
  geom_raster(aes(song1, song2, fill = jaccard_sim)) + # tile plot
  theme(axis.text.x = element_text(angle = 90, hjust = 1, size = 4), 
        axis.text.y = element_text(size = 4),
        aspect.ratio = 1) # fix aixs labels
        
        
# filter high similarity pairs
song_sim %>%
  filter(jaccard_sim > .5)  # only look at those with similarity > .5
  
  
 # inspect lyrics
print(songs$lyrics[songs$name == "In My Life"])
print(songs$lyrics[songs$name == "There are places I remember"]) 

# filter to find the most similar songs
song_sim %>%
  filter(jaccard_sim <= .5) %>%
  arrange(desc(jaccard_sim)) %>% # sort by similarity
  head() 
  
  
  
 # build the corpus using textreuse
docs <- songs$lyrics
names(docs) <- songs$name # named vector for document ids
corpus <- TextReuseCorpus(text = docs, 
                          tokenizer = tokenize_ngrams, n = 3, 
                          progress = FALSE,
                          keep_tokens = TRUE)

# create the comparisons
comparisons <- pairwise_compare(corpus, jaccard_similarity, progress = FALSE)
comparisons[1:3, 1:3]

# look at only those comparisons with Jaccard similarity > .1
candidates <- pairwise_candidates(comparisons)
candidates[candidates$score > 0.1, ] 

# look at the hashed shingles for "Eleanor Rigby"
tokens(corpus)$`Eleanor Rigby` %>% head()
hashes(corpus)$`Eleanor Rigby` %>% head()


# manually hash shingles
songs %>%
  mutate(hash = (map(shingles, hash_string))) -> songs

# note by using the "map" function, we have a list column
# for details, see purrr documentation

songs$hash[songs$name == "Eleanor Rigby"][[1]] %>% head()


# compute jaccard similarity on hashes instead of shingled lyrics
# add this column to our song data.frame
song_sim %>%
  group_by(song1, song2) %>% mutate(jaccard_sim_hash = jaccard_similarity(songs$hash[songs$name == song1][[1]], songs$hash[songs$name == song2][[1]])) -> song_sim

# how many songs do the jaccard similarity computed from hashing
# versus the actual shingles NOT match?
sum(song_sim$jaccard_sim != song_sim$jaccard_sim_hash)
      