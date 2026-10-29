-- VBIS Chapter 3 SQL Exercises
-- Student: Yuzil Zulfugarov
-- Database: PostgreSQL
-- Queries must be tested against the assigned textbook schema.

-- Exercise 3.11 (a)
-- Students who have taken a Computer Science course
SELECT DISTINCT s.ID, s.name
FROM student AS s
JOIN takes AS t ON t.ID = s.ID
JOIN course AS c ON c.course_id = t.course_id
WHERE c.dept_name = 'Comp. Sci.';

-- Exercise 3.11 (b)
-- Students who have not taken a course before 2017
SELECT s.ID, s.name
FROM student AS s
WHERE NOT EXISTS (
    SELECT 1
    FROM takes AS t
    WHERE t.ID = s.ID
      AND t.year < 2017
);

-- Exercise 3.11 (c)
-- Department(s) with the highest instructor salary
SELECT dept_name
FROM instructor
GROUP BY dept_name
HAVING MAX(salary) >= ALL (
    SELECT MAX(salary)
    FROM instructor
    GROUP BY dept_name
);

-- Exercise 3.11 (d)
-- Minimum among the departments' maximum instructor salaries
SELECT MIN(max_salary)
FROM (
    SELECT MAX(salary) AS max_salary
    FROM instructor
    GROUP BY dept_name
) AS department_salaries;

-- Exercise 3.15 (a)
-- Customers who have an account at every Brooklyn branch
SELECT c.customer_name
FROM customer AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM branch AS b
    WHERE b.branch_city = 'Brooklyn'
      AND NOT EXISTS (
          SELECT 1
          FROM depositor AS d
          JOIN account AS a ON a.account_number = d.account_number
          WHERE d.customer_name = c.customer_name
            AND a.branch_name = b.branch_name
      )
);

-- Exercise 3.15 (b)
-- Total amount of all loans
SELECT SUM(amount) AS total_loan_amount
FROM loan;

-- Exercise 3.15 (c)
-- Branches whose assets exceed the assets of at least
-- one branch located in Brooklyn
SELECT branch_name
FROM branch
WHERE assets > ANY (
    SELECT assets
    FROM branch
    WHERE branch_city = 'Brooklyn'
);

-- Exercise 3.24
-- Accounting students whose advisor belongs to Physics
SELECT DISTINCT s.ID, s.name
FROM student AS s
JOIN advisor AS a ON a.s_ID = s.ID
JOIN instructor AS i ON i.ID = a.i_ID
WHERE s.dept_name = 'Accounting'
  AND i.dept_name = 'Physics';

-- Exercise 3.25
-- Departments with a budget greater than Philosophy's budget
SELECT dept_name
FROM department
WHERE budget > (
    SELECT budget
    FROM department
    WHERE dept_name = 'Philosophy'
)
ORDER BY dept_name;
