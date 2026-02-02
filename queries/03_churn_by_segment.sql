WITH monthly_txn AS (
    SELECT
        a.customer_id,
        FORMAT(t.transaction_date, 'yyyy-MM') AS txn_month,
        COUNT(*) AS txn_count
    FROM transactions t
    JOIN accounts a
        ON t.account_id = a.account_id
    GROUP BY
        a.customer_id,
        FORMAT(t.transaction_date, 'yyyy-MM')
),
txn_trend AS (
    SELECT
        customer_id,
        txn_month,
        txn_count,
        LAG(txn_count) OVER (
            PARTITION BY customer_id
            ORDER BY txn_month
        ) AS prev_month_txn
    FROM monthly_txn
)
SELECT
    customer_id,
    txn_month,
    txn_count,
    prev_month_txn,
    CASE
        WHEN prev_month_txn IS NOT NULL
             AND txn_count < prev_month_txn
        THEN 'Declining Activity'
        ELSE 'Stable'
    END AS activity_trend
FROM txn_trend
ORDER BY customer_id, txn_month;


WITH last_transaction AS (
    SELECT
        a.customer_id,
        MAX(t.transaction_date) AS last_txn_date
    FROM transactions t
    JOIN accounts a
        ON t.account_id = a.account_id
    GROUP BY a.customer_id
),
customer_status AS (
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
    FROM customers c
    LEFT JOIN last_transaction lt
        ON c.customer_id = lt.customer_id
)
SELECT
    is_churned,
    COUNT(*) AS customers
FROM customer_status
GROUP BY is_churned;
