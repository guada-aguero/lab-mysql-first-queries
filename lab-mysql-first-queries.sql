USE lab_mysql;
SELECT * 
FROM applestore2;
-- 1. Which are the different genres?
SELECT DISTINCT prime_genre
FROM applestore2;

-- 2. Which is the genre with more apps rated?
SELECT prime_genre
	  ,sum(rating_count_tot) AS num_of_ratings
FROM applestore2
GROUP by prime_genre
ORDER by num_of_ratings DESC;
/* The genre with more apps rated is Games with 52630139  ratings */

-- 3. Which is the genre with more apps?
SELECT prime_genre
	  ,count(id) as total_apps
FROM applestore2
GROUP by prime_genre
ORDER by total_apps DESC;
/* The genre with more apps  is Games with 3808  apps */

-- 4. Which is the one with less?
SELECT prime_genre
	  ,count(id) as total_apps
FROM applestore2
GROUP by prime_genre
ORDER by total_apps;
/* The genre with less apps  is Catalogs with 10  apps */

-- 5. Take the 10 apps most rated.
SELECT track_name
	  ,rating_count_tot
FROM applestore2
ORDER by rating_count_tot DESC
LIMIT 10;

-- 6. Take the 10 apps best rated by users.
SELECT track_name
      ,user_rating
FROM applestore2
ORDER by user_rating DESC
LIMIT 10;

-- 7. Take a look on the data you retrieved in the question 5. Give some insights.
/*We can see that, in general, the apps with most ratings are within the 'Social Networking', 'Games', and 'Music' genres, 
with a funny exception being the 'Bible', as the 7th most rated app, which I find absolutely hilarious */

-- 8. Take a look on the data you retrieved in the question 6. Give some insights.
/* This information can't really be considered as relevant given there are more than 10 apps with a 5 stars rating. To do a better analysis,
 we would need to consider the amount of ratings also. It is easier to have 5/5 on two reviews than on 1000.
It also cought my attention that there unknown track names (or parts of the name) showing as ????????. This could be due to encoding issues,
for example, when the names contain characters from other languages that aren't supported by the DB, but there could be other reasons */

-- 9. Now compare the data from questions 5 and 6. What do you see?
/* As I mentioned in question 8, we would need to consider these both results together, in order to be able to perform a more accurate or fair analysis of rating vs number or reviews*/

-- 10. How could you take the top 3 regarding the user ratings but also the number of votes?
SELECT track_name
	  ,user_rating
      ,rating_count_tot
FROM applestore2
ORDER by 2 DESC,3 DESC
LIMIT 3;

-- 11. Does people care about the price?** Do some queries, comment why are you doing them and the results you retrieve. What is your conclusion?

/* We can start by examining the distribution of free and paid apps in the database. */
SELECT 
    CASE 
        WHEN price = 0 THEN 'Free' 
        ELSE 'Paid' 
    END AS app_type,
    COUNT(*) AS count
FROM applestore2
GROUP BY app_type;
/*This query categorizes apps into 'Free' and 'Paid' based on their price and counts the number of apps in each category. 
This helps us understand the proportion of free versus paid apps.
We can see that there are about 30% more free apps*/

/*Then we can check the avg user rating for free and paid apps*/
SELECT
	CASE
	   WHEN price = 0 THEN 'Free'
       ELSE 'Paid'
	END AS app_type
    ,avg(user_rating) AS avg_rating
FROM applestore2
GROUP by app_type;
  /*This query calculates the average user rating for free and paid apps, allowing us to compare user satisfaction across these categories.
  We can see that, even thorugh the difference is not signifficant, actually paid apps have a slightly higher rating than free apps, 
  which could potentially suggest that users perceive paid apps as higher quality or more valuable, influencing their ratings.*/
  
/*We can now look at the average number of ratings for free and paid apps.*/
SELECT
	CASE
		WHEN price = 0 THEN 'Free'
        ELSE 'Paid'
	END AS app_type
    ,avg(rating_count_tot) AS avg_total_ratings
FROM applestore2
GROUP by app_type;
/*This query calculates the average number of ratings for free and paid apps, giving insight into user engagement with each category.
We can see here, that free apps receive significantly more ratings on average than paid apps, suggesting that they attract more users, which is expected as there is no cost barrier to try them.*/

/*To understand the direct relationship between price and user rating, we can analyze the correlation.*/
SELECT 
     price
    ,AVG(user_rating) AS avg_rating
    ,AVG(rating_count_tot) AS avg_total_ratings
FROM applestore2
GROUP BY price
ORDER BY price;
/*This query calculates the average user rating and the average number of ratings for each distinct price point, ordered by price. This helps identify trends across different price points.
The correlation between price and user rating is not significant, suggesting that while there might be a slight tendency for more expensive apps to be rated higher, it is not a strong relationship.
*/

/*CONCLUSIONS: 
 Users tend to engage more with free apps, as evidenced by the higher number of ratings. However, paid apps generally receive higher average ratings, 
 indicating that users might perceive them as higher quality or more valuable. Despite this, the weak correlation between price and user rating 
 suggests that price is not a major factor in determining user satisfaction.*/
