/* 
Business Problem: E-Commerce Sales & Customer Analytics

Objective:
As a Data Analyst at an e-commerce company, the objective is to analyze transactional data 
to uncover actionable insights that drive revenue growth, improve customer retention, 
and optimize product and marketing strategies.

The analysis focuses on understanding customer behavior, product performance, and regional trends 
to support data-driven business decisions.

Key Business Questions:

1. Product Performance Analysis:
   - Identify top-performing product categories contributing the highest revenue.
   - Detect underperforming categories to optimize inventory and promotional strategies.

2. Customer Segmentation & Value Analysis:
   - Identify the top 10% of high-value customers based on total spending.
   - Analyze repeat vs one-time buyers to evaluate customer loyalty.
   - Segment customers based on purchase behavior and spending patterns.

3. Sales Trend Analysis:
   - Analyze monthly and quarterly revenue trends to identify seasonality.
   - Detect peak sales periods and potential demand fluctuations.

4. Customer Purchase Behavior:
   - Measure purchase frequency per customer.
   - Identify frequent buyers vs occasional buyers for targeted engagement strategies.

5. Regional Performance Analysis:
   - Evaluate revenue contribution by location.
   - Identify high-performing and underperforming regions.
   - Support region-specific marketing and expansion strategies.

6. Discount Effectiveness:
   - Analyze the impact of discounts on sales and revenue.
   - Evaluate whether discounts drive higher conversions or reduce profitability.

7. Cross-Sell & Product Affinity Analysis:
   - Identify patterns of products purchased together.
   - Recommend bundle offers and cross-selling opportunities.

Expected Outcome:
The analysis will enable the business to:
- Increase revenue through optimized product and pricing strategies
- Improve customer retention by targeting high-value and repeat customers
- Enhance marketing effectiveness through data-driven segmentation
- Support strategic decision-making across product, customer, and regional levels
*/
create schema ecommerce;
use ecommerce;
select * from ecommerce_orders limit 3;

SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN cid IS NULL THEN 1 ELSE 0 END) AS cid_nulls,
    SUM(CASE WHEN tid IS NULL THEN 1 ELSE 0 END) AS tid_nulls,
    SUM(CASE WHEN gender IS NULL THEN 1 ELSE 0 END) AS gender_nulls,
    SUM(CASE WHEN `Age Group` IS NULL THEN 1 ELSE 0 END) AS age_group_nulls,
    SUM(CASE WHEN `Purchase Date` IS NULL THEN 1 ELSE 0 END) AS purchase_date_nulls,
    SUM(CASE WHEN `Product Category` IS NULL THEN 1 ELSE 0 END) AS product_category_nulls,
    SUM(CASE WHEN `Discount Availed` IS NULL THEN 1 ELSE 0 END) AS discount_availed_nulls,
    SUM(CASE WHEN `Discount Name` IS NULL THEN 1 ELSE 0 END) AS discount_name_nulls,
    SUM(CASE WHEN `Discount Amount (INR)` IS NULL THEN 1 ELSE 0 END) AS discount_amount_nulls,
    SUM(CASE WHEN `Gross Amount` IS NULL THEN 1 ELSE 0 END) AS gross_amount_nulls,
    SUM(CASE WHEN `Net Amount` IS NULL THEN 1 ELSE 0 END) AS net_amount_nulls,
    SUM(CASE WHEN `Purchase Method` IS NULL THEN 1 ELSE 0 END) AS purchase_method_nulls,
    SUM(CASE WHEN Location IS NULL THEN 1 ELSE 0 END) AS location_nulls
FROM ecommerce_orders;
SELECT CID,TID,Gender ,`Age Group` ,`Purchase Date`,
`Product Category` ,`Discount Availed` ,`Discount Name` ,`Discount Amount (INR)` ,`Gross Amount`,`Net Amount` ,`Purchase Method` ,Location  ,
       COUNT(*) AS duplicate_count
