/*
===========================================================
 File:        cleaning_log.sql
 Purpose:     Create cleaning log table and record updates
 Author:      Amadeo F. Genio IV
 Description:
   - Creates the cleaning_log table if it doesn't exist.
   - Inserts records of data cleaning steps with timestamps
     and rows affected.
   - Can be run independently after cleaning transformations.
===========================================================
*/

-- 1. Create the log table
CREATE TABLE IF NOT EXISTS log_table (
	log_id SERIAL PRIMARY KEY,
	run_timestamp TIMESTAMP DEFAULT NOW(),
	steps VARCHAR(100),
	notes TEXT,
	rows_affected INTEGER
);

-- 2. Log the transformations within the staging table
INSERT INTO log_table (steps, notes, rows_affected)
VALUES ('Standardize Column state', 'Expanded abbreviations', 2823)

INSERT INTO log_table (steps, notes, rows_affected)
VALUES ('Standardize Column country', 'Expanded abbreviations', 2823);

INSERT INTO log_table (steps, notes, rows_affected)
VALUES ('Standardize Column territory', 'Expanded abbreviations', 2823);

INSERT INTO log_table (steps, notes, rows_affected)
VALUES ('Standardize Column phone', 'Set all to digits only', 2823);

INSERT INTO log_table (steps, notes, rows_affected)
VALUES ('Standardize Column state', 'Fill NULLs with "N/A"', 1486);

INSERT INTO log_table (steps, notes, rows_affected)
VALUES ('Update Column price', 'Recalculated capped price', 1304);

INSERT INTO log_table (steps, notes, rows_affected)
VALUES ('Update Column sales', 'Recalculated sales via new price', 2823);

SELECT * FROM log_table;