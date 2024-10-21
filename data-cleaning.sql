-- Data Cleaning

SELECT * FROM layoffs;

-- 1. Remove Duplicates
-- 2. Standardize the data
-- 3. Null values or blank values
-- 4. Remove any columns

-- Copy raw data from original table into another table

CREATE TABLE layoffs_staging LIKE layoffs;
SELECT * FROM layoffs_staging;

INSERT INTO layoffs_staging SELECT * FROM layoffs;
SELECT * FROM layoffs_staging;


-- 1 REMOVE DUPLICATES

SELECT *, ROW_NUMBER() OVER(PARTITION BY company, location,industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num FROM layoffs_staging;


-- NO DUPLICATES DETECTED AS THERE IS NO ROW NUMBER GREATER THAN 1

WITH duplicate_cte AS (
SELECT *, ROW_NUMBER() OVER(PARTITION BY company, location,industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num FROM layoffs_staging
)
SELECT * FROM duplicate_cte WHERE row_num > 1;

-- 2 STANDARDIZE DATA

SELECT trim(company) FROM layoffs_staging;

UPDATE layoffs_staging SET company = trim(company);


SELECT DISTINCT country from layoffs_staging ORDER BY 1;

UPDATE layoffs_staging SET country = 'United States' WHERE country = 'United States.';

SELECT DISTINCT country from layoffs_staging ORDER BY 1;

SELECT * FROM layoffs_staging;

UPDATE layoffs_staging SET `date` = str_to_date(`date`, '%Y-%m-%d');

ALTER TABLE layoffs_staging MODIFY COLUMN `date` DATE;

-- 3 NULL AND BLANK VALUES

SELECT * FROM layoffs_staging WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

SELECT * FROM layoffs_staging WHERE industry IS NULL OR industry = '';

UPDATE layoffs_staging SET industry = 'Travel' WHERE company = 'Airbnb';

SELECT * FROM layoffs_staging WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

-- 4 REMOVE UNNECCESSARY COLUMNS

DELETE FROM layoffs_staging WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;
SELECT * FROM layoffs_staging;







