create database rt_Sales;

create table rts 
          (
		transactions_id	int Primary Key ,
	    sale_date date,	
        sale_time	time,
        customer_id	int,
        gender	varchar(15),
        age	int,
        category	varchar(15),
        quantiy	int,
        price_per_unit	float,
        cogs float,
        total_sale float
		);
        

-- Data Cleaning -- 
select * from rts 
where 
transactions_id is null 
or 
sale_date is null 
or 
sale_time is null 
or 
gender is null 
or 
category is null 
or quantiy is null 

or cogs is null 

or total_sale is null 
; 




-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'

 SELECT 
    *
FROM
    rts
WHERE
    sale_date = '2022-11-05';
    
    

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022 

SELECT 
    *
FROM
    rts
WHERE
    category = 'clothing'
        AND sale_date BETWEEN '2022-11-01' AND '2022-11-30'
        AND quantiy >= 4;
        
        
-- Q.3Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT 
    category, SUM(total_sale) AS Total_Sales
FROM
    rts
GROUP BY category; 


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
 
SELECT 
    category, AVG(age)
FROM
    rts
WHERE
    category = 'Beauty'
GROUP BY category; 


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT 
    transactions_id, SUM(total_sale) AS Total_sale
FROM
    rts
GROUP BY transactions_id
HAVING SUM(total_sale) > 1000;

SELECT 
    *
FROM
    rts
WHERE
    total_sale > 1000;
    
    
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.


SELECT 
    gender, category, COUNT(transactions_id)
FROM
    rts
GROUP BY gender , category
ORDER BY 2; 



-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

select * from 
(Select 
  year(sale_date),
  month(sale_date),
  Round(avg(total_sale)),
  Rank()over(partition by year(sale_date) order by avg(total_sale) desc) as ranking
from rts 
group by 1,2) as T1 
where ranking = 1;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales


SELECT 
    customer_id, SUM(total_sale)
FROM
    rts
GROUP BY customer_id
ORDER BY SUM(total_sale) DESC
LIMIT 5; 


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.


SELECT 
    category, COUNT(DISTINCT customer_id)
FROM
    rts
GROUP BY category;



-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


SELECT 
    shift, COUNT(transactions_id)
FROM
    (SELECT 
        *,
            CASE
                WHEN HOUR(sale_time) <= 12 THEN 'Morning'
                WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
                ELSE 'Evening'
            END AS shift
    FROM
        rts) AS T2
GROUP BY shift; 












