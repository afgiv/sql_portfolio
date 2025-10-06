# This script will insert the necessary logs coming from the run_results.json to the audit table run_log.
# Run this script right after running/testing dbt models.

# Import the necessary pacakges
import psycopg2
import json, os
from dotenv import load_dotenv

# Connect to PostgreSQL
load_dotenv()

conn = psycopg2.connect(
    host="localhost",
    dbname = os.getenv("DB_NAME"),
    user = os.getenv("DB_USER"),
    password = os.getenv("DB_PASSWORD"),
    port="5432"
)

curr = conn.cursor()

# Locate and load the run_results.json
file = r"ecommerce\target\run_results.json"

with open(file) as f:
    results = json.load(f)

# Parse the json file to catch the warn or error threads
for dict in results['results']:
    status = dict.get('status')
    if status in ["success", "pass", "warn"]:
        time_completed = dict.get('timing')[1].get('completed_at')
    elif status == "error":
        time_completed = dict.get('timing')[0].get('completed_at')

    message = dict.get('message')
    run_type = dict.get('unique_id')

    if dict.get('unique_id').startswith("test"):
        rows_affected = dict.get('failures')
    else:
        rows_affected = dict.get('adapter_response').get('rows_affected')


    curr.execute("""
        INSERT INTO analytics.run_log(run_time, category, status, run_type, rows_processed, message)
        VALUES (%s, %s, %s, %s, %s, %s)
                 """,
        (time_completed, 'finished', status, run_type, rows_affected, message))
        

print("Data successfully logged in the audit table!")

conn.commit()

curr.close()
conn.close()