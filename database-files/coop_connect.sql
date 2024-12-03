DROP DATABASE IF EXISTS coop_connect;

CREATE DATABASE IF NOT EXISTS coop_connect;

USE coop_connect;

-- school tables
CREATE TABLE
    IF NOT EXISTS college (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(255) NOT NULL
    );

CREATE TABLE
    IF NOT EXISTS department (
        id INT AUTO_INCREMENT PRIMARY KEY,
        college INT NOT NULL,
        name VARCHAR(255) NOT NULL,
        -- one-to-one
        CONSTRAINT fk_department_college FOREIGN KEY (college) REFERENCES college (id) ON UPDATE CASCADE ON DELETE CASCADE
    );

CREATE TABLE
    IF NOT EXISTS major (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        department INT NOT NULL,
        -- one-to-one
        CONSTRAINT fk_major_department FOREIGN KEY (department) REFERENCES department (id) ON UPDATE CASCADE ON DELETE CASCADE
    );

CREATE TABLE
    IF NOT EXISTS coop_advisor (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        email VARCHAR(255) NOT NULL,
        department_id INT NOT NULL,
        -- one-to-many
        CONSTRAINT fk_coop_advisor_department FOREIGN KEY (department_id) REFERENCES department (id) ON UPDATE CASCADE ON DELETE CASCADE
    );

-- company tables
CREATE TABLE
    IF NOT EXISTS industry (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(255) NOT NULL
    );

CREATE TABLE
    IF NOT EXISTS company (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        industry INT NOT NULL,
        location VARCHAR(255) NOT NULL,
        description TEXT NOT NULL,
        criteria TEXT NOT NULL,
        -- one-to-one
        CONSTRAINT fk_company_industry FOREIGN KEY (industry) REFERENCES industry (id) ON UPDATE CASCADE ON DELETE RESTRICT
    );

CREATE TABLE
    IF NOT EXISTS skill (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(255) NOT NULL
    );

CREATE TABLE
    IF NOT EXISTS hiring_manager (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        position VARCHAR(255) NOT NULL,
        email VARCHAR(255) NOT NULL,
        company_id INT NOT NULL,
        -- one-to-many
        CONSTRAINT fk_hiring_manager_company FOREIGN KEY (company_id) REFERENCES company (id) ON UPDATE CASCADE ON DELETE CASCADE
    );

CREATE TABLE
    IF NOT EXISTS hiring_manager_coop_advisor (
        hiring_manager_id INT NOT NULL,
        coop_advisor_id INT NOT NULL,
        PRIMARY KEY (hiring_manager_id, coop_advisor_id),
        -- one-to-many
        CONSTRAINT fk_hmca_hiring_manager FOREIGN KEY (hiring_manager_id) REFERENCES hiring_manager (id) ON UPDATE CASCADE ON DELETE CASCADE,
        CONSTRAINT fk_hmca_coop_advisor FOREIGN KEY (coop_advisor_id) REFERENCES coop_advisor (id) ON UPDATE CASCADE ON DELETE CASCADE
    );

CREATE TABLE
    IF NOT EXISTS job_position (
        id INT AUTO_INCREMENT PRIMARY KEY,
        title VARCHAR(255) NOT NULL,
        description TEXT NOT NULL,
        still_accepting BOOLEAN NOT NULL,
        num_applicants INT NOT NULL,
        postedAt DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
        updatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        location VARCHAR(255) NOT NULL,
        desired_skills TEXT NOT NULL,
        targeted_majors TEXT NOT NULL,
        company_id INT NOT NULL,
        -- one-to-many
        CONSTRAINT fk_job_position_company FOREIGN KEY (company_id) REFERENCES company (id) ON UPDATE CASCADE ON DELETE CASCADE
    );

-- student tables
CREATE TABLE
    IF NOT EXISTS student (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        email VARCHAR(255) NOT NULL,
        gpa DECIMAL(3, 2) NOT NULL,
        major_id INT NOT NULL,
        grad_year INT NOT NULL,
        advised_by INT NOT NULL,
        hired_by INT,
        past_job INT,
        -- one-to-one
        CONSTRAINT fk_student_major FOREIGN KEY (major_id) REFERENCES major (id) ON UPDATE CASCADE ON DELETE RESTRICT,
        CONSTRAINT fk_advised_by FOREIGN KEY (advised_by) REFERENCES coop_advisor (id) ON UPDATE CASCADE ON DELETE RESTRICT,
        CONSTRAINT fk_hired_by FOREIGN KEY (hired_by) REFERENCES hiring_manager (id) ON UPDATE CASCADE ON DELETE SET NULL,
        CONSTRAINT fk_past_job FOREIGN KEY (past_job) REFERENCES job_position (id) ON UPDATE CASCADE ON DELETE SET NULL
    );

CREATE TABLE
    IF NOT EXISTS student_past_job (
        student_id INT NOT NULL,
        job_position_id INT NOT NULL,
        PRIMARY KEY (student_id, job_position_id),
        -- one-to-many
        CONSTRAINT fk_student_past_job_student FOREIGN KEY (student_id) REFERENCES student (id) ON UPDATE CASCADE ON DELETE CASCADE,
        CONSTRAINT fk_student_past_job_job_position FOREIGN KEY (job_position_id) REFERENCES job_position (id) ON UPDATE CASCADE ON DELETE CASCADE
    );

CREATE TABLE
    IF NOT EXISTS review (
        id INT AUTO_INCREMENT PRIMARY KEY,
        rating INT NOT NULL,
        review TEXT NOT NULL,
        student_id INT NOT NULL,
        job_position_id INT NOT NULL,
        -- one-to-many
        CONSTRAINT fk_review_student FOREIGN KEY (student_id) REFERENCES student (id) ON UPDATE CASCADE ON DELETE CASCADE,
        CONSTRAINT fk_review_job_position FOREIGN KEY (job_position_id) REFERENCES job_position (id) ON UPDATE CASCADE ON DELETE CASCADE
    );

CREATE TABLE
    IF NOT EXISTS interview_question (
        id INT AUTO_INCREMENT PRIMARY KEY,
        question TEXT NOT NULL,
        job_position_id INT NOT NULL,
        author_id INT NOT NULL,
        -- one-to-many
        CONSTRAINT fk_interview_question_job_position FOREIGN KEY (job_position_id) REFERENCES job_position (id) ON UPDATE CASCADE ON DELETE RESTRICT,
        CONSTRAINT fk_interview_question_author FOREIGN KEY (author_id) REFERENCES student (id) ON UPDATE CASCADE ON DELETE CASCADE
    );

CREATE TABLE
    IF NOT EXISTS application (
        id INT AUTO_INCREMENT PRIMARY KEY,
        applicant_id INT NOT NULL,
        job_position_id INT NOT NULL,
        status ENUM ('Pending', 'Accepted', 'Rejected') DEFAULT 'Pending',
        applied_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        -- one-to-many
        CONSTRAINT fk_application_student FOREIGN KEY (applicant_id) REFERENCES student (id) ON UPDATE CASCADE ON DELETE CASCADE,
        CONSTRAINT fk_application_job_position FOREIGN KEY (job_position_id) REFERENCES job_position (id) ON UPDATE CASCADE ON DELETE CASCADE
    );

-- Populating tables
-- colleges
INSERT INTO
    coop_connect.college (id, name)
VALUES
    ('1', 'Northeastern');

INSERT INTO
    coop_connect.college (id, name)
VALUES
    ('2', 'Boston University');

-- departments
INSERT INTO
    coop_connect.department (college, name)
VALUES
    ('1', 'Khoury College of Computer Science');

INSERT INTO
    coop_connect.department (college, name)
VALUES
    ('2', 'College of Arts, Media & Design');

-- majors
INSERT INTO
    coop_connect.major (id, name, department)
VALUES
    ('1', 'Computer Science', '1');

INSERT INTO
    coop_connect.major (id, name, department)
VALUES
    ('2', 'Cybersecurity', '1');

INSERT INTO
    coop_connect.major (id, name, department)
VALUES
    ('3', 'Design', '2');

-- co-op advisors
INSERT INTO
    coop_connect.coop_advisor (id, name, email, department_id)
VALUES
    (
        '1',
        'Winston Churchill',
        'w.churchill@northeastern.edu',
        '1'
    );

INSERT INTO
    coop_connect.coop_advisor (id, name, email, department_id)
VALUES
    (
        '2',
        'Amber Jackson',
        'a.jackson@northeastern.edu',
        '2'
    );

-- students
INSERT INTO
    coop_connect.student (
        id,
        name,
        email,
        gpa,
        major_id,
        grad_year,
        advised_by
    )
VALUES
    (
        1,
        'Maura Turner',
        'm.turner@northeastern.edu',
        4.0,
        '1',
        '2027',
        '1'
    );

INSERT INTO
    coop_connect.student (
        id,
        name,
        email,
        gpa,
        major_id,
        grad_year,
        advised_by
    )
VALUES
    (
        2,
        'Wade Wilson',
        'w.wilson@northeastern.edu',
        3.0,
        '1',
        '2027',
        '1'
    );

INSERT INTO
    coop_connect.student (
        id,
        name,
        email,
        gpa,
        major_id,
        grad_year,
        advised_by
    )
VALUES
    (
        3,
        'Matt Smith',
        'm.smith@northeastern.edu',
        3.7,
        '3',
        '2027',
        '1'
    );

INSERT INTO
    coop_connect.student (
        id,
        name,
        email,
        gpa,
        major_id,
        grad_year,
        advised_by
    )
VALUES
    (
        4,
        'Ann Adams',
        'a.adams@northeastern.edu',
        2.5,
        '3',
        '2026',
        '2'
    );

-- industries
INSERT INTO
    coop_connect.industry (id, name)
VALUES
    ('1', 'Tech');

INSERT INTO
    coop_connect.industry (id, name)
VALUES
    ('2', 'Pharmaceuticals');

-- companies
INSERT INTO
    coop_connect.company (
        id,
        name,
        industry,
        location,
        description,
        criteria
    )
VALUES
    ('1', 'Microsoft', '1', 'Seattle', 'abc', 'abc');

INSERT INTO
    coop_connect.company (
        id,
        name,
        industry,
        location,
        description,
        criteria
    )
VALUES
    ('2', 'Apple', '1', 'Los Angeles', 'abc', 'abc');

-- job positions
INSERT INTO
    coop_connect.job_position (
        id,
        title,
        description,
        still_accepting,
        num_applicants,
        location,
        desired_skills,
        targeted_majors,
        company_id
    )
VALUES
    (
        '1',
        'Software Developer',
        'abc',
        '1',
        20,
        'Seattle',
        'teamwork',
        'Computer Science',
        '1'
    );

INSERT INTO
    coop_connect.job_position (
        id,
        title,
        description,
        still_accepting,
        num_applicants,
        location,
        desired_skills,
        targeted_majors,
        company_id
    )
VALUES
    (
        '2',
        'UX Designer',
        'abc',
        '1',
        20,
        'Los Angeles',
        'teamwork',
        'Biology',
        '2'
    );

-- applications
INSERT INTO
    coop_connect.application (id, applicant_id, job_position_id, status)
VALUES
    ('1', '2', '2', 'Pending');

INSERT INTO
    coop_connect.application (id, applicant_id, job_position_id, status)
VALUES
    ('2', '3', '2', 'Rejected');

-- hiring managers
INSERT INTO
    coop_connect.hiring_manager (id, name, position, email, company_id)
VALUES
    (
        '1',
        'Damian Wayne',
        '1',
        'd.wayne@outlook.com',
        '1'
    );

INSERT INTO
    coop_connect.hiring_manager (id, name, position, email, company_id)
