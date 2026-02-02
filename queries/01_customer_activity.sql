-- Purpose:
-- Identify active vs inactive customers based on recent transaction activity.
-- Active customers are defined as having at least one transaction in the last 90 days.
WITH recent_activity AS (
    SELECT DISTINCT
        a.customer_id
    FROM transactions t
    JOIN accounts a
        ON t.account_id = a.account_id
    WHERE t.transaction_date >= DATEADD(DAY, -90, GETDATE())
)
SELECT
    COUNT(DISTINCT c.customer_id) AS total_customers,
    COUNT(DISTINCT r.customer_id) AS active_customers,
    COUNT(DISTINCT c.customer_id) - COUNT(DISTINCT r.customer_id) AS inactive_customers
FROM customers c
LEFT JOIN recent_activity r
    ON c.customer_id = r.customer_id;

WITH last_transaction AS (
    SELECT
        a.customer_id,
        MAX(t.transaction_date) AS last_txn_date
    FROM transactions t
    JOIN accounts a
        ON t.account_id = a.account_id
    GROUP BY a.customer_id
)
SELECT
    customer_id,
    last_txn_date,
    DATEDIFF(DAY, last_txn_date, GETDATE()) AS days_since_last_txn,
    CASE
        WHEN DATEDIFF(DAY, last_txn_date, GETDATE()) > 90 THEN 'Churned'
        ELSE 'Active'
    END AS customer_status
FROM last_transaction
ORDER BY days_since_last_txn DESC;