FROM ecommerce_orders
GROUP BY  CID,TID,Gender ,`Age Group` ,`Purchase Date`,
`Product Category` ,`Discount Availed` ,`Discount Name` ,`Discount Amount (INR)` ,`Gross Amount`,`Net Amount` ,`Purchase Method` ,Location
HAVING COUNT(*) > 1;
select count(*) from ecommerce_orders;
select * from ecommerce_orders limit 3;
select round(sum(`Net Amount`),0) as Total_Sales from  ecommerce_orders;
-- Total Sales Amount Is Nearly 15.8 Crores
select avg(`Net Amount`) as Average_Sales from  ecommerce_orders;
-- Average sales price is '2875'
select count(tid) as Total_orders from  ecommerce_orders;
-- Total order is '55000'
select avg(`Discount Amount (INR)`) as Average_Discount from  ecommerce_orders;
-- Company is giving nearly 137 Inr in discount

-- Gender wise count
select gender ,count(gender) as total_count_of_gender from ecommerce_orders group by gender;
-- Male ,Female and Other Have nearly same count that is between 18000 to 18460

-- Month and year wise sales
SELECT DATE_FORMAT(`Purchase Date`, '%Y-%m') AS month, round(SUM(`Net Amount`),0) AS monthly_sales
FROM ecommerce_orders
GROUP BY month
ORDER BY  monthly_sales desc,month  ;
/*
Top 2 Maximum Sales month is
'2021-12', '3711177'
'2023-12', '3900779'
 */
 -- Farther time impact on sales show at dashboard Visualy
 
 -- Location wise total orders and net sales
SELECT location, COUNT(*) AS total_orders, round(SUM(`Net Amount`),0) AS total_sales
FROM ecommerce_orders
GROUP BY location
ORDER BY total_sales DESC;
-- Mumbai, Delhi and Banglore have contribute nearly 3.2 cr, 3.1 cr and 2.36 cr in Total sales , That is nearly 54 % to 55 %
-- So focus on ads and campaigns in these 3 cities

-- Top 3 Most selling products in cities
SELECT *
FROM (
    SELECT Location, `Product Category`, ROUND(SUM(`Net Amount`), 0) AS `Total Sales`,
        RANK() OVER (
            PARTITION BY Location ORDER BY SUM(`Net Amount`) DESC) AS `Rank in City`
    FROM ecommerce_orders
    GROUP BY Location, `Product Category`
) AS ranked_data
WHERE `Rank in City` <= 3
ORDER BY Location, `Rank in City`;
-- In Every cities, top 3 most selling product is "Electronics" ,"Clothing" and "Beauty And Health"
-- So Focus on advertisement of These 3 Products more

-- Ordes and Net Amount From Payment Method
SELECT `Purchase Method`, COUNT(*) AS `Total Ordes`, round(SUM(`Net Amount`),0) AS `Total Sales`
FROM ecommerce_orders
GROUP BY `Purchase Method`
order by `Total Sales`  desc ;
--  Payments through Credit Card,Debit Card and Net Banking  are nearly 6.36Cr, 3.97Cr and 1.57Cr, that is  nearly 75% of Total Payments
-- So  make sure , It is easy For customers to Pay Through these And give Them Offers when They pay from Credit Cards
-- Age Group Wise Sales
SELECT `Age Group`, COUNT(*) AS `Total Ordes`,  round(SUM(`Net Amount`),0) AS `Total Sales`
FROM ecommerce_orders
GROUP BY `Age Group`
order by  `Total Sales` desc ;
-- Age Group "25-45": And "18-25" are contribute 6.39Cr and 4.68Cr respectivaly, That is 70% of Total sales
-- So focus on adds where These two age group people has persence, like - social media,Near office and College ...Etc

select * from ecommerce_orders limit 3;
-- Product Category Wise Sales
select `Product Category` ,round(sum(`Net Amount`),0) as `Total Sales`
from ecommerce_orders
group by `Product Category`
order by `Total Sales` desc;
-- "Electronics","Clothing" And "Beauty and Health" are contributing nearly 4.74Cr , 3.12Cr and 2.41Cr respectivaly,That is Nearly 65%

-- Top 10 % Customers by Spending
-- sales by top 10% Customers
CREATE VIEW `Top 10% Customers` AS
SELECT 
    cid,total_spent