VALUES
    ('2', 'Sarah Lewis', '2', 's.lewis@gmail.com', '2');

-- interview questions
INSERT INTO
    coop_connect.interview_question (id, question, job_position_id, author_id)
VALUES
    ('1', 'What is your greatest strength?', '1', '1');

INSERT INTO
    coop_connect.interview_question (id, question, job_position_id, author_id)
VALUES
    ('2', 'What is your greatest weakness?', '2', '3');

-- reviews
INSERT INTO
    coop_connect.review (id, rating, review, student_id, job_position_id)
VALUES
    ('1', '3', 'Review 1', '1', '1');

INSERT INTO
    coop_connect.review (id, rating, review, student_id, job_position_id)
VALUES
    ('2', '4', 'Review 2', '3', '1');

INSERT INTO
    coop_connect.review (id, rating, review, student_id, job_position_id)
VALUES
    ('3', '2', 'Review 3', '1', '2');

-- skills
INSERT INTO
    skill (id, name)
VALUES
    (1, 'Python');

INSERT INTO
    skill (id, name)
VALUES
    (2, 'SQL');

-- many-to-many coop advisors/hiring managers
INSERT INTO
    coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id)
VALUES
    (1, 1);

INSERT INTO
    coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id)
VALUES
    (1, 2);

INSERT INTO
    coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id)
VALUES
    (2, 1);

INSERT INTO
    coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id)
VALUES
    (2, 2);

-- user stories sql crud statements
-- 1. Maura Turner
-- (1.1) See if co-op position she applied for is filled
SELECT
    application.id
FROM
    coop_connect.student
    JOIN coop_connect.application ON student.id = application.applicant_id
    JOIN coop_connect.job_position ON application.job_position_id = job_position.id
WHERE
    student.id = '1'
    AND still_accepting = '0';

-- (1.2) See previous students who had co-ops she is interested in
SELECT
    student.id
FROM
    coop_connect.student
WHERE
    past_job = 'x';

-- (1.3) See previous interview questions for a co-op position
SELECT
    interview_question.question
FROM
    coop_connect.interview_question
    JOIN coop_connect.job_position jp on interview_question.job_position_id = jp.id
    JOIN coop_connect.application a on jp.id = a.job_position_id
    JOIN coop_connect.student s on a.applicant_id = s.id
WHERE
    s.id = '1'
    AND a.job_position_id = '1';

-- (1.4) See reviews from people that worked at companies she is interested in
SELECT
    r.rating,
    r.review,
    jp.title,
    c.name
FROM
    coop_connect.review r
    JOIN coop_connect.job_position jp on r.job_position_id = jp.id
    JOIN coop_connect.company c on jp.company_id = c.id
WHERE
    c.name = 'Microsoft';

-- (1.5) See status of applications
SELECT
    jp.title,
    a.status
FROM
    coop_connect.job_position jp
    JOIN coop_connect.application a on jp.id = a.job_position_id
    JOIN coop_connect.student s on a.applicant_id = s.id
WHERE
    s.id = '1';

-- (1.6) Keep track of applications/apply to positions
INSERT INTO
    coop_connect.application (id, applicant_id, job_position_id, status)
VALUES
    ('3', '1', '1', 'Pending');

-- 2. Wade Wilson
-- (2.1) Share reviews on past positions
INSERT INTO
    coop_connect.review (id, rating, review, student_id, job_position_id)
VALUES
    ('4', '5', 'Review 4', '2', '1');

-- (2.2) Allow other students to contact him about his past position(s)
SELECT
    s.name,
    s.email
FROM
    coop_connect.student s
    JOIN coop_connect.review r on s.id = r.student_id
WHERE
    r.job_position_id = '1';

-- (2.3) Update a past review
UPDATE coop_connect.review
SET
    review = "Review 4 Updated"
WHERE
    id = '4';

-- (2.4) Delete past review that is no longer relevant
DELETE FROM coop_connect.review
WHERE
    review.id = '1';

-- (2.5) Share interview questions
INSERT INTO
    coop_connect.interview_question (id, question, job_position_id, author_id)
VALUES
    (
        '3',
        'What is your past experience in this field?',
        '1',
        '2'
    );

-- (2.6) Get contact information of advisor
SELECT
    ca.email
FROM
    coop_connect.coop_advisor ca
    JOIN coop_connect.student s on ca.id = s.advised_by
WHERE
    s.id = '2';

-- 3.Damian Wayne
-- (3.1) Post job descriptions
INSERT INTO
    coop_connect.job_position (
        id,
        title,
        description,
        still_accepting,
        num_applicants,
        location,
        desired_skills,
        targeted_majors,
        company_id
    )
VALUES
    (
        '3',
        'UX Designer',
        'abc',
        '1',
        20,
        'Houston',
        'Java, Python',
        'Computer Science',
        '1'
    );

-- (3.2) Search for students with a certain major and get their contact info
SELECT
    s.id,
    s.name,
    s.email
FROM
    coop_connect.student s
    JOIN coop_connect.major m ON s.major_id = m.id
WHERE
    m.name = 'Computer Science';

-- (3.3) Update application status
UPDATE coop_connect.application
SET
    status = 'Rejected'
WHERE
    applicant_id = '1';

-- (3.4) Look at reviews for his company's positions
SELECT
    r.rating,
    r.review,
    jp.title
FROM
    coop_connect.review r
    JOIN coop_connect.job_position jp on r.job_position_id = jp.id
    JOIN coop_connect.company c on jp.company_id = c.id
WHERE
    c.name = 'Microsoft';

-- (3.5) Look at job postings from similar companies
SELECT
    jp.title,
    jp.description,
    jp.desired_skills,
    jp.targeted_majors
FROM
    coop_connect.job_position jp
    JOIN coop_connect.company c on jp.company_id = c.id
    JOIN coop_connect.industry i on c.industry = i.id
WHERE
    i.name = 'Tech';

-- (3.6) View students past jobs
SELECT
    jp.id,
    jp.title,
    jp.description
FROM
    coop_connect.job_position jp
    JOIN coop_connect.student s on jp.id = s.past_job
WHERE
    s.id = '1';

-- 4. Winston Churchill
-- (4.1) Look at reviews of various positions
SELECT
    r.rating,
    r.review,
    jp.title,
    c.name
FROM
    coop_connect.review r
    JOIN coop_connect.job_position jp on jp.id = r.job_position_id
    JOIN coop_connect.company c on jp.company_id = c.id
ORDER BY
    c.id,
    jp.id;

-- (4.2) Look for jobs that want a certain major
SELECT
    *
FROM
    coop_connect.job_position
WHERE
    targeted_majors = 'Computer Science';

-- (4.3) Get contact info of recruiter from a certain company
SELECT
    hm.name,
    hm.position,
    hm.email
FROM
    coop_connect.hiring_manager hm
    JOIN coop_connect.company c on c.id = hm.company_id
WHERE
    c.name = 'Microsoft';

-- (4.4) Get contact info of recruiters of job positions that want a certain major
SELECT
    hm.name,
    hm.position,
    hm.email,
    jp.title,
    jp.description
FROM
    coop_connect.hiring_manager hm
    JOIN coop_connect.job_position jp on hm.company_id = jp.company_id
WHERE
    jp.targeted_majors = 'Computer Science';

-- (4.5) Get list of industries and the companies within them
SELECT
    i.name,
    c.name
FROM
    coop_connect.industry i
    JOIN coop_connect.company c on i.id = c.industry
ORDER BY
    i.name,
    c.name;

-- (4.6) Delete students no longer at Northeastern
DELETE FROM coop_connect.student
WHERE
    student.id = 4;

-- Mockaroo data
-- College table data
insert into
    coop_connect.college (name)
values
    ('Massachusetts Institute of Technology');

insert into
    coop_connect.college (name)
values
    ('Northeastern University');

insert into
    coop_connect.college (name)
values
    ('Tufts University');

insert into
    coop_connect.college (name)
values
    ('Boston College');

-- Department table data
insert into
    coop_connect.department (college, name)
values
    ('1', 'College of Computer Science');

insert into
    coop_connect.department (college, name)
values
    ('2', 'College of Computer Science');

insert into
    coop_connect.department (college, name)
values
    ('3', 'College of Computer Science');

insert into
    coop_connect.department (college, name)
values
    ('4', 'College of Computer Science');

insert into
    coop_connect.department (college, name)
values
    ('1', 'School of Business');

insert into
    coop_connect.department (college, name)
values
    ('2', 'School of Business');

insert into
    coop_connect.department (college, name)
values
    ('3', 'School of Business');

insert into
    coop_connect.department (college, name)
values
    ('4', 'School of Business');

insert into
    coop_connect.department (college, name)
values
    ('1', 'College of Science & Engineering');

insert into
    coop_connect.department (college, name)
values
    ('2', 'College of Science & Engineering');

insert into
    coop_connect.department (college, name)
values
    ('3', 'College of Science & Engineering');

insert into
    coop_connect.department (college, name)
values
    ('4', 'College of Science & Engineering');

insert into
    coop_connect.department (college, name)
values
    ('1', 'School of Health Science');

insert into
    coop_connect.department (college, name)
values
    ('2', 'School of Health Science');

insert into
    coop_connect.department (college, name)
values
    ('3', 'School of Health Science');

insert into
    coop_connect.department (college, name)
values
    ('4', 'School of Health Science');

insert into
    coop_connect.department (college, name)
values
    ('1', 'School of Criminal Justice');

insert into
    coop_connect.department (college, name)
values
    ('2', 'School of Criminal Justice');

insert into
    coop_connect.department (college, name)
values
    ('3', 'School of Criminal Justice');

insert into
    coop_connect.department (college, name)
values
    ('4', 'School of Criminal Justice');

-- Major table data
insert into
    coop_connect.major (name, department)
values
    ('Data Science', 2);

insert into
    coop_connect.major (name, department)
values
    ('Accounting', 1);

insert into
    coop_connect.major (name, department)
values
    ('Journalism', 3);

insert into
    coop_connect.major (name, department)
values
    ('Cybersecurity', 2);

insert into
    coop_connect.major (name, department)
values
    ('Marketing', 1);

insert into
    coop_connect.major (name, department)
values
    ('French', 3);

insert into
    coop_connect.major (name, department)
values
    ('Journalism', 3);

insert into
    coop_connect.major (name, department)
values
    ('Marketing', 1);

insert into
    coop_connect.major (name, department)
values
    ('Finance', 1);

insert into
    coop_connect.major (name, department)
values
    ('Management', 1);

insert into
    coop_connect.major (name, department)
values
    ('Data Science', 2);

insert into
    coop_connect.major (name, department)
values
    ('Chemistry', 3);

insert into
    coop_connect.major (name, department)
values
    ('Cybersecurity', 2);

insert into
    coop_connect.major (name, department)
values
    ('Cybersecurity', 2);

insert into
    coop_connect.major (name, department)
values
    ('Management', 1);

insert into
    coop_connect.major (name, department)
values
    ('Physics', 3);

insert into
    coop_connect.major (name, department)
values
    ('Philosophy', 3);

insert into
    coop_connect.major (name, department)
values
    ('Management', 1);

insert into
    coop_connect.major (name, department)
values
    ('Accounting', 1);

insert into
    coop_connect.major (name, department)
values
    ('Management', 1);

insert into
    coop_connect.major (name, department)
values
    ('Cybersecurity', 2);

insert into
    coop_connect.major (name, department)
values
    ('Management', 1);

insert into
    coop_connect.major (name, department)
values
    ('Philosophy', 3);

insert into
    coop_connect.major (name, department)
values
    ('Chemistry', 3);

insert into
    coop_connect.major (name, department)
