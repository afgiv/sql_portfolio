/*
===========================================================
 File:        create_run_log.sql
 Purpose:     Create the run_log table to track dbt executions.
 Author:      Amadeo F. Genio IV
 Description: 
   - Stores metadata about dbt model runs such as start/end time,
     status, number of models executed, rows processed, and errors.
   - Used by custom dbt macros (log_run_start, log_run_end) to
     insert run details automatically.
 Notes:
   - This table resides in the analytics schema.
   - Helps provide observability into dbt runs and aids debugging.
   - Must be created once before running the logging macros.
============================================================
*/

CREATE TABLE IF NOT EXISTS analytics.run_log (
	run_id SERIAL UNIQUE,
	run_time TIMESTAMP,
	status VARCHAR(50),
	models_run INTEGER,
	rows_processed BIGINT,
	error TEXT
);