-- SQL Retail Sales Analysis

-- Creating Database
CREATE DATABASE retails_sales_db;

-- Creating Table
CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

-- Viewing Data
SELECT * FROM retail_sales;

-- Data Exploration & Cleaning

-- How many sales we have?
SELECT COUNT(*) FROM retail_sales;

-- How many unique customers we have?
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;

-- How many unique categories we have?
SELECT DISTINCT category FROM retail_sales;

-- Exploring Null Values
SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

-- Deleting The Null Values
DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

-- Data Analysis & Business Key Problems

-- 1. Top Performing Categories by Revenue
SELECT 
	category,
	SUM(total_sale) AS total_revenue
FROM retail_sales
GROUP BY category
ORDER BY total_revenue DESC;

-- 2. Peak Sales Hours and Days
-- By Hours
SELECT 
	EXTRACT(HOUR FROM sale_time) AS hour,
	SUM(total_sale) AS hourly_sales
FROM retail_sales
GROUP BY hour
ORDER BY hourly_sales DESC;

-- By Days
SELECT 
	TO_CHAR(sale_date, 'Day') AS day_of_week, 
	SUM(total_sale) AS daily_sales
FROM retail_sales
GROUP BY day_of_week
ORDER BY daily_sales DESC;

-- 3. Average Age by Category
SELECT 
	category,
	CEIL(AVG(age)) AS avg_age
FROM retail_sales
GROUP BY category
ORDER BY avg_age DESC;

-- 4. Gender Preference in Categories
SELECT gender, category, SUM(quantity) AS total_quantity
FROM retail_sales
GROUP BY gender, category
ORDER BY category, total_quantity DESC;

-- 5. Customer Segmentation by Age Group
SELECT
  CASE
    WHEN age BETWEEN 18 AND 25 THEN '18-25'
    WHEN age BETWEEN 26 AND 35 THEN '26-35'
    WHEN age BETWEEN 36 AND 45 THEN '36-45'
    WHEN age BETWEEN 46 AND 60 THEN '46-60'
    ELSE '60+'
  END AS age_group,
  SUM(total_sale) AS total_spent
FROM retail_sales
GROUP BY age_group
ORDER BY age_group;

-- 6. Top Spending Customers
SELECT 
	customer_id,
	SUM(total_sale) AS total_spent,
	COUNT(transactions_id) AS total_transactions
FROM retail_sales
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 10;

-- 7. Category Profitability
SELECT 
	category,
	ROUND(SUM(total_sale - cogs)::NUMERIC ,2) AS total_profit
FROM retail_sales
GROUP BY category
ORDER BY total_profit DESC;

-- 8. High-Selling, Low-Profit Categories
SELECT 
	category, 
	SUM(quantity) AS total_quantity, 
	ROUND(SUM(total_sale - cogs)::NUMERIC ,2) AS total_profit
FROM retail_sales
GROUP BY category
ORDER BY total_quantity DESC;

-- 9. Average Basket Size
SELECT 
	ROUND(AVG(quantity), 2) AS avg_items_per_txn, 
	ROUND(AVG(total_sale)::NUMERIC, 2) AS avg_sale_value
FROM retail_sales;

-- 10. Age vs Spending Correlation
SELECT age, SUM(total_sale) AS total_spent
FROM retail_sales
GROUP BY age
ORDER BY age;