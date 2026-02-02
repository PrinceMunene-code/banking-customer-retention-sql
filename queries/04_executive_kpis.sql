IF OBJECT_ID('tempdb..#customer_status') IS NOT NULL
    DROP TABLE #customer_status;

SELECT
    c.customer_id,
    c.age,
    c.region,
    lt.last_txn_date,
    CASE
        WHEN lt.last_txn_date IS NULL THEN 1
        WHEN DATEDIFF(DAY, lt.last_txn_date, GETDATE()) > 90 THEN 1
        ELSE 0
    END AS is_churned
INTO #customer_status
FROM customers c
LEFT JOIN (
    SELECT
        a.customer_id,
        MAX(t.transaction_date) AS last_txn_date
    FROM transactions t
    JOIN accounts a
        ON t.account_id = a.account_id
    GROUP BY a.customer_id
) lt
    ON c.customer_id = lt.customer_id;

SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN is_churned = 1 THEN 1 ELSE 0 END) AS churned_customers,
    SUM(CASE WHEN is_churned = 0 THEN 1 ELSE 0 END) AS active_customers,
    CAST(
        SUM(CASE WHEN is_churned = 1 THEN 1 ELSE 0 END) * 100.0
        / COUNT(*) AS DECIMAL(5,2)
    ) AS churn_rate_pct,

    -- Age segmentation
    SUM(CASE WHEN age < 35 AND is_churned = 1 THEN 1 ELSE 0 END) AS churn_under_35,
    SUM(CASE WHEN age >= 35 AND is_churned = 1 THEN 1 ELSE 0 END) AS churn_35_plus
FROM #customer_status;

