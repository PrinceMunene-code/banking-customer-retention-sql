CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    signup_date DATE,
    gender VARCHAR(10),
    age INT,
    region VARCHAR(50)
);
CREATE TABLE accounts (
    account_id INT PRIMARY KEY,
    customer_id INT,
    account_type VARCHAR(20),   -- Savings, Current
    open_date DATE,
    status VARCHAR(20),         -- Active, Closed
    CONSTRAINT fk_accounts_customers
        FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    account_id INT,
    transaction_date DATE,
    amount DECIMAL(12,2),
    transaction_type VARCHAR(20),  -- Deposit, Withdrawal, Transfer
    CONSTRAINT fk_transactions_accounts
        FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);
CREATE TABLE balances (
    account_id INT,
    balance_date DATE,
    balance_amount DECIMAL(12,2),
    CONSTRAINT fk_balances_accounts
        FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);
