# WEBSCRAPING FOR DUMMIES

In general, I was following this blog as a starting point: 
https://www.analyticsvidhya.com/blog/2017/03/beginners-guide-on-web-scraping-in-r-using-rvest-with-hands-on-knowledge/
1. Check this WONDERFUL website: https://flukeout.github.io/#
    Here you can learn some basics of CSS that can really be helpful, while having fun with a nice game :D
2. Find a page that interests you to analyse deeper. Here I used the page from IMDb for the most rated movies of 2016
3. Open the developer's view of the page: Usually, something in the top corner of the browser, hidden somewhere in the "Extra tools". It is usually called "Developer tools" or similar, I guess it depends on the browser
4. Check the elements you need for scraping. You can either go into the Java code and check what you need (it will be selected on the page), or you can click on with the left click of your mouse on "Inspect" and you will find the corresponding piece of code of the item you selected to be inspected
5. With the help of the library "rvest", one can use simple commands to load the elements in RStudio
