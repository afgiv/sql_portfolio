-- Create the database
CREATE DATABASE supersales_db;

-- Check if data is imported successfully
SELECT *
FROM superstore;

-- Create a staging table to work with
CREATE TABLE superstore_stage
LIKE superstore;

INSERT superstore_stage
SELECT * FROM superstore;

-- Check the staging table and start working from there
SELECT *
FROM superstore_stage;

-- Checking the CSV file, Row ID has 9994 but only 9694 records were imported
SELECT MAX(`Row ID`), COUNT(*) FROM superstore_stage; -- Fix the Row ID after the deletion of duplicates

-- Check the datatype of each column
DESCRIBE superstore_stage;

-- Transform the Order Date and Ship Date to Date type
UPDATE superstore_stage
SET `Order Date` = STR_TO_DATE(`Order Date`, '%m/%d/%Y');

ALTER TABLE superstore_stage
MODIFY COLUMN `Order Date` DATE;

UPDATE superstore_stage
SET `Ship Date` = STR_TO_DATE(`Ship Date`, '%m/%d/%Y');

ALTER TABLE superstore_stage
MODIFY COLUMN `Ship Date` DATE;

-- Check if the data table has duplicates
SELECT `Order ID`, `Order Date`, `Ship Date`, `Ship Mode`, `Customer ID`, `Customer Name`, `Segment`, `Country`, `City`, `State`, `Postal Code`, `Region`, `Product ID`,
`Category`, `Sub-Category`, `Product Name`, `Sales`, `Quantity`, `Discount`, `Profit` , COUNT(*) as Count
FROM superstore_stage
GROUP BY `Order ID`, `Order Date`, `Ship Date`, `Ship Mode`, `Customer ID`, `Customer Name`, `Segment`, `Country`, `City`, `State`, `Postal Code`, `Region`, `Product ID`,
`Category`, `Sub-Category`, `Product Name`, `Sales`, `Quantity`, `Discount`, `Profit`
HAVING Count > 1; -- Returned 1 row with 2 counts

-- Check the duplicates
SELECT *
FROM superstore_stage
WHERE `Order ID` = 'US-2014-150119'; -- Rows 3406 & 3407

-- In order to delete, create a temp table and use that to delete the duplicate, using MIN() will keep the lowest value thus having only 1 copy
DELETE FROM superstore_stage
WHERE `Row ID` NOT IN(
SELECT * FROM (
SELECT MIN(`Row ID`) as `Row ID`
FROM superstore_stage
GROUP BY `Order ID`, `Order Date`, `Ship Date`, `Ship Mode`, `Customer ID`, `Customer Name`, `Segment`, `Country`, `City`, `State`, `Postal Code`, `Region`, `Product ID`,
`Category`, `Sub-Category`, `Product Name`, `Sales`, `Quantity`, `Discount`, `Profit`) as temp);

-- Check through each column for any misspelled texts

SELECT DISTINCT `Ship Mode`
FROM superstore_stage
GROUP BY `Ship Mode`;

-- Check the relationship of the Customer ID and Cusomer Name
SELECT `Customer ID`, COUNT(DISTINCT `Customer Name`) AS name_count
FROM superstore_stage
GROUP BY `Customer ID`
HAVING name_count > 1;

SELECT `Customer Name`, COUNT(DISTINCT `Customer ID`) AS id_count
FROM superstore_stage
GROUP BY `Customer Name`
HAVING id_count > 1;

SELECT DISTINCT Segment
FROM superstore_stage
GROUP BY Segment;

SELECT DISTINCT Country
FROM superstore_stage
GROUP BY Country;

SELECT DISTINCT City, COUNT(*) -- We use COUNT(*) to check each category and compare when same category exists
FROM superstore_stage
GROUP BY City
ORDER BY City;

SELECT DISTINCT State
FROM superstore_stage
GROUP BY State;

SELECT DISTINCT REGION
FROM superstore_stage
GROUP BY REGION;