values
    ('Finance', 1);

insert into
    coop_connect.major (name, department)
values
    ('Chemistry', 3);

insert into
    coop_connect.major (name, department)
values
    ('Accounting', 1);

insert into
    coop_connect.major (name, department)
values
    ('Philosophy', 3);

insert into
    coop_connect.major (name, department)
values
    ('Physics', 3);

insert into
    coop_connect.major (name, department)
values
    ('Journalism', 3);

insert into
    coop_connect.major (name, department)
values
    ('Philosophy', 3);

insert into
    coop_connect.major (name, department)
values
    ('Environmental Studies', 3);

insert into
    coop_connect.major (name, department)
values
    ('Accounting', 1);

insert into
    coop_connect.major (name, department)
values
    ('Cybersecurity', 2);

insert into
    coop_connect.major (name, department)
values
    ('Chemistry', 3);

insert into
    coop_connect.major (name, department)
values
    ('Cybersecurity', 2);

insert into
    coop_connect.major (name, department)
values
    ('German', 3);

insert into
    coop_connect.major (name, department)
values
    ('Philosophy', 3);

insert into
    coop_connect.major (name, department)
values
    ('Management', 1);

insert into
    coop_connect.major (name, department)
values
    ('Accounting', 1);

-- Co-op Advisor table data
insert into
    coop_connect.coop_advisor (name, email, department_id)
values
    (
        'Darrel Swidenbank',
        'dswidenbank0@marriott.com',
        1
    );

insert into
    coop_connect.coop_advisor (name, email, department_id)
values
    ('Shaine Greenless', 'sgreenless1@vkontakte.ru', 2);

insert into
    coop_connect.coop_advisor (name, email, department_id)
values
    ('Josi Hallitt', 'jhallitt2@shinystat.com', 4);

insert into
    coop_connect.coop_advisor (name, email, department_id)
values
    ('Shermy Umbers', 'sumbers3@e-recht24.de', 9);

insert into
    coop_connect.coop_advisor (name, email, department_id)
values
    ('Lorrin Suttaby', 'lsuttaby4@arstechnica.com', 2);

insert into
    coop_connect.coop_advisor (name, email, department_id)
values
    ('Dani Young', 'dyoung5@opensource.org', 3);

insert into
    coop_connect.coop_advisor (name, email, department_id)
values
    ('Eydie Vedyasov', 'evedyasov6@wix.com', 20);

insert into
    coop_connect.coop_advisor (name, email, department_id)
values
    (
        'Kaleb Robertacci',
        'krobertacci7@cafepress.com',
        5
    );

insert into
    coop_connect.coop_advisor (name, email, department_id)
values
    ('Morrie Briddock', 'mbriddock8@nature.com', 14);

insert into
    coop_connect.coop_advisor (name, email, department_id)
values
    ('Mathilda Salleir', 'msalleir9@taobao.com', 7);

insert into
    coop_connect.coop_advisor (name, email, department_id)
values
    ('Germana Worsham', 'gworshama@ucla.edu', 10);

insert into
    coop_connect.coop_advisor (name, email, department_id)
values
    ('Michail Loxston', 'mloxstonb@disqus.com', 13);

insert into
    coop_connect.coop_advisor (name, email, department_id)
values
    ('Bryon Loude', 'bloudec@angelfire.com', 12);

insert into
    coop_connect.coop_advisor (name, email, department_id)
values
    ('Cristabel Beri', 'cberid@ovh.net', 16);

insert into
    coop_connect.coop_advisor (name, email, department_id)
values
    ('Milena Dallaway', 'mdallawaye@elpais.com', 18);

insert into
    coop_connect.coop_advisor (name, email, department_id)
values
    ('Elihu Sitlington', 'esitlingtonf@nasa.gov', 19);

insert into
    coop_connect.coop_advisor (name, email, department_id)
values
    ('Kirstin Abeau', 'kabeaug@weather.com', 15);

insert into
    coop_connect.coop_advisor (name, email, department_id)
values
    ('Gertrud Lyne', 'glyneh@cpanel.net', 12);

insert into
    coop_connect.coop_advisor (name, email, department_id)
values
    ('Jae Craft', 'jcrafti@topsy.com', 7);

insert into
    coop_connect.coop_advisor (name, email, department_id)
values
    (
        'Thorvald Rydings',
        'trydingsj@sciencedaily.com',
        11
    );

insert into
    coop_connect.coop_advisor (name, email, department_id)
values
    ('Tom Jaquemar', 'tjaquemark@printfriendly.com', 8);

insert into
    coop_connect.coop_advisor (name, email, department_id)
values
    ('Nickolai Gebbie', 'ngebbiel@goodreads.com', 19);

insert into
    coop_connect.coop_advisor (name, email, department_id)
values
    (
        'Jaquenette Glasscock',
        'jglasscockm@ucla.edu',
        16
    );

insert into
    coop_connect.coop_advisor (name, email, department_id)
values
    ('Derril Serginson', 'dserginsonn@alibaba.com', 3);

insert into
    coop_connect.coop_advisor (name, email, department_id)
values
    ('Harman Pappi', 'hpappio@trellian.com', 20);

insert into
    coop_connect.coop_advisor (name, email, department_id)
values
    ('Holmes Shivlin', 'hshivlinp@webs.com', 15);

insert into
    coop_connect.coop_advisor (name, email, department_id)
values
    (
        'Kathryn Pinnington',
        'kpinningtonq@symantec.com',
        4
    );

insert into
    coop_connect.coop_advisor (name, email, department_id)
values
    (
        'Tate Castagnaro',
        'tcastagnaror@aboutads.info',
        16
    );

insert into
    coop_connect.coop_advisor (name, email, department_id)
values
    ('Frank Gregh', 'fgreghs@cdbaby.com', 2);

insert into
    coop_connect.coop_advisor (name, email, department_id)
values
    ('Megan Antcliff', 'mantclifft@devhub.com', 20);

insert into
    coop_connect.coop_advisor (name, email, department_id)
values
    ('Keeley Roser', 'kroseru@biblegateway.com', 9);

insert into
    coop_connect.coop_advisor (name, email, department_id)
values
    (
        'Goddard Pettingall',
        'gpettingallv@japanpost.jp',
        6
    );

insert into
    coop_connect.coop_advisor (name, email, department_id)
values
    ('Chastity Donnelly', 'cdonnellyw@loc.gov', 18);

insert into
    coop_connect.coop_advisor (name, email, department_id)
values
    ('Melisenda Blue', 'mbluex@vinaora.com', 2);

insert into
    coop_connect.coop_advisor (name, email, department_id)
values
    ('Donnajean Hynd', 'dhyndy@theatlantic.com', 10);

insert into
    coop_connect.coop_advisor (name, email, department_id)
values
    ('Reinold Ing', 'ringz@sfgate.com', 1);

insert into
    coop_connect.coop_advisor (name, email, department_id)
values
    ('Cristina Spikeings', 'cspikeings10@ehow.com', 17);

insert into
    coop_connect.coop_advisor (name, email, department_id)
values
    ('Eolande Selwyn', 'eselwyn11@vkontakte.ru', 14);

insert into
    coop_connect.coop_advisor (name, email, department_id)
values
    ('Linn Mayoh', 'lmayoh12@biblegateway.com', 5);

insert into
    coop_connect.coop_advisor (name, email, department_id)
values
    (
        'Ariella Chiverstone',
        'achiverstone13@smugmug.com',
        6
    );

-- Industry table data
insert into
    coop_connect.industry (name)
values
    ('Healthcare');

insert into
    coop_connect.industry (name)
values
    ('Public Sector');

insert into
    coop_connect.industry (name)
values
    ('Technology');

insert into
    coop_connect.industry (name)
values
    ('Banking');

insert into
    coop_connect.industry (name)
values
    ('Consumer Services');

insert into
    coop_connect.industry (name)
values
    ('Government');

insert into
    coop_connect.industry (name)
values
    ('Energy');

insert into
    coop_connect.industry (name)
values
    ('Energy');

insert into
    coop_connect.industry (name)
values
    ('Education');

insert into
    coop_connect.industry (name)
values
    ('Banking');

insert into
    coop_connect.industry (name)
values
    ('Consumer Services');

insert into
    coop_connect.industry (name)
values
    ('Education');

insert into
    coop_connect.industry (name)
values
    ('Engineering');

insert into
    coop_connect.industry (name)
values
    ('Healthcare');

insert into
    coop_connect.industry (name)
values
    ('Sales and Trading');

insert into
    coop_connect.industry (name)
values
    ('Life Sciences');

insert into
    coop_connect.industry (name)
values
    ('Retail');

insert into
    coop_connect.industry (name)
values
    ('Retail');

insert into
    coop_connect.industry (name)
values
    ('Manufacturing');

insert into
    coop_connect.industry (name)
values
    ('Sales and Trading');

insert into
    coop_connect.industry (name)
values
    ('Energy');

insert into
    coop_connect.industry (name)
values
    ('Government');

insert into
    coop_connect.industry (name)
values
    ('Retail');

insert into
    coop_connect.industry (name)
values
    ('Technology');

insert into
    coop_connect.industry (name)
values
    ('Environment');

insert into
    coop_connect.industry (name)
values
    ('Healthcare');

insert into
    coop_connect.industry (name)
values
    ('Public Sector');

insert into
    coop_connect.industry (name)
values
    ('Sales and Trading');

insert into
    coop_connect.industry (name)
values
    ('Media and Communications');

insert into
    coop_connect.industry (name)
values
    ('Consumer Services');

insert into
    coop_connect.industry (name)
values
    ('Energy');

insert into
    coop_connect.industry (name)
values
    ('Public Sector');

insert into
    coop_connect.industry (name)
values
    ('Banking');

insert into
    coop_connect.industry (name)
values
    ('Environment');

insert into
    coop_connect.industry (name)
values
    ('Healthcare');

insert into
    coop_connect.industry (name)
values
    ('Technology');

insert into
    coop_connect.industry (name)
values
    ('Consumer Services');

insert into
    coop_connect.industry (name)
values
    ('Banking');

insert into
    coop_connect.industry (name)
values
    ('Consumer Services');

insert into
    coop_connect.industry (name)
values
    ('Media and Communications');

-- Company table data
insert into
    coop_connect.company (name, industry, location, description, criteria)
values
    (
        'Cummings-Brown',
        '31',
        'Chicago',
        'Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc.',
        'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt.'
    );

insert into
    coop_connect.company (name, industry, location, description, criteria)
values
    (
        'Schmidt Group',
        '8',
        'London',
        'Nunc purus. Phasellus in felis.',
        'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo.'
    );

insert into
    coop_connect.company (name, industry, location, description, criteria)
values
    (
        'McLaughlin, Sauer and Maggio',
        '36',
        'Chicago',
        'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.',
        'Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim.'
    );

insert into
    coop_connect.company (name, industry, location, description, criteria)
values
    (
        'Ritchie, Ritchie and Romaguera',
        '20',
        'Miami',
        'Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla.',
        'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl.'
    );

insert into
    coop_connect.company (name, industry, location, description, criteria)
values
    (
        'Hettinger-Herman',
        '34',
        'Toronto',
        'Nunc rhoncus dui vel sem. Sed sagittis.',
        'Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.'
    );

insert into
    coop_connect.company (name, industry, location, description, criteria)
values
    (
        'Conroy and Sons',
        '29',
        'Los Angeles',
        'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.',
        'Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst.'
    );

insert into
    coop_connect.company (name, industry, location, description, criteria)
values
    (
        'Leuschke Inc',
        '13',
        'London',
        'Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio.',
        'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy.'
    );

insert into
    coop_connect.company (name, industry, location, description, criteria)
