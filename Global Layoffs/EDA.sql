-- EDA or Exploratory Data Analysis

-- Here we are going to explore the data without an agenda, we are just going to explore the data and
-- see what patterns or trends, hidden insights that we can find

-- By looking at the data, it shows exactly where we are going to focus which is the total_laid_off column


SELECT *
FROM layoffs_staging2;

-- When is the start and end of the date of the data?

SELECT MIN(`date`) ,MAX(`date`)
FROM layoffs_staging2;

-- Which company did the most layoffs?

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- Which type of industry did the most layoffs?

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- Which company had the highest percentage of layoffs? Which company had the least?

SELECT company, percentage_laid_off
FROM layoffs_staging2
WHERE percentage_laid_off IS NOT NULL
ORDER BY 2 DESC;

SELECT company, percentage_laid_off
FROM layoffs_staging2
WHERE percentage_laid_off IS NOT NULL
ORDER BY 2;

-- Which company had the most funds raised?

SELECT company, SUM(funds_raised_millions)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- Which company had the most layoffs in a single day? Which day?

SELECT company, `date`, total_laid_off
FROM layoffs_staging2
WHERE total_laid_off IS NOT NULL
ORDER BY 3 DESC;

-- Which country had the most layoffs?

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- How many are laid off per year?

SELECT YEAR(`date`) AS per_year, SUM(total_laid_off)
FROM layoffs_staging2
WHERE YEAR(`date`) IS NOT NULL
GROUP BY per_year
ORDER BY 2 DESC;

-- Which are the top 3 companies per year that did the most layoffs?

WITH company_year AS
(
SELECT company, YEAR(`date`) as per_year, SUM(total_laid_off) as total_laid_off
FROM layoffs_staging2
GROUP BY company, per_year
),
company_rank AS
(
SELECT company, per_year, total_laid_off, DENSE_RANK() OVER(PARTITION BY per_year ORDER BY total_laid_off DESC) as ranking
FROM company_year
)
SELECT *
FROM company_rank
WHERE ranking <= 3
AND per_year IS NOT NULL
ORDER BY per_year, total_laid_off DESC;

-- What is the rolling total layoffs per month?

WITH date_cte AS
(
SELECT SUBSTRING(`date`,1,7) as dates, SUM(total_laid_off) as total_laid_off
FROM layoffs_staging2
GROUP BY dates
ORDER BY dates
)
SELECT dates, SUM(total_laid_off) OVER(ORDER BY dates) as rolling_total
FROM date_cte
ORDER BY dates; 