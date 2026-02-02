WITH last_transaction AS (
    SELECT
        a.customer_id,
        MAX(t.transaction_date) AS last_txn_date
    FROM transactions t
    JOIN accounts a
        ON t.account_id = a.account_id
    GROUP BY a.customer_id
),
churned_customers AS (
    SELECT
        customer_id,
        FORMAT(last_txn_date, 'yyyy-MM') AS churn_month
    FROM last_transaction
    WHERE DATEDIFF(DAY, last_txn_date, GETDATE()) > 90
)
SELECT
    churn_month,
    COUNT(DISTINCT customer_id) AS churned_customers
FROM churned_customers
GROUP BY churn_month
ORDER BY churn_month;

WITH customer_value AS (
    SELECT
        a.customer_id,
        SUM(ABS(t.amount)) AS total_transaction_value
    FROM transactions t
    JOIN accounts a
        ON t.account_id = a.account_id
    GROUP BY a.customer_id
),
ranked_customers AS (
    SELECT
        customer_id,
        total_transaction_value,
        NTILE(5) OVER (ORDER BY total_transaction_value DESC) AS value_bucket
    FROM customer_value
)
SELECT
    customer_id,
    total_transaction_value
FROM ranked_customers
WHERE value_bucket = 1
ORDER BY total_transaction_value DESC;
