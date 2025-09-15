#This script will gather the datasets from Kaggle through API
#It will also load the raw data to PostgreSQL using psycopg2 after tables have been created

#import the packages needed by documentation from Kaggle
import kagglehub
import pandas as pd
import os


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
    df = pd.read_csv(file_path, encoding="latin1")
    datasets[file.replace(".csv", "")] = df
    print(file + " loaded")

# Check each data set columns, clean if necessary
for file in files:
    title = file.replace(".csv", "")
    print(title + ": " + datasets[title].columns)

# The dataset 'product_category_name_translation' have 1 column with unwanted characters
datasets['product_category_name_translation'].rename(columns={'ï»¿product_category_name':'product_category_name'}, inplace=True)

# Check if the column name is renamed
print(datasets['product_category_name_translation'].columns)

# The datasets are now set to be loaded up to PostgreSQL