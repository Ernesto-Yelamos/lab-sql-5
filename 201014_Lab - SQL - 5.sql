USE sakila;

SELECT * FROM sakila.actor
LIMIT 5;

-- LAB-INTRO-SQL
	-- 1- Show tables in the database.
SHOW TABLES;

	-- 2. Explore tables. (select everything from each table)
SELECT * FROM actor;
SELECT * FROM address;
SELECT * FROM category;
SELECT * FROM city;
SELECT * FROM country;
SELECT * FROM customer;
SELECT * FROM film;

	-- 3. Select one column from a table. Get film titles.
SELECT title AS 'film title' FROM sakila.film_text;

	-- 4. Select one column from a table and alias it. Get languages.
SELECT name AS Language FROM sakila.language;

	-- 5. How many stores does the company have? How many employees? which are their names?
SELECT count(store_id) FROM store;


-- LAB-SQL-2
	-- 1. Select all the actors with the first name ‘Scarlett’.
SELECT * FROM sakila.actor
WHERE first_name IN ('Scarlett');

	-- 2. Select all the actors with the last name ‘Johansson’.
SELECT * FROM sakila.actor
WHERE last_name IN ('Johansson');

	-- 3. How many films (movies) are available for rent?
SELECT count(film_id) FROM film;

	-- 4. How many films have been rented?
SELECT count(rental_id) FROM rental;

	-- 5. What is the shortest and longest rental period?
SELECT rental_date, return_date FROM sakila.rental
LIMIT 5;

SELECT min(return_date - rental_date) as shortest_rental_period, max(return_date - rental_date) as longest_rental_period FROM sakila.rental;

	-- 6. What are the shortest and longest movie duration? Name the values `max_duration` and `min_duration`.
SELECT min(length) AS shortest_duration, max(length) AS longest_duration FROM film;

	-- 7. What's the average movie duration?
SELECT ROUND(AVG(length)) as average_duration FROM film;

	-- 8. What's the average movie duration expressed in format (hours, minutes)?
SELECT CONCAT(FLOOR(ROUND(AVG(length))/60),'h ', MOD(ROUND(AVG(length)),60),'m') AS average_duration_hs_ms FROM film;

	-- 9. How many movies longer than 3 hours?
SELECT COUNT(film_id) FROM film
WHERE length > 180;

	-- 10. Get the name and email formatted. Example: Mary SMITH - *mary.smith@sakilacustomer.org*.
SELECT CONCAT((left(first_name,1)), SUBSTR(LOWER(first_name),2), ' ',last_name, ' - ' ,LOWER(email)) from customer;

	-- 11. What's the length of the longest film title?
SELECT max(LENGTH(title)) AS longest_film_title FROM film;


-- LAB-SQL-3
	-- 1. How many distinct (different) actors' last names are there?
SELECT COUNT(DISTINCT(last_name)) FROM sakila.actor;
    
	-- 2. In how many different languages were the films originally produced?
SELECT COUNT(name) FROM sakila.language;
    
	-- 3. How many movies were not originally filmed in English?
SELECT COUNT(DISTINCT(original_language_id)) FROM sakila.film;
    
	-- 4. Get 10 of the longest movies from 2006.
SELECT film_id, title, release_year, length FROM sakila.film
ORDER BY length DESC
LIMIT 10;
    
	-- 5. How many days has the company been operating (check `DATEDIFF()` function)?
SELECT min(rental_date) AS 'first_rental', max(return_date) AS 'last_return', DATEDIFF(max(return_date), min(rental_date)) AS 'operating_in_days' FROM sakila.rental;

	-- 6. Show rental info with additional columns month and weekday. Get 20.
SELECT*, SUBSTRING((rental_date), 6, 2) AS 'rental_month', SUBSTRING((return_date), 6, 2) AS 'return_month' FROM sakila.rental
LIMIT 20;

SELECT * , date_format(rental_date, '%M') AS 'month' , date_format(rental_date, '%w') AS 'day' FROM sakila.rental LIMIT 20;

	-- 7. Add an additional column `day_type` with values 'weekend' and 'workday' depending on the rental day of the week.
SELECT*,
CASE
	WHEN DATE_FORMAT(rental_date, '%w') BETWEEN 1 and 5 THEN 'workday'        -- %w - Sunday=0 & Saturday=6
    ELSE 'weekend'
END AS "day_type"
FROM sakila.rental;

	-- 8. How many rentals were in the last month of activity?
select rental_date from sakila.rental
ORDER BY rental_date DESC;