values
    (
        'Considine LLC',
        '11',
        'Toronto',
        'Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue.',
        'Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum.'
    );

insert into
    coop_connect.company (name, industry, location, description, criteria)
values
    (
        'Grant, DuBuque and Yundt',
        '9',
        'Toronto',
        'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.',
        'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis. Donec semper sapien a libero.'
    );

insert into
    coop_connect.company (name, industry, location, description, criteria)
values
    (
        'Haag and Sons',
        '24',
        'Los Angeles',
        'Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus.',
        'Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula.'
    );

insert into
    coop_connect.company (name, industry, location, description, criteria)
values
    (
        'Schmitt-Kiehn',
        '23',
        'Boston',
        'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci.',
        'Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo.'
    );

insert into
    coop_connect.company (name, industry, location, description, criteria)
values
    (
        'Kuvalis-Bahringer',
        '12',
        'London',
        'Vestibulum sed magna at nunc commodo placerat. Praesent blandit.',
        'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo.'
    );

insert into
    coop_connect.company (name, industry, location, description, criteria)
values
    (
        'Schinner, Smitham and Gutkowski',
        '38',
        'New York City',
        'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.',
        'Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum.'
    );

insert into
    coop_connect.company (name, industry, location, description, criteria)
values
    (
        'Gerlach-Kris',
        '25',
        'Los Angeles',
        'Duis at velit eu est congue elementum. In hac habitasse platea dictumst.',
        'Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.'
    );

insert into
    coop_connect.company (name, industry, location, description, criteria)
values
    (
        'Keebler-Lynch',
        '3',
        'New York City',
        'Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna.',
        'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla.'
    );

insert into
    coop_connect.company (name, industry, location, description, criteria)
values
    (
        'Mueller-McDermott',
        '15',
        'Boston',
        'Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum.',
        'Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.'
    );

insert into
    coop_connect.company (name, industry, location, description, criteria)
values
    (
        'Bartoletti, Runolfsdottir and Stamm',
        '19',
        'New York City',
        'Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat.',
        'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum.'
    );

insert into
    coop_connect.company (name, industry, location, description, criteria)
values
    (
        'McDermott Group',
        '7',
        'Boston',
        'Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus.',
        'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus.'
    );

insert into
    coop_connect.company (name, industry, location, description, criteria)
values
    (
        'Bode and Sons',
        '5',
        'London',
        'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.',
        'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum.'
    );

insert into
    coop_connect.company (name, industry, location, description, criteria)
values
    (
        'Feest, Braun and Schaden',
        '1',
        'Boston',
        'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo.',
        'Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc.'
    );

insert into
    coop_connect.company (name, industry, location, description, criteria)
values
    (
        'Crona, Emmerich and Connelly',
        '37',
        'Boston',
        'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.',
        'Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis.'
    );

insert into
    coop_connect.company (name, industry, location, description, criteria)
values
    (
        'Reinger, Dicki and Lowe',
        '14',
        'Boston',
        'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit.',
        'Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.'
    );

insert into
    coop_connect.company (name, industry, location, description, criteria)
values
    (
        'Sipes Inc',
        '26',
        'New York City',
        'Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo.',
        'Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus.'
    );

insert into
    coop_connect.company (name, industry, location, description, criteria)
values
    (
        'Kirlin-Ankunding',
        '39',
        'Miami',
        'Aenean fermentum. Donec ut mauris eget massa tempor convallis.',
        'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.'
    );

insert into
    coop_connect.company (name, industry, location, description, criteria)
values
    (
        'Heller, Dare and Harvey',
        '18',
        'Chicago',
        'Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.',
        'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla.'
    );

insert into
    coop_connect.company (name, industry, location, description, criteria)
values
    (
        'Cole and Sons',
        '21',
        'Charlotte',
        'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.',
        'Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst.'
    );

insert into
    coop_connect.company (name, industry, location, description, criteria)
values
    (
        'Prohaska-Goyette',
        '6',
        'New York City',
        'Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc.',
        'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst.'
    );

insert into
    coop_connect.company (name, industry, location, description, criteria)
values
    (
        'Heidenreich-Daniel',
        '4',
        'Miami',
        'Phasellus in felis. Donec semper sapien a libero. Nam dui.',
        'Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices.'
    );

insert into
    coop_connect.company (name, industry, location, description, criteria)
values
    (
        'Paucek Inc',
        '2',
        'Toronto',
        'Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc.',
        'Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis.'
    );

insert into
    coop_connect.company (name, industry, location, description, criteria)
values
    (
        'Grady Group',
        '30',
        'Chicago',
        'Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.',
        'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum.'
    );

insert into
    coop_connect.company (name, industry, location, description, criteria)
values
    (
        'Davis, Jones and Bashirian',
        '27',
        'Miami',
        'Vivamus in felis eu sapien cursus vestibulum. Proin eu mi.',
        'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum.'
    );

insert into
    coop_connect.company (name, industry, location, description, criteria)
values
    (
        'Haag-Kassulke',
        '28',
        'New York City',
        'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.',
        'Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo.'
    );

insert into
    coop_connect.company (name, industry, location, description, criteria)
values
    (
        'Kunze-Herzog',
        '32',
        'Charlotte',
        'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.',
        'Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.'
    );

insert into
    coop_connect.company (name, industry, location, description, criteria)
values
    (
        'Wiegand, Hilpert and Larkin',
        '10',
        'Boston',
        'Duis at velit eu est congue elementum. In hac habitasse platea dictumst.',
        'Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.'
    );

insert into
    coop_connect.company (name, industry, location, description, criteria)
values
    (
        'Johnston Inc',
        '33',
        'London',
        'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.',
        'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti.'
    );

insert into
    coop_connect.company (name, industry, location, description, criteria)
values
    (
        'Cummings Group',
        '17',
        'Boston',
        'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam.',
        'Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.'
    );

insert into
    coop_connect.company (name, industry, location, description, criteria)
values
    (
        'Huel, Bernier and Goldner',
        '16',
        'London',
        'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum.',
        'Proin risus. Praesent lectus. Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio.'
    );

insert into
    coop_connect.company (name, industry, location, description, criteria)
values
    (
        'Durgan Group',
        '35',
        'London',
        'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.',
        'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet.'
    );

insert into
    coop_connect.company (name, industry, location, description, criteria)
values
    (
        'Bartoletti and Sons',
        '40',
        'Boston',
        'Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus.',
        'Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo.'
    );

insert into
    coop_connect.company (name, industry, location, description, criteria)
values
    (
        'Hilll-Dicki',
        '22',
        'Chicago',
        'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo.',
        'Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.'
    );

-- Skill table data
insert into
    coop_connect.skill (name)
values
    ('Taleo');

insert into
    coop_connect.skill (name)
values
    ('JDeveloper');

insert into
    coop_connect.skill (name)
values
    ('Information Security Awareness');

insert into
    coop_connect.skill (name)
values
    ('Active TS/SCI Clearance');

insert into
    coop_connect.skill (name)
values
    ('Accounting');

insert into
    coop_connect.skill (name)
values
    ('Appraisals');

insert into
    coop_connect.skill (name)
values
    ('Youth Programs');

insert into
    coop_connect.skill (name)
values
    ('Public Speaking');

insert into
    coop_connect.skill (name)
values
    ('DC-DC');

insert into
    coop_connect.skill (name)
values
    ('FSMS');

insert into
    coop_connect.skill (name)
values
    ('Critical thinking');

insert into
    coop_connect.skill (name)
values
    ('Electronics');

insert into
    coop_connect.skill (name)
values
    ('CVD');

insert into
    coop_connect.skill (name)
values
    ('CTQ');

insert into
    coop_connect.skill (name)
values
    ('Aerial Lifts');

insert into
    coop_connect.skill (name)
values
    ('DXX');

insert into
    coop_connect.skill (name)
values
    ('Photo Shoots');

insert into
    coop_connect.skill (name)
values
    ('Servers');

insert into
    coop_connect.skill (name)
values
    ('Verilog');

insert into
    coop_connect.skill (name)
values
    ('PTC Creo');

insert into
    coop_connect.skill (name)
values
    ('GWAS');

insert into
    coop_connect.skill (name)
values
    ('Taxes');

insert into
    coop_connect.skill (name)
values
    ('MRB');

insert into
    coop_connect.skill (name)
values
    ('Youth Engagement');

insert into
    coop_connect.skill (name)
values
    ('AAAHC');

insert into
    coop_connect.skill (name)
values
    ('Executive Coaching');

insert into
    coop_connect.skill (name)
values
    ('DDA compliance');

insert into
    coop_connect.skill (name)
values
    ('TWiki');

insert into
    coop_connect.skill (name)
values
    ('SQL');

insert into
    coop_connect.skill (name)
values
    ('Urban Regeneration');

insert into
    coop_connect.skill (name)
values
    ('Disability Insurance');

insert into
    coop_connect.skill (name)
values
    ('Digital Printing');

insert into
    coop_connect.skill (name)
values
    ('IT Audit');

insert into
    coop_connect.skill (name)
values
    ('UX Design');

insert into
    coop_connect.skill (name)
values
    ('UCP 600');

insert into
    coop_connect.skill (name)
values
    ('JUNOS');

insert into
    coop_connect.skill (name)
values
    ('Python');

insert into
    coop_connect.skill (name)
values
    ('DXL');

insert into
    coop_connect.skill (name)
values
    ('iLife');

insert into
    coop_connect.skill (name)
values
    ('Russian');

-- Hiring manager table data
insert into
    coop_connect.hiring_manager (name, position, email, company_id)
values
    (
        'Marjie Pucknell',
        'HR Director',
        'mpucknell0@virginia.edu',
        '33'
    );

insert into
    coop_connect.hiring_manager (name, position, email, company_id)
values
    (
        'Erminie Domek',
        'Talent Acquisition Manager',
        'edomek1@a8.net',
        '40'
    );

insert into
    coop_connect.hiring_manager (name, position, email, company_id)
values
    (
        'Nadiya Gommes',
        'Campus Recruiter',
        'ngommes2@adobe.com',
        '4'
    );

insert into
    coop_connect.hiring_manager (name, position, email, company_id)
values
    (
        'Boyce Dunkinson',
        'HR Director',
        'bdunkinson3@yandex.ru',
        '20'
    );

insert into
    coop_connect.hiring_manager (name, position, email, company_id)
values
    (
        'Paddie Maile',
        'HR Director',
        'pmaile4@blogs.com',
        '36'
    );

insert into
    coop_connect.hiring_manager (name, position, email, company_id)
values
    (
        'Maxie Crowche',
        'HR Director',
        'mcrowche5@deviantart.com',
        '30'
    );

insert into
    coop_connect.hiring_manager (name, position, email, company_id)
values
    (
        'Alwin Stopher',
        'Talent Acquisition Manager',
        'astopher6@liveinternet.ru',
        '28'
    );

insert into
    coop_connect.hiring_manager (name, position, email, company_id)
values
    (
        'Smitty Rolin',
        'HR Director',
        'srolin7@slashdot.org',
        '27'
    );

insert into
    coop_connect.hiring_manager (name, position, email, company_id)
values
    (
        'Cary Staveley',
        'HR Director',
        'cstaveley8@hubpages.com',
        '29'
    );

insert into
    coop_connect.hiring_manager (name, position, email, company_id)
values
    (
        'Anatola Bool',
        'HR Director',
        'abool9@blogspot.com',
        '26'
    );

insert into
    coop_connect.hiring_manager (name, position, email, company_id)
values
    (
        'Arri Usmar',
        'Talent Acquisition Manager',
        'ausmara@cisco.com',
        '12'
    );

insert into
    coop_connect.hiring_manager (name, position, email, company_id)
