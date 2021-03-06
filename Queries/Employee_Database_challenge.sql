--Create table showing titles and dates
SELECT e.emp_no, e.first_name, e.last_name, 
		t.title, t.from_date, t.to_date
INTO retirement_titles
FROM employees as e
INNER JOIN titles as t
ON (e.emp_no = t.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;

SELECT * FROM retirement_titles


-- Use Distinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title
INTO unique_titles
FROM retirement_titles as rt
WHERE (rt.to_date = '9999-01-01')
ORDER BY rt.emp_no, rt.to_date DESC;

SELECT * FROM unique_titles

--Get count of employees due to retire. Sorted by department
SELECT title,
	COUNT (title)
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY count DESC;

SELECT * FROM retiring_titles;

--Create mentorship eligibility table
SELECT DISTINCT ON (e.emp_no) e.emp_no,
		e.first_name, e.last_name, e.birth_date,
		de.from_date, de.to_date,
		t.title
INTO mentorship_eligibility
FROM employees as e
LEFT JOIN dept_emp as de
		ON (e.emp_no = de.emp_no)
LEFT JOIN titles as t
		ON (e.emp_no = t.emp_no)
WHERE (de.to_date = '9999-01-01')
AND (birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY emp_no;



--EXTRA TABLES FOR ANALYSIS
--Count number of employees eligible for mentorship
SELECT title,
COUNT(title)
INTO mentor_title_count
FROM unique_titles
GROUP BY title;
  
  
--Create table with mentoree and retiree counts   
SELECT rt.title,
  	rt.count as retire_count,
  	mtc.count as mentoree_count
INTO comparison_table
FROM retiring_titles as rt
LEFT JOIN mentor_title_count as mtc
ON (rt.title = mtc.title);

