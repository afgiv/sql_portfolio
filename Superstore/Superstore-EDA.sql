-- EDA (Superstore Analysis: 2014-2017)

/*
Executive Summary

This analysis explores a Superstore dataset spanning 2014–2017, covering 793 unique customers and 4,851 orders.
Over the period, the store generated $2.18M in sales with $270K in profit, resulting in a 12.4% profit margin.

Key findings reveal that 16% of products generated losses, largely driven by aggressive discounting and mispriced items.
Shipping preferences leaned heavily toward standard class, while consumer and corporate segments accounted for the majority of sales.

Scenario testing showed strong upside potential:

Reducing discounts by 10% → +19.9% profit gain
Increasing prices by 5% → +40.3% profit gain
Combining both strategies → +61.2% profit gain

Overall, the store demonstrates solid sales volume but suffers from profit leakage, with actionable opportunities in discount control and pricing optimization.
*/

-- Timeframe
SELECT MIN(`Order Date`), MAX(`Order Date`)
FROM superstore_stage;
-- Almost 4 years of data, from 2014 January to 2017 December

-- How many customers did the store have?
SELECT COUNT(DISTINCT `Customer ID`), COUNT(DISTINCT `Customer Name`)
FROM superstore_stage;
-- Both Customer ID and Customer Name shows the same count of 793 customers within the timeframe

-- How many orders were made? How about the products? How many did we sell on total?
SELECT COUNT(DISTINCT `Order ID`) AS order_count, COUNT(`Product Name`) AS prod_count, SUM(Quantity) AS units_sold
FROM superstore_stage;
-- A total of 4,851 unique orders, 9,382 products, and 35,559 units in total were sold

-- How many products are listed per order?
SELECT COUNT(*) AS total_orders, ROUND(AVG(products_per_order)) AS avg_products_per_order, MAX(products_per_order) AS max_product_order,
MIN(products_per_order) AS min_product_order
FROM (
SELECT `Order ID`, COUNT(DISTINCT `Product Name`) AS products_per_order
FROM superstore_stage
GROUP BY `Order ID`
) AS sub;
-- On average, each order contained about 2 products. The smallest basket had 1 product, while the largest contained 12 products

-- What are the total sales and profit?
SELECT ROUND(SUM(Sales), 2) as total_sales, ROUND(SUM(Profit), 2) AS total_profit, ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS profit_margin
FROM superstore_stage;
-- From a span of 4 years, total Sales generated was 2,175,857.71 and Total Profit generated 270,124.75 having a 12.41% profit margin

-- Which category of products is the most common? But which of them generated more sales and profit?
SELECT Category, COUNT(Category) AS Cat_count, ROUND(SUM(Sales), 2) AS total_sales, ROUND(SUM(Profit), 2) AS total_profit
FROM superstore_stage
GROUP BY Category 
ORDER BY Cat_count DESC;
-- Office Supplies is the most common category, but Technology contributes more in terms of sales and profit

-- Which sub-category of products is the most common? But which of them generated more sales and profit?
SELECT `Sub-Category`, COUNT(`Sub-Category`) AS sub_count, ROUND(SUM(Sales), 2) AS total_sales, ROUND(SUM(Profit), 2) AS total_profit
FROM superstore_stage
GROUP BY `Sub-Category`
ORDER BY sub_count DESC;
-- Binders are the most common then papers, but Copiers which is the least, generated more sales and profit than the rest

-- Which state(Top 10) generated more sales and profit?
SELECT State, ROUND(SUM(Sales), 2) AS total_sales, ROUND(SUM(Profit), 2) AS total_profit
FROM superstore_stage
GROUP BY State
ORDER BY total_sales DESC
LIMIT 10;
-- The state of California generated 422,000.19 in sales but New York generated more profit

-- Which Region generated more sales and profit?
SELECT Region, COUNT(Region) AS Count, ROUND(SUM(Sales), 2) AS total_sales, ROUND(SUM(Profit), 2) AS total_profit
FROM superstore_stage
GROUP BY Region
ORDER BY Count DESC;
-- The West Region generated more sales and profit

-- Which type of ship mode is the most common?
SELECT `Ship Mode`, COUNT(`Ship Mode`) AS Count
FROM superstore_stage
GROUP BY `Ship Mode`
ORDER BY Count DESC;
-- The Standard Class is the most common type of Ship Mode

-- What is the average days before the product is shipped?
SELECT ROUND(AVG(DATEDIFF(`Ship Date`, `Order Date`))) AS avg_days
FROM superstore_stage;
-- An average of 4 days before the product is shipped

-- What is the average days before the product is shipped based on the type of ship mode?
SELECT `Ship Mode`, ROUND(AVG(DATEDIFF(`Ship Date`, `Order Date`))) AS avg_days
FROM superstore_stage
GROUP BY `Ship Mode`
ORDER BY avg_days;
-- For the Standard Class ship mode, it would take at least 5 days before the product is shipped

