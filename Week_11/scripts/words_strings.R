#### General Info ####----------------------
# 
#
#
# created: 2023-04-18
# created by: Marisa Mackie

#### Load Libraries ####---------------------
library(tidyverse)
library(tidytext)
library(wordcloud2)
library(janeaustenr)
library(stopwords)

#### Intro to stringr--------

# string and character are the same thing

# quotation marks indicate a string
words <- "This is a string"

# vectors of strings
words_vector <- c("Apples", "Bananas", "Oranges")

### Tools Overview--------
# Manipulation functions
# Whitespace tools
# Locale sensitive operations
# Pattern matching functions

### Manipulation--------

# paste words together; useful in columns of characters
paste("High temp","Low pH")

# you can add different separators between words
paste("High temp", "Low pH", sep = "-")

# removes space between words
paste0("High temp, Low pH")

# Can apply paste to all items within a vector
shapes <- c("Square", "Circle", "Triangle")
paste("My favorite shape is a", shapes)

# You can paste stuff before, after, between items in a vector
two_cities <- c("best","worst")
paste("It was the", two_cities, "of times.")

# Returns how many letters in each string within vector
str_length(shapes)

# you can modify strings; remove characters
# example: extract 2nd to 4th letter
seq_data <- c("ATCCCGTC")
str_sub(seq_data, start = 2, end = 4)

# you can modify strings; changes characters
# example: substitutes an A to the 3rd position
str_sub(seq_data, start = 3, end = 3) <- "A"
seq_data

# can duplicate patterns in strings
str_dup(seq_data, times = c(2,3)) # duplicating it 2 and 3 times


### Whitespace----------

# mistakes, for example "High" vs " High" vs "High " are all unique values
# want to remove the whitespaces

bad <- c("High", " High", "High ", "Low")

# removes any whitespace on either side of string
str_trim(bad)

# you can pad white space to either side
# example: add white space to the 5th position on the right side
# note: if there is already somethin in the 5th position, it will not overwrite
str_pad(bad, 5, side = "right")

# you can add characters instead of white space
# note: will also add padding if there is gap between position & end of string; see "Low11"
str_pad(bad, 5, side = "right", pad = "1")


### Locale sensitive--------
# Will perform differently in in different languages.

# make everything upper case
x <- "I love R!"
str_to_upper(x)

# make everything lower case
str_to_lower(x)

# title case (capitalizes first letter of each word)
str_to_title(x)

### Pattern matching--------
# Can view, detect, locate, extract, match, replace, and split strings based on patterns

data <- c("AAA", "TATA", "CTAG", "GCTT")

# find all strings with an A
str_view(data, pattern = "A")

# logical: returns true or false if pattern matches data
str_detect(data, pattern = "A")

# Find exact location (start & end) that the pattern appears
# NA = pattern not present in that string
str_locate(data, pattern = "A")


#### regex: regular expressions--------
# Types:
# metacharacters
# sequences
# quantifiers
# character classes
# POSIX character classes (Portable Operating System Interface)

### Metacharacters-----
# .\^$*+?|(){}[]

# Using \\ with metacharacter tells R that you want to use the character in the way you want it, not the way R wants it
# telling R to "take this at face value"

# example:
vals <- c("a.b","b.c","c.d")

# tells R that when it sees a period, replace it with a white space
# you must put the backslashes so that it knows what you want to replace
str_replace(vals, "\\.", " ")

# Note: str_replace will replace only the first instance it finds
vals <- c("a.b.c","b.c.d","c.d.e")
str_replace(vals, "\\.", " ")

# Use str_replace_all to replace ALL instances it finds
str_replace_all(vals, "\\.", " ")

### Sequences-----
# \\d =
# \\D =
# \\s =
# \\S =
# \\w =
# \\W =
# \\b =
# \\B =
# \\h =
# \\H =
# \\v =
# \\V =


val2 <- c("test 123","test456", "test")

# keeps only things that have digits in them (numbers)
str_subset(val2, "\\d")

### Character class--------
#
# [aeiou]
# [AEIOU]
# [0123456789]
# [0-9]
# [a-z]
# [A-Z]
# [a-zA-Z0-9]
# [^aeiou]
# [^0-9]

