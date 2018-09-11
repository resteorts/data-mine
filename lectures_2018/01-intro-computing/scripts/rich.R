setwd("~/Dropbox/350-F14/labs/03-text")

# part I of scrape the rich 

rich <- readLines("rich.html")
length(rich) # number of lines of the text
sum(nchar(rich)) # total number of characters in the text

# Find the entries for Bill Gates and Stanley Kroneke. Give the text of the lines from the file recording their net worth. 
# Bill Gates 72 B, Stanely K, 5.3 B

# Write a regular expression to capture a person's net worth 

