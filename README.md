# Advanced E-Commerce Analysis: From Raw Data to Strategic Insights
**<h3>Executive Summary</h3>**
<div align="justify">A deep dive analysis of two years of transactional data to uncover hidden customer behaviors, improve retention, and optimize sales strategy. This project moves beyond standard descriptive reporting to answer complex, strategic business questions using advanced data modeling in SQL and interactive visualization in Tableau. Using a 2 year transactional e-commerce dataset (from 2009-12-01 to 2011-12-09), this analysis provides a multi faceted view of business health, focusing on customer retention, customer value segmentation, and strategic product portfolio management.

The core of this project lies in the sophisticated SQL transformations performed in PostgreSQL to create powerful analytical models like Cohort Analysis, RFM Segmentation, and the BCG Matrix. The final result is a comprehensive executive dashboard designed to drive strategic decision making.

<p></p>

[View the Interactive Dashboard on Tableau Public](https://public.tableau.com/views/Advancede-CommerceAnalysis/DashboardDeep?:language=en-GB&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)


### The Business Challenge
An online retail company faced strategic challenges: slowing growth and uncertainty about customer loyalty. To make informed decisions, management needed data-driven answers to several critical questions:

* **Customer Retention:** Are our new customers loyal? How well are we retaining them over time?
* **Customer Value:** Who are our most valuable customers and how can we segment them for targeted marketing?
* **Product Strategy:** Which products are our "Stars" that we should invest in, and which are "Dogs" that we should reconsider?
* **Business Growth:** What is our real sales momentum? Are we growing month over month?

<br>

**<h3>Deep Dive into Key Strategic Analyses</h3>**
This project showcases several advanced analytical techniques, all calculated and modeled in the PostgreSQL backend.

**1. Customer Cohort Analysis**

This is the most critical analysis for understanding customer loyalty. Customers are grouped into cohorts based on their first purchase month. We then track what percentage of each cohort returns for subsequent purchases over time, revealing the long term health of the customer base.

*Technical Highlight:* This requires complex SQL queries involving CTEs, date functions, and window functions to pivot the data correctly, demonstrating advanced data modeling capabilities.

![cohort analisys](https://github.com/wisnuyulianto/advanced-ecommerce-analysis--from-raw-data-to-strategic-insights/blob/main/visualizations/cohort.png)
<sup>A heatmap visualizing customer retention rates, providing a clear view of business health.</sup>
<br>The Cohort Analysis clearly revealed month over month loyalty trends, allowing for the early detection of declining customer retention

**2. RFM Customer Segmentation**

To provide actionable marketing insights, customers were segmented using the RFM model (Recency, Frequency, Monetary). This identifies key groups like "Champions," "Loyal Customers," and "At-Risk" customers, enabling highly targeted marketing campaigns.

*Technical Highlight:* This involves calculating Recency, Frequency, and Monetary scores for each customer and then assigning them to a segment using CASE statements and NTILE window functions in SQL.
````
-- Snippet of RFM Segmentation Logic
SELECT
    customer_id,
    recency_score,
    frequency_score,
    monetary_score,
    CASE
        WHEN (recency_score >= 4 AND frequency_score >= 4) THEN 'Champions'
        WHEN (recency_score >= 3 AND frequency_score >= 3) THEN 'Loyal Customers'
        WHEN (recency_score <= 2 AND frequency_score >= 3) THEN 'At-Risk'
        ELSE 'Needs Attention'
    END as customer_segment
FROM rfm_scores;
````
<sup>SQL of distribution of customers across different RFM segments.</sup>

**3. Product Portfolio Analysis (BCG Matrix)**

To guide product strategy, a BCG Matrix was created to classify products based on their sales growth and relative market share. This framework helps management decide where to invest, what to maintain, and which products to potentially divest.

*Technical Highlight:* This analysis requires calculating sales growth rates and relative market share for each product, then plotting them in a four quadrant scatter plot.

![bcg analisys](https://github.com/wisnuyulianto/advanced-ecommerce-analysis--from-raw-data-to-strategic-insights/blob/main/visualizations/bcg.png)
<br>A scatter plot segmenting products into nto strategic categories like "Stars" and "Dogs," providing a clear framework for inventory and product investment decisions.

<br>

**<h3>Technical Architecture & Tools</h3>**

1. **Backend (PostgreSQL):** All complex business logic, cohort calculations, and segmentation were performed using advanced SQL within database [VIEWs](https://github.com/wisnuyulianto/advanced-ecommerce-analysis--from-raw-data-to-strategic-insights/tree/main/sql_scripts). This ensures a robust and scalable "Single Source of Truth".
2. **Frontend (Tableau):** The precalculated, analytics ready data was exported to a [.csv](https://github.com/wisnuyulianto/advanced-ecommerce-analysis--from-raw-data-to-strategic-insights/blob/main/data/clean_online_retail.csv) and connected to Tableau for visualization. This separation of concerns ensures high performance in the dashboard.
