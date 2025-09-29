{% macro log_run_start() %}
    {% do run_query(
        "INSERT INTO analytics.run_log(run_time, category, status, run_type, rows_processed, message)"~
        "VALUES (NOW() AT TIME ZONE 'utc', 'started', NULL, NULL, 0, NULL);"
    ) %}
{% endmacro %}