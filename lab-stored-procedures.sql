use sakila;

# 1. In the previous lab we wrote a query to find first name, last name, and emails of all the customers who rented Action movies. Convert the query into a simple stored procedure.

# Storing query into procedure action_lovers
DELIMITER //
create procedure action_lovers()
begin
  select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = "Action"
  group by first_name, last_name, email;
end //
DELIMITER ;

# Executing query
call action_lovers();


# 2. Now keep working on the previous stored procedure to make it more dynamic. Update the stored procedure in a such manner that it can take a string argument for the category name and return the results for all customers that rented movie of that category/genre.
# For eg., it could be action, animation, children, classics, etc.

# Creating procedure that takes film categories as input value
DELIMITER //
create procedure category_lovers(in category_name text)
begin
  select first_name, last_name, email
  from customer
  join rental on customer.customer_id = rental.customer_id
  join inventory on rental.inventory_id = inventory.inventory_id
  join film on film.film_id = inventory.film_id
  join film_category on film_category.film_id = film.film_id
  join category on category.category_id = film_category.category_id
  where category.name = category_name
  group by first_name, last_name, email;
end //
DELIMITER ;

# Giving category name "Animation for instance...
call category_lovers('Animation');
# returns 488 customer names and email addresses


# 3. Write a query to check the number of movies released in each movie category. Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number. Pass that number as an argument in the stored procedure.

# The query
select c.name as category_name, count(f.film_id) as n_films from film f
join film_category fc
using (film_id)
join category c
using (category_id)
group by name;

# The stored procedure with number of films above which a category will be returned
DELIMITER //
create procedure categories_more_films_than(in more_films_than int)
begin
	select c.name as category_name, count(f.film_id) as n_films from film f
	join film_category fc
	using (film_id)
	join category c
	using (category_id)
	group by name
    having n_films > more_films_than;
end //
DELIMITER ;

# Executing stored procedure with boundary set to 70 films
call categories_more_films_than(70);
# Output:
# category_name			n_films
# Foreign					73
# Sports					74