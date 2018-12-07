use sakila;
-- 1a. Display the first and last names of all actors from the table actor. --
SELECT * FROM actor;

Select first_name, last_name from actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.

set sql_safe_updates = 0;
update actor
set first_name = lcase(first_name);
update actor

set last_name = lcase(last_name);

update actor
set first_name = concat(ucase(left(first_name,1)),substring(first_name,2));
update actor
set last_name = concat(ucase(left(last_name,1)),substring(last_name,2));

Select first_name, last_name from actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." --
-- What is one query would you use to obtain this information? --
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name LIKE 'Joe%';

-- 2b. Find all actors whose last name contain the letters GEN:--

SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE '%gen';

-- 2c. Find all actors whose last names contain the letters LI.  --
-- This time, order the rows by last name and first name, in that order: --

SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE '%li%'
ORDER BY last_name, first_name desc;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China: --

SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a. You want to keep a description of each actor. --
-- You don't think you will be performing queries on a description, --
-- so create a column in the table actor named description and use the data type BLOB --
-- (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant). --

ALTER TABLE actor ADD description BLOB(20) NULL;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. --
-- Delete the description column.

ALTER TABLE actor drop description;

-- 4a. List the last names of actors, as well as how many actors have that last name. -- 


SELECT last_name, count(*) as NUM FROM actor GROUP BY last_name ORDER BY NUM desc;

-- 4b. List last names of actors and the number of actors who have that last name, --
-- but only for names that are shared by at least two actors -- 

SELECT last_name, count(*) as NUM 
FROM actor 
GROUP BY last_name
having num > 1
ORDER BY NUM desc;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. -- 
-- Write a query to fix the record. --

UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' and last_name = 'WILLIAMS';

SELECT actor_id, first_name, last_name
from actor
where first_name = 'harpo';

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it? --
-- Hint: https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html --

show create table address;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. --
-- Use the tables staff and address: --

SELECT * from staff;

SELECT staff.first_name, staff.last_name, address.address
FROM staff
INNER JOIN address ON staff.address_id=address.address_id;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. --
-- Use tables staff and payment. --

SELECT staff.staff_id, staff.first_name, staff.last_name, sum(payment.amount) as 'Total Amount Rung'
FROM staff
INNER JOIN payment ON staff.staff_id=payment.staff_id
where payment_date < '2005-09-01'
GROUP BY staff_id;

-- 6c. List each film and the number of actors who are listed for that film. --
-- Use tables film_actor and film. Use inner join. --

SELECT film_actor.film_id, film_actor.actor_id, film.title, count(film_actor.actor_id) as 'Total Actors'
FROM film_actor
INNER JOIN film ON film_actor.film_id=film.film_id
GROUP BY film_id;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system? --

SELECT inventory_id, film_id, count(film_id) as 'Total Film in Inventory'
FROM inventory
WHERE film_id IN
(
 SELECT film_id
 FROM film
 WHERE title = 'Hunchback Impossible'
)
GROUP BY film_id;

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. -- 
-- List the customers alphabetically by last name: --

SELECT payment.customer_id, customer.first_name, customer.last_name, sum(payment.amount) as 'Total Amount Paid'
FROM payment
INNER JOIN customer ON payment.customer_id=customer.customer_id
GROUP BY customer_id
ORDER BY last_name asc;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. --
-- As an unintended consequence, films starting with the letters K and Q have also soared in popularity. --
-- Use subqueries to display the titles of movies starting with the letters K and Q whose language is English. --

SELECT film_id, title, language_id
FROM film
WHERE title LIKE 'k%' or title LIKE 'q%' and
	language_id =
	(
	SELECT language_id
	FROM language
	WHERE name = 'English'
	);

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip. --

SELECT actor_id, first_name, last_name
FROM actor
WHERE actor_id in (SELECT actor_id
					FROM film_actor
					WHERE film_id = 
					(
					SELECT film_id
					FROM film
					WHERE title = 'Alone Trip'
					)
				);

-- 7c. You want to run an email marketing campaign in Canada, --
-- for which you will need the names and email addresses of all Canadian customers. -- 
-- Use joins to retrieve this information. --

SELECT customer_id, first_name, last_name, email
FROM customer
WHERE address_id in (SELECT address_id
					FROM address
					WHERE city_id in 
						(
						SELECT city_id
						FROM city
						WHERE country_id = 
							(
							SELECT country_id
							FROM country
							WHERE country ='Canada'
							)
						)
					);

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. -- 
-- Identify all movies categorized as family films. --

select film_id, title
from film
where film_id in (
				select film_id
				from film_category
				where category_id = (
									SELECT category_id
									FROM category
									WHERE name ='Family'
									)
				);
                
-- 7e. Display the most frequently rented movies in descending order.

select inventory.film_id, film.title, count(rental.rental_date) as 'Total_Rental'
FROM inventory
INNER JOIN rental ON inventory.inventory_id=rental.inventory_id
INNER JOIN film ON inventory.inventory_id=film.film_id
GROUP BY film_id
ORDER BY Total_Rental desc;

-- 7f. Write a query to display how much business, in dollars, each store brought in. --

select store.store_id, concat('$', format(sum(payment.amount), 'c', 'en-us')) as 'Total_Payment'
FROM payment
INNER JOIN staff ON payment.staff_id=staff.staff_id
INNER JOIN store ON staff.store_id=store.store_id
GROUP BY store_id
ORDER BY Total_Payment desc;


-- 7g. Write a query to display for each store its store ID, city, and country. --

select store.store_id, city.city, country.country
FROM store
INNER JOIN address ON address.address_id=store.address_id
INNER JOIN city ON address.city_id=city.city_id
INNER JOIN country ON city.country_id=country.country_id
GROUP BY store_id;

-- 7h. List the top five genres in gross revenue in descending order. --
-- (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.) --


select category.name, sum(payment.amount) as 'Gross_Revenue' 
FROM payment
INNER JOIN rental ON rental.rental_id=payment.rental_id
INNER JOIN inventory ON inventory.inventory_id=rental.inventory_id
INNER JOIN film_category ON film_category.film_id=inventory.film_id
INNER JOIN category ON category.category_id=film_category.category_id
GROUP BY category.name
ORDER BY Gross_Revenue desc
limit 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. --
-- Use the solution from the problem above to create a view. -- 
-- If you haven't solved 7h, you can substitute another query to create a view. --

CREATE VIEW Top_5_Genres AS
select category.name, sum(payment.amount) as 'Gross_Revenue' 
FROM payment
INNER JOIN rental ON rental.rental_id=payment.rental_id
INNER JOIN inventory ON inventory.inventory_id=rental.inventory_id
INNER JOIN film_category ON film_category.film_id=inventory.film_id
INNER JOIN category ON category.category_id=film_category.category_id
GROUP BY category.name
ORDER BY Gross_Revenue desc
limit 5;

-- 8b. How would you display the view that you created in 8a? --

select * from Top_5_Genres;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it. --

drop view Top_5_Genres;



