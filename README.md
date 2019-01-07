Problem

You're a successful Shopify merchant with many collections of products! You’d like to keep an eye on your collections. Let’s create an app that displays a Custom Collections list page and a Collection Details page. Your app will fetch the data from the Shopify Custom Collections REST API.

Custom Collections list page: A simple list of every custom collection (e.g. In our above response you will see we will need cells for: Aerodynamic, Durable and Small). Tapping on a collection launches the Collection Details page. 

Collection Details page: A list of every product for a specific collection. 

Each row in the list needs to contain, at a minimum: 

The name of the product

The total available inventory across all variants of the product

The collection title

The collection image


To fetch the products for a custom collection you will need to retrieve the list of collects in a specific collection first :
https://shopicruit.myshopify.com/admin/collects.json?collection_id=68424466488&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6

(replace collection_id with the appropriate id you retrieved from the collections list)

Then load the product details with each product_id in the collect list : 

https://shopicruit.myshopify.com/admin/products.json?ids=2759137027,2759143811&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6

(replace ids with the appropriate product ids separated by a comma)


Here are a couple simple libraries that you can use to fetch the data (these are optional, you can pick one or use any other alternative).

Android:
http://square.github.io/retrofit/
http://square.github.io/okhttp/
iOS:
https://github.com/Alamofire/Alamofire/ or just use URLSession

Extra

Feeling adventurous? In the Collection Details page add the collection details in a card at the top that contains the image, title and body_html of the selected collection. See if  you can make the details card height flexible to display the whole description.

What you need to submit:
A screenshot of your app showing the Custom Collections list page

A screenshot of your app showing the Collection Details page after clicking on “Aerodynamic” from the Custom Collections list page

Your project code (A link to your hosted version where it can be tested).

Please include a Zip file with your screenshots and submit a link for your working code in the “Mobile Challenge Submission” section of the application. 
