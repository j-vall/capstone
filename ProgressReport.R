

# Data Processing

### Download and extract:

download.file("https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip",temp)
unzip(zipfile="files.zip",exdir="./temp")

### read data

blog<-readLines("./final/en_US/en_US.blogs.txt")

### Analysing the data

# create and save sample
b1<-sample(blog,10000)
writeLines(b1,"b1/b1.txt")

# create corpus from sample
blog.vector <- VectorSource(b1)
blog.corpus <- Corpus(blog.vector)

# transform
blog.corpus <- tm_map(blog.corpus, tolower)
blog.corpus <- tm_map(blog.corpus, removeNumbers)
blog.corpus <- tm_map(blog.corpus, removePunctuation)
blog.corpus <- tm_map(blog.corpus, PlainTextDocument)

# create DTM
dtm<-DocumentTermMatrix(blog.corpus)

# get frequencies and sort
freq<-sort(colSums(as.matrix(dtm)),decreasing=TRUE)

# create data frame
wf <- data.frame(word=names(freq), freq=freq)

# generate histogram
library(ggplot2)
p <- ggplot(subset(wf, freq>1000), aes(word, freq))
p <- p + geom_bar(stat="identity")
p <- p + theme(axis.text.x=element_text(angle=45, hjust=1))
p

# remove stop words
blog.corpus <- tm_map(blog.corpus, removeWords, stopwords("english"))

# repeat steps to get a new histogram excluding stop words
dtm<-DocumentTermMatrix(blog.corpus)
freq<-sort(colSums(as.matrix(dtm)),decreasing=TRUE)
wf <- data.frame(word=names(freq), freq=freq)
p <- ggplot(subset(wf, freq>500), aes(word, freq))
p <- p + geom_bar(stat="identity")
p <- p + theme(axis.text.x=element_text(angle=45, hjust=1))
p

`