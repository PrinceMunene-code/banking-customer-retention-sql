-- Purpose:
-- Analyze churn distribution across key customer segments
-- to identify where retention risk is concentrated.

-- Churn by age group
SELECT
    CASE
        WHEN age BETWEEN 18 AND 25 THEN '18–25'
        WHEN age BETWEEN 26 AND 35 THEN '26–35'
        WHEN age BETWEEN 36 AND 45 THEN '36–45'
        WHEN age BETWEEN 46 AND 60 THEN '46–60'
        ELSE '60+'
    END AS age_group,
    COUNT(*) AS total_customers,
    SUM(is_churned) AS churned_customers,
    CAST(SUM(is_churned) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS churn_rate_pct
FROM #customer_status
GROUP BY
    CASE
        WHEN age BETWEEN 18 AND 25 THEN '18–25'
        WHEN age BETWEEN 26 AND 35 THEN '26–35'
        WHEN age BETWEEN 36 AND 45 THEN '36–45'
        WHEN age BETWEEN 46 AND 60 THEN '46–60'
        ELSE '60+'
    END
ORDER BY churn_rate_pct DESC;

-- Churn by region
SELECT
    region,
    COUNT(*) AS total_customers,
    SUM(is_churned) AS churned_customers,
    CAST(SUM(is_churned) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS churn_rate_pct
FROM #customer_status
GROUP BY region
ORDER BY churn_rate_pct DESC;
