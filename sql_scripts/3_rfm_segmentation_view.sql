CREATE OR REPLACE VIEW retail_data.rfm_customer_segmentation AS
WITH
-- Step 1: Calculate the base RFM values for each customer
rfm_base AS (
    SELECT
        customer_id,
        -- Recency: Days since the last purchase from the most recent date in the dataset
        (SELECT MAX(invoice_date) FROM retail_data.clean_online_retail) - MAX(invoice_date) AS recency_days,
        -- Frequency: Total number of distinct invoices (transactions)
        COUNT(DISTINCT invoice_no) AS frequency,
        -- Monetary: Total sum of money spent
        SUM(total_price) AS monetary_value
    FROM
        retail_data.clean_online_retail
    GROUP BY
        customer_id
),

-- Step 2: Calculate RFM scores by ranking customers into quartiles (4 groups)
rfm_scores AS (
    SELECT
        customer_id,
        recency_days,
        frequency,
        monetary_value,
        -- NTILE(4) divides the customers into 4 groups (quartiles)
        -- Recency Score: Lower recency is better, so we use DESC order on the days.
        NTILE(4) OVER (ORDER BY recency_days DESC) AS r_score,
        -- Frequency & Monetary Score: Higher is better, so we use standard ASC order.
        NTILE(4) OVER (ORDER BY frequency ASC) AS f_score,
        NTILE(4) OVER (ORDER BY monetary_value ASC) AS m_score
    FROM
        rfm_base
),

-- Step 3: Combine the scores to create a final RFM score
rfm_final AS (
    SELECT
        customer_id,
        recency_days,
        frequency,
        monetary_value,
        r_score,
        f_score,
        m_score,
        -- Concatenate scores for a combined RFM score string
        r_score::text || f_score::text || m_score::text AS rfm_score_string
    FROM
        rfm_scores
)

-- Final Step: Classify customers into named segments based on their RFM scores
SELECT
    f.*, -- Select all columns from the rfm_final CTE
    CASE
        WHEN rfm_score_string IN ('444', '443', '434', '344') THEN 'Champions'
        WHEN rfm_score_string IN ('343', '334', '433', '442') THEN 'Loyal Customers'
        WHEN rfm_score_string IN ('322', '323', '332', '422') THEN 'Potential Loyalists'
        WHEN rfm_score_string IN ('411', '412', '421') THEN 'New Customers'
        WHEN rfm_score_string IN ('311', '312', '321') THEN 'Promising'
        WHEN rfm_score_string IN ('233', '234', '243', '244') THEN 'Customers Needing Attention'
        WHEN rfm_score_string IN ('212', '221', '222', '223', '232', '132', '123') THEN 'At-Risk'
        WHEN rfm_score_string IN ('111', '112', '121', '122', '211') THEN 'Hibernating'
        ELSE 'Other'
    END AS customer_segment
FROM
    rfm_final AS f;