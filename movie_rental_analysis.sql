-- Movie Rental Analysis
-- SQLite project
-- Database: MOVIE RENTAL ANALYSIS.db

-- 1. Total revenue
SELECT ROUND(SUM(amount), 2) AS total_revenue
FROM payment;

-- 2. Total rentals
SELECT COUNT(*) AS total_rentals
FROM rentat;

-- 3. Top 10 customers by total spending
SELECT c.customer_id,
       c.first_name || ' ' || c.last_name AS customer_name,
       ROUND(SUM(p.amount), 2) AS total_spent
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 10;

-- 4. Top 10 most rented movies
SELECT f.film_id,
       f.title,
       COUNT(r.rental_id) AS rental_count
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rentat r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title
ORDER BY rental_count DESC
LIMIT 10;

-- 5. Revenue by movie category
SELECT cat.name AS category,
       ROUND(SUM(p.amount), 2) AS revenue
FROM category cat
JOIN film_category fc ON cat.category_id = fc.category_id
JOIN inventory i ON fc.film_id = i.film_id
JOIN rentat r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY cat.category_id, cat.name
ORDER BY revenue DESC;

-- 6. Rentals by movie category
SELECT cat.name AS category,
       COUNT(r.rental_id) AS rentals
FROM category cat
JOIN film_category fc ON cat.category_id = fc.category_id
JOIN inventory i ON fc.film_id = i.film_id
JOIN rentat r ON i.inventory_id = r.inventory_id
GROUP BY cat.category_id, cat.name
ORDER BY rentals DESC;

-- 7. Store performance
SELECT s.store_id,
       ROUND(SUM(p.amount), 2) AS revenue,
       COUNT(r.rental_id) AS rentals
FROM store s
JOIN inventory i ON s.store_id = i.store_id
JOIN rentat r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY s.store_id
ORDER BY revenue DESC;

-- 8. Rentals and revenue by film rating
SELECT f.rating,
       COUNT(r.rental_id) AS rentals,
       ROUND(SUM(p.amount), 2) AS revenue
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rentat r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY f.rating
ORDER BY rentals DESC;

-- 9. Average rental duration by film rating
SELECT rating,
       ROUND(AVG(rental_duration), 2) AS avg_rental_duration,
       COUNT(*) AS films
FROM film
GROUP BY rating
ORDER BY avg_rental_duration DESC;

-- 10. 10 longest movies
SELECT title, length, rating, rental_rate
FROM film
ORDER BY length DESC
LIMIT 10;

-- 11. Movies with the highest rental rate
SELECT title, rental_rate, replacement_cost, rating
FROM film
ORDER BY rental_rate DESC, title
LIMIT 10;

-- 12. Monthly revenue
SELECT strftime('%Y-%m', payment_date) AS month,
       ROUND(SUM(amount), 2) AS revenue,
       COUNT(*) AS payments
FROM payment
GROUP BY month
ORDER BY month;

-- 13. Monthly rentals
SELECT strftime('%Y-%m', rental_date) AS month,
       COUNT(*) AS rentals
FROM rentat
GROUP BY month
ORDER BY month;

-- 14. Films that were never rented
SELECT f.film_id, f.title
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rentat r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title
HAVING COUNT(r.rental_id) = 0
ORDER BY f.title;

-- 15. Top 10 actors by number of films
SELECT a.actor_id,
       a.first_name || ' ' || a.last_name AS actor_name,
       COUNT(fa.film_id) AS film_count
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id
ORDER BY film_count DESC
LIMIT 10;

-- 16. Average number of days taken to return a rental
SELECT ROUND(
         AVG(julianday(return_date) - julianday(rental_date)), 2
       ) AS avg_return_days
FROM rentat
WHERE return_date IS NOT NULL;

-- 17. Active vs inactive customers
SELECT active,
       COUNT(*) AS customer_count
FROM customer
GROUP BY active;

-- 18. Top 10 cities by rentals
SELECT ci.city,
       COUNT(r.rental_id) AS rentals,
       ROUND(SUM(p.amount), 2) AS revenue
FROM city ci
JOIN address a ON ci.city_id = a.city_id
JOIN customer c ON a.address_id = c.address_id
JOIN rentat r ON c.customer_id = r.customer_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY ci.city_id, ci.city
ORDER BY rentals DESC
LIMIT 10;