-- Which group of customers are the most common? But which of them generated more sales and profit?
SELECT Segment, COUNT(Segment) AS Count, ROUND(SUM(Sales), 2) AS total_sales, ROUND(SUM(Profit), 2) AS total_profit
FROM superstore_stage
GROUP BY Segment
ORDER BY Count DESC;
-- The Consumer group are the most common type of customer and generated more sales and profit than the others

-- Which product is best seller? Do they profit? Vice versa?
SELECT `Product Name`, ROUND(SUM(Sales), 2) AS total_sales, ROUND(SUM(Profit), 2) AS total_profit
FROM superstore_stage
GROUP BY `Product Name`
ORDER BY total_sales DESC
LIMIT 5;

SELECT `Product Name`, ROUND(SUM(Sales), 2) AS total_sales, ROUND(SUM(Profit), 2) AS total_profit
FROM superstore_stage
GROUP BY `Product Name`
ORDER BY total_profit DESC
LIMIT 5;
-- The product 'Canon imageCLASS 2200 Advanced Copier' is the best seller and best profiter but the 'Cisco TelePresence System EX90 Videoconferencing Unit' incurred a loss

-- Which products incurred a loss? To check why these products incurred losses, include the necessarry features and study them
SELECT `Product Name`, MAX(`Unit Cost`) AS Unit_Cost, MAX(`Unit Price`) AS Unit_Price, ROUND(SUM(Quantity), 2) AS total_Quantity, 
ROUND(SUM(`Unit Price` * Quantity * Discount), 2) AS total_Discounted_Amount, ROUND(SUM(Sales), 2) AS total_Sales, 
ROUND(SUM(`Unit Cost` * Quantity), 2) AS total_Cost, ROUND(SUM(Profit), 2) AS Neg_Profit
FROM superstore_stage
GROUP BY `Product Name`
HAVING ROUND(SUM(Profit), 2) < 0
ORDER BY Neg_Profit ASC
LIMIT 5;
-- The 'Cubify CubeX 3D Printer Double Head Print' incurred a loss of 8879.97, likely due to excessive discounting

-- How many products had loss?
SELECT COUNT(*) AS product_count, COUNT(CASE WHEN total_profit < 0 THEN 1 END) AS neg_prod_count,
ROUND((COUNT(CASE WHEN total_profit < 0 THEN 1 END) / COUNT(*)) * 100, 2) AS pct
FROM (
SELECT `Product Name`, ROUND(SUM(Profit), 2) AS total_profit
FROM superstore_stage
GROUP BY `Product Name`
) AS sub;
-- 16% of the total 1,738 products incurred loss

-- Are the products high enough above cost? Price Markup %
SELECT `Product Name`, MAX(`Unit Cost`), MAX(`Unit Price`), ROUND(((MAX(`Unit Price`) - MAX(`Unit Cost`)) / MAX(`Unit Cost`)) * 100, 2) AS Markup_pct
FROM superstore_stage
GROUP BY `Product Name`
ORDER BY Markup_pct;
-- Some products did not give any profit because pricing is the same with the costing (Lower Markup % means price <= cost)

-- How much was earned after the discounts? Price Realization % & Weighted Discount Rate
SELECT `Product Name`, SUM(Quantity) AS Quantity, ROUND(SUM(Sales), 2) AS Total_Sales, ROUND(SUM(`Unit Price` * Quantity), 2) AS Full_Price_Revenue, 
ROUND(SUM(`Unit Price` * Quantity * Discount) / SUM(`Unit Price` * Quantity), 2) AS Weighted_Disc_Rate,
ROUND((SUM(Sales)/SUM(`Unit Price` * Quantity)) * 100, 2) AS Price_Real_pct
FROM superstore_stage
GROUP BY `Product Name`
ORDER BY Price_Real_pct;
-- Some products did very little profit due to heavy discount (Lower Price Realization % or higher Weighted Discount Rate means heavy discount)

-- How much of the sales are eaten up by the costing? Cost-to-Sales Ratio
SELECT `Product Name`, ROUND(SUM(`Unit Cost` * Quantity), 2) AS total_cost, ROUND(SUM(Sales), 2) AS total_sales,
ROUND((SUM(`Unit Cost` * Quantity) / SUM(Sales)) * 100, 2) AS cost_sale_ratio_pct
FROM superstore_stage
GROUP BY `Product Name`
ORDER BY cost_sale_ratio_pct DESC;
-- Some products have a high cost-to-sale ratio percentage thus incurring a loss (High Cost-to-Sale Ratio % means product is being sold to a loss)

-- How much of the revenue are being given away? Is it effective? Discount % of Sales and Profit Margin % relation
SELECT `Product Name`, ROUND(SUM(`Unit Cost` * Quantity * Discount), 2) AS total_disc_amount, ROUND(SUM(Sales), 2) AS total_sales,
ROUND((SUM(`Unit Cost`* Quantity * Discount) / SUM(Sales)), 2) AS disc_pct_of_sales, ROUND((SUM(Profit)/SUM(Sales)) * 100, 2) AS profit_margin_pct
FROM superstore_stage
GROUP BY `Product Name`
ORDER BY disc_pct_of_sales DESC;
-- Even though very little percentage of revenue is given away through discount, products are incurring loss due to bad pricing

