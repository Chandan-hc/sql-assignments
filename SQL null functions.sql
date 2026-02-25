-- NULL VALUE FUNCTIONS – 20 Questions

-- Replace NULL price with 0.
   select product_name,  NVL(price, 0) AS price
   from products;

-- Replace NULL Customer_Name with 'Unknown'.
   select NVL(Customer_Name, 'Unknown') AS Customer_Name from Customers;

-- Count NULL values in Product_Name.
   select COUNT(*) AS null_count from Products WHERE Product_Name IS NULL;

-- Find rows where Order_Date is NULL.
   select * from Orders WHERE Order_Date IS NULL;

-- Use COALESCE to return first non-null value.
   select  COALESCE(Customer_Name, Alt_Customer_Name, 'Unknown') AS First_Non_Null_Name
   from Customers;
   
-- Use NVL to replace NULL values.
   select 
    Customer_ID,
    NVL(Customer_Name, 'Unknown') AS Customer_Name from Customers;

-- Use IFNULL function.
   select NVL(Customer_Name, 'Unknown') AS Customer_Name from Customers;

-- Check if column is NULL.
   select * from Orders WHERE Order_Date IS NULL;

-- Check if column is NOT NULL.
   select * from Orders WHERE Order_Date IS NOT NULL;

-- Use NULLIF between two columns.
   select Order_ID, Ordered_Amount, Shipped_Amount,
       NULLIF(Shipped_Amount, Ordered_Amount) AS Difference from Orders;

-- Replace blank values with NULL.
   select NULLIF(TRIM(Customer_Name), '') AS Customer_Name from Customers;

-- Count non-null values.
   select COUNT(Product_Name) AS non_null_count from Products;
    
-- Filter records where price is NULL or 0.
   select * from Products WHERE Price IS NULL OR Price = 0;

-- Use CASE to handle NULL values.
   select Customer_ID, CASE  WHEN Customer_Name IS NULL THEN 'Unknown' ELSE Customer_Name  END AS Customer_Name from Customers;

-- Compare NULL values properly.
    select *from Orders WHERE Order_Date IS NULL;

-- Handle NULL in aggregation.
    select SUM(nvl(unit_price,0)) AS total_unit_price from orders;

-- Find average excluding NULL values.
    select AVG(Product_Price) AS avg_price from Products;

-- Find sum ignoring NULL values.
    select SUM(Product_Price) AS total_price from Products;


-- Identify columns containing NULL using metadata.
   select COLUMN_NAME from USER_TAB_COLUMNS WHERE TABLE_NAME = 'PRODUCTS' AND NULLABLE = 'Y';
    
