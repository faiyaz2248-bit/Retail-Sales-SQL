# Retail Sales Analysis SQL Project

## 📊 Project Overview
This project focuses on performing a comprehensive Data Analysis (EDA) on retail sales data using SQL. It involves setting up a structured database, cleaning the raw transaction data, and executing complex queries to derive business insights related to customer behavior, product performance, and sales trends.

## 🗄️ Database Schema
The analysis is performed on a database named `rt_Sales` with a primary table `rts`.

### Table Structure
| Column | Data Type | Description |
| :--- | :--- | :--- |
| `transactions_id` | INT (PK) | Unique identifier for each transaction |
| `sale_date` | DATE | Date of the transaction |
| `sale_time` | TIME | Time of the transaction |
| `customer_id` | INT | Unique ID for the customer |
| `gender` | VARCHAR(15) | Gender of the customer |
| `age` | INT | Age of the customer |
| `category` | VARCHAR(15) | Product category |
| `quantiy` | INT | Number of units sold |
| `price_per_unit` | FLOAT | Price per unit |
| `cogs` | FLOAT | Cost of Goods Sold |
| `total_sale` | FLOAT | Total revenue generated |

---

## 🛠️ Key Analysis Phases

### 1. Data Cleaning
The script ensures data integrity by checking for `NULL` values across all critical columns, including transaction IDs, dates, categories, and sales figures.

### 2. Business Logic & SQL Queries
The project provides solutions to specific business questions through SQL queries:
* **Time-Specific Retrieval:** Extracting all sales records for a specific date.
* **Targeted Sales Filtering:** Finding high-quantity sales (>= 4) in the 'Clothing' category for November 2022.
* **Category Performance:** Calculating total sales and the number of unique customers for each product category.
* **Customer Insights:** Determining the average age of customers in the 'Beauty' category and identifying the top 5 customers by total spending.
* **Transaction Segmentation:** Counting transactions by gender and category.
* **Advanced Time Analysis:** Ranking and identifying the best-selling month for each year based on average sales.
* **Shift-Based Analysis:** Categorizing orders into 'Morning', 'Afternoon', and 'Evening' shifts based on the transaction time.

---

## 🚀 How to Use
1.  **Create the Database:** Run the `CREATE DATABASE rt_Sales;` command.
2.  **Define the Schema:** Execute the `CREATE TABLE rts` script to set up the columns and data types.
3.  **Import Data:** Load your retail sales dataset into the `rts` table.
4.  **Run Analysis:** Execute the provided SQL queries in `Retail Sales.sql` to generate reports and insights.


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT * FROM rts WHERE sale_date = '2022-11-05';


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' 
-- and the quantity sold is more than 4 in the month of Nov-2022 
SELECT * FROM rts 
WHERE category = 'clothing' 
AND sale_date BETWEEN '2022-11-01' AND '2022-11-30' 
AND quantiy >= 4;


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT category, SUM(total_sale) AS Total_Sales 
FROM rts GROUP BY category;


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT category, AVG(age) FROM rts 
WHERE category = 'Beauty' GROUP BY category;


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM rts WHERE total_sale > 1000;


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT gender, category, COUNT(transactions_id) 
FROM rts GROUP BY gender, category ORDER BY 2;


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT * FROM (
    SELECT 
      year(sale_date) as year, 
      month(sale_date) as month, 
      Round(avg(total_sale)) as avg_sale,
      Rank() OVER(PARTITION BY year(sale_date) ORDER BY avg(total_sale) DESC) as ranking
    FROM rts GROUP BY 1,2
) AS T1 WHERE ranking = 1;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
SELECT customer_id, SUM(total_sale) 
FROM rts GROUP BY customer_id 
ORDER BY SUM(total_sale) DESC LIMIT 5;


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT category, COUNT(DISTINCT customer_id) 
FROM rts GROUP BY category;


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
SELECT shift, COUNT(transactions_id) FROM (
    SELECT *,
    CASE
        WHEN HOUR(sale_time) <= 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift
    FROM rts
) AS T2 GROUP BY shift;
