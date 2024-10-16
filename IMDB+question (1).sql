USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT COUNT(*) FROM DIRECTOR_MAPPING;
-- Number of rows in director_mapping 3867

SELECT COUNT(*) FROM GENRE;
-- Number of rows in genre 14662

SELECT COUNT(*) FROM MOVIE;
-- Number of rows in movie 7997

SELECT COUNT(*) FROM NAMES;
-- Number of rows in names 25735

SELECT COUNT(*) FROM RATINGS;
-- Number of rows in ratings 7997

SELECT COUNT(*) FROM ROLE_MAPPING;
-- Number of rows in role_mapping 15615


-- Q2. Which columns in the movie table have null values?
-- Type your code below:

-- Code for find out columns in the movie table have null values
SELECT 
    COUNT(CASE WHEN id IS NULL THEN 1 END) AS ID_NULL_COUNT,
    COUNT(CASE WHEN title IS NULL THEN 1 END) AS title_NULL_COUNT,
    COUNT(CASE WHEN year IS NULL THEN 1 END) AS year_NULL_COUNT,
    COUNT(CASE WHEN date_published IS NULL THEN 1 END) AS date_published_NULL_COUNT,
    COUNT(CASE WHEN duration IS NULL THEN 1 END) AS duration_NULL_COUNT,
    COUNT(CASE WHEN country IS NULL THEN 1 END) AS country_NULL_COUNT,
    COUNT(CASE WHEN worlwide_gross_income IS NULL THEN 1 END) AS worlwide_gross_income_NULL_COUNT,
    COUNT(CASE WHEN languages IS NULL THEN 1 END) AS languages_NULL_COUNT,
    COUNT(CASE WHEN production_company IS NULL THEN 1 END) AS production_company_NULL_COUNT
FROM movie;

-- four columns in movie table have the null values
-- column id,title,year,data_published,duration have no null values 
-- columns country=20,worlwide_gross_income=3724, languages=194,production_company=528 have null values as mention



-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- code to find out the Number of movies released each year
SELECT Year, 
       COUNT(id) AS number_of_movies
FROM    movie
        GROUP BY Year;
-- Most number of movies released in 2017


-- code to find out the Number of movies released each month
SELECT MONTH(date_published) AS month_num,
       COUNT(id) AS number_of_movies
FROM   movie
       GROUP BY month_num
	   ORDER BY month_num;
-- Most number of movies month-wise released in March month



/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

-- Code to find out the number of movies were produced in the USA or India in the year 2019
SELECT COUNT(DISTINCT id) AS number_of_movies, 
       year
FROM   movie
WHERE (country LIKE '%USA%'
        OR country LIKE '%INDIA%')
        AND year = 2019;

-- In the year 2019, 1059 number of movies were produced in the USA or India 


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

-- Code to find out the unique genre present in the dataset
SELECT DISTINCT genre
FROM   genre;

-- There are 13 genre in the dataset



/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

-- Code to find out the Which genre had the highest number of movies produced overall
SELECT genre, 
	   COUNT(m.id) AS number_of_movies
FROM   movie m
        INNER JOIN
	  genre g ON m.id = g.movie_id
	  GROUP BY genre
      ORDER BY number_of_movies DESC
	  LIMIT 1;

-- "Drama" genre had the highest number of movies 4285 produced overall



/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

-- Code to find out the number of movies belongs to each genre
WITH movies_with_one_genre AS
 (
    SELECT movie_id
    FROM   genre
           GROUP BY movie_id
		   HAVING COUNT(DISTINCT genre) = 1
)
SELECT COUNT(DISTINCT movie_id) AS unique_movies_with_one_genre
FROM   movies_with_one_genre;

-- 3289 movies belongs to each genre


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


-- Code to find out the the average duration of movies in each genre
 SELECT 
    genre, ROUND(AVG(duration), 2) AS avg_duration
FROM
    movie m
        INNER JOIN
    genre g ON m.id = g.movie_id
GROUP BY genre
ORDER BY avg_duration DESC;

-- "Action" genre have the highest average duration 112.88 of movies
-- "Horror" genre have the least average duration 92.72 of movies



/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

-- Code to find out the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced
WITH genre_details AS
 (

SELECT genre,
       COUNT(movie_id) as movie_count,
       RANK() OVER(ORDER BY count(movie_id)  desc) AS genre_rank
FROM genre
GROUP BY genre
)
SELECT * FROM genre_details  WHERE genre="Thriller";

-- The rank of the "Thriller"genre is 3 among all the genre


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/



-- Segment 2:




-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:


