-- DATE FUNCTIONS – 20 Questions
  
-- Extract year from Order_Date.
    select EXTRACT(YEAR FROM Order_Date) AS Order_Year from Orders;

-- Extract month from Order_Date.
    select EXTRACT(MONTH FROM Order_Date) AS Order_Month from Orders;

-- Extract day from Order_Date.
    select EXTRACT(DAY FROM Order_Date) AS Order_Day from Orders;

-- Find current date.
    select SYSDATE from DUAL;

-- Find current timestamp.
   select SYSDATE from DUAL;

-- Add 7 days to Order_Date.
   select Order_Date + 7 AS New_Date from Orders;

-- Subtract 30 days from Order_Date.
   select Order_Date - 30 AS New_Date from Orders;

-- Find difference between two dates.
   select end_date - start_date AS difference_in_days FROfrom orders;

--Find number of months between two dates.
   select months_between(sysdate, order_date) as months_difference from orders;

--Find last day of the month.
   select LAST_DAY(Order_Date) from Orders;

-- Get first day of the year.
   select MAKEDATE(YEAR(Order_Date),1) from Orders;

-- Format date as 'DD-MM-YYYY'.
   select TO_CHAR(Order_Date, 'DD-MM-YYYY') AS formatted_date from Orders;

-- Convert string to date.
   select TO_DATE('24-02-2026', 'DD-MM-YYYY') from dual;

-- Convert date to string.
   select TO_CHAR(Order_Date, 'YYYY/MM/DD') AS formatted_date from Orders;

-- Find week number of the year.
    select TO_CHAR(Order_Date, 'WW') AS week_number from Orders;

-- Find day name from date.
    select TO_CHAR(Order_Date, 'Day') AS day_name from Orders;

-- Find quarter of the year.
   select TO_CHAR(Order_Date, 'Q') AS quarter  from Orders;

-- Calculate age from DOB.
    select FLOOR(MONTHS_BETWEEN(SYSDATE, TO_DATE('2000-01-01','YYYY-MM-DD')) / 12) AS years_difference from dual;

-- Check if date is weekend.
    SELECT CASE 
         WHEN DATEPART(WEEKDAY, Order_Date) IN (1,7) THEN 'Weekend'
         ELSE 'Weekday'END AS day_type
         FROM Orders;
-- Find next Monday after a given date.
   select NEXT_DAY(Order_Date, 'SUNDAY') AS next_sunday from Orders;