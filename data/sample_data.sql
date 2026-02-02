INSERT INTO customers VALUES
(1, '2022-01-10', 'Male', 34, 'Nairobi'),
(2, '2022-03-05', 'Female', 29, 'Mombasa'),
(3, '2023-02-20', 'Male', 41, 'Kisumu'),
(4, '2023-06-15', 'Female', 37, 'Nakuru'),
(5, '2024-01-08', 'Male', 26, 'Nairobi');

INSERT INTO accounts VALUES
(101, 1, 'Savings', '2022-01-10', 'Active'),
(102, 2, 'Current', '2022-03-05', 'Active'),
(103, 3, 'Savings', '2023-02-20', 'Closed'),
(104, 4, 'Current', '2023-06-15', 'Active'),
(105, 5, 'Savings', '2024-01-08', 'Active');

INSERT INTO transactions VALUES
(1001, 101, '2024-10-01', 5000, 'Deposit'),
(1002, 101, '2024-11-15', -2000, 'Withdrawal'),
(1003, 102, '2024-09-20', 12000, 'Deposit'),
(1004, 104, '2024-06-10', 3000, 'Deposit'),
(1005, 104, '2024-06-25', -1500, 'Withdrawal'),
(1006, 105, '2024-12-05', 8000, 'Deposit');

INSERT INTO balances VALUES
(101, '2024-11-30', 3000),
(102, '2024-09-30', 12000),
(104, '2024-06-30', 1500),
(105, '2024-12-31', 8000);