values
    (
        'Laurella Huckster',
        'Talent Acquisition Manager',
        'lhucksterb@lycos.com',
        '22'
    );

insert into
    coop_connect.hiring_manager (name, position, email, company_id)
values
    (
        'Allison Chessman',
        'HR Director',
        'gchessmanc@globo.com',
        '31'
    );

insert into
    coop_connect.hiring_manager (name, position, email, company_id)
values
    (
        'Sabrina Gillatt',
        'HR Director',
        'bgillattd@joomla.org',
        '17'
    );

insert into
    coop_connect.hiring_manager (name, position, email, company_id)
values
    (
        'Binnie Salman',
        'Talent Acquisition Manager',
        'bsalmane@rakuten.co.jp',
        '39'
    );

insert into
    coop_connect.hiring_manager (name, position, email, company_id)
values
    (
        'Benoite Ysson',
        'Talent Acquisition Manager',
        'byssonf@abc.net.au',
        '37'
    );

insert into
    coop_connect.hiring_manager (name, position, email, company_id)
values
    (
        'Prudence Buyers',
        'Campus Recruiter',
        'pbuyersg@xing.com',
        '34'
    );

insert into
    coop_connect.hiring_manager (name, position, email, company_id)
values
    (
        'Nonna Sarll',
        'HR Director',
        'nsarllh@admin.ch',
        '38'
    );

insert into
    coop_connect.hiring_manager (name, position, email, company_id)
values
    (
        'Vito Bootman',
        'Campus Recruiter',
        'vbootmani@sciencedirect.com',
        '35'
    );

insert into
    coop_connect.hiring_manager (name, position, email, company_id)
values
    (
        'Sarena Querree',
        'Talent Acquisition Manager',
        'squerreej@wordpress.com',
        '8'
    );

insert into
    coop_connect.hiring_manager (name, position, email, company_id)
values
    (
        'May Howlin',
        'HR Director',
        'mhowlink@google.ru',
        '6'
    );

insert into
    coop_connect.hiring_manager (name, position, email, company_id)
values
    (
        'Wynny Downs',
        'HR Director',
        'wdownsl@vistaprint.com',
        '7'
    );

insert into
    coop_connect.hiring_manager (name, position, email, company_id)
values
    (
        'Felicia Crossthwaite',
        'Campus Recruiter',
        'fcrossthwaitem@indiatimes.com',
        '2'
    );

insert into
    coop_connect.hiring_manager (name, position, email, company_id)
values
    (
        'Rhea Gossart',
        'Campus Recruiter',
        'rgossartn@mac.com',
        '14'
    );

insert into
    coop_connect.hiring_manager (name, position, email, company_id)
values
    (
        'Egon Woollends',
        'Campus Recruiter',
        'ewoollendso@cdbaby.com',
        '19'
    );

insert into
    coop_connect.hiring_manager (name, position, email, company_id)
values
    (
        'Nathaniel O'' Donohue',
        'HR Director',
        'nop@macromedia.com',
        '18'
    );

insert into
    coop_connect.hiring_manager (name, position, email, company_id)
values
    (
        'Aline Borless',
        'Talent Acquisition Manager',
        'aborlessq@mozilla.org',
        '23'
    );

insert into
    coop_connect.hiring_manager (name, position, email, company_id)
values
    (
        'Neila Boaler',
        'Talent Acquisition Manager',
        'nboalerr@twitpic.com',
        '5'
    );

insert into
    coop_connect.hiring_manager (name, position, email, company_id)
values
    (
        'Titos Phelips',
        'Campus Recruiter',
        'tphelipss@nationalgeographic.com',
        '21'
    );

insert into
    coop_connect.hiring_manager (name, position, email, company_id)
values
    (
        'Inez Vecard',
        'HR Director',
        'ivecardt@livejournal.com',
        '25'
    );

insert into
    coop_connect.hiring_manager (name, position, email, company_id)
values
    (
        'Sigismundo Farny',
        'HR Director',
        'sfarnyu@reverbnation.com',
        '11'
    );

insert into
    coop_connect.hiring_manager (name, position, email, company_id)
values
    (
        'Reilly Walklot',
        'HR Director',
        'rwalklotv@columbia.edu',
        '9'
    );

insert into
    coop_connect.hiring_manager (name, position, email, company_id)
values
    (
        'Trevor Siney',
        'Campus Recruiter',
        'tsineyw@craigslist.org',
        '15'
    );

insert into
    coop_connect.hiring_manager (name, position, email, company_id)
values
    (
        'Chad Winter',
        'HR Director',
        'cwinterx@amazon.de',
        '13'
    );

insert into
    coop_connect.hiring_manager (name, position, email, company_id)
values
    (
        'Shena Calvard',
        'Talent Acquisition Manager',
        'scalvardy@hp.com',
        '10'
    );

insert into
    coop_connect.hiring_manager (name, position, email, company_id)
values
    (
        'Glenden Tomaszek',
        'Talent Acquisition Manager',
        'gtomaszekz@house.gov',
        '3'
    );

insert into
    coop_connect.hiring_manager (name, position, email, company_id)
values
    (
        'Camila Asple',
        'Campus Recruiter',
        'casple10@wix.com',
        '32'
    );

insert into
    coop_connect.hiring_manager (name, position, email, company_id)
values
    (
        'Marysa Samper',
        'Talent Acquisition Manager',
        'msamper11@boston.com',
        '16'
    );

insert into
    coop_connect.hiring_manager (name, position, email, company_id)
values
    (
        'Trent Costa',
        'Campus Recruiter',
        'tcosta12@bbc.co.uk',
        '1'
    );

insert into
    coop_connect.hiring_manager (name, position, email, company_id)
values
    (
        'Dulcea Battram',
        'HR Director',
        'dbattram13@shutterfly.com',
        '24'
    );

-- Hiring manager co-op advisor bridge table data
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('1', '37');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('33', '15');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('26', '39');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('16', '24');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('23', '25');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('34', '32');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('22', '13');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('14', '7');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('2', '27');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('8', '29');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('31', '23');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('37', '12');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('10', '22');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('20', '20');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('28', '21');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('35', '26');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('19', '16');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('6', '3');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('32', '30');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('40', '31');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('18', '4');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('29', '35');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('25', '36');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('21', '33');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('36', '40');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('13', '34');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('27', '6');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('9', '19');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('38', '3');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('3', '1');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('39', '10');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('15', '17');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('30', '7');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('11', '14');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('4', '8');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('24', '5');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('5', '18');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('12', '28');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('7', '11');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('17', '38');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('3', '28');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('32', '29');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('35', '18');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('26', '31');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('17', '31');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('30', '23');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('2', '34');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('9', '22');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('40', '15');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('7', '17');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('34', '27');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('20', '33');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('8', '14');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('4', '20');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('13', '35');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('39', '6');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('24', '40');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('1', '5');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('21', '26');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('5', '16');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('15', '19');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('19', '10');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('23', '12');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('6', '2');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('14', '9');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('10', '36');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('27', '8');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('29', '37');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('36', '1');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('25', '21');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('18', '5');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('38', '7');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('22', '30');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('12', '25');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('16', '32');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('11', '11');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('31', '24');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('28', '3');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('33', '38');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('37', '13');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('22', '37');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('20', '15');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('34', '5');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('32', '31');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('38', '26');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('7', '5');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('14', '40');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('25', '13');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('12', '21');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('18', '14');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('27', '2');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('35', '17');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('40', '10');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('4', '34');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('36', '33');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('29', '6');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('17', '18');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('21', '19');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('39', '32');
-- insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('30', '22');
-- Job position table data
insert into
    coop_connect.job_position (
        title,
        description,
        still_accepting,
        num_applicants,
        location,
        desired_skills,
        targeted_majors,
        company_id
    )
values
    (
        'Database Administrator II',
        'Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis.',
        false,
        27,
        'London',
        'Djembe',
        'Suspendisse ornare consequat lectus.',
        '38'
    );

insert into
    coop_connect.job_position (
        title,
        description,
        still_accepting,
        num_applicants,
        location,
        desired_skills,
        targeted_majors,
        company_id
    )
values
    (
        'Web Designer IV',
        'Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti.',
        true,
        97,
        'London',
        'BDC',
        'In hac habitasse platea dictumst.',
        '10'
    );

insert into
    coop_connect.job_position (
        title,
        description,
        still_accepting,
        num_applicants,
        location,
        desired_skills,
        targeted_majors,
        company_id
    )
values
    (
        'Nurse Practicioner',
        'In eleifend quam a odio. In hac habitasse platea dictumst.',
        true,
        57,
        'Chicago',
        'RPT',
        'Nulla facilisi.',
        '34'
    );

insert into
    coop_connect.job_position (
        title,
        description,
        still_accepting,
        num_applicants,
        location,
        desired_skills,
        targeted_majors,
        company_id
    )
values
    (
        'Programmer Analyst IV',
        'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.',
        true,
        13,
        'Chicago',
        'HTML5',
        'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo.',
        '36'
    );

insert into
    coop_connect.job_position (
        title,
        description,
        still_accepting,
        num_applicants,
        location,
        desired_skills,
        targeted_majors,
        company_id
    )
values
    (
        'Help Desk Technician',
        'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.',
        false,
        22,
        'Charlotte',
        'VTK',
        'Quisque id justo sit amet sapien dignissim vestibulum.',
        '9'
    );

insert into
    coop_connect.job_position (
        title,
        description,
        still_accepting,
        num_applicants,
        location,
        desired_skills,
        targeted_majors,
        company_id
    )
values
    (
        'Senior Cost Accountant',
        'Integer a nibh. In quis justo.',
        false,
        3,
        'New York City',
        'Programming',
        'Nullam varius.',
        '25'
    );

insert into
    coop_connect.job_position (
        title,
        description,
        still_accepting,
        num_applicants,
        location,
        desired_skills,
        targeted_majors,
        company_id
    )
values
    (
        'Product Engineer',
        'Aliquam erat volutpat. In congue. Etiam justo.',
        true,
        19,
        'Toronto',
        'Water Resources',
        'Duis aliquam convallis nunc.',
        '17'
    );

insert into
    coop_connect.job_position (
        title,
        description,
        still_accepting,
        num_applicants,
        location,
        desired_skills,
        targeted_majors,
        company_id
    )
values
    (
        'Dental Hygienist',
        'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue.',
        true,
        91,
        'Chicago',
        'Human Resource Planning',
        'Nulla ac enim.',
        '16'
    );

insert into
    coop_connect.job_position (
        title,
        description,
        still_accepting,
        num_applicants,
        location,
        desired_skills,
        targeted_majors,
        company_id
    )
values
    (
        'Dental Hygienist',
        'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem.',
        true,
        74,
        'Miami',
        'MKS Integrity',
        'In eleifend quam a odio.',
        '40'
    );

insert into
    coop_connect.job_position (
        title,
        description,
        still_accepting,
        num_applicants,
        location,
        desired_skills,
        targeted_majors,
        company_id
    )
values
    (
        'Sales Associate',
        'In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices.',
        true,
        66,
        'Boston',
        'TTCN',
        'Cras non velit nec nisi vulputate nonummy.',
        '11'
    );

insert into
    coop_connect.job_position (
        title,
        description,
        still_accepting,
        num_applicants,
        location,
        desired_skills,
        targeted_majors,
        company_id
    )
values
    (
        'Senior Editor',
        'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl.',
        false,
        48,
        'New York City',
        'Operational Planning',
        'Nulla facilisi.',
        '23'
    );

insert into
    coop_connect.job_position (
        title,
        description,
        still_accepting,
        num_applicants,
        location,
        desired_skills,
        targeted_majors,
        company_id
    )
