library(rvest)

# Define the url of the page you want to scrape
url <- 'http://www.imdb.com/search/title?count=100&release_date=2016,2016&title_type=feature'
webpage <- read_html(url)

# Access the data and transform them to text
rank_data_html <- html_nodes(webpage, '.text-primary')
rank_data <- html_text(rank_data_html)

rank_title_html <- html_nodes(webpage, '.lister-item-header a')
rank_title <- html_text(rank_title_html)

rank_runtime_html <- html_nodes(webpage, '.text-muted span.runtime')
rank_runtime <- html_text(rank_runtime_html)

rank_genre_html <- html_nodes(webpage, '.text-muted span.genre')
rank_genre <- html_text(rank_genre_html)

#----------------------------------------------------------------------------- #

# Define the url of the page you want to scrape
# The %s at the end is due to the fact that we are going to loop over the pages
new_url <- "https://www.imdb.com/list/ls058011111/?sort=list_order,asc&mode=detail&page=%s"

table <- data.table()
dt <- data.table()

i <- 1

while (i < 11) {
  # Read the page with the increasing index
  new_webpage <- read_html(sprintf(new_url, i))
  
  # Access the data and transform them to text
  # Rank of the actress/actor
  rank_html <- html_nodes(new_webpage, '.text-primary')
  rank <- html_text(rank_html)
  rank <- as.numeric(gsub(",", "", rank))
  # Name of the actress/actor
  name_html <- html_nodes(new_webpage, '.lister-item-header a')
  name <- gsub(pattern = "\n", replacement = "", x = html_text(name_html))
  # Gender of the actress/actor
  gender_html <- html_nodes(new_webpage, '.text-muted.text-small')
  gender <- gsub(pattern = " ", replacement = "", x = html_text(gender_html))
  gender <- gsub("\n", "", x = gender)
  gender <- sapply(strsplit(x = gender, split = "|", fixed = TRUE), '[', 1)
  
  # Make a table of ouf the data and rbind them together
  table <- data.table(name = name,
                      gender = ifelse(gender == "Actress", "Female", "Male"),
                      rank = rank)
  dt <- rbind(dt, table)
  
  i <- i + 1
}

ggplot(data = dt) +
  geom_bar(aes(y = rank, fill = gender), orientation = "y") +
  coord_trans(y = "log") + 
  ggtitle("Rank of actresses and actors in log scale")
