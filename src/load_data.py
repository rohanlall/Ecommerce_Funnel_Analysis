"""Load the Olist CSVs from data/raw into a DuckDB database with short table names."""
from pathlib import Path

import duckdb

ROOT = Path(__file__).resolve().parents[1]
RAW = ROOT / "data" / "raw"
DB = ROOT / "data" / "olist.duckdb"

TABLES = {
    "customers": "olist_customers_dataset.csv",
    "orders": "olist_orders_dataset.csv",
    "order_items": "olist_order_items_dataset.csv",
    "payments": "olist_order_payments_dataset.csv",
    "reviews": "olist_order_reviews_dataset.csv",
    "products": "olist_products_dataset.csv",
    "sellers": "olist_sellers_dataset.csv",
    "geolocation": "olist_geolocation_dataset.csv",
    "category_translation": "product_category_name_translation.csv",
}


def main():
    con = duckdb.connect(str(DB))
    for table, fname in TABLES.items():
        path = RAW / fname
        if not path.exists():
            raise SystemExit(f"Missing {path}. Download the dataset from Kaggle into data/raw/.")
        con.execute(f"CREATE OR REPLACE TABLE {table} AS SELECT * FROM read_csv_auto(?)", [str(path)])
        n = con.execute(f"SELECT COUNT(*) FROM {table}").fetchone()[0]
        print(f"{table:22s} {n:>8,} rows")
    con.close()


if __name__ == "__main__":
    main()
