# This python script will load the CSV file to the staging table created in PostgreSQL

# 1. Import necessary libraries
import os
import psycopg2

# 2. Connection details
conn = psycopg2.connect(
    dbname = os.getenv("DB_NAME"),
    user = os.getenv("DB_USER"),
    password = os.getenv("DB_PASSWORD"),
    host = "localhost",
    port = "5432"
)

# 3. Create the cursor
cur = conn.cursor()

# 4. Truncate the staging table before reload
cur.execute("TRUNCATE TABLE staging_sales;")
conn.commit()

# 5. Load the CSV file to the staging table
csv_path = os.path.join(os.path.dirname(__file__), "sales_data_sample.csv")
with open(csv_path, "r", encoding="cp1252") as file:
    cur.copy_expert("""
    COPY staging_sales (
        order_number,
        quantity,
        price,
        order_line_num,
        sales,
        order_date,
        status,
        qtr_id,
        month_id,
        year_id,
        product_line,
        msrp,
        product_code,
        company_name,
        phone,
        address_1,
        address_2,
        city,
        state,
        postal_code,
        country,
        territory,
        customer_firstname,
        customer_lastname,
        deal_size
    ) FROM STDIN
    WITH (FORMAT CSV, DELIMITER ',', HEADER TRUE);
    """, file)

conn.commit()

# 6. Close the connections
cur.close()
conn.close()

# 7. Print if successful
print('Data successfully loaded into staging_sales')