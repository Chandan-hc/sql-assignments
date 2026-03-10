-- 1. Create CUSTOMERS Table
CREATE TABLE CUSTOMERS (
    CUSTOMER_ID NUMBER PRIMARY KEY,
    FIRST_NAME VARCHAR2(50),
    LAST_NAME VARCHAR2(50),
    CITY VARCHAR2(50),
    PHONE_NUMBER VARCHAR2(20),
    LOYALTY_POINTS NUMBER
);

-- 2. Create ORDERS Table
CREATE TABLE ORDERS (
    ORDER_ID NUMBER PRIMARY KEY,
    CUSTOMER_ID NUMBER,
    ORDER_DATE DATE,
    TOTAL_AMOUNT NUMBER(10, 2),
    DISCOUNT_AMT NUMBER(10, 2), -- Can be NULL if no discount
    SHIPPING_DATE DATE          -- Can be NULL if not shipped yet
);

-- 3. Insert Data with intentional NULL values
-- Customers
INSERT INTO CUSTOMERS VALUES (101, 'John', 'Doe', 'New York', '555-0100', 500);
INSERT INTO CUSTOMERS VALUES (102, 'Jane', 'Smith', NULL, '555-0101', 120);
INSERT INTO CUSTOMERS VALUES (103, 'Robert', 'Brown', 'Chicago', NULL, 0);
INSERT INTO CUSTOMERS VALUES (104, 'Emily', 'Davis', NULL, NULL, NULL); -- Lots of NULLs
INSERT INTO CUSTOMERS VALUES (105, 'Michael', 'Wilson', 'Miami', '555-0105', NULL);

-- Orders
INSERT INTO ORDERS VALUES (5001, 101, DATE '2023-10-01', 150.00, 10.00, DATE '2023-10-03');
INSERT INTO ORDERS VALUES (5002, 102, DATE '2023-10-02', 200.50, NULL, DATE '2023-10-05'); -- No discount
INSERT INTO ORDERS VALUES (5003, 101, DATE '2023-10-05', 75.00, 5.00, NULL); -- Not shipped
INSERT INTO ORDERS VALUES (5004, 104, DATE '2023-10-06', 300.00, NULL, NULL); -- No discount, Not shipped
INSERT INTO ORDERS VALUES (5005, 105, DATE '2023-10-07', 50.00, 0.00, DATE '2023-10-08');
INSERT INTO ORDERS VALUES (5006, NULL, DATE '2023-10-08', 20.00, NULL, DATE '2023-10-09'); -- Orphan order

COMMIT;
Here are 40 questions focused exclusively on **SQL Joins** (Inner, Left, Right, Full, Cross, Self, and Natural). These questions are designed to test how Joins interact with **NULL** values in your `CUSTOMERS` and `ORDERS` tables.

### Part 1: 20 Solved Join Questions (with Answers)

**1. (Inner Join) Retrieve a list of customers who have placed at least one order. Display Name and Order ID.**
*Note: This excludes customers with no orders and orders with NULL Customer IDs.*
```sql
SELECT C.FIRST_NAME, C.LAST_NAME, O.ORDER_ID
FROM CUSTOMERS C
INNER JOIN ORDERS O ON C.CUSTOMER_ID = O.CUSTOMER_ID;
```

**2. (Left Join) List all customers and their Order IDs. Include customers who have not placed any orders.**
*Note: Returns NULL in the Order column for customers like 'Robert' or 'Emily'.*
```sql
SELECT C.FIRST_NAME, O.ORDER_ID
FROM CUSTOMERS C
LEFT JOIN ORDERS O ON C.CUSTOMER_ID = O.CUSTOMER_ID;
```

**3. (Left Join - Finding Non-Matches) Find customers who have NEVER placed an order.**
*Note: We join, then filter for where the "Right" table is NULL.*
```sql
SELECT C.FIRST_NAME, C.LAST_NAME
FROM CUSTOMERS C
LEFT JOIN ORDERS O ON C.CUSTOMER_ID = O.CUSTOMER_ID
WHERE O.ORDER_ID IS NULL;
```

**4. (Right Join) List all orders and the associated customer name. Include orders that do not have a linked Customer ID.**
*Note: This will show Order 5006, which has a NULL Customer_ID.*
```sql
SELECT C.FIRST_NAME, O.ORDER_ID, O.TOTAL_AMOUNT
FROM CUSTOMERS C
RIGHT JOIN ORDERS O ON C.CUSTOMER_ID = O.CUSTOMER_ID;
```

