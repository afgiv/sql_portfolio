{% macro log_run_start() %}

    INSERT INTO analytics.run_log(run_time, status, models_run, rows_processed, error)
    VALUES (CURRENT_TIMESTAMP, 'started', 0, 0, NULL);

{% endmacro %}

{% macro log_run_end() %}

    {% set total_models = run_results | length %}
    {% set total_rows = run_results | sum(attribute='rows_affected') %}
    {% set errors = run_results | map(attribute='error') | reject('equalto', none) | join(', ') %}

    INSERT INTO analytics.run_log(run_time, status, models_run, rows_processed, error)
    VALUES (CURRENT_TIMESTAMP, 'finished', {{ total_models }}, {{ total_rows }}, {% if errors|length > 0 %}'{{ errors }}'{% else %}NULL{% endif %});

{% endmacro %}