SELECT COUNT(rental_id) FROM sakila.rental 
WHERE ( "2006-02-14" - INTERVAL 30 DAY) <= rental_date; -- Checking for last 30 days

select count(*)
from sakila.rental
where year(rental_date) = 2006 AND month(rental_date) = 02; -- Checking for February


-- LAB-SQL-4
	-- 1. Get film ratings.
SELECT title, rating FROM sakila.film; 
    
	-- 2. Get release years.
SELECT title, release_year FROM sakila.film; 
    
	-- 3. Get all films with ARMAGEDDON in the title.
SELECT title FROM sakila.film
WHERE title LIKE '%ARMAGEDDON%'; -- LIKE method

SELECT title FROM sakila.film 
WHERE title REGEXP ' ARMAGEDDON|ARMAGEDDON '; -- Using Regexp

	-- 4. Get all films with APOLLO in the title.
SELECT title FROM sakila.film
WHERE title LIKE '%APOLLO%'; -- LIKE method

SELECT title FROM sakila.film 
WHERE title REGEXP ' APOLLO|APOLLO '; -- Using Regexp

	-- 5. Get all films which title ends with APOLLO.
SELECT title FROM sakila.film
WHERE title REGEXP 'APOLLO$';

	-- 6. Get all films with word DATE in the title.
SELECT * FROM sakila.film
WHERE title LIKE '%DATE%'; -- LIKE method

SELECT * FROM sakila.film
WHERE title LIKE 'DATE %' OR title LIKE '% DATE'; -- LIKE method - removes words containing date

SELECT title FROM sakila.film 
WHERE title REGEXP ' DATE|DATE '; -- Using Regexp
    
	-- 7. Get 10 films with the longest title.
SELECT title, release_year FROM sakila.film
ORDER BY LENGTH(title) DESC
LIMIT 10;

	-- 8. Get the 10 longest films.                                     
SELECT title, length FROM sakila.film
ORDER BY length DESC
LIMIT 10;    									

	-- 9. How many films include **Behind the Scenes** content?
SELECT * FROM sakila.film WHERE special_features LIKE '%Behind the Scenes%'; -- check films with behind the scenes content

SELECT count(special_features) AS amount_behind_the_scenes FROM sakila.film WHERE special_features LIKE '%Behind the Scenes%'; -- Count how many films have behind the scenes content

	-- 10. List films ordered by release year and title in alphabetical order.
SELECT title, release_year FROM sakila.film 
ORDER BY release_year DESC, title ASC;




-- Lab | SQL Queries 5
	-- 1. Drop column `picture` from `staff`.
ALTER TABLE sakila.staff DROP picture;
SELECT * FROM sakila.staff;

	-- 2. A new person is hired to help Jon. Her name is TAMMY SANDERS, and she is a customer. Update the database accordingly.
SELECT * FROM sakila.customer
WHERE first_name = 'TAMMY' and last_name = 'SANDERS'; -- Find the customer TAMMY SANDERS

DESCRIBE sakila.staff;

DELETE FROM sakila.staff WHERE staff_id>=3;
SELECT * FROM sakila.staff;

INSERT INTO sakila.staff(first_name, last_name, address_id, email, store_id, active, username, password)
VALUES ('Tammy', 'Sanders', '79', 'TAMMY.SANDERS@sakilacustomer.org', '2', '1', 'Tammy', '');
SELECT * FROM sakila.staff;


	-- 3. Add rental for movie "Academy Dinosaur" by Charlotte Hunter from Mike Hillyer at Store 1 today.    
SELECT*FROM sakila.film Where title = 'Academy Dinosaur';
SELECT * FROM sakila.customer WHERE first_name = 'Charlotte' AND last_name = 'Hunter';
SELECT * FROM sakila.staff WHERE first_name = 'Mike' AND last_name = 'Hillyer';

select*from sakila.rental;
describe sakila.rental;

INSERT INTO rental(rental_date,inventory_id,customer_id,staff_id)
VALUES (current_timestamp(),'5','130','1');

SELECT * FROM sakila.rental;


	-- 4. Delete non-active users, but first, create a _backup table_ `deleted_users` to store `customer_id`, `email`, and the `date` the user was deleted.
SELECT * FROM sakila.customer;

DROP TABLE deleted_users; -- Doing tests the table had been created and the next step was giving an error:

CREATE TABLE deleted_users AS (SELECT customer_id, email, create_date, active
FROM sakila.customer
WHERE active=0);

SELECT * FROM sakila.deleted_users;

DELETE FROM sakila.customer
WHERE active = 0;