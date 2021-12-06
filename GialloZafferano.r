######################### RECIPES FOR NICE MEAL IDEAS ##########################

library(rvest)
library(data.table)

# Define the url of the page you want to scrape
# The %s at the end is due to the fact that we are going to loop over the pages
categories <- c("Antipasti/", "Primi/", "Secondi-piatti/")

recipe_list <- list()

# For each category, we will extract all the recipes in a page, for a total of
# 3 pages (ca. 50 recipes for each category)
for (category in categories) {
  
  new_url <- paste0("https://www.giallozafferano.it/ricette-cat/", 
                    category, "page%s")
  
  # This is the index over which we will loop to go over many pages
  j <- 1
  
  while (j < 5) {
    # Read the page with the increasing index
    new_webpage <- html_session(sprintf(new_url, j))
    # Get the content of the box where the title and the url of the recipe is
    recipes_html <- html_nodes(new_webpage, '.gz-title')
    
    # Get the recipe names
    recipe_names <- html_text(recipes_html)
    # Get the recipe URLs to access them
    recipes_url <- html_attr(html_nodes(recipes_html, xpath = "./a"), "href")

    # Fill the recipes    
    for (i in 1:length(recipes_url)) {
      # Go to the page of a specific recipe
      spesa_page <- jump_to(new_webpage, recipes_url[[i]])
      # Get the ingredients
      ingredients_html <- html_nodes(spesa_page, '.gz-list-ingredients a')
      ingredients <- html_text(ingredients_html)
      # Get the quantities
      quantities_html <- html_nodes(spesa_page, '.gz-list-ingredients span')
      quantities <- grep("\n\t", html_text(quantities_html), value = TRUE)
      quantities <- gsub("\n", "", gsub("\t", "", quantities))
      # Put them into a data table
      tmp_recipe <- data.table(name = recipe_names[[i]],
                               ingredients = ingredients,
                               quantities  = quantities,
                               category = gsub("/", "", category))
      if (nrow(tmp_recipe) == 0) {
        next()
      }
      # Fill the list of recipe and set the recipe name as name of that list
      # recipe <- list(tmp_recipe)
      # names(recipe) <- recipe_names[[i]]
      # Append to the main list
      recipe_list <- rbind(recipe_list, tmp_recipe)
    }
    
    j <- j + 1
  }
  
}

fwrite(recipe_list, "~/Desktop/Projects/WebScrapingExercises/recipe_list.csv")


# Recipe categories (NOT FINISHED YET!)
# recipes_category_html <- html_nodes(new_webpage, '.gz-category')
# recipes_category_url <- html_attr(html_nodes(recipes_category_html, xpath = "./a"), "href")
# recipes_category <- gsub("/", "", gsub("/ricette-cat/", "", recipes_category_url))

# ----------------
# Non riesco ad accedere al mio account
# page <- rvest:::request_POST(page, url = "https://www.giallozafferano.it/utente/login",
#                              body = list("username" = "saracerioli91",
#                                          "password" = "webScraping1",
#                                          "redirect_url" = "https://www.giallozafferano.it/utente/"))
# 
# 
# ingredient <- html_nodes(page, '.gz-user-page, div')
# ingredient <- html_text(ingredient)



