# This script will gather the datasets from Kaggle through API
# It will also load the raw data to PostgreSQL using psycopg2 after tables have been created

# Import the packages needed by documentation from Kaggle
import kagglehub
import pandas as pd
import os

# Import the package for connecting to PostgreSQL
import psycopg2
import tempfile
from dotenv import load_dotenv


# The target have 9 dataset files which are packed on a folder.
data_id = "olistbr/brazilian-ecommerce"

folder_path = kagglehub.dataset_download(data_id)

files = ["olist_customers_dataset.csv",
        "olist_geolocation_dataset.csv",
        "olist_order_items_dataset.csv",
        "olist_order_payments_dataset.csv",
        "olist_order_reviews_dataset.csv",
        "olist_orders_dataset.csv",
        "olist_products_dataset.csv",
        "olist_sellers_dataset.csv",
        "product_category_name_translation.csv"]

# Prepare a dictionary to have a key:value relation between dataset title:dataset
datasets = {}

# Run the files in the for loop to read the csv files inside the folder
for file in files:
    file_path = os.path.join(folder_path, file)
    df = pd.read_csv(file_path, encoding="utf-8")
    datasets[file.replace(".csv", "")] = df
    print(file + " loaded")

# Check each data set columns, clean if necessary
for file in files:
    title = file.replace(".csv", "")
    print(title + ": " + datasets[title].columns)

# The dataset'olist_products_dataset' have misspelled columns using the word length (lenght)
datasets['olist_products_dataset'].rename(columns={'product_name_lenght':'product_name_length',
                                                   'product_description_lenght':'product_description_length'}, inplace=True)

# The dataset 'product_category_name_translation' have 1 column with unwanted characters
datasets['product_category_name_translation'].rename(columns={'ï»¿product_category_name':'product_category_name'}, inplace=True)

# Check if the columns name is renamed
print(datasets['olist_products_dataset'].columns)
print(datasets['product_category_name_translation'].columns)

# Check each head of the dataset to gather information on what to set each columns data type
# In order to see full row and columns, set pd display to max

pd.set_option('display.max_columns', None)
pd.set_option('display.max_rows', None)

for set, df in datasets.items():
    print(set)
    print(df.head(1))

# The datasets are now set to be loaded up to PostgreSQL

# After creating the tables for the raw datasets, we can now load each table with the data
# Connect to PostgreSQL using psycopg2

load_dotenv()

conn = psycopg2.connect(
    host = "localhost",
    dbname = os.getenv("DB_NAME"),
    user = os.getenv("DB_USER"),
    password = os.getenv("DB_PASSWORD"),
    port = "5432"
)

curr = conn.cursor()

# In order to load the datasets to each table in the database, we create a tempfile as csv of each dataset and load using copy_expert
# Prepare the table names to iterate using for loop
raw_tables = {
    "olist_customers_dataset": "customers",
    "olist_geolocation_dataset": "geolocation",
    "olist_order_items_dataset": "order_items",
    "olist_order_payments_dataset": "order_payments",
    "olist_order_reviews_dataset": "order_reviews",
    "olist_orders_dataset": "orders",
    "olist_products_dataset": "products",
    "olist_sellers_dataset": "sellers",
    "product_category_name_translation": "product_category"
}

for name, df in datasets.items():
    table = raw_tables[name]

    with tempfile.NamedTemporaryFile(mode="w+", suffix=".csv", delete=False) as tmp:
        df.to_csv(tmp.name, index=False, encoding='utf-8')
        tmp.flush() # This function will make sure that the file is complete to load in PostgreSQL
        path = tmp.name

        with open(path, mode="r+", encoding='utf-8') as file:
            curr.copy_expert(f"""
                COPY raw.{table}
                FROM STDIN
                WITH CSV DELIMITER ',' HEADER;
                             """, file)
        print(table + " successfully loaded in PostgreSQL")
    os.remove(path) # Will delete the tempfile after using it
        
conn.commit()

curr.close()
conn.close()