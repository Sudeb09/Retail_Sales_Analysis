# Retail Sales Data Analysis

This repository contains a SQL-based analysis of retail sales data, designed to uncover key business insights from transactional records. The analysis covers various aspects of sales performance, customer behavior, and profitability.

-----

## Database and Table Setup

The project begins by setting up a PostgreSQL database and a `retail_sales` table to store the transactional data.

### Database Creation

```sql
CREATE DATABASE retails_sales_db;
```

### Table Structure

The `retail_sales` table includes the following columns:

| Column Name     | Data Type    | Description                               |
| :-------------- | :----------- | :---------------------------------------- |
| `transactions_id` | `INT`        | Unique identifier for each transaction (Primary Key) |
| `sale_date`     | `DATE`       | Date of the sale                          |
| `sale_time`     | `TIME`       | Time of the sale                          |
| `customer_id`   | `INT`        | Unique identifier for each customer       |
| `gender`        | `VARCHAR(10)`| Gender of the customer                    |
| `age`           | `INT`        | Age of the customer                       |
| `category`      | `VARCHAR(35)`| Product category of the item sold         |
| `quantity`      | `INT`        | Number of units sold in the transaction   |
| `price_per_unit`| `FLOAT`      | Price of a single unit                    |
| `cogs`          | `FLOAT`      | Cost of Goods Sold for the transaction    |
| `total_sale`    | `FLOAT`      | Total sale amount for the transaction     |

```sql
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
```

-----

## Data Exploration & Cleaning

Initial steps involve understanding the dataset and ensuring data quality.

### Viewing Data

```sql
SELECT * FROM retail_sales;
```

### Counting Records

  - **Total Sales:**
    ```sql
    SELECT COUNT(*) FROM retail_sales;
    ```
  - **Unique Customers:**
    ```sql
    SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
    ```
  - **Unique Categories:**
    ```sql
    SELECT DISTINCT category FROM retail_sales;
    ```

### Handling Null Values

  - **Identifying Nulls:**
    ```sql
    SELECT * FROM retail_sales
    WHERE
        sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR
        gender IS NULL OR age IS NULL OR category IS NULL OR
        quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
    ```
  - **Deleting Null Rows:**
    ```sql
    DELETE FROM retail_sales
    WHERE
        sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR
        gender IS NULL OR age IS NULL OR category IS NULL OR
        quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
    ```

-----

## Data Analysis & Business Key Problems

This section contains SQL queries addressing specific business questions to derive actionable insights.

### 1\. Top Performing Categories by Revenue

Identifies which product categories generate the most revenue.

```sql
SELECT
	category,
	SUM(total_sale) AS total_revenue
FROM retail_sales
GROUP BY category
ORDER BY total_revenue DESC;
```

### 2\. Peak Sales Hours and Days

Determines the busiest times for sales, useful for staffing and promotions.

  - **By Hours:**
    ```sql
    SELECT
    	EXTRACT(HOUR FROM sale_time) AS hour,
    	SUM(total_sale) AS hourly_sales
    FROM retail_sales
    GROUP BY hour
    ORDER BY hourly_sales DESC;
    ```
  - **By Days:**
    ```sql
    SELECT
    	TO_CHAR(sale_date, 'Day') AS day_of_week,
    	SUM(total_sale) AS daily_sales
    FROM retail_sales
    GROUP BY day_of_week
    ORDER BY daily_sales DESC;
    ```

### 3\. Average Age by Category

Analyzes the average age of customers purchasing from different categories.

```sql
SELECT
	category,
	CEIL(AVG(age)) AS avg_age
FROM retail_sales
GROUP BY category
ORDER BY avg_age DESC;
```

### 4\. Gender Preference in Categories

Examines sales quantity across categories based on customer gender.

```sql
SELECT gender, category, SUM(quantity) AS total_quantity
FROM retail_sales
GROUP BY gender, category
ORDER BY category, total_quantity DESC;
```

### 5\. Customer Segmentation by Age Group

Segments customers into age groups to understand spending patterns.

```sql
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
```

### 6\. Top Spending Customers

Identifies the top 10 customers based on their total spending and transaction count.

```sql
SELECT
	customer_id,
	SUM(total_sale) AS total_spent,
	COUNT(transactions_id) AS total_transactions
FROM retail_sales
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 10;
```

### 7\. Category Profitability

Calculates the total profit for each product category.

```sql
SELECT
	category,
	ROUND(SUM(total_sale - cogs)::NUMERIC ,2) AS total_profit
FROM retail_sales
GROUP BY category
ORDER BY total_profit DESC;
```

### 8\. High-Selling, Low-Profit Categories

Reveals categories with high sales volume but potentially lower profit margins.

```sql
SELECT
	category,
	SUM(quantity) AS total_quantity,
	ROUND(SUM(total_sale - cogs)::NUMERIC ,2) AS total_profit
FROM retail_sales
GROUP BY category
ORDER BY total_quantity DESC;
```

### 9\. Average Basket Size

Determines the average number of items and average sale value per transaction.

```sql
SELECT
	ROUND(AVG(quantity), 2) AS avg_items_per_txn,
	ROUND(AVG(total_sale)::NUMERIC, 2) AS avg_sale_value
FROM retail_sales;
```

### 10\. Age vs Spending Correlation

Examines the relationship between customer age and total spending.

```sql
SELECT age, SUM(total_sale) AS total_spent
FROM retail_sales
GROUP BY age
ORDER BY age;
```
