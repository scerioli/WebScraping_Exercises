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




# Interesting for the future: Screenplays of many IMDb movies
# https://www.imsdb.com/