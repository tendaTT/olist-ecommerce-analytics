import pandas as pd
from sqlalchemy import create_engine


engine = create_engine('postgresql://логин:пароль@localhost:5432/имя_базы')

files_to_tables = {
    'olist_customers_dataset.csv': 'customers',
    'olist_orders_dataset.csv': 'orders',
    'olist_order_items_dataset.csv': 'order_items',
    'olist_order_payments_dataset.csv': 'order_payments',
    'olist_products_dataset.csv': 'products',
    'product_category_name_translation.csv': 'product_category_name_translation'
}

for file, table in files_to_tables.items():
    print(f"Загружаю {file} в таблицу {table}...")
    df = pd.read_csv(file)
    date_cols = [col for col in df.columns if 'timestamp' in col or 'date' in col]
    for col in date_cols:
        df[col] = pd.to_datetime(df[col])
    df.to_sql(table, engine, if_exists='append', index=False)

print("Все данные успешно загружены!")