-- Code to find out the min and max value of avg_rating,total_votes,median rating
SELECT MIN(avg_rating) AS min_avg_rating,
       MAX(avg_rating) AS max_avg_rating,
       MIN(total_votes) AS min_total_votes,
       MAX(total_votes) AS max_total_votes,
       MIN(median_rating) AS min_median_rating,
       MAX(median_rating) AS max_median_rating
FROM ratings;

-- min(avg_rating)= 0 ,max(avg_rating= 5
-- min(total_votes)= 177, max(total_votes)= 2000
-- min(median_rating)= 0 , max(median_raing)= 8

    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

-- Code to find out the top 10 movies based on average rating
SELECT title,
	   avg_rating,
       RANK() OVER(ORDER BY avg_rating DESC) AS movie_rank
FROM   ratings r
	   INNER JOIN
       movie m
       ON r.movie_id=m.id
       LIMIT 10;
    
    -- title "Kirket" have the highest avg_rating 10
    

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

-- Code to find out the ratings table based on the movie counts by median ratings
SELECT  median_rating,
       COUNT(movie_id) as movie_count
FROM   ratings
	   GROUP BY median_rating
       ORDER BY median_rating ;

-- movies with median rating 7 is highest as 2257


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:


-- Code to find out the production house has produced the most number of hit movies
WITH production_company_details AS 
(
SELECT production_company,
       COUNT(m.id) AS movie_count,
       RANK() OVER( ORDER BY COUNT(id) DESC) AS prod_company_rank
FROM   movie m
       INNER JOIN
       ratings r
       ON r.movie_id= m.id
WHERE  avg_rating > 8
	   AND production_company IS NOT NULL
       GROUP BY  production_company
       )
SELECT * FROM production_company_details
WHERE prod_company_rank=1;

-- "Dream Warrior Pictures" and "National Theatre Live" production company has produced the most number of hits movies


-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- movies released in each genre 
-- in march 2017
-- country USA 
-- votes > 1,000


-- Code to find out the movies released in each genre during March 2017 in the USA had more than 1,000 votes
SELECT genre,
       Count(m.id) AS movie_count
FROM   movie AS m
       INNER JOIN genre AS g
               ON g.movie_id = m.id
       INNER JOIN ratings AS r
               ON r.movie_id = m.id
WHERE  year = 2017
       AND Month(date_published) = 3
       AND country LIKE '%USA%'
       AND total_votes > 1000
GROUP  BY genre
ORDER  BY movie_count DESC; 

-- "Drama" genre released the highest number of movies during march 2017 in the USA had more than 1,000 votes
-- "family" genre released the least number of movies during march 2017 in the USA had more than 1,000 votes

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:


-- Code to find out the movies of each genre that start with the word ‘The’ and which have an average rating > 8
SELECT title,
       avg_rating,
       genre
FROM   movie AS m
       INNER JOIN genre AS g
		ON g.movie_id = m.id
	   INNER JOIN ratings AS r
		ON r.movie_id = m.id
WHERE  avg_rating > 8
       AND title LIKE 'THE%'
ORDER BY avg_rating DESC;

-- There are 15 movies of each genre that start with word "the"
-- "The Brighton Miracle" movie have the highest avg_rating 9.5


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:


-- Code to find out the movies released between 1 April 2018 and 1 April 2019 with median rating of 8
SELECT count(id) as Total_Movie,
	   median_rating
FROM  movie m
      INNER JOIN 
      ratings r 
      ON m.id=r.movie_id
WHERE  median_rating = 8
       AND date_published BETWEEN '2018-04-01' AND '2019-04-01'
       GROUP BY median_rating;
      
-- 361 movies released between 1 april and 1 april 2019 with median rating 8


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

-- code to find out the total_votes for both German and Italian movies
SELECT country,
       SUM(total_votes) AS total_votes
FROM   movie AS m
	   INNER JOIN ratings AS r
       ON m.id = r.movie_id
WHERE  country IN ('Germany', 'Italy')
	   GROUP By country;

-- Germany movies get the greater number of votes than the Italy movies



-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/




-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

-- Code to find out the null values in the "names" table
SELECT 	Sum(CASE WHEN  name IS NULL THEN 1 ELSE 0 END) AS name_nulls,
		Sum(CASE WHEN  height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
		Sum(CASE WHEN  date_of_birth  IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
		Sum(CASE WHEN  known_for_movies  IS NULL THEN 1 ELSE 0 END) AS knowns_for_movies_nulls
FROM    names;

-- following columns in names table  have the nullvalues = height_nulls,date_of_birth,known_for_movies 


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


-- Finding the top three genres with high-rated movies.
WITH Top_Three_Genre AS (
    SELECT
        genre,
        COUNT(m.id) AS Movie_count
    FROM movie m
    INNER JOIN genre g ON m.id = g.movie_id
    INNER JOIN ratings r ON r.movie_id = m.id
    WHERE avg_rating > 8
    GROUP BY genre
    ORDER BY Movie_count DESC
    LIMIT 3
)
-- Now finding the top three directors in top three genres.
SELECT n.name AS director_name,
    COUNT(m.id) AS Movie_count
FROM movie m
INNER JOIN director_mapping d ON m.id = d.movie_id
INNER JOIN names n ON n.id = d.name_id
INNER JOIN genre g ON g.movie_id = m.id
INNER JOIN ratings r ON m.id = r.movie_id
WHERE g.genre IN (SELECT genre FROM Top_Three_Genre)
    AND avg_rating > 8
GROUP BY director_name
ORDER BY Movie_count DESC
LIMIT 3;

-- "James Mangold"and "Joe Russo" and "Anthony Russo" are the top three director in the top genre with the average ratinggreater than 8



/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Code to find out the top two actors whose movies have a median rating >= 8
SELECT n.name  AS actor_name , 
       count(rm.movie_id) AS movie_count
FROM   ratings r
       INNER JOIN 
       movie m ON m.id=r.movie_id
       INNER JOIN 
       role_mapping rm ON rm.movie_id=m.id
       INNER JOIN 
       names n ON n.id=rm.name_id
WHERE  r.median_rating >= 8 AND category = 'ACTOR'
       GROUP BY actor_name
       ORDER BY movie_count  DESC 
       LIMIT 2;

-- "Mammootty" and "Mohanlal" are the top two actor whose movie have a median rating greater than 8


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:


-- Code to find out the top three production houses based on the number of votes received by their movies
SELECT production_company,
       SUM(total_votes) AS vote_count ,
       RANK() OVER(ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM   movie m 
       INNER JOIN 
       ratings r ON m.id=r.movie_id
	   GROUP BY production_company LIMIT 3;
       
-- "Marvel Studios" and "Twentieth Century Fox" and "Warner Bros." are the top three production company based on number of votes
-- "Marvel Studios" have highest number of votes 

       
/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Code to Rank actors with movies released in India based on their average ratings
WITH top_actor AS
(
SELECT name  AS actor_name,
	   SUM(total_votes) AS total_votes,
	   COUNT(title) AS movie_count,
       Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS actor_avg_rating,
       RANK() OVER( ORDER  BY Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) DESC, 
                              SUM(total_votes)DESC) AS actor_rank
FROM   ratings r
       INNER JOIN 
       movie m ON m.id=r.movie_id
       INNER JOIN 
       role_mapping rm ON rm.movie_id=m.id
       INNER JOIN 
       names n ON n.id=rm.name_id
WHERE  country="India" AND category="Actor"
       AND country LIKE '%India%'
	   GROUP BY actor_name
       HAVING movie_count >= 5
       )
SELECT * 
FROM top_actor 
	 ORDER BY actor_rank LIMIT 1;
     
 -- "Vijay Sethupathi" actor is at the top of the list with rank 1 with average rating 8.42
       
       
-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


-- Code to find out the top five actresses in Hindi movies released in India based on their average ratings
SELECT  name AS actress_name,
        SUM(total_votes) AS total_votes,
        COUNT(m.id) AS movie_count,
        ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) AS actress_avg_rating,
        ROW_NUMBER() OVER(ORDER BY ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) DESC, SUM(total_votes) 
        DESC ) AS actress_rank
FROM    names n
		INNER JOIN role_mapping rm ON n.id = rm.name_id
        INNER JOIN ratings r ON rm.movie_id = r.movie_id
		INNER JOIN movie m ON m.id = rm.movie_id
        WHERE category = "actress"
        AND country LIKE "%india%"
        AND languages LIKE "%hindi%"
        GROUP BY actress_name
        HAVING movie_count >= 3;     
-- "Taapsee Pannu" top of the rank with average rating 7.74
-- "Taapsee Pannu","Kriti Sanon","Divya Dutta","Shraddha Kapoor","Kriti Kharbanda" these are the top five actress based on their average rating 


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/

/
/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

-- Code for the Thriller movie as per average rating  and classify them in the given category
SELECT title,
       genre,
       avg_rating,
       CASE
           WHEN avg_rating > 8 THEN 'Superhit movies'
		   WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit movies'
           WHEN avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch movies'
           WHEN avg_rating < 5 THEN 'Flop movies'
           END AS rating_category
FROM    movie AS m
        INNER JOIN genre AS g ON m.id = g.movie_id
        INNER JOIN ratings AS r ON r.movie_id = m.id
WHERE   genre = 'Thriller';

-- "Der müde Tod" title hit thriller movie with highest  average rating 7.7 

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

-- code for the genre-wise running total and moving average of the average movie duration
SELECT  genre,
		ROUND(AVG(duration),2) AS avg_duration,
        SUM(ROUND(AVG(duration), 2)) OVER (ORDER BY genre) AS running_total_duration,
        ROUND(AVG(ROUND(AVG(duration), 2)) OVER (ORDER BY genre ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS moving_avg_duration
FROM    movie AS m 
        INNER JOIN 
        genre AS g ON m.id = g.movie_id
        GROUP BY genre
        ORDER BY genre;
        
-- "Action" genre hav the highest average rating 112.88 and highest running tottal duration,highest moving average duration         


-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


-- Top 3 Genres based on most number of movies
WITH top_three_genre AS 
(
    SELECT genre,
           COUNT(m.id) AS movie_count
    FROM   movie m
           INNER JOIN
           genre g ON g.movie_id = m.id
           GROUP BY genre
           ORDER BY movie_count DESC
           LIMIT 3
),
final_tab AS 
(
    SELECT g.genre,
           m.year,
           m.title,
           worlwide_gross_income,
           ROW_NUMBER() OVER (PARTITION BY m.year ORDER BY worlwide_gross_income DESC) AS movie_rank
    FROM   movie m
           INNER JOIN
		   genre g ON g.movie_id = m.id
    WHERE  g.genre IN (SELECT genre FROM top_three_genre)
)
-- Retrieve the results of the top movies in the top genres.
SELECT * FROM final_tab
WHERE  movie_rank <= 5;
        
-- "Shatamanam Bhavati" highest-grossing movies of each year that belong to the "Drama" genres
-- "Shatamanam Bhavati","Winner","Thank You for Your Service","The Healer","The Healer" five higest grosiing movies of each year that belongs the top genre




-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

-- Code for the top two production houses that have produced the highest number of hits (median rating >= 8)
SELECT production_company,
	   COUNT(id) AS movie_count,
       RANK() OVER( ORDER BY COUNT(id) DESC) AS prod_comp_rank
FROM   movie m 
       INNER JOIN 
       ratings r ON r.movie_id=m.id
WHERE  median_rating >= 8  
       AND production_company IS NOT NULL
	   AND Position(',' IN languages) > 0
	   GROUP  BY production_company LIMIT 2;
       
-- "Star Cinema" and "Twentieth Century Fox" top two production houses that have produced the highest number of hits (median rating >= 8) 




-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Code for top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre
SELECT name AS actress_name,
       SUM(total_votes) AS total_votes,
       COUNT(m.id) AS movie_count,
       ROUND(SUM(avg_rating*total_votes)/Sum(total_votes),2) AS actress_avg_rating,
       RANK() OVER(ORDER BY COUNT(m.id) DESC) AS actress_rank       
FROM movie m 
     INNER JOIN 
	 genre g ON g.movie_id=m.id
     INNER JOIN
     ratings r ON r.movie_id=m.id
     INNER JOIN 
     role_mapping rm ON  rm.movie_id=m.id
     INNER JOIN
     names n ON n.id=rm.name_id
WHERE category="Actress" AND avg_rating >8 
      AND genre="drama"
      GROUP BY actress_name LIMIT 3;
     
-- "Parvathy Thiruvothu" ,"Susan Brown" and " Amanda Lawrence"  top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre


/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

-- Code for top 9 directors
WITH next_date_details AS
 (
SELECT d.name_id,
       name ,
       d.movie_id,
       r.avg_rating,
       total_votes,
       date_published,
       duration,
       Lead(date_published,1) OVER(partition BY d.name_id ORDER BY date_published,movie_id ) AS next_date_published
FROM   director_mapping d
	   INNER JOIN 
	    names n ON n.id=d.name_id 
		INNER JOIN 
		movie m ON m.id= d.movie_id 
        INNER JOIN 
        ratings r ON r.movie_id=m.id
        ),
top_director_details AS 
(
SELECT *,
       datediff(next_date_published,date_published) AS date_difference
FROM   next_date_details )
SELECT name_id                       AS director_id,
       name                          AS director_name,
       COUNT(movie_id)               AS number_of_movies,
       ROUND(AVG(date_difference),2) AS avg_inter_movie_days,
       ROUND(AVG(avg_rating),2)      AS avg_rating,
       SUM(total_votes)              AS total_votes,
       MIN(avg_rating)               AS min_rating,
       MAX(avg_rating)               AS max_rating,
       SUM(duration)                 AS total_duration   
FROM   top_director_details
       GROUP BY director_id
       ORDER BY  COUNT(movie_id) DESC LIMIT 9;
       
-- "Andrew Jones" named director and director id nm2096009 released the highest number of movies


       
     




