CREATE OR REPLACE VIEW retail_data.bcg_matrix_analysis AS
WITH
product_yearly_sales AS (
    SELECT
        stock_code,
        description,
        EXTRACT(YEAR FROM invoice_date) AS sales_year,
        SUM(total_price) AS total_sales
    FROM
        retail_data.clean_online_retail
    WHERE
        EXTRACT(YEAR FROM invoice_date) IN (2010, 2011)
    GROUP BY
        1, 2, 3
),
sales_comparison AS (
    SELECT
        stock_code,
        description,
        SUM(CASE WHEN sales_year = 2010 THEN total_sales ELSE 0 END) AS sales_2010,
        SUM(CASE WHEN sales_year = 2011 THEN total_sales ELSE 0 END) AS sales_2011
    FROM
        product_yearly_sales
    GROUP BY
        1, 2
),
product_growth_rate AS (
    SELECT
        *,
        CASE
            WHEN sales_2010 > 0 THEN ((sales_2011 - sales_2010) / sales_2010)
            ELSE 0
        END AS sales_growth_rate
    FROM
        sales_comparison
    WHERE
        sales_2011 > 0
),
market_metrics AS (
    SELECT
        AVG(sales_growth_rate) AS avg_market_growth,
        MAX(sales_2011) AS max_sales_2011
    FROM
        product_growth_rate
)
SELECT
    pgr.stock_code,
    pgr.description,
    pgr.sales_2011,
    pgr.sales_growth_rate,
    pgr.sales_2011 / mm.max_sales_2011 AS relative_market_share,
    CASE
        WHEN pgr.sales_growth_rate > mm.avg_market_growth AND (pgr.sales_2011 / mm.max_sales_2011) >= 0.1 THEN 'Star'
        WHEN pgr.sales_growth_rate <= mm.avg_market_growth AND (pgr.sales_2011 / mm.max_sales_2011) >= 0.1 THEN 'Cash Cow'
        WHEN pgr.sales_growth_rate > mm.avg_market_growth AND (pgr.sales_2011 / mm.max_sales_2011) < 0.1 THEN 'Question Mark'
        ELSE 'Dog'
    END AS bcg_quadrant
FROM
    product_growth_rate pgr,
    market_metrics mm
WHERE
    pgr.sales_2010 > 100
ORDER BY
    pgr.sales_2011 DESC;
