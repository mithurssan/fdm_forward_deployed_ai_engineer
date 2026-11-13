-- 1. Show each complaint with customer name.
SELECT first_name, complaint_text
FROM complaint
JOIN customer
ON complaint.customer_id = customer.customer_id;

-- 2. Add optional account type without dropping complaints that have no account.
SELECT account_type
FROM complaint LEFT OUTER JOIN account
ON complaint.account_id = account.account_id;

-- 3. Verify distinct complaint count before and after joins.
SELECT COUNT(*) 
FROM complaint;

SELECT COUNT(*)
FROM complaint JOIN account
ON complaint.account_id = account.account_id;

-- 4. Create complaint_analyst_view containing only justified fields.
DROP VIEW complaint_analyst_view;

CREATE VIEW complaint_analyst_view AS
SELECT account_type,
account.status,
channel, 
complaint_text,
complaint.customer_id,
category,
priority
FROM complaint LEFT OUTER JOIN account
ON complaint.account_id = account.account_id;

SELECT * FROM  complaint_analyst_view;