SELECT `Product ID`, COUNT(DISTINCT Category) AS cat_count, COUNT(DISTINCT `Sub-Category`) AS sub_count, COUNT(DISTINCT `Product Name`) AS pro_count
FROM superstore_stage
GROUP BY `Product ID`
HAVING cat_count > 1 OR sub_count > 1 OR pro_count > 1; -- Shows that some Product ID`s have 2 Product Names

-- List all Product ID and the Product Names that have the same Product ID
WITH CTE_Ex AS (
SELECT `Product ID`
FROM superstore_stage
GROUP BY `Product ID`
HAVING COUNT(DISTINCT `Product Name`) > 1)
SELECT DISTINCT `Product ID`, `Product Name`
FROM superstore_stage
WHERE `Product ID` IN ( SELECT `Product ID` FROM CTE_Ex)
ORDER BY `Product ID`; -- Result indicates serious data inconsistency due to Product ID`s having two completely different products

-- For the sake of this portfolio project, continue by deleting the inconsistent product ID`s even though the data has serious data inconsistency
DELETE FROM superstore_stage
WHERE `Product ID` IN (
SELECT pid
FROM (SELECT `Product ID` as pid
FROM superstore_stage
GROUP BY `Product ID`
HAVING COUNT(DISTINCT `Product Name`) > 1) AS id_del);

-- Update the Row ID
SET @row_num = 0;
UPDATE superstore_stage
SET `Row ID` = (@row_num := @row_num + 1)
ORDER BY `Order Date`;

-- Now add a column for the unit price
ALTER TABLE superstore_stage
ADD COLUMN `Unit Price` DOUBLE;
-- Set the unit price by dividing the sales and the quantity
UPDATE superstore_stage
SET `Unit Price` = (Sales /	(1 - Discount)) / Quantity;

-- Add a column for the unit cost
ALTER TABLE superstore_stage
ADD COLUMN `Unit Cost` DOUBLE;
-- Set the unit cost by subtracting the sales and profit and divide by the quantity
UPDATE superstore_stage
SET `Unit Cost` = (Sales - Profit) / Quantity;

-- Standardize the Sales, Profit, and Unit Price to 2 decimal places
UPDATE superstore_stage
SET Sales = ROUND(Sales, 2), Profit = ROUND(Profit, 2), `Unit Price` = ROUND(`Unit Price`, 2), `Unit Cost` = ROUND(`Unit Cost`, 2);

-- For clarity, rearrange the columns to order by Unit Cost, Unit Price, Quantity, Discount, Sales, Profit
ALTER TABLE superstore_stage
MODIFY COLUMN `Unit Cost` DOUBLE AFTER `Product Name`,
MODIFY COLUMN `Unit Price` DOUBLE AFTER `Unit Cost`,
MODIFY COLUMN `Quantity` INT AFTER `Unit Price`,
MODIFY COLUMN `Discount` DOUBLE AFTER `Quantity`,
MODIFY COLUMN `Sales` DOUBLE AFTER `Discount`,
MODIFY COLUMN `Profit` DOUBLE AFTER `Sales`;

-- Check for NULL values in each column, to avoid crashing divide the query to two
SELECT * 
FROM superstore_stage
WHERE `Order ID` IS NULL
OR `Order Date` IS NULL
OR `Ship Date` IS NULL
OR `Ship Mode` IS NULL
OR `Customer ID` IS NULL
OR `Customer Name` IS NULL
OR `Segment` IS NULL
OR `Country` IS NULL
OR `City` IS NULL
OR `State` IS NULL;

SELECT * 
FROM superstore_stage
WHERE `Postal Code` IS NULL
OR `Region` IS NULL
OR `Product ID` IS NULL
OR `Category` IS NULL
OR `Sub-Category` IS NULL
OR `Product Name` IS NULL
OR `Unit Cost` IS NULL
OR `Unit Price` IS NULL
OR `Quantity` IS NULL
OR `Discount` IS NULL
OR `Sales` IS NULL
OR `Profit` IS NULL;
-- No NULL values found

-- Final
SELECT * FROM superstore_stage
ORDER BY `Row ID`;

