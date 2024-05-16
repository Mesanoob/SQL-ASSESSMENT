-- Active: 1715669642874@@127.0.0.1@3306

-- 1. Analyse the data
-- ****************************************************************
SELECT u.*, p.*
FROM users u
JOIN progress p
ON u.user_id = p.user_id;

-- 2. What are the Top 25 schools (.edu domains)?
-- ****************************************************************
SELECT COUNT(u.email_domain) AS `Number of students`, u.email_domain 
FROM users u
GROUP BY email_domain  
ORDER BY `Number of Students` DESC
LIMIT 25;

-- How many .edu learners are located in New York? 
-- ****************************************************************
SELECT COUNT(*) 
FROM users 
WHERE email_domain LIKE '%.edu' 
AND city = 'New York';

-- The mobile_app column contains either mobile-user or NULL. 
-- How many of these Codecademy learners are using the mobile app?
-- ****************************************************************
SELECT COUNT(*) 
FROM users 
WHERE mobile_app = 'mobile-user';


-- 3. Query for the sign up counts for each hour.
-- Refer to CodeAcademy to solve this question
-- Hint: https://dev.mysql.com/doc/refman/5.7/en/date-and-time-functions.html#function_date-format 
-- ****************************************************************
SELECT strftime('%H', sign_up_at) AS hour, COUNT(*) AS sign_up_count_by_hour
FROM users
GROUP BY hour
ORDER BY hour;

-- 4. Do different schools (.edu domains) prefer different courses?
-- ****************************************************************
-- HOW to determine preference for differenct coures 
-- What courses are the New Yorker Students taking?
-- ****************************************************************
-- 4. METHOD #1: Do different schools (.edu domains) prefer different courses?
-- Calculate the users from each email domain that have non-empty entries learning C++, SQL, HTML, JavaScript, Java
-- Count the total number of users per email domain, sorted by the email domain in descending order.
-- ****************************************************************
-- QUESTIONS ESSENTIALLY IS ASKING is there a preference for course in different schools
-- E.G school 1 most students are taking SQL therefore preference is SQL 
-- Sort by courses taken  
WITH CourseCounts AS (
    SELECT email_domain, 
           SUM(CASE WHEN learn_cpp <> '' THEN 1 ELSE 0 END) AS CppLearners,
           SUM(CASE WHEN learn_sql <> '' THEN 1 ELSE 0 END) AS SqlLearners,
           SUM(CASE WHEN learn_html <> '' THEN 1 ELSE 0 END) AS HtmlLearners,
           SUM(CASE WHEN learn_javascript <> '' THEN 1 ELSE 0 END) AS JsLearners,
           SUM(CASE WHEN learn_java <> '' THEN 1 ELSE 0 END) AS JavaLearners
    FROM progress
    JOIN users ON progress.user_id = users.user_id
    GROUP BY email_domain
)
SELECT email_domain,
       CASE 
           WHEN CppLearners >= SqlLearners AND CppLearners >= HtmlLearners AND CppLearners >= JsLearners AND CppLearners >= JavaLearners THEN 'C++'
           WHEN SqlLearners >= CppLearners AND SqlLearners >= HtmlLearners AND SqlLearners >= JsLearners AND SqlLearners >= JavaLearners THEN 'SQL'
           WHEN HtmlLearners >= CppLearners AND HtmlLearners >= SqlLearners AND HtmlLearners >= JsLearners AND HtmlLearners >= JavaLearners THEN 'HTML'
           WHEN JsLearners >= CppLearners AND JsLearners >= SqlLearners AND JsLearners >= HtmlLearners AND JsLearners >= JavaLearners THEN 'JavaScript'
           WHEN JavaLearners >= CppLearners AND JavaLearners >= SqlLearners AND JavaLearners >= HtmlLearners AND JavaLearners >= JsLearners THEN 'Java'
       END AS PreferredCourse,
       CASE 
           WHEN CppLearners >= SqlLearners AND CppLearners >= HtmlLearners AND CppLearners >= JsLearners AND CppLearners >= JavaLearners THEN CppLearners
           WHEN SqlLearners >= CppLearners AND SqlLearners >= HtmlLearners AND SqlLearners >= JsLearners AND SqlLearners >= JavaLearners THEN SqlLearners
           WHEN HtmlLearners >= CppLearners AND HtmlLearners >= SqlLearners AND HtmlLearners >= JsLearners AND HtmlLearners >= JavaLearners THEN HtmlLearners
           WHEN JsLearners >= CppLearners AND JsLearners >= SqlLearners AND JsLearners >= HtmlLearners AND JsLearners >= JavaLearners THEN JsLearners
           WHEN JavaLearners >= CppLearners AND JavaLearners >= SqlLearners AND JavaLearners >= HtmlLearners AND JavaLearners >= JsLearners THEN JavaLearners
       END AS LearnerCount
FROM CourseCounts
ORDER BY email_domain DESC;




-- ****************************************************************
SELECT COUNT(*)
FROM users
WHERE city = 'New York';

SELECT p.*
FROM users u
JOIN progress p ON u.user_id = p.user_id
WHERE u.city = 'New York';

-- What courses are the Chicago Students taking?
-- ****************************************************************

SELECT COUNT(*)
FROM users
WHERE city = 'Chicago';
SELECT p.*
FROM users u
JOIN progress p ON u.user_id = p.user_id
WHERE u.city = 'Chicago';