str_count(val2, [aeiou])

str_count(val2, [0-9])

### QUantifiers-----
# ^ beginning of string
# $ end of string
# \n = new line
# + = 
# * = 
# ? =
# 
#

# Example: Make a regex that finds all the strings that contain a phone number. 
# We know there is a specific pattern (3 numbers, 3 numbers, 4 numbers 
# and it can have either a "." or "-" to separate them). 
# Let's also say we know that the first number cannot be a 1
strings <- c("550-153-7578",
             "banana",
             "435.114.77586",
             "home: 672-442-6739")

# ([2-9][0-9]{2}) = Find number 2-9 for digit 1, number 0-9 for the next 2 digits
# [- .] = separated by - and .
# 
phone <- "([2-9][0-9]{2})[- .]([0-9]{3})[- .]([0-9]{4})"

test <- str_subset(strings, phone)
test

# new example:
string <- c("444.5694.92","126.4971.34")

num <- "([0-9]{3})[.]([0-9]{4})[.]([0-9]{2})"

str_subset(string, num)

# Challenge:
# Let's clean it up. Lets replace all the "." with "-" and extract only the numbers 
# (leaving the letters behind). Remove any extra white space. 
# You can use a sequence of pipes.

# my solution:
test %>% 
  str_replace_all("\\D"," ") %>% # removes all non-digit characters with spaces
  str_trim() %>% # removes white spaces on ends
  str_replace_all(" ", "-" ) # replaces all spaces with dashes

# Nyssa's solution:
test %>%
  str_replace_all(pattern = "\\.", replacement = "-") %>% # replace periods with -
  str_replace_all(pattern = "[a-zA-Z]|\\:", replacement = "") %>% # remove all the things we don't want
  str_trim() # trim the white space


#### Intro to tidytext--------
# NOTE: DO NOT USE VIEW() WITH JANE AUSTEN BOOKS. TOO MUCH DATA. CRASHES COMPUTER.

head(austen_books())

# let's add a column for line & chapter of book
original_books <- austen_books() %>% # gets all books
  group_by(book) %>% 
  mutate(line = row_number(),
         chapter = cumsum(str_detect(text, regex("^chapter [\\divxlc]", # count the chapters (starts with the word chapter followed by a digit or roman numeral)
                                                 ignore_case = TRUE)))) %>%  # ignore upper or lower case
ungroup() # ungroup it so we have a dataframe again
# don't try to view the entire thing... its >73000 lines...
head(original_books)

# Clean data so word per row is tidy
tidy_books <- original_books %>%
  unnest_tokens(output = word, input = text) # add a column named word, with the input as the text column
head(tidy_books) # there are now >725,000 rows.

# Can get the "stop words" i.e. filler words like "and" "in" "I" etc.
head(get_stopwords())

# remove stopwords from books
cleaned_books <- tidy_books %>%
  anti_join(get_stopwords()) # creates dataframe without stopwords

head(cleaned_books)

# count number of times each word is used, sort highest to lowest
cleaned_books %>%
  count(word, sort = TRUE)

# get based on sentiments (connotation of word)
sent_word_counts <- tidy_books %>%
  inner_join(get_sentiments()) %>% # only keep words with positive or negative sentiments
  count(word, sentiment, sort = TRUE) # count them

# plot to visualize counts of positive & negative words
sent_word_counts %>%
  filter(n > 150) %>% # take only if there are over 150 instances of it
  mutate(n = ifelse(sentiment == "negative", -n, n)) %>% # add a column where if the word is negative make the count negative
  mutate(word = reorder(word, n)) %>% # sort it so it gows from largest to smallest
  ggplot(aes(word, n, fill = sentiment)) +
  geom_col() +
  coord_flip() +
  labs(y = "Contribution to sentiment")

### Make a word cloud-----
words<-cleaned_books %>%
  count(word) %>% # count all the words
  arrange(desc(n))%>% # sort the words
  slice(1:100) #take the top 100
wordcloud2(words, shape = 'triangle', size=0.3) # make a wordcloud out of the top 100 words

