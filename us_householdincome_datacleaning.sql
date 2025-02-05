# US Household Income Data Cleaning

SELECT * 
FROM us_project.us_householdincome;

SELECT * 
FROM us_project.ushouseholdincome_statistics;

# rename the id column to eliminate typo 
ALTER TABLE ushouseholdincome_statistics RENAME COLUMN `ï»¿id` TO `id`;


SELECT id, COUNT(id) 
FROM us_project.us_householdincome
GROUP BY id
HAVING COUNT(id) > 1;


-- This query identifies duplicate id values in the us_householdincome table by assigning row numbers and filtering out the first occurrence.
SELECT *
FROM (
SELECT row_id,
id,
ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) row_num
FROM us_project.us_householdincome
)  duplicates
WHERE row_num > 1;

-- Delete duplicate rows based off the ones we identified in the previous query
DELETE FROM us_householdincome
WHERE row_id IN (
SELECT row_id
FROM (
SELECT row_id,
id,
ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) row_num
FROM us_project.us_householdincome
)  duplicates
WHERE row_num > 1)
;

-- Identify typos in the State_name column 
SELECT DISTINCT state_name
FROM us_householdincome
;

-- Correct the typos for state names
UPDATE us_project.us_householdincome
SET State_Name = 'Georgia'
WHERE State_Name = 'georia';

UPDATE us_project.us_householdincome
SET State_Name = 'Alabama'
WHERE State_Name = 'alabama';

-- identifying the row with a missing value in the 'Place' column
SELECT *
FROM us_project.us_householdincome
WHERE place = '';

-- Correcting the missing value in the place column by populating the data with the corrections made
UPDATE us_project.us_householdincome
SET Place = 'Autaugaville'
WHERE City = 'Vinemont'
AND
County = 'Autauga County';