FROM (SELECT cid,SUM(`Net Amount`) AS total_spent,
NTILE(10) OVER (ORDER BY SUM(`Net Amount`) DESC) AS grp
FROM ecommerce_orders
GROUP BY cid
) t
WHERE grp = 1;
select round(sum(total_spent),0) as `Total Sales` from `Top 10% Customers`;
-- Total Sales  By top 10% Customers is 3.24Cr, That is nearly 25% of Total sales
-- 1/10 Customers contributes 1/4 of total sales ,These are most Valuabe Customers foe Companies
-- So Give them gift for their values, like offers,coupen ,Voucher ....Etc,For make them Feel Valuabel,This increase trust of those at Company

   -- Analyze repeat vs one-time buyers.
 SELECT 
    customer_type,
    COUNT(*) AS total_customers,
    ROUND(SUM(total_spent), 0) AS total_revenue,
    ROUND(AVG(total_spent), 0) AS avg_revenue_per_customer
FROM (
    SELECT 
        cid,
        COUNT(*) AS purchase_count,
        SUM(`Net Amount`) AS total_spent,
        CASE 
            WHEN COUNT(*) = 1 THEN 'One-Time Buyer'
            ELSE 'Repeat Buyer'
        END AS customer_type
    FROM ecommerce_orders
    GROUP BY cid
) AS customer_data
GROUP BY customer_type;

 -- Company has 55.2% Loyal customers and they are Contributing 76.3 % of Total Revenue,and their average revenue is also 7517
 
   -- Segment customers based on spending patterns.
 SELECT 
    customer_segment,
    COUNT(*) AS total_customers,
    ROUND(AVG(total_spent), 0) AS avg_spending,
    ROUND(SUM(total_spent), 0) AS total_revenue
FROM (
    SELECT 
        cid,
        SUM(`Net Amount`) AS total_spent,
        CASE 
            WHEN SUM(`Net Amount`) < 5000 THEN 'Low Value'
            WHEN SUM(`Net Amount`) BETWEEN 5000 AND 20000 THEN 'Medium Value'
            ELSE 'High Value'
        END AS customer_segment
    FROM ecommerce_orders
    GROUP BY cid
) AS segmented_data
GROUP BY customer_segment
ORDER BY total_revenue DESC;
-- Medium segment customers contributes in revenue nearly 71%

select * from ecommerce_orders limit 3;


-- Identify frequent buyers vs occasional buyers.
   SELECT 
    customer_type,
    COUNT(*) AS total_customers,
    ROUND(AVG(total_orders), 0) AS avg_orders,
    ROUND(SUM(total_spent), 0) AS total_revenue
FROM (
    SELECT 
        cid,
        COUNT(*) AS total_orders,
        SUM(`Net Amount`) AS total_spent,
        CASE 
            WHEN COUNT(*) = 1 THEN 'One-Time Buyer'
            WHEN COUNT(*) BETWEEN 2 AND 5 THEN 'Occasional Buyer'
            ELSE 'Frequent Buyer'
        END AS customer_type
    FROM ecommerce_orders
    GROUP BY cid
) AS customer_data
GROUP BY customer_type
ORDER BY total_revenue DESC;
-- Occasional Buyer contribute in sell nearly 74% of totsl sales


--  Regional Sales Performance:
  
   SELECT 
    Location,
    ROUND(SUM(`Net Amount`), 0) AS total_revenue,
    ROUND(
        SUM(`Net Amount`) * 100 / SUM(SUM(`Net Amount`)) OVER (), 
        2
    ) AS revenue_percentage
FROM ecommerce_orders
GROUP BY Location
ORDER BY revenue_percentage DESC;
  
-- Metro cities contribute the majority of total revenue → strong purchasing power and digital adoption.

-- Product Associations & Cross-Sell Opportunities
SELECT 
    a.`Product Category` AS product_1,
    b.`Product Category` AS product_2,
    COUNT(*) AS pair_count
FROM ecommerce_orders a
JOIN ecommerce_orders b
    ON a.tid = b.tid
    AND a.`Product Category` < b.`Product Category`
GROUP BY product_1, product_2
HAVING pair_count > 50
ORDER BY pair_count DESC;

SELECT 
    tid,
    COUNT(DISTINCT `Product Category`) AS product_count
FROM ecommerce_orders
GROUP BY tid
HAVING product_count > 1;
/*
Cross-sell analysis was attempted using transaction-level joins. However, the dataset contains only one product per transaction,
 limiting the ability to identify product associations. In real-world scenarios,
 basket-level data would enable deeper cross-selling insights.
 */
 
select distinct(`Product Category`) from ecommerce_orders;