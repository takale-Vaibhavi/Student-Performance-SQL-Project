/*=========================================
  PROJECT: STUDENT PERFORMANCE ANALYSIS
  TOOL: POSTGRESQL                       
-------------------------------------------*/

/*-------------------------
  STEP 1: CREATE TABLE
---------------------------*/
CREATE TABLE students (
    school VARCHAR(10),
    sex VARCHAR(10),
    age INT,
    address VARCHAR(10),
    famsize VARCHAR(10),
    Pstatus VARCHAR(10),
    Medu INT,
    Fedu INT,
    Mjob VARCHAR(30),
    Fjob VARCHAR(30),
    reason VARCHAR(30),
    guardian VARCHAR(30),
    traveltime INT,
    studytime INT,
    failures INT,
    schoolsup VARCHAR(5),
    famsup VARCHAR(5),
    paid VARCHAR(5),
    activities VARCHAR(5),
    nursery VARCHAR(5),
    higher VARCHAR(5),
    internet VARCHAR(5),
    romantic VARCHAR(5),
    famrel INT,
    freetime INT,
    goout INT,
    Dalc INT,
    Walc INT,
    health INT,
    absences INT,
    G1 INT,
    G2 INT,
    G3 INT
);

/* --------------------
DATA VALIDATION
---------------------*/
select * from students;

/*--------------------
ADD STUDENT ID
--------------------*/
ALTER TABLE students
ADD COLUMN IF NOT EXISTS student_id SERIAL;

/* Verify Generated IDs */

SELECT student_id, sex, age,G3
FROM students
LIMIT 10;

/*------------------------
removing unnessary column
--------------------------*/
ALTER TABLE students
DROP COLUMN school,
DROP COLUMN famsize,
DROP COLUMN Pstatus,
DROP COLUMN guardian,
DROP COLUMN traveltime,
DROP COLUMN nursery,
DROP COLUMN higher,
DROP COLUMN freetime,
DROP COLUMN famrel;

/*-----------------------
RENAME COLUMN NAMES
-----------------------*/
ALTER TABLE students
RENAME COLUMN Medu TO mother_edu;

ALTER TABLE students
RENAME COLUMN Fedu TO father_edu;

ALTER TABLE students
RENAME COLUMN Mjob TO mother_job;

ALTER TABLE students
RENAME COLUMN Fjob TO father_job;

ALTER TABLE students
RENAME COLUMN studytime TO weekly_studytime;
ALTER TABLE students
RENAME COLUMN reason TO school_choice_reason;

ALTER TABLE students
RENAME COLUMN schoolsup TO school_support;

ALTER TABLE students
RENAME COLUMN famsup TO family_support;

ALTER TABLE students
RENAME COLUMN goout TO social_activity;

ALTER TABLE students
RENAME COLUMN Dalc TO weekday_alcohol;

ALTER TABLE students
RENAME COLUMN Walc TO weekend_alcohol;

ALTER TABLE students
RENAME COLUMN G1 TO first_exam_score;

ALTER TABLE students
RENAME COLUMN G2 TO second_exam_score;

ALTER TABLE students
RENAME COLUMN G3 TO final_exam_score;

/*-------------------------------------
	STUDENT OVERVIEW ANALYSIS
--------------------------------------*/
--Q1.How many students are in the dataset?
select count(*) as total_student
from students;

--Q2.How many male and female students?
select gender,count(*)as total_students
from students
group by gender;

--Q3.What is the average student age?
select avg(age) as average_as
from students;

/*-------------------------------------
	ACADEMIC PERFORMANCE ANALYSIS
-------------------------------------*/
--Q4.What is the average final performance?
SELECT ROUND(AVG(final_exam_score),2) AS average_score
FROM students;


--Q5.Who are the highest-performing students?
select student_id, gender,age, final_exam_score
from students
order by final_exam_score  desc
limit 10;

--Q6.Which students need additional support and bottom 10 students?
select student_id, gender,age, final_exam_score
from students
order by final_exam_score  asc
limit 10;

--Q7.How is the topper? 
select student_id, gender,age, final_exam_score
from students
order by final_exam_score  desc
limit 1;


--Q8.How is the second topper?
select student_id, gender,age, final_exam_score
from students
order by final_exam_score  desc
limit 1 offset 1;

/*---------------------------
	STUDY TIME ANALYSIS
----------------------------*/
--Q9.Do students who study more score higher?
SELECT weekly_studytime,
       ROUND(AVG(final_exam_score),2) AS average_score
FROM students
GROUP BY weekly_studytime
ORDER BY weekly_studytime;

--Q10.More failures usually mean lower final scores.
SELECT failures,
       ROUND(AVG(final_exam_score),2) AS average_score
FROM students
GROUP BY failures
ORDER BY failures;---More failures usually mean lower final scores

/*------------------------
	ABSENCE ANALYSIS
-------------------------*/
--Q11.Do students with high absences perform worse?
SELECT student_id,
       absences,
       final_exam_score
FROM students
ORDER BY absences DESC;

/*-----------------------------
	INTERNET ACCESS ANALYSIS
-----------------------------*/
--Q12.Does internet access affect grades?
SELECT internet,
       ROUND(AVG(final_exam_score),2) AS average_score
FROM students
GROUP BY internet;

/*-------------------------------
	FAMILY SUPPORT ANALYSIS
-------------------------------*/
--Q13.Does family support improve grades
SELECT family_support,
       ROUND(AVG(final_exam_score),2) AS average_score
FROM students
GROUP BY family_support;

/*---------------------------------
	SOCIAL ACTIVITY ANALYSIS
----------------------------------*/
--Q14.Does spending more time with friends affect grades?
SELECT social_activity,
       ROUND(AVG(final_exam_score),2) AS average_score
FROM students
GROUP BY social_activity
ORDER BY social_activity;

/*------------------------------------
	ALCOHAL CONSUMPTION ANALYSIS
-------------------------------------*/
--Q15.Does alcohol consumption affect academic performance?
SELECT weekend_alcohol,
       ROUND(AVG(final_exam_score),2) AS average_score
FROM students
GROUP BY weekend_alcohol
ORDER BY weekend_alcohol;

/*----------------------------------
	BEST PERFORMACE GENDER
-----------------------------------*/
--Q16Which gender performs better on average?
SELECT gender,
       ROUND(AVG(final_exam_score),2) AS average_score
FROM students
GROUP BY gender;

/* ----------------------------------
	HIGHEST AVERAGE SCORE BY AGE
------------------------------------*/
--Q17.Which age group performs best?
SELECT age,
       ROUND(AVG(final_exam_score),2) AS average_score
FROM students
GROUP BY age
ORDER BY average_score DESC;


--Q18.Students Scoring Above Average?
SELECT student_id,
       gender,
       final_exam_score
FROM students
WHERE final_exam_score >
(    SELECT AVG(final_exam_score)
    FROM students
);
select* from students;

--Q19.Rank students from highest marks to lowest?
SELECT student_id,
       final_exam_score,
       ROW_NUMBER() OVER(ORDER BY final_exam_score DESC) AS rank_no
FROM students;