values
    (
        'Professor',
        'Duis mattis egestas metus. Aenean fermentum.',
        false,
        73,
        'Miami',
        'Lumion',
        'Aenean sit amet justo.',
        '1'
    );

insert into
    coop_connect.job_position (
        title,
        description,
        still_accepting,
        num_applicants,
        location,
        desired_skills,
        targeted_majors,
        company_id
    )
values
    (
        'Nuclear Power Engineer',
        'Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia.',
        true,
        36,
        'New York City',
        'MCSA',
        'Sed accumsan felis.',
        '20'
    );

insert into
    coop_connect.job_position (
        title,
        description,
        still_accepting,
        num_applicants,
        location,
        desired_skills,
        targeted_majors,
        company_id
    )
values
    (
        'VP Quality Control',
        'Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.',
        false,
        98,
        'Toronto',
        'VCT',
        'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est.',
        '39'
    );

insert into
    coop_connect.job_position (
        title,
        description,
        still_accepting,
        num_applicants,
        location,
        desired_skills,
        targeted_majors,
        company_id
    )
values
    (
        'Project Manager',
        'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.',
        false,
        98,
        'Toronto',
        'Geometric Dimensioning &amp; Tolerancing',
        'Nullam sit amet turpis elementum ligula vehicula consequat.',
        '14'
    );

insert into
    coop_connect.job_position (
        title,
        description,
        still_accepting,
        num_applicants,
        location,
        desired_skills,
        targeted_majors,
        company_id
    )
values
    (
        'Desktop Support Technician',
        'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.',
        true,
        35,
        'Boston',
        'Wholesale Operations',
        'Nulla ac enim.',
        '29'
    );

insert into
    coop_connect.job_position (
        title,
        description,
        still_accepting,
        num_applicants,
        location,
        desired_skills,
        targeted_majors,
        company_id
    )
values
    (
        'Web Developer I',
        'Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor.',
        true,
        72,
        'Los Angeles',
        'HDV',
        'Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl.',
        '35'
    );

insert into
    coop_connect.job_position (
        title,
        description,
        still_accepting,
        num_applicants,
        location,
        desired_skills,
        targeted_majors,
        company_id
    )
values
    (
        'Help Desk Technician',
        'In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy.',
        true,
        47,
        'Chicago',
        'Abstracting',
        'Sed ante.',
        '32'
    );

insert into
    coop_connect.job_position (
        title,
        description,
        still_accepting,
        num_applicants,
        location,
        desired_skills,
        targeted_majors,
        company_id
    )
values
    (
        'GIS Technical Architect',
        'Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis.',
        true,
        13,
        'New York City',
        'Industrial Ethernet',
        'Donec ut mauris eget massa tempor convallis.',
        '18'
    );

insert into
    coop_connect.job_position (
        title,
        description,
        still_accepting,
        num_applicants,
        location,
        desired_skills,
        targeted_majors,
        company_id
    )
values
    (
        'Civil Engineer',
        'In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem.',
        false,
        90,
        'Boston',
        'Cluster',
        'Nulla suscipit ligula in lacus.',
        '4'
    );

insert into
    coop_connect.job_position (
        title,
        description,
        still_accepting,
        num_applicants,
        location,
        desired_skills,
        targeted_majors,
        company_id
    )
values
    (
        'Financial Advisor',
        'Proin at turpis a pede posuere nonummy. Integer non velit.',
        false,
        40,
        'New York City',
        'Award Winner',
        'Donec ut dolor.',
        '2'
    );

insert into
    coop_connect.job_position (
        title,
        description,
        still_accepting,
        num_applicants,
        location,
        desired_skills,
        targeted_majors,
        company_id
    )
values
    (
        'Marketing Manager',
        'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.',
        true,
        43,
        'Los Angeles',
        'RCP',
        'Phasellus id sapien in sapien iaculis congue.',
        '28'
    );

insert into
    coop_connect.job_position (
        title,
        description,
        still_accepting,
        num_applicants,
        location,
        desired_skills,
        targeted_majors,
        company_id
    )
values
    (
        'Administrative Assistant III',
        'Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula.',
        true,
        49,
        'Toronto',
        'JCAHO',
        'Nulla nisl.',
        '7'
    );

insert into
    coop_connect.job_position (
        title,
        description,
        still_accepting,
        num_applicants,
        location,
        desired_skills,
        targeted_majors,
        company_id
    )
values
    (
        'Web Developer II',
        'In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat.',
        true,
        10,
        'New York City',
        'LN',
        'Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.',
        '31'
    );

insert into
    coop_connect.job_position (
        title,
        description,
        still_accepting,
        num_applicants,
        location,
        desired_skills,
        targeted_majors,
        company_id
    )
values
    (
        'Research Associate',
        'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.',
        true,
        54,
        'Boston',
        'Sybase IQ',
        'Suspendisse potenti.',
        '27'
    );

insert into
    coop_connect.job_position (
        title,
        description,
        still_accepting,
        num_applicants,
        location,
        desired_skills,
        targeted_majors,
        company_id
    )
values
    (
        'Food Chemist',
        'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue.',
        true,
        60,
        'New York City',
        'nCloth',
        'Vestibulum ac est lacinia nisi venenatis tristique.',
        '8'
    );

insert into
    coop_connect.job_position (
        title,
        description,
        still_accepting,
        num_applicants,
        location,
        desired_skills,
        targeted_majors,
        company_id
    )
values
    (
        'Marketing Assistant',
        'Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.',
        false,
        55,
        'Miami',
        'Power Systems',
        'Cras non velit nec nisi vulputate nonummy.',
        '22'
    );

insert into
    coop_connect.job_position (
        title,
        description,
        still_accepting,
        num_applicants,
        location,
        desired_skills,
        targeted_majors,
        company_id
    )
values
    (
        'Payment Adjustment Coordinator',
        'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.',
        true,
        65,
        'Boston',
        'CFII',
        'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis.',
        '5'
    );

insert into
    coop_connect.job_position (
        title,
        description,
        still_accepting,
        num_applicants,
        location,
        desired_skills,
        targeted_majors,
        company_id
    )
values
    (
        'Senior Sales Associate',
        'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.',
        false,
        76,
        'Toronto',
        'LDAP Administration',
        'Etiam justo.',
        '15'
    );

insert into
    coop_connect.job_position (
        title,
        description,
        still_accepting,
        num_applicants,
        location,
        desired_skills,
        targeted_majors,
        company_id
    )
values
    (
        'Recruiting Manager',
        'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam.',
        true,
        41,
        'Chicago',
        'BSP',
        'Nulla ut erat id mauris vulputate elementum.',
        '13'
    );

insert into
    coop_connect.job_position (
        title,
        description,
        still_accepting,
        num_applicants,
        location,
        desired_skills,
        targeted_majors,
        company_id
    )
values
    (
        'VP Accounting',
        'Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.',
        true,
        97,
        'Charlotte',
        'Utilization Management',
        'Duis consequat dui nec nisi volutpat eleifend.',
        '12'
    );

insert into
    coop_connect.job_position (
        title,
        description,
        still_accepting,
        num_applicants,
        location,
        desired_skills,
        targeted_majors,
        company_id
    )
values
    (
        'Web Designer IV',
        'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum.',
        true,
        83,
        'Charlotte',
        'FP7',
        'Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.',
        '6'
    );

insert into
    coop_connect.job_position (
        title,
        description,
        still_accepting,
        num_applicants,
        location,
        desired_skills,
        targeted_majors,
        company_id
    )
values
    (
        'Nuclear Power Engineer',
        'Duis at velit eu est congue elementum. In hac habitasse platea dictumst.',
        true,
        28,
        'Boston',
        'Social Media Marketing',
        'Donec vitae nisi.',
        '24'
    );

insert into
    coop_connect.job_position (
        title,
        description,
        still_accepting,
        num_applicants,
        location,
        desired_skills,
        targeted_majors,
        company_id
    )
values
    (
        'Senior Cost Accountant',
        'Sed accumsan felis. Ut at dolor quis odio consequat varius.',
        true,
        100,
        'Boston',
        'IAR',
        'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc.',
        '26'
    );

insert into
    coop_connect.job_position (
        title,
        description,
        still_accepting,
        num_applicants,
        location,
        desired_skills,
        targeted_majors,
        company_id
    )
values
    (
        'Payment Adjustment Coordinator',
        'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo.',
        true,
        25,
        'Chicago',
        'Report Writing',
        'Maecenas pulvinar lobortis est.',
        '19'
    );

insert into
    coop_connect.job_position (
        title,
        description,
        still_accepting,
        num_applicants,
        location,
        desired_skills,
        targeted_majors,
        company_id
    )
values
    (
        'Design Engineer',
        'Duis bibendum. Morbi non quam nec dui luctus rutrum.',
        true,
        11,
        'Miami',
        'EEPROM',
        'Suspendisse accumsan tortor quis turpis.',
        '33'
    );

insert into
    coop_connect.job_position (
        title,
        description,
        still_accepting,
        num_applicants,
        location,
        desired_skills,
        targeted_majors,
        company_id
    )
values
    (
        'Operator',
        'Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum.',
        true,
        77,
        'Boston',
        'User Interface Design',
        'Aenean fermentum.',
        '30'
    );

insert into
    coop_connect.job_position (
        title,
        description,
        still_accepting,
        num_applicants,
        location,
        desired_skills,
        targeted_majors,
        company_id
    )
values
    (
        'VP Marketing',
        'Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla.',
        false,
        56,
        'Boston',
        'IRI',
        'Duis consequat dui nec nisi volutpat eleifend.',
        '37'
    );

insert into
    coop_connect.job_position (
        title,
        description,
        still_accepting,
        num_applicants,
        location,
        desired_skills,
        targeted_majors,
        company_id
    )
values
    (
        'Pharmacist',
        'Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.',
        false,
        96,
        'Los Angeles',
        'NRF',
        'Praesent blandit lacinia erat.',
        '21'
    );

insert into
    coop_connect.job_position (
        title,
        description,
        still_accepting,
        num_applicants,
        location,
        desired_skills,
        targeted_majors,
        company_id
    )
values
    (
        'Physical Therapy Assistant',
        'In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.',
        false,
        33,
        'Boston',
        'Zines',
        'In hac habitasse platea dictumst.',
        '3'
    );

