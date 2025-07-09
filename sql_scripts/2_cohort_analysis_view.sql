CREATE OR REPLACE VIEW retail_data.cohort_analysis_data AS
WITH customer_first_purchase AS (
    -- Step 1: Find the first purchase month for each customer (their cohort)
    SELECT
        customer_id,
        MIN(DATE_TRUNC('month', invoice_date)) AS cohort_month
    FROM
        retail_data.clean_online_retail
    GROUP BY
        customer_id
),
monthly_activity AS (
    -- Step 2: Get the distinct months each customer made a purchase
    SELECT DISTINCT
        customer_id,
        DATE_TRUNC('month', invoice_date) AS activity_month
    FROM
        retail_data.clean_online_retail
)
-- Step 3: Calculate retention by joining the two and finding the month difference
SELECT
    TO_CHAR(c.cohort_month, 'YYYY-MM') AS cohort_month,
    -- Calculate the number of months between their first purchase and the current purchase
    EXTRACT(YEAR FROM age(a.activity_month, c.cohort_month)) * 12 + 
    EXTRACT(MONTH FROM age(a.activity_month, c.cohort_month)) AS month_number,
    COUNT(DISTINCT c.customer_id) AS retained_customers
FROM
    customer_first_purchase c
JOIN
    monthly_activity a ON c.customer_id = a.customer_id
GROUP BY
    1, 2;