**5. (Full Outer Join) List ALL customers and ALL orders. If a customer has no order, show NULLs for order info. If an order has no customer, show NULLs for customer info.**
```sql
SELECT C.FIRST_NAME, O.ORDER_ID
FROM CUSTOMERS C
FULL OUTER JOIN ORDERS O ON C.CUSTOMER_ID = O.CUSTOMER_ID;
```

**6. (Left Join with NVL) Calculate the total amount spent by each customer. If they haven't bought anything, display 0 instead of NULL.**
```sql
SELECT C.FIRST_NAME, NVL(SUM(O.TOTAL_AMOUNT), 0) AS TOTAL_SPENT
FROM CUSTOMERS C
LEFT JOIN ORDERS O ON C.CUSTOMER_ID = O.CUSTOMER_ID
GROUP BY C.FIRST_NAME;
```

**7. (Self Join) Find pairs of customers who live in the same City.**
*Note: We must exclude NULL cities and ensure we don't match a customer to themselves.*
```sql
SELECT A.FIRST_NAME AS CUST_1, B.FIRST_NAME AS CUST_2, A.CITY
FROM CUSTOMERS A
JOIN CUSTOMERS B ON A.CITY = B.CITY
WHERE A.CUSTOMER_ID < B.CUSTOMER_ID;
```

**8. (Cross Join) Generate a theoretical list of every customer buying every order (Cartesian Product).**
```sql
SELECT C.FIRST_NAME, O.ORDER_ID
FROM CUSTOMERS C
CROSS JOIN ORDERS O;
```

**9. (Natural Join) Join Customers and Orders automatically based on the common column (`CUSTOMER_ID`).**
*Note: Oracle does not require table aliases on the common column in a Natural Join.*
```sql
SELECT FIRST_NAME, ORDER_ID
FROM CUSTOMERS
NATURAL JOIN ORDERS;
```

**10. (Left Join & Filtering) List all Customers and their Order Dates, but only for orders placed after October 5th. Keep customers with NO orders in the list.**
*Note: The condition must be in the `ON` clause, not `WHERE`, to preserve the Left Join behavior for non-matching rows.*
```sql
SELECT C.FIRST_NAME, O.ORDER_DATE
FROM CUSTOMERS C
LEFT JOIN ORDERS O ON C.CUSTOMER_ID = O.CUSTOMER_ID AND O.ORDER_DATE > DATE '2023-10-05';
```

**11. (Full Join - Exclusive) Find records that are EITHER a Customer without an order OR an Order without a Customer (The "Anti-Join" of both sides).**
```sql
SELECT C.CUSTOMER_ID AS C_ID, O.ORDER_ID
FROM CUSTOMERS C
FULL OUTER JOIN ORDERS O ON C.CUSTOMER_ID = O.CUSTOMER_ID
WHERE C.CUSTOMER_ID IS NULL OR O.CUSTOMER_ID IS NULL;
```

