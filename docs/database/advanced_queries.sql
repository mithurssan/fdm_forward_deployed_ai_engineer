-- 1. Use CASE for unresolved age buckets 0-7, 8-30 and 31+ days.
SELECT received_at, changed_at,
CASE
	WHEN JULIANDAY(changed_at) - JULIANDAY(received_at) <= 7
	THEN '0-7'
	WHEN JULIANDAY(changed_at) - JULIANDAY(received_at) <=30
	THEN '8-30'
	ELSE '31+'
END AS 'age_buckets'
FROM complaint LEFT OUTER JOIN complaint_status_history
ON complaint.complaint_id = complaint_status_history.complaint_id
WHERE new_status<>'CLOSED';


-- 2. Use a CTE to identify repeat complainants.
WITH repeat_complainants AS (
	SELECT customer_id,
	COUNT(*) AS complainant_count
	FROM complaint c
	GROUP BY customer_id
)
SELECT customer_id, complainant_count
FROM repeat_complainants
WHERE complainant_count > 1;

-- 3. Use ROW_NUMBER to select latest status per complaint.
WITH latest_status AS (
	SELECT complaint_id, new_status, changed_at,
	ROW_NUMBER() OVER (
	PARTITION BY complaint_id
	ORDER BY changed_at DESC
	) AS rn
FROM complaint_status_history
)

SELECT * FROM latest_status
WHERE rn = 1;

-- 4. Rank customers by complaint count.
WITH customer_counts AS (
SELECT customer_id, COUNT(*) AS complaint_count
FROM complaint  
GROUP BY customer_id
)
SELECT customer_id, complaint_count,
RANK () OVER(ORDER BY complaint_count DESC)
AS complaint_rank
FROM customer_counts;

-- 5.Determine complaint priority classification.
SELECT complaint_id, priority,
CASE 
	WHEN priority = 'Critical'
	THEN '1'
	WHEN priority = 'High'
	THEN '2'
	WHEN priority = 'Medium'
	THEN '3'
	WHEN priority = 'Low'
	THEN '4'
END AS 'priority_classification'
FROM complaint c
ORDER BY priority_classification;

-- 6.Find customers who submitted more than one complaint.
SELECT customer_id, COUNT(*) AS complaint_count
FROM complaint c 
GROUP BY c.customer_id 
HAVING complaint_count > 1;

-- 7. Rank customers by number of complaints.
WITH customer_counts AS (
SELECT customer_id, COUNT(*) AS complaint_count
FROM complaint  
GROUP BY customer_id
)
SELECT customer_id, complaint_count,
RANK () OVER(ORDER BY complaint_count DESC)
AS complaint_rank
FROM customer_counts;

-- 8. Rank complaints by receive date within each category.
SELECT complaint_id, received_at, category,
RANK() OVER(PARTITION BY category ORDER BY received_at DESC) AS received_rank
FROM complaint;