-- Student table data
-- insert into coop_connect.student (name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values ('Sisely Duley', 'sduley0@hatena.ne.jp', 3.33, 1, 2028, '36', '28', '33');
-- insert into coop_connect.student (name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values ('Chen Chalfont', 'cchalfont1@foxnews.com', 2.04, 2, 2026, '2', '6', '28');
-- insert into coop_connect.student (name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values ('Justina McQueen', 'jmcqueen2@bigcartel.com', 1.95, 3, 2028, '9', '5', '2');
-- insert into coop_connect.student (name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values ('Gertie Roskell', 'groskell3@fotki.com', 3.64, 4, 2026, '12', '15', '1');
-- insert into coop_connect.student (name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values ('Max Banbury', 'mbanbury4@sourceforge.net', 1.65, 5, 2027, '30', '1', '13');
-- insert into coop_connect.student (name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values ('Sonnie Harlin', 'sharlin5@soup.io', 3.75, 6, 2027, '6', '22', '35');
-- insert into coop_connect.student (name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values ('Lind Pally', 'lpally6@examiner.com', 3.5, 7, 2025, '18', '36', '37');
-- insert into coop_connect.student (name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values ('Gusty Murty', 'gmurty7@meetup.com', 2.7, 8, 2025, '19', '13', '19');
-- insert into coop_connect.student (name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values ('Minetta Neward', 'mneward8@163.com', 3.23, 9, 2027, '3', '37', '17');
-- insert into coop_connect.student (name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values ('Josy Groucutt', 'jgroucutt9@blog.com', 2.3, 10, 2026, '29', '38', '8');
-- insert into coop_connect.student (name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values ('Jillane Tottle', 'jtottlea@aboutads.info', 3.7, 11, 2026, '37', '33', '26');
-- insert into coop_connect.student (name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values ('Virgina Neal', 'vnealb@oakley.com', 1.99, 12, 2027, '16', '14', '11');
-- insert into coop_connect.student (name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values ('Stevena Limpertz', 'slimpertzc@imdb.com', 3.78, 13, 2028, '1', '26', '4');
-- insert into coop_connect.student (name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values ('Alon Reignould', 'areignouldd@so-net.ne.jp', 2.55, 14, 2025, '11', '34', '38');
-- insert into coop_connect.student (name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values ('Ceil Bruneau', 'cbruneaue@newyorker.com', 1.19, 15, 2025, '40', '12', '21');
-- insert into coop_connect.student (name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values ('Yancey Eastham', 'yeasthamf@networksolutions.com', 1.37, 16, 2025, '24', '23', '29');
-- insert into coop_connect.student (name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values ('Dore Twiname', 'dtwinameg@com.com', 3.93, 17, 2025, '28', '8', '24');
-- insert into coop_connect.student (name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values ('Jakie Breslauer', 'jbreslauerh@amazon.co.jp', 2.17, 18, 2025, '4', '2', '14');
-- insert into coop_connect.student (name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values ('Calv Sullens', 'csullensi@alibaba.com', 3.53, 19, 2028, '33', '39', '39');
-- insert into coop_connect.student (name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values ('Tallulah Peasee', 'tpeaseej@csmonitor.com', 3.7, 20, 2028, '14', '18', '30');
-- insert into coop_connect.student (name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values ('Granthem Harkins', 'gharkinsk@bloglines.com', 1.57, 21, 2025, '22', '17', '27');
-- insert into coop_connect.student (name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values ('Brigitta Audus', 'baudusl@howstuffworks.com', 2.88, 22, 2026, '26', '9', '6');
-- insert into coop_connect.student (name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values ('Rozalie Koomar', 'rkoomarm@lulu.com', 2.94, 23, 2027, '10', '20', '7');
-- insert into coop_connect.student (name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values ('Lynde Smidmore', 'lsmidmoren@bloomberg.com', 2.14, 24, 2027, '35', '19', '34');
-- insert into coop_connect.student (name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values ('Madlen Shrimptone', 'mshrimptoneo@merriam-webster.com', 2.27, 25, 2026, '38', '30', '9');
-- insert into coop_connect.student (name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values ('Vittoria Jozsa', 'vjozsap@zimbio.com', 3.94, 26, 2027, '15', '35', '32');
-- insert into coop_connect.student (name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values ('Sheena Bussetti', 'sbussettiq@nhs.uk', 3.85, 27, 2028, '21', '40', '16');
-- insert into coop_connect.student (name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values ('Jewelle Hortop', 'jhortopr@shareasale.com', 3.8, 28, 2025, '25', '32', '31');
-- insert into coop_connect.student (name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values ('Joseph Daveren', 'jdaverens@delicious.com', 3.98, 29, 2028, '23', '16', '23');
-- insert into coop_connect.student (name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values ('Lev Gomery', 'lgomeryt@pbs.org', 2.73, 30, 2025, '39', '3', '25');
-- insert into coop_connect.student (name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values ('Tommie Sparks', 'tsparksu@plala.or.jp', 1.41, 31, 2028, '31', '29', '12');
-- insert into coop_connect.student (name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values ('Ephraim Benettelli', 'ebenettelliv@samsung.com', 3.72, 32, 2028, '8', '10', '15');
-- insert into coop_connect.student (name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values ('Maisey Kahn', 'mkahnw@businessweek.com', 2.34, 33, 2028, '5', '31', '36');
-- insert into coop_connect.student (name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values ('Enid Lavalde', 'elavaldex@yellowbook.com', 1.46, 34, 2026, '20', '24', '22');
-- insert into coop_connect.student (name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values ('Lothario Duffin', 'lduffiny@canalblog.com', 2.98, 35, 2026, '13', '21', '10');
-- insert into coop_connect.student (name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values ('Oralle Urey', 'oureyz@cbc.ca', 1.58, 36, 2025, '27', '4', '3');
-- insert into coop_connect.student (name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values ('Kari Leftbridge', 'kleftbridge10@photobucket.com', 2.56, 37, 2027, '32', '27', '18');
-- insert into coop_connect.student (name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values ('Tedra Broy', 'tbroy11@disqus.com', 1.45, 38, 2026, '34', '11', '5');
-- insert into coop_connect.student (name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values ('Ramonda Mincini', 'rmincini12@alibaba.com', 3.23, 39, 2025, '7', '25', '40');
-- insert into coop_connect.student (name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values ('Bibi Branson', 'bbranson13@goodreads.com', 2.27, 40, 2025, '17', '7', '20');
-- -- Bridge table data
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('38', '19');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('35', '29');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('40', '13');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('38', '15');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('35', '28');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('40', '19');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('3', '12');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('30', '30');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('5', '1');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('14', '13');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('10', '23');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('23', '27');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('31', '8');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('39', '37');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('37', '25');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('15', '7');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('21', '17');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('28', '20');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('7', '21');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('17', '14');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('29', '34');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('16', '6');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('6', '3');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('32', '32');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('27', '4');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('20', '9');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('26', '24');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('11', '40');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('4', '35');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('9', '33');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('34', '39');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('8', '2');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('25', '38');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('2', '16');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('13', '22');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('24', '29');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('22', '31');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('18', '26');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('19', '10');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('1', '36');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('33', '5');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('36', '11');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('12', '18');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('7', '37');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('35', '1');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('39', '35');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('19', '30');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('25', '12');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('15', '33');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('13', '24');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('31', '26');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('3', '5');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('37', '16');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('9', '40');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('5', '13');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('27', '3');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('10', '17');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('40', '32');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('32', '21');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('4', '4');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('20', '6');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('17', '36');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('8', '29');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('36', '25');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('21', '8');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('18', '20');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('30', '27');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('14', '38');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('26', '23');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('6', '2');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('22', '7');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('24', '14');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('2', '10');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('23', '22');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('29', '18');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('16', '9');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('11', '39');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('33', '34');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('12', '28');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('34', '31');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('1', '19');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('28', '11');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('10', '22');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('27', '26');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('3', '14');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('8', '13');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('26', '34');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('14', '27');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('38', '18');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('18', '37');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('25', '7');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('5', '4');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('23', '36');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('1', '24');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('4', '23');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('7', '32');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('15', '9');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('11', '11');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('32', '2');
-- insert into coop_connect.student_past_job (student_id, job_position_id) values ('12', '39');
-- Review table data
insert into
    coop_connect.review (rating, review, student_id, job_position_id)
values
    (1.3, 'Cras pellentesque volutpat dui.', '1', '2');

insert into
    coop_connect.review (rating, review, student_id, job_position_id)
values
    (
        2.4,
        'Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum.',
        '1',
        '1'
    );

insert into
    coop_connect.review (rating, review, student_id, job_position_id)
values
    (
        4.4,
        'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla.',
        '27',
        '9'
    );
insert into
    coop_connect.review (rating, review, student_id, job_position_id)
values
    (
        3.6,
        'Praesent id massa id nisl venenatis lacinia.',
        '22',
        '32'
    );
insert into
    coop_connect.review (rating, review, student_id, job_position_id)
values
    (
        3.1,
        'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.',
        '18',
        '14'
    );
insert into
    coop_connect.review (rating, review, student_id, job_position_id)
values
    (2.5, 'Vivamus tortor.', '8', '38');
insert into
    coop_connect.review (rating, review, student_id, job_position_id)
values
    (3.1, 'Suspendisse potenti.', '14', '2');
insert into
    coop_connect.review (rating, review, student_id, job_position_id)
values
    (1.2, 'Integer a nibh. In quis justo.', '39', '13');
insert into
    coop_connect.review (rating, review, student_id, job_position_id)
values
    (
        4.0,
        'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti.',
        '19',
        '8'
    );
insert into
    coop_connect.review (rating, review, student_id, job_position_id)
values
    (
        3.3,
        'Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat.',
        '13',
        '30'
    );
insert into
    coop_connect.review (rating, review, student_id, job_position_id)
values
    (
        1.6,
        'Cras in purus eu magna vulputate luctus.',
        '33',
        '15'
    );
insert into
    coop_connect.review (rating, review, student_id, job_position_id)
values
    (
        4.0,
        'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit.',
        '38',
        '27'
    );
insert into
    coop_connect.review (rating, review, student_id, job_position_id)
values
    (
        1.4,
        'Nullam sit amet turpis elementum ligula vehicula consequat.',
        '34',
        '35'
    );
insert into
    coop_connect.review (rating, review, student_id, job_position_id)
values
    (3.9, 'In sagittis dui vel nisl.', '26', '29');
insert into
    coop_connect.review (rating, review, student_id, job_position_id)
values
    (
        3.9,
        'Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.',
        '12',
        '11'
    );
insert into
    coop_connect.review (rating, review, student_id, job_position_id)
values
    (
        2.0,
        'Sed vel enim sit amet nunc viverra dapibus.',
        '35',
        '39'
    );
insert into
    coop_connect.review (rating, review, student_id, job_position_id)
values
    (
        2.1,
        'In congue. Etiam justo. Etiam pretium iaculis justo.',
        '7',
        '4'
    );
insert into
    coop_connect.review (rating, review, student_id, job_position_id)
values
    (
        4.4,
        'Mauris lacinia sapien quis libero.',
        '31',
        '40'
    );
insert into
    coop_connect.review (rating, review, student_id, job_position_id)
values
    (
        1.9,
        'Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.',
        '5',
        '37'
    );
insert into
    coop_connect.review (rating, review, student_id, job_position_id)
values
    (
        1.0,
        'Morbi a ipsum. Integer a nibh. In quis justo.',
        '36',
        '3'
    );
insert into
    coop_connect.review (rating, review, student_id, job_position_id)
values
    (
        1.8,
        'Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum.',
        '25',
        '34'
    );
insert into
    coop_connect.review (rating, review, student_id, job_position_id)
values
    (
        3.2,
        'Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue.',
        '15',
        '20'
    );
insert into
    coop_connect.review (rating, review, student_id, job_position_id)
values
    (3.4, 'Sed sagittis.', '17', '1');
insert into
    coop_connect.review (rating, review, student_id, job_position_id)
values
    (
        3.0,
        'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis.',
        '6',
        '22'
    );
insert into
    coop_connect.review (rating, review, student_id, job_position_id)
values
    (
        4.8,
        'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.',
        '1',
        '25'
    );
insert into
    coop_connect.review (rating, review, student_id, job_position_id)
values
    (
        4.1,
        'Phasellus sit amet erat. Nulla tempus.',
        '11',
        '12'
    );
insert into
    coop_connect.review (rating, review, student_id, job_position_id)
values
    (
        3.9,
        'Donec ut mauris eget massa tempor convallis.',
        '10',
        '31'
    );
insert into
    coop_connect.review (rating, review, student_id, job_position_id)
values
    (
        2.6,
        'Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien.',
        '4',
        '6'
    );
insert into
    coop_connect.review (rating, review, student_id, job_position_id)
values
    (
        1.3,
        'In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl.',
        '20',
        '5'
    );
insert into
    coop_connect.review (rating, review, student_id, job_position_id)
values
    (
        3.5,
        'Curabitur at ipsum ac tellus semper interdum.',
        '40',
        '24'
    );
insert into
    coop_connect.review (rating, review, student_id, job_position_id)
values
    (
        2.5,
        'Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.',
        '21',
        '28'
    );
insert into
    coop_connect.review (rating, review, student_id, job_position_id)
values
    (
        3.4,
        'Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam.',
        '29',
        '21'
    );
insert into
    coop_connect.review (rating, review, student_id, job_position_id)
values
    (
        2.8,
        'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla.',
        '3',
        '19'
    );
insert into
    coop_connect.review (rating, review, student_id, job_position_id)
values
    (
        4.6,
        'Integer tincidunt ante vel ipsum.',
        '16',
        '26'
    );
insert into
    coop_connect.review (rating, review, student_id, job_position_id)
values
    (
        2.5,
        'Pellentesque ultrices mattis odio.',
        '23',
        '23'
    );
insert into
    coop_connect.review (rating, review, student_id, job_position_id)
values
    (
        3.9,
        'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.',
        '30',
        '36'
    );
insert into
    coop_connect.review (rating, review, student_id, job_position_id)
values
    (
        2.3,
        'Quisque id justo sit amet sapien dignissim vestibulum.',
        '24',
        '17'
    );
insert into
    coop_connect.review (rating, review, student_id, job_position_id)
values
    (2.6, 'Donec semper sapien a libero.', '2', '18');
insert into
    coop_connect.review (rating, review, student_id, job_position_id)
values
    (
        4.1,
        'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc.',
        '32',
        '10'
    );
insert into
    coop_connect.review (rating, review, student_id, job_position_id)
values
    (
        4.7,
        'In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.',
        '9',
        '7'
    );
-- Interview question table data
insert into
    coop_connect.interview_question (question, job_position_id, author_id)
values
    (
        'Donec dapibus. Duis at velit eu est congue elementum.',
        '38',
        '40'
    );
insert into
    coop_connect.interview_question (question, job_position_id, author_id)
values
    (
        'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue.',
        '35',
        '12'
    );
insert into
    coop_connect.interview_question (question, job_position_id, author_id)
values
    (
        'Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci.',
        '31',
        '4'
    );
insert into
    coop_connect.interview_question (question, job_position_id, author_id)
values
    ('Quisque ut erat.', '29', '22');
insert into
    coop_connect.interview_question (question, job_position_id, author_id)
values
    (
        'Ut tellus. Nulla ut erat id mauris vulputate elementum.',
        '6',
        '33'
    );
insert into
    coop_connect.interview_question (question, job_position_id, author_id)
values
    (
        'Duis bibendum. Morbi non quam nec dui luctus rutrum.',
        '11',
        '18'
    );
insert into
    coop_connect.interview_question (question, job_position_id, author_id)
values
    (
        'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien.',
        '20',
        '3'
    );
insert into
    coop_connect.interview_question (question, job_position_id, author_id)
values
    (
        'Duis at velit eu est congue elementum. In hac habitasse platea dictumst.',
        '8',
        '20'
    );
insert into
    coop_connect.interview_question (question, job_position_id, author_id)
values
    ('Nullam porttitor lacus at turpis.', '40', '38');
insert into
    coop_connect.interview_question (question, job_position_id, author_id)
values
    (
        'Maecenas ut massa quis augue luctus tincidunt.',
        '33',
        '32'
    );
insert into
    coop_connect.interview_question (question, job_position_id, author_id)
values
    (
        'Proin interdum mauris non ligula pellentesque ultrices.',
        '37',
        '14'
    );
insert into
    coop_connect.interview_question (question, job_position_id, author_id)
values
    ('Praesent blandit. Nam nulla.', '24', '9');
insert into
    coop_connect.interview_question (question, job_position_id, author_id)
values
    (
        'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi.',
        '34',
        '25'
    );
insert into
    coop_connect.interview_question (question, job_position_id, author_id)
values
    (
        'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.',
        '25',
        '13'
    );
insert into
    coop_connect.interview_question (question, job_position_id, author_id)
values
    (
        'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo.',
        '28',
        '35'
    );
insert into
    coop_connect.interview_question (question, job_position_id, author_id)
values
    (
        'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy.',
        '32',
        '30'
    );
insert into
    coop_connect.interview_question (question, job_position_id, author_id)
values
    ('Integer ac leo.', '39', '2');
insert into
    coop_connect.interview_question (question, job_position_id, author_id)
values
    ('Mauris sit amet eros.', '26', '5');
insert into
    coop_connect.interview_question (question, job_position_id, author_id)
values
    ('Sed ante. Vivamus tortor.', '27', '8');
insert into
    coop_connect.interview_question (question, job_position_id, author_id)
values
    (
        'Nullam molestie nibh in lectus. Pellentesque at nulla.',
        '22',
        '6'
    );
insert into
    coop_connect.interview_question (question, job_position_id, author_id)
values
    ('Donec semper sapien a libero.', '10', '21');
insert into
    coop_connect.interview_question (question, job_position_id, author_id)
values
    (
        'Nulla justo. Aliquam quis turpis eget elit sodales scelerisque.',
        '19',
        '15'
    );
insert into
    coop_connect.interview_question (question, job_position_id, author_id)
values
    ('In hac habitasse platea dictumst.', '12', '7');
insert into
    coop_connect.interview_question (question, job_position_id, author_id)
values
    ('Duis aliquam convallis nunc.', '21', '27');
insert into
    coop_connect.interview_question (question, job_position_id, author_id)
values
    ('Aliquam erat volutpat.', '7', '34');
insert into
    coop_connect.interview_question (question, job_position_id, author_id)
values
    (
        'Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.',
        '14',
        '24'
    );
insert into
    coop_connect.interview_question (question, job_position_id, author_id)
values
    (
        'Nullam molestie nibh in lectus. Pellentesque at nulla.',
        '30',
        '17'
    );
insert into
    coop_connect.interview_question (question, job_position_id, author_id)
values
    (
        'Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla.',
        '17',
        '29'
    );
insert into
    coop_connect.interview_question (question, job_position_id, author_id)
values
    (
        'In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt.',
        '23',
        '37'
    );
insert into
    coop_connect.interview_question (question, job_position_id, author_id)
values
    ('In eleifend quam a odio.', '5', '36');
insert into
    coop_connect.interview_question (question, job_position_id, author_id)
values
    (
        'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo.',
        '15',
        '26'
    );
insert into
    coop_connect.interview_question (question, job_position_id, author_id)
values
    (
        'Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.',
        '3',
        '23'
    );
insert into
    coop_connect.interview_question (question, job_position_id, author_id)
values
    (
        'In sagittis dui vel nisl. Duis ac nibh.',
        '4',
        '1'
    );
insert into
    coop_connect.interview_question (question, job_position_id, author_id)
values
    ('Praesent blandit lacinia erat.', '18', '11');
insert into
    coop_connect.interview_question (question, job_position_id, author_id)
values
    (
        'Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam. Nam tristique tortor eu pede.',
        '13',
        '10'
    );
insert into
    coop_connect.interview_question (question, job_position_id, author_id)
values
    ('Sed ante.', '2', '16');
insert into
    coop_connect.interview_question (question, job_position_id, author_id)
values
    ('In sagittis dui vel nisl.', '9', '31');
insert into
    coop_connect.interview_question (question, job_position_id, author_id)
values
    ('Sed ante.', '1', '39');
insert into
    coop_connect.interview_question (question, job_position_id, author_id)
values
    (
        'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien.',
        '16',
        '19'
    );
insert into
    coop_connect.interview_question (question, job_position_id, author_id)
values
    ('Integer a nibh.', '36', '28');
-- Application table data
insert into coop_connect.application (applicant_id, job_position_id, status) values ('5', '10', 'Accepted');
insert into coop_connect.application (applicant_id, job_position_id, status) values ('11', '31', 'Rejected');
insert into coop_connect.application (applicant_id, job_position_id, status) values ('26', '13', 'Pending');
insert into coop_connect.application (applicant_id, job_position_id, status) values ('25', '15', 'Rejected');
insert into coop_connect.application (applicant_id, job_position_id, status) values ('1', '6', 'Accepted');
insert into coop_connect.application (applicant_id, job_position_id, status) values ('18', '32', 'Rejected');
insert into coop_connect.application (applicant_id, job_position_id, status) values ('3', '3', 'Rejected');
insert into coop_connect.application (applicant_id, job_position_id, status) values ('35', '9', 'Pending');
insert into coop_connect.application (applicant_id, job_position_id, status) values ('32', '24', 'Rejected');
insert into coop_connect.application (applicant_id, job_position_id, status) values ('4', '7', 'Rejected');
insert into coop_connect.application (applicant_id, job_position_id, status) values ('16', '39', 'Rejected');
insert into coop_connect.application (applicant_id, job_position_id, status) values ('7', '36', 'Accepted');
insert into coop_connect.application (applicant_id, job_position_id, status) values ('34', '20', 'Pending');
insert into coop_connect.application (applicant_id, job_position_id, status) values ('36', '16', 'Accepted');
insert into coop_connect.application (applicant_id, job_position_id, status) values ('12', '38', 'Accepted');
insert into coop_connect.application (applicant_id, job_position_id, status) values ('33', '28', 'Accepted');
insert into coop_connect.application (applicant_id, job_position_id, status) values ('37', '17', 'Accepted');
insert into coop_connect.application (applicant_id, job_position_id, status) values ('24', '5', 'Pending');
insert into coop_connect.application (applicant_id, job_position_id, status) values ('19', '26', 'Accepted');
insert into coop_connect.application (applicant_id, job_position_id, status) values ('39', '14', 'Rejected');
insert into coop_connect.application (applicant_id, job_position_id, status) values ('6', '35', 'Rejected');
insert into coop_connect.application (applicant_id, job_position_id, status) values ('14', '33', 'Pending');
insert into coop_connect.application (applicant_id, job_position_id, status) values ('20', '4', 'Accepted');
insert into coop_connect.application (applicant_id, job_position_id, status) values ('9', '11', 'Rejected');
insert into coop_connect.application (applicant_id, job_position_id, status) values ('22', '2', 'Rejected');
insert into coop_connect.application (applicant_id, job_position_id, status) values ('21', '25', 'Rejected');
insert into coop_connect.application (applicant_id, job_position_id, status) values ('31', '29', 'Rejected');
insert into coop_connect.application (applicant_id, job_position_id, status) values ('8', '22', 'Pending');
insert into coop_connect.application (applicant_id, job_position_id, status) values ('40', '34', 'Accepted');
insert into coop_connect.application (applicant_id, job_position_id, status) values ('23', '21', 'Accepted');
insert into coop_connect.application (applicant_id, job_position_id, status) values ('15', '19', 'Rejected');
insert into coop_connect.application (applicant_id, job_position_id, status) values ('10', '40', 'Accepted');
insert into coop_connect.application (applicant_id, job_position_id, status) values ('27', '23', 'Rejected');
insert into coop_connect.application (applicant_id, job_position_id, status) values ('2', '8', 'Pending');
insert into coop_connect.application (applicant_id, job_position_id, status) values ('28', '27', 'Pending');
insert into coop_connect.application (applicant_id, job_position_id, status) values ('17', '30', 'Accepted');
insert into coop_connect.application (applicant_id, job_position_id, status) values ('13', '37', 'Rejected');
insert into coop_connect.application (applicant_id, job_position_id, status) values ('30', '12', 'Pending');
insert into coop_connect.application (applicant_id, job_position_id, status) values ('38', '1', 'Rejected');
insert into coop_connect.application (applicant_id, job_position_id, status) values ('29', '18', 'Accepted');