**12. (Inner Join with Aggregates) Find the average loyalty points of customers who have actually placed an order.**
*Note: Distinct ensures we don't double count points if a customer ordered twice.*
'''sql
SELECT AVG(DISTINCT C.LOYALTY_POINTS)
FROM CUSTOMERS C
JOIN ORDERS O ON C.CUSTOMER_ID = O.CUSTOMER_ID;

**13. (Left Join with Coalesce) Display a report: "Customer Name - Order ID". If there is no order, display "Customer Name - No Order".**
```sql
SELECT C.FIRST_NAME || ' - ' || COALESCE(TO_CHAR(O.ORDER_ID), 'No Order') AS REPORT_LOG
FROM CUSTOMERS C
LEFT JOIN ORDERS O ON C.CUSTOMER_ID = O.CUSTOMER_ID;
```

**14. (Self Join on Inequality) Find pairs of orders where the first order has a higher amount than the second order.**
```sql
SELECT O1.ORDER_ID AS HIGH_VAL_ORDER, O2.ORDER_ID AS LOW_VAL_ORDER
FROM ORDERS O1
JOIN ORDERS O2 ON O1.TOTAL_AMOUNT > O2.TOTAL_AMOUNT;
```

**15. (Left Join) Count how many orders each customer has made.**
*Note: `COUNT(O.ORDER_ID)` is safer than `COUNT(*)` because it returns 0 for NULLs.*
```sql
SELECT C.FIRST_NAME, COUNT(O.ORDER_ID) AS ORDER_COUNT
FROM CUSTOMERS C
LEFT JOIN ORDERS O ON C.CUSTOMER_ID = O.CUSTOMER_ID
GROUP BY C.FIRST_NAME;
```

**16. (Right Join with Date Logic) List all orders and the Customer City. If the Customer is NULL (orphan order), display 'Unknown City'.**
```sql
SELECT O.ORDER_ID, NVL(C.CITY, 'Unknown City')
FROM CUSTOMERS C
RIGHT JOIN ORDERS O ON C.CUSTOMER_ID = O.CUSTOMER_ID;
```

**17. (Non-Equi Join) Find customers whose Loyalty Points are greater than the Total Amount of any single order.**
*Note: Joining based on value comparison rather than ID equality.*
```sql
SELECT DISTINCT C.FIRST_NAME, C.LOYALTY_POINTS, O.TOTAL_AMOUNT
FROM CUSTOMERS C
JOIN ORDERS O ON C.LOYALTY_POINTS > O.TOTAL_AMOUNT;
```

**18. (Left Join) List Customers and their "Shipping Status". If the order exists but Shipping Date is NULL, show 'Pending'. If no order exists, show 'N/A'.**
```sql
SELECT C.FIRST_NAME,
       CASE
           WHEN O.ORDER_ID IS NULL THEN 'N/A'
           WHEN O.SHIPPING_DATE IS NULL THEN 'Pending'
           ELSE 'Shipped'
       END AS STATUS
FROM CUSTOMERS C
LEFT JOIN ORDERS O ON C.CUSTOMER_ID = O.CUSTOMER_ID;
```

**19. (Using USING) Perform an Inner Join using the `USING` clause instead of `ON`.**
*Note: This works because both tables share the column name `CUSTOMER_ID`.*
```sql
SELECT FIRST_NAME, ORDER_ID
FROM CUSTOMERS
JOIN ORDERS USING (CUSTOMER_ID);
```

**20. (Multiple Join Conditions) Join Customers and Orders where the Customer ID matches AND the Customer has a valid City (City is not null).**
```sql
SELECT C.FIRST_NAME, O.ORDER_ID
FROM CUSTOMERS C
JOIN ORDERS O ON C.CUSTOMER_ID = O.CUSTOMER_ID
WHERE C.CITY IS NOT NULL;
```

---

### Part 2: 20 Practice Join Questions (Unsolved)

Use the solved examples above as a guide to figure these out.

-- 1.  **(Inner Join)** List the `FIRST_NAME` of the customer and the `TOTAL_AMOUNT` for all orders that have a Discount (`DISCOUNT_AMT` is not null).
     SELECT C.FIRST_NAME, O.TOTAL_AMOUNT FROM CUSTOMERS C JOIN ORDERS O ON C.CUSTOMER_ID = O.CUSTOMER_ID WHERE O.DISCOUNT_AMT IS NOT NULL

-- 2.  **(Left Join)** List all Customers. If they have an order, display the `ORDER_DATE`. If not, ensure the row still appears with a NULL date.
            select c.first_name, o.order_date from customers c left join orders o on c.customer_id = o.customer_id

-- 3.  **(Right Join)** Display `ORDER_ID` and `FIRST_NAME`. We want to see **all** orders, including the one with `CUSTOMER_ID` NULL (Order 5006).
            select o.order_id, c.first_name from customers c right join orders o on c.customer_id = o.customer_id

-- 4.  **(Full Outer Join)** Find the count of rows returned when you Full Outer Join Customers and Orders. (Try to predict the number before running it).
        select count(*) from customers c full outer join orders o on c.customer_id = o.customer_id

-- 5.  **(Left Join - Anti Join)** Find the `CUSTOMER_ID`s that exist in the `CUSTOMERS` table but do NOT exist in the `ORDERS` table.
       select c.customer_id from customers c left join orders o on c.customer_id = o.customer_id where o.order_id is null

-- 6.  **(Self Join)** Find pairs of Orders (`O1`, `O2`) that were placed on the exact same `ORDER_DATE`.
      select o1.order_id, o2.order_id, o1.order_date from orders o1 join orders o2 on o1.order_date = o2.order_date and o1.order_id < o2.order_id

-- 7.  **(Cross Join)** Create a list showing every Customer paired with every unique `CITY` found in the Customer table.
    select c.first_name, c2.city from customers c cross join (select distinct city from customers) c2

-- 8.  **(Inner Join + Aggregates)** Calculate the total `DISCOUNT_AMT` given to customers living in 'New York'.
      select sum(o.discount_amt) from customers c join orders o on c.customer_id = o.customer_id where c.city = 'new york'

-- 9.  **(Left Join + NVL)** Select `FIRST_NAME` and the `SHIPPING_DATE`. If the shipping date is NULL (either because the order isn't shipped OR the customer has no order), display 'Not Shipped'.
       select c.first_name, nvl(to_char(o.shipping_date,'yyyy-mm-dd'),'not shipped') from customers c left join orders o on c.customer_id = o.customer_id

-- 10. **(Right Join)** Find the sum of `TOTAL_AMOUNT` for orders that do **not** have a linked Customer (Orphan orders).
        select sum(o.total_amount) from customers c right join orders o on c.customer_id = o.customer_id where c.customer_id is null

-- 11. **(Natural Join)** Use a Natural Join to display `LAST_NAME` and `TOTAL_AMOUNT`. (Be careful: does `LOYALTY_POINTS` exist in both tables? No? Then it uses `CUSTOMER_ID`).
      select last_name, total_amount from customers natural join orders

-- 12. **(Left Join with Multiple Conditions)** Join Customers to Orders, but ONLY link orders where the `TOTAL_AMOUNT` is greater than 100. Customers with small orders should look like they have NULL orders.
       select c.first_name, o.order_id, o.total_amount from customers c left join orders o on c.customer_id = o.customer_id and o.total_amount > 100

-- 13. **(Inner Join)** List `FIRST_NAME` and `ORDER_ID` for customers who have a Phone Number (`IS NOT NULL`).
       select c.first_name, o.order_id from customers c join orders o on c.customer_id = o.customer_id where c.phone_number is not null

-- 14. **(Full Join + Coalesce)** Display a list of IDs. If it's a Customer without an order, show Customer ID. If it's an Order without a Customer, show Order ID. Use `COALESCE`.
       select coalesce(c.customer_id, o.order_id) as id from customers c full outer join orders o on c.customer_id = o.customer_id

-- 15. **(Self Join)** Find customers who have the same `LOYALTY_POINTS` value as another customer.
       select a.first_name, b.first_name, a.loyalty_points from customers a join customers b on a.loyalty_points = b.loyalty_points and a.customer_id < b.customer_id

-- 16. **(Inner Join)** Display `FIRST_NAME`, `CITY`, and `ORDER_DATE` for orders that have actually been shipped (`SHIPPING_DATE` is not null).
       select c.first_name, c.city, o.order_date from customers c join orders o on c.customer_id = o.customer_id where o.shipping_date is not null

-- 17. **(Left Join)** Calculate the Average `TOTAL_AMOUNT` per Customer. Ensure customers with no orders show up (likely as NULL or 0 depending on how you write the Average).
      select c.first_name, avg(o.total_amount) from customers c left join orders o on c.customer_id = o.customer_id group by c.first_name

-- 18. **(Cartesian/Cross)** Count how many rows are generated if you Cross Join `CUSTOMERS` (5 rows) and `ORDERS` (6 rows).
      select count(*) from customers cross join orders

-- 19. **(Join with Date Comparison)** Find Customers who placed an order on the same day their account was created? (Wait, we don't have account creation date. Instead: Find Orders placed *after* the shipping date? This checks for data errors).
     selct c.first_name, o.order_id, o.order_date, o.shipping_date from customers c join orders o on c.customer_id = o.customer_id where o.order_date > o.shipping_date;

-- 20. **(Three-way Simulation)** *Advanced Challenge:* Perform a Left Join from Customers to Orders, and then Self Join that result to find Customers who have placed **more than one** order.
     SELECT DISTINCT C.FIRST_NAME FROM CUSTOMERS C
     LEFT JOIN ORDERS O1  ON C.CUSTOMER_ID = O1.CUSTOMER_ID
     LEFT JOIN ORDERS O2  ON C.CUSTOMER_ID = O2.CUSTOMER_ID
     AND O1.ORDER_ID < O2.ORDER_ID WHERE O2.ORDER_ID IS NOT NULL
      