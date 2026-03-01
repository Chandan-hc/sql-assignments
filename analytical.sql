-- ANALYTICAL FUNCTIONS (WINDOW FUNCTIONS) – 20 Questions
    
-- Assign row numbers to each order.
  select  order_id, row_number() over(order by order_id) form orders;

--   Rank products by price.
    select product_id, product_name, price, RANK() OVER (ORDER BY price DESC) AS price_rank from products;   
   
-- Dense rank products by sales.
     select product_id,  product_name, sales_amount, DENSE_RANK() OVER (ORDER BY sales_amount DESC) AS sales_rank from products;

-- Find running total of sales.
    select product_id,sale_date,sales_amount,SUM(sales_amount) OVER (PARTITION BY product_id ORDER BY sale_date) 
    AS running_total from sales
     ORDER BY product_id, sale_date;

-- Calculate cumulative sum by month.
    select extract(month from order_date) as month, 
    SUM(SUM(quantity*unit_price)) OVER (ORDER BY  extract(month from order_date)) AS cumulative_sales from orders 
     GROUP BY  EXTRACT (month from order_date) ORDER BY  month;

-- Find moving average of last 3 days.
   select sale_date, sales_amount, AVG(sales_amount) OVER (ORDER BY sale_date ROWS BETWEEN 2 PRECEDING AND CURRENT ROW ) AS moving_avg_3_days
   from sales ORDER BY sale_date;

-- Calculate lag of previous day sales.
   select sale_date, sales_amount,LAG(sales_amount, 1) OVER ( ORDER BY sale_date  ) AS previous_day_sales
   from sales ORDER BY sale_date;

-- Calculate lead of next day sales.
   select sale_date, sales_amount,LEAD(sales_amount, 1) OVER (ORDER BY sale_date) AS next_day_sales
  from sales ORDER BY sale_date;

-- Find difference between current and previous sale.
   select sale_date, sales_amount, sales_amount - LAG(sales_amount, 1) OVER ( ORDER BY sale_date ) AS difference_from_previous
    from sales  ORDER BY sale_date;

-- Partition sales by region.
   select region,sale_date,sales_amount,
    SUM(sales_amount) OVER (PARTITION BY region) AS total_sales_region from sales
     ORDER BY region, sale_date;

-- Find top 3 products per category.
    select *from (select product_id,category_id,product_name,sales_amount,ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY sales_amount DESC
    ) AS rn from products) WHERE rn <= 3 ORDER BY category_id, rn;

-- Find bottom 2 customers by sales.
   select *from (select customer_id,customer_name,total_sales,ROW_NUMBER() OVER (ORDER BY total_sales ASC) AS rn from customers)
     WHERE rn <= 2 ORDER BY total_sales ASC;

-- Calculate percentage of total sales.
   select customer_id, customer_name, sales_amount,ROUND( (sales_amount / SUM(sales_amount) OVER ()) * 100, 2 ) AS pct_of_total_sales   from sales
       ORDER BY pct_of_total_sales DESC;
    
-- Find first order per customer.
  select *from (select order_id, customer_id, order_date, amount, ROW_NUMBER() OVER ( PARTITION BY customer_id ORDER BY order_date ASC ) AS rn
    -- from orders) WHERE rn = 1  ORDER BY customer_id;

-- Find last order per customer.
   select *from ( select order_id, customer_id, order_date, amount, ROW_NUMBER() OVER (  PARTITION BY customer_i  ORDER BY order_date DESC) AS rn
    from order) WHERE rn = 1 ORDER BY customer_id;

-- Calculate average salary within department.
    select employee_id,employee_name,department_id,salary,ROUND(AVG(salary) OVER (PARTITION BY department_id), 2) AS avg_salary_dept from employees
    ORDER BY department_id, employee_id;

-- Compare current row with max value in partition.
   select sale_id,region,sales_amount,MAX(sales_amount) OVER (PARTITION BY region) AS max_sales_region, sales_amount - MAX(sales_amount) OVER (PARTITION BY region) AS diff_from_max
   from sales ORDER BY region, sales_amount DESC;
   
-- Find cumulative distinct count.
    select s1.sale_date, COUNT(DISTINCT s2.customer_id) AS cumulative_distinct_customers from sales s1 JOIN sales s2 ON s2.sale_date <= s1.sale_date
    GROUP BY s1.sale_date ORDER BY s1.sale_date;