-- Which products rely on discounts to sell? Average Discount per Product Rate
SELECT `Product Name`, ROUND(AVG(Discount), 2) AS avg_disc_rate, ROUND(SUM(Sales), 2) AS total_sales, ROUND(SUM(Profit), 2) AS total_profit
FROM superstore_stage
GROUP BY `Product Name`
ORDER BY avg_disc_rate DESC;
-- Some products are heavily discounted in order to sell thus incurring loss

-- How much each unit sold is contributing to the profit? Contribution Margin Per Unit
SELECT `Product Name`, ROUND(SUM(Sales) - SUM(`Unit Cost` * Quantity), 2) AS total_gross_profit, SUM(Quantity) AS total_quantity,
ROUND((SUM(Sales) - SUM(`Unit Cost` * Quantity)) / SUM(Quantity), 2) AS Contribution_Margin_per_Unit
FROM superstore_stage
GROUP BY `Product Name`
ORDER BY Contribution_Margin_per_Unit DESC;
-- Even though the data shows products have low volume in sales, they generated high margin profit per unit

-- Are high volume orders actually worth it or are they just good in numbers? Profit per Order
SELECT `Product Name`, COUNT(DISTINCT `Order ID`) AS order_count, ROUND(SUM(Profit), 2) AS total_profit,
ROUND(SUM(Profit)/COUNT(DISTINCT `Order ID`), 2) AS profit_per_order
FROM superstore_stage
GROUP BY `Product Name`
ORDER BY profit_per_order DESC;
-- Some products had few orders made but have a high profit per order

-- How much money was given away due to discounts or pricing inefficiency? Leakage Analysis
SELECT `Product Name`, ROUND(SUM((`Unit Price` - `Unit Cost`) * Quantity), 2) AS expected_profit, ROUND(SUM(Profit), 2) AS actual_profit,
ROUND(SUM((`Unit Price` - `Unit Cost`) * Quantity) - SUM(Profit), 2) AS profit_leak
FROM superstore_stage
GROUP BY `Product Name`
ORDER BY profit_leak DESC;
-- A lot of products incurred loss and a huge profit leak, likely due to pricing inefficiency and discount

-- In order to avoid loss, what is the minimum price of each product so that it will still profit even after the discount? Break-Even Price
SELECT `Product Name`, ROUND(AVG(`Unit Cost` / (1 - Discount)), 2) AS break_price, ROUND(AVG(`Unit Price`), 2) AS avg_price,
ROUND(AVG(`Unit Price`) - AVG(`Unit Cost` / (1 - Discount)), 2) AS price_gap
FROM superstore_stage
GROUP BY `Product Name`
ORDER BY price_gap;
-- A lot of products are too far from the minimum break even price resulting to a loss

-- What if discounts are reduced by 10%? How about if unit price is raised 5%? What are the profits? Scenario Analysis
WITH curr AS (
SELECT ROUND(SUM(Sales), 2) AS current_sales, ROUND(SUM(Profit), 2) AS current_profit
FROM superstore_stage),
scenarios AS (
SELECT 'Reduce Discounts by 10%' AS scenario, ROUND(SUM(`Unit Price` * Quantity * (1 - (Discount * 0.9))), 2) AS new_sales,
ROUND(SUM(`Unit Price` * Quantity * (1 - (Discount * 0.9)) - (`Unit Cost` * Quantity)), 2) AS new_profit
FROM superstore_stage
UNION ALL
SELECT 'Increase Price by 5%' AS scenario, ROUND(SUM((`Unit Price` * 1.05) * Quantity * (1 - Discount)), 2) AS new_sales,
ROUND(SUM((`Unit Price` * 1.05) * Quantity * (1 - Discount) - (`Unit Cost` * Quantity)), 2) AS new_profit
FROM superstore_stage
UNION ALL
SELECT 'Discount -10% and Price +5%' AS scenario, ROUND(SUM((`Unit Price` * 1.05) * Quantity * (1 - (Discount * 0.9))), 2) AS new_sales,
ROUND(SUM((`Unit Price` * 1.05) * Quantity * (1 - (Discount * 0.9)) - (`Unit Cost` * Quantity)), 2) AS new_profit
FROM superstore_stage)
SELECT s.scenario, c.current_sales, s.new_sales, ROUND(((s.new_sales - c.current_sales) / c.current_sales) * 100, 2) AS sales_pct_diff,
c.current_profit, s.new_profit, ROUND(((s.new_profit - c.current_profit) / c.current_profit) * 100, 2) AS profit_pct_diff
FROM scenarios AS s
CROSS JOIN curr AS c;
-- Scenario analysis shows that if discounts are reduced by 10%, increase price by 5%, or combination of both, profit could increase by 19.9%, 40.3%, and 61.2%, respectively