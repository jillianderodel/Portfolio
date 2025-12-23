-- 1a.
SELECT
	*
FROM
	employees
	INNER JOIN
		jobs
		ON
			employees.job_id = jobs.job_id;
-- 1b.
SELECT
	*
FROM
	employees AS e
	LEFT OUTER JOIN
		jobs AS j
		ON
			e.job_id = j.job_id;
-- 1c. There aren't any jobs in the employees table that aren't in the jobs table.
-- 1d.
SELECT
	*
FROM
	jobs AS j
	RIGHT OUTER JOIN
		employees AS e
		ON
			j.job_id = e.job_id;
-- 1e.
SELECT
	e.first_name,
	e.last_name,
	e.phone_number,
	j.job_id,
	j.job_title,
	j.max_salary
FROM
	employees as e
	INNER JOIN
		jobs as j
		ON
			e.job_id = j.job_id;
-- 1f.
SELECT
	e.first_name,
	e.last_name,
	e.phone_number,
	j.job_id,
	j.job_title,
	j.max_salary
FROM
	employees as e
	INNER JOIN
		jobs as j
		ON
			e.job_id = j.job_id
WHERE
	max_salary >= 9000
ORDER BY
	j.job_id ASC
	LIMIT 15;
	
-- 2a.
SELECT
	e.first_name,
	e.last_name,
	e.email,
	d.department_id,
	d.department_name,
	l.location_id,
	l.country_id
FROM
	employees as e
	INNER JOIN
		departments as d
		ON
			e.department_id = d.department_id
	INNER JOIN
		locations as l
		ON
			d.location_id = l.location_id;
-- 2b.
SELECT
	e.first_name,
	e.last_name,
	e.email,
	d.department_id,
	d.department_name,
	l.location_id,
	l.country_id,
	c.country_name
FROM
	employees as e
	INNER JOIN
		departments as d
		ON
			e.department_id = d.department_id
	INNER JOIN
		locations as l
		ON
			d.location_id = l.location_id
	INNER JOIN
		countries as c
		ON
			l.country_id = c.country_id;
-- 2c.
SELECT
	*
FROM
	employees as e
	LEFT OUTER JOIN
		dependents as d
		ON
			e.employee_id = d.employee_id
WHERE
	dependent_id is null;
-- 2d.
SELECT
	*
FROM
	countries
WHERE
	country_name like '%s%';
SELECT
	*
FROM
	countries
WHERE
	region_id = 1 or region_id = 2;
SELECT
	*
FROM
	countries
WHERE
	country_name like '%s%'
	UNION
		SELECT
			*
		FROM
			countries
		WHERE
			region_id = 1 or region_id = 2;
-- 2e.
SELECT
	*
FROM
	countries
WHERE
	country_name like '%s%'
	INTERSECT
		SELECT
			*
		FROM
			countries
		WHERE
			region_id = 1 or region_id = 2;
-- The results say that the intersect doesn't produce any duplications.

-- 3a.
SELECT
	COUNT(salary) as [under_10]
FROM
	employees
WHERE
	salary < 10000;
-- 3b.
SELECT
	last_name,
	LENGTH(last_name) as [LastNameChars]
FROM
	employees
WHERE
	LENGTH(last_name) > 8
ORDER BY
	LENGTH(last_name) ASC;
-- 3c.
SELECT
	SUBSTR(first_name, 1, 1) || '. ' || last_name || ": " || email as [EmployeeInfo]
FROM
	employees;
-- 3d.
SELECT
	STRFTIME('%Y-%m-%d', '1977-08-16') - STRFTIME('%Y-%m-%d', '1935-01-08') as
	[Elvis Age];
	
-- 4a.
SELECT
	AVG(salary) as [Average Salary],
	MIN(salary) as [Minimum Salary],
	MAX(salary) as [Maximum Salary]
FROM
	employees;
-- 4b.
SELECT
	department_id,
	AVG(salary) as [Average Salary]
FROM
	employees
GROUP BY
	department_id
ORDER BY
	department_id asc;
-- 4c.
SELECT
	department_id,
	ROUND(AVG(salary), 1) as [Average Salary]
FROM
	employees
GROUP BY
	department_id
ORDER BY
	department_id asc;
-- 4d.
SELECT
	department_id,
	ROUND(AVG(salary), 1) as [Average Salary]
FROM
	employees
GROUP BY
	department_id
HAVING
	[Average Salary] > 9000
ORDER BY
	department_id asc;
-- 4e.
SELECT
	department_id,
	job_id,
	ROUND(AVG(salary), 1) as [Average Salary]
FROM
	employees
GROUP BY
	department_id, job_id
ORDER BY
	department_id asc,
	job_id asc;