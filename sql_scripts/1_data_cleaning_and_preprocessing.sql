CREATE OR REPLACE VIEW retail_data.clean_online_retail AS
WITH
-- Step 1: Basic Cleaning and Type Casting
base_cleaning AS (
    SELECT
        "Invoice" AS invoice_no,
        "StockCode" AS stock_code,
        "Description" AS description,
        "Quantity"::integer AS quantity,
        "InvoiceDate"::timestamp AS invoice_date,
        "Price"::numeric AS unit_price,
        "Customer ID"::varchar AS customer_id,
        "Country" AS country
    FROM
        retail_data.raw_online_retail
    WHERE
        "Customer ID" IS NOT NULL
        AND "Quantity" > 0
        AND "Price" > 0
        AND "Invoice" NOT LIKE 'C%' -- Exclude cancelled transactions
),

-- Step 2: Filter out non product operational stock codes
product_transactions_only AS (
    SELECT
        *
    FROM
        base_cleaning
    WHERE
        -- Ensure stock_code is mostly numeric, filtering out manual codes.
        stock_code ~ '^[0-9]+[A-Z]?$'
        AND stock_code NOT IN ('POST', 'D', 'M', 'BANK CHARGES', 'AMAZONFEE', 'CRUK')
)

-- Final Selection of Cleaned Data
SELECT
    invoice_no,
    stock_code,
    -- Use the cleaned description
    TRIM(LOWER(description)) AS description,
    quantity,
    invoice_date,
    unit_price,
    customer_id,
    country,
    (quantity * unit_price) as total_price
FROM
    product_transactions_only;
