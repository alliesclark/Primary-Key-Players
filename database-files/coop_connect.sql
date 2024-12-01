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
        CONSTRAINT fk_review_student FOREIGN KEY (student_id) REFERENCES student (id),
        CONSTRAINT fk_review_job_position FOREIGN KEY (job_position_id) REFERENCES job_position (id)
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

-- insert mockaroo data here NOT DONE YET!!!!
-- College table data
insert into coop_connect.college (id, name) values (1, 'Massachusetts Institute of Technology');
insert into coop_connect.college (id, name) values (2, 'Northeastern University');
insert into coop_connect.college (id, name) values (3, 'Tufts University');
insert into coop_connect.college (id, name) values (4, 'Boston College');
insert into coop_connect.college (id, name) values (5, 'Boston College');
insert into coop_connect.college (id, name) values (6, 'Massachusetts Institute of Technology');
insert into coop_connect.college (id, name) values (7, 'Massachusetts Institute of Technology');
insert into coop_connect.college (id, name) values (8, 'Harvard University');
insert into coop_connect.college (id, name) values (9, 'Boston College');
insert into coop_connect.college (id, name) values (10, 'Boston College');
insert into coop_connect.college (id, name) values (11, 'Boston College');
insert into coop_connect.college (id, name) values (12, 'Northeastern University');
insert into coop_connect.college (id, name) values (13, 'Harvard University');
insert into coop_connect.college (id, name) values (14, 'Boston College');
insert into coop_connect.college (id, name) values (15, 'Boston College');
insert into coop_connect.college (id, name) values (16, 'Boston College');
insert into coop_connect.college (id, name) values (17, 'Boston University');
insert into coop_connect.college (id, name) values (18, 'Boston University');
insert into coop_connect.college (id, name) values (19, 'Northeastern University');
insert into coop_connect.college (id, name) values (20, 'Massachusetts Institute of Technology');
insert into coop_connect.college (id, name) values (21, 'Tufts University');
insert into coop_connect.college (id, name) values (22, 'Massachusetts Institute of Technology');
insert into coop_connect.college (id, name) values (23, 'Northeastern University');
insert into coop_connect.college (id, name) values (24, 'Northeastern University');
insert into coop_connect.college (id, name) values (25, 'Northeastern University');
insert into coop_connect.college (id, name) values (26, 'Harvard University');
insert into coop_connect.college (id, name) values (27, 'Northeastern University');
insert into coop_connect.college (id, name) values (28, 'Massachusetts Institute of Technology');
insert into coop_connect.college (id, name) values (29, 'Boston College');
insert into coop_connect.college (id, name) values (30, 'Harvard University');
insert into coop_connect.college (id, name) values (31, 'Boston University');
insert into coop_connect.college (id, name) values (32, 'Harvard University');
insert into coop_connect.college (id, name) values (33, 'Harvard University');
insert into coop_connect.college (id, name) values (34, 'Northeastern University');
insert into coop_connect.college (id, name) values (35, 'Harvard University');
insert into coop_connect.college (id, name) values (36, 'Massachusetts Institute of Technology');
insert into coop_connect.college (id, name) values (37, 'Tufts University');
insert into coop_connect.college (id, name) values (38, 'Tufts University');
insert into coop_connect.college (id, name) values (39, 'Boston University');
insert into coop_connect.college (id, name) values (40, 'Tufts University');

-- Department table data
insert into coop_connect.department (id, college, name) values (1, '36', 'College of Computer Science');
insert into coop_connect.department (id, college, name) values (2, '30', 'School of Business');
insert into coop_connect.department (id, college, name) values (3, '9', 'School of Business');
insert into coop_connect.department (id, college, name) values (4, '40', 'College of Computer Science');
insert into coop_connect.department (id, college, name) values (5, '11', 'College of Arts and Sciences');
insert into coop_connect.department (id, college, name) values (6, '12', 'College of Computer Science');
insert into coop_connect.department (id, college, name) values (7, '10', 'College of Arts and Sciences');
insert into coop_connect.department (id, college, name) values (8, '34', 'School of Business');
insert into coop_connect.department (id, college, name) values (9, '16', 'School of Business');
insert into coop_connect.department (id, college, name) values (10, '19', 'College of Computer Science');
insert into coop_connect.department (id, college, name) values (11, '33', 'College of Arts and Sciences');
insert into coop_connect.department (id, college, name) values (12, '4', 'School of Business');
insert into coop_connect.department (id, college, name) values (13, '2', 'College of Computer Science');
insert into coop_connect.department (id, college, name) values (14, '28', 'College of Computer Science');
insert into coop_connect.department (id, college, name) values (15, '14', 'School of Business');
insert into coop_connect.department (id, college, name) values (16, '35', 'College of Arts and Sciences');
insert into coop_connect.department (id, college, name) values (17, '39', 'School of Business');
insert into coop_connect.department (id, college, name) values (18, '1', 'School of Business');
insert into coop_connect.department (id, college, name) values (19, '23', 'College of Computer Science');
insert into coop_connect.department (id, college, name) values (20, '15', 'College of Computer Science');
insert into coop_connect.department (id, college, name) values (21, '13', 'College of Computer Science');
insert into coop_connect.department (id, college, name) values (22, '6', 'School of Business');
insert into coop_connect.department (id, college, name) values (23, '20', 'College of Arts and Sciences');
insert into coop_connect.department (id, college, name) values (24, '26', 'College of Arts and Sciences');
insert into coop_connect.department (id, college, name) values (25, '8', 'College of Arts and Sciences');
insert into coop_connect.department (id, college, name) values (26, '17', 'College of Computer Science');
insert into coop_connect.department (id, college, name) values (27, '31', 'College of Arts and Sciences');
insert into coop_connect.department (id, college, name) values (28, '22', 'College of Arts and Sciences');
insert into coop_connect.department (id, college, name) values (29, '24', 'College of Computer Science');
insert into coop_connect.department (id, college, name) values (30, '29', 'College of Computer Science');
insert into coop_connect.department (id, college, name) values (31, '32', 'School of Business');
insert into coop_connect.department (id, college, name) values (32, '27', 'College of Computer Science');
insert into coop_connect.department (id, college, name) values (33, '5', 'School of Business');
insert into coop_connect.department (id, college, name) values (34, '37', 'College of Arts and Sciences');
insert into coop_connect.department (id, college, name) values (35, '7', 'School of Business');
insert into coop_connect.department (id, college, name) values (36, '25', 'School of Business');
insert into coop_connect.department (id, college, name) values (37, '18', 'School of Business');
insert into coop_connect.department (id, college, name) values (38, '21', 'College of Computer Science');
insert into coop_connect.department (id, college, name) values (39, '38', 'College of Computer Science');
insert into coop_connect.department (id, college, name) values (40, '3', 'College of Computer Science');

-- Major table data
insert into coop_connect.major (id, name, department) values (1, 'Data Science', 2);
insert into coop_connect.major (id, name, department) values (2, 'Accounting', 1);
insert into coop_connect.major (id, name, department) values (3, 'Journalism', 3);
insert into coop_connect.major (id, name, department) values (4, 'Cybersecurity', 2);
insert into coop_connect.major (id, name, department) values (5, 'Marketing', 1);
insert into coop_connect.major (id, name, department) values (6, 'French', 3);
insert into coop_connect.major (id, name, department) values (7, 'Journalism', 3);
insert into coop_connect.major (id, name, department) values (8, 'Marketing', 1);
insert into coop_connect.major (id, name, department) values (9, 'Finance', 1);
insert into coop_connect.major (id, name, department) values (10, 'Management', 1);
insert into coop_connect.major (id, name, department) values (11, 'Data Science', 2);
insert into coop_connect.major (id, name, department) values (12, 'Chemistry', 3);
insert into coop_connect.major (id, name, department) values (13, 'Cybersecurity', 2);
insert into coop_connect.major (id, name, department) values (14, 'Cybersecurity', 2);
insert into coop_connect.major (id, name, department) values (15, 'Management', 1);
insert into coop_connect.major (id, name, department) values (16, 'Physics', 3);
insert into coop_connect.major (id, name, department) values (17, 'Philosophy', 3);
insert into coop_connect.major (id, name, department) values (18, 'Management', 1);
insert into coop_connect.major (id, name, department) values (19, 'Accounting', 1);
insert into coop_connect.major (id, name, department) values (20, 'Management', 1);
insert into coop_connect.major (id, name, department) values (21, 'Cybersecurity', 2);
insert into coop_connect.major (id, name, department) values (22, 'Management', 1);
insert into coop_connect.major (id, name, department) values (23, 'Philosophy', 3);
insert into coop_connect.major (id, name, department) values (24, 'Chemistry', 3);
insert into coop_connect.major (id, name, department) values (25, 'Finance', 1);
insert into coop_connect.major (id, name, department) values (26, 'Chemistry', 3);
insert into coop_connect.major (id, name, department) values (27, 'Accounting', 1);
insert into coop_connect.major (id, name, department) values (28, 'Philosophy', 3);
insert into coop_connect.major (id, name, department) values (29, 'Physics', 3);
insert into coop_connect.major (id, name, department) values (30, 'Journalism', 3);
insert into coop_connect.major (id, name, department) values (31, 'Philosophy', 3);
insert into coop_connect.major (id, name, department) values (32, 'Environmental Studies', 3);
insert into coop_connect.major (id, name, department) values (33, 'Accounting', 1);
insert into coop_connect.major (id, name, department) values (34, 'Cybersecurity', 2);
insert into coop_connect.major (id, name, department) values (35, 'Chemistry', 3);
insert into coop_connect.major (id, name, department) values (36, 'Cybersecurity', 2);
insert into coop_connect.major (id, name, department) values (37, 'German', 3);
insert into coop_connect.major (id, name, department) values (38, 'Philosophy', 3);
insert into coop_connect.major (id, name, department) values (39, 'Management', 1);
insert into coop_connect.major (id, name, department) values (40, 'Accounting', 1);

-- Co-op Advisor table data
insert into coop_connect.coop_advisor (id, name, email, department_id) values (1, 'Darrel Swidenbank', 'dswidenbank0@marriott.com', '27');
insert into coop_connect.coop_advisor (id, name, email, department_id) values (2, 'Shaine Greenless', 'sgreenless1@vkontakte.ru', '3');
insert into coop_connect.coop_advisor (id, name, email, department_id) values (3, 'Josi Hallitt', 'jhallitt2@shinystat.com', '10');
insert into coop_connect.coop_advisor (id, name, email, department_id) values (4, 'Shermy Umbers', 'sumbers3@e-recht24.de', '9');
insert into coop_connect.coop_advisor (id, name, email, department_id) values (5, 'Lorrin Suttaby', 'lsuttaby4@arstechnica.com', '1');
insert into coop_connect.coop_advisor (id, name, email, department_id) values (6, 'Dani Young', 'dyoung5@opensource.org', '23');
insert into coop_connect.coop_advisor (id, name, email, department_id) values (7, 'Eydie Vedyasov', 'evedyasov6@wix.com', '21');
insert into coop_connect.coop_advisor (id, name, email, department_id) values (8, 'Kaleb Robertacci', 'krobertacci7@cafepress.com', '5');
insert into coop_connect.coop_advisor (id, name, email, department_id) values (9, 'Morrie Briddock', 'mbriddock8@nature.com', '14');
insert into coop_connect.coop_advisor (id, name, email, department_id) values (10, 'Mathilda Salleir', 'msalleir9@taobao.com', '7');
insert into coop_connect.coop_advisor (id, name, email, department_id) values (11, 'Germana Worsham', 'gworshama@ucla.edu', '29');
insert into coop_connect.coop_advisor (id, name, email, department_id) values (12, 'Michail Loxston', 'mloxstonb@disqus.com', '13');
insert into coop_connect.coop_advisor (id, name, email, department_id) values (13, 'Bryon Loude', 'bloudec@angelfire.com', '12');
insert into coop_connect.coop_advisor (id, name, email, department_id) values (14, 'Cristabel Beri', 'cberid@ovh.net', '16');
insert into coop_connect.coop_advisor (id, name, email, department_id) values (15, 'Milena Dallaway', 'mdallawaye@elpais.com', '18');
insert into coop_connect.coop_advisor (id, name, email, department_id) values (16, 'Elihu Sitlington', 'esitlingtonf@nasa.gov', '19');
insert into coop_connect.coop_advisor (id, name, email, department_id) values (17, 'Kirstin Abeau', 'kabeaug@weather.com', '15');
insert into coop_connect.coop_advisor (id, name, email, department_id) values (18, 'Gertrud Lyne', 'glyneh@cpanel.net', '32');
insert into coop_connect.coop_advisor (id, name, email, department_id) values (19, 'Jae Craft', 'jcrafti@topsy.com', '30');
insert into coop_connect.coop_advisor (id, name, email, department_id) values (20, 'Thorvald Rydings', 'trydingsj@sciencedaily.com', '37');
insert into coop_connect.coop_advisor (id, name, email, department_id) values (21, 'Tom Jaquemar', 'tjaquemark@printfriendly.com', '8');
insert into coop_connect.coop_advisor (id, name, email, department_id) values (22, 'Nickolai Gebbie', 'ngebbiel@goodreads.com', '22');
insert into coop_connect.coop_advisor (id, name, email, department_id) values (23, 'Jaquenette Glasscock', 'jglasscockm@ucla.edu', '36');
insert into coop_connect.coop_advisor (id, name, email, department_id) values (24, 'Derril Serginson', 'dserginsonn@alibaba.com', '39');
insert into coop_connect.coop_advisor (id, name, email, department_id) values (25, 'Harman Pappi', 'hpappio@trellian.com', '31');
insert into coop_connect.coop_advisor (id, name, email, department_id) values (26, 'Holmes Shivlin', 'hshivlinp@webs.com', '25');
insert into coop_connect.coop_advisor (id, name, email, department_id) values (27, 'Kathryn Pinnington', 'kpinningtonq@symantec.com', '4');
insert into coop_connect.coop_advisor (id, name, email, department_id) values (28, 'Tate Castagnaro', 'tcastagnaror@aboutads.info', '26');
insert into coop_connect.coop_advisor (id, name, email, department_id) values (29, 'Frank Gregh', 'fgreghs@cdbaby.com', '2');
insert into coop_connect.coop_advisor (id, name, email, department_id) values (30, 'Megan Antcliff', 'mantclifft@devhub.com', '20');
insert into coop_connect.coop_advisor (id, name, email, department_id) values (31, 'Keeley Roser', 'kroseru@biblegateway.com', '40');
insert into coop_connect.coop_advisor (id, name, email, department_id) values (32, 'Goddard Pettingall', 'gpettingallv@japanpost.jp', '6');
insert into coop_connect.coop_advisor (id, name, email, department_id) values (33, 'Chastity Donnelly', 'cdonnellyw@loc.gov', '28');
insert into coop_connect.coop_advisor (id, name, email, department_id) values (34, 'Melisenda Blue', 'mbluex@vinaora.com', '24');
insert into coop_connect.coop_advisor (id, name, email, department_id) values (35, 'Donnajean Hynd', 'dhyndy@theatlantic.com', '34');
insert into coop_connect.coop_advisor (id, name, email, department_id) values (36, 'Reinold Ing', 'ringz@sfgate.com', '17');
insert into coop_connect.coop_advisor (id, name, email, department_id) values (37, 'Cristina Spikeings', 'cspikeings10@ehow.com', '35');
insert into coop_connect.coop_advisor (id, name, email, department_id) values (38, 'Eolande Selwyn', 'eselwyn11@vkontakte.ru', '11');
insert into coop_connect.coop_advisor (id, name, email, department_id) values (39, 'Linn Mayoh', 'lmayoh12@biblegateway.com', '33');
insert into coop_connect.coop_advisor (id, name, email, department_id) values (40, 'Ariella Chiverstone', 'achiverstone13@smugmug.com', '38');

-- Industry table data
insert into coop_connect.industry (id, name) values (1, 'Healthcare');
insert into coop_connect.industry (id, name) values (2, 'Public Sector');
insert into coop_connect.industry (id, name) values (3, 'Technology');
insert into coop_connect.industry (id, name) values (4, 'Banking');
insert into coop_connect.industry (id, name) values (5, 'Consumer Services');
insert into coop_connect.industry (id, name) values (6, 'Government');
insert into coop_connect.industry (id, name) values (7, 'Energy');
insert into coop_connect.industry (id, name) values (8, 'Energy');
insert into coop_connect.industry (id, name) values (9, 'Education');
insert into coop_connect.industry (id, name) values (10, 'Banking');
insert into coop_connect.industry (id, name) values (11, 'Consumer Services');
insert into coop_connect.industry (id, name) values (12, 'Education');
insert into coop_connect.industry (id, name) values (13, 'Engineering');
insert into coop_connect.industry (id, name) values (14, 'Healthcare');
insert into coop_connect.industry (id, name) values (15, 'Sales and Trading');
insert into coop_connect.industry (id, name) values (16, 'Life Sciences');
insert into coop_connect.industry (id, name) values (17, 'Retail');
insert into coop_connect.industry (id, name) values (18, 'Retail');
insert into coop_connect.industry (id, name) values (19, 'Manufacturing');
insert into coop_connect.industry (id, name) values (20, 'Sales and Trading');
insert into coop_connect.industry (id, name) values (21, 'Energy');
insert into coop_connect.industry (id, name) values (22, 'Government');
insert into coop_connect.industry (id, name) values (23, 'Retail');
insert into coop_connect.industry (id, name) values (24, 'Technology');
insert into coop_connect.industry (id, name) values (25, 'Environment');
insert into coop_connect.industry (id, name) values (26, 'Healthcare');
insert into coop_connect.industry (id, name) values (27, 'Public Sector');
insert into coop_connect.industry (id, name) values (28, 'Sales and Trading');
insert into coop_connect.industry (id, name) values (29, 'Media and Communications');
insert into coop_connect.industry (id, name) values (30, 'Consumer Services');
insert into coop_connect.industry (id, name) values (31, 'Energy');
insert into coop_connect.industry (id, name) values (32, 'Public Sector');
insert into coop_connect.industry (id, name) values (33, 'Banking');
insert into coop_connect.industry (id, name) values (34, 'Environment');
insert into coop_connect.industry (id, name) values (35, 'Healthcare');
insert into coop_connect.industry (id, name) values (36, 'Technology');
insert into coop_connect.industry (id, name) values (37, 'Consumer Services');
insert into coop_connect.industry (id, name) values (38, 'Banking');
insert into coop_connect.industry (id, name) values (39, 'Consumer Services');
insert into coop_connect.industry (id, name) values (40, 'Media and Communications');

-- Company table data
insert into coop_connect.company (id, name, industry, location, description, criteria) values (1, 'Cummings-Brown', '31', 'Chicago', 'Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc.', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt.');
insert into coop_connect.company (id, name, industry, location, description, criteria) values (2, 'Schmidt Group', '8', 'London', 'Nunc purus. Phasellus in felis.', 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo.');
insert into coop_connect.company (id, name, industry, location, description, criteria) values (3, 'McLaughlin, Sauer and Maggio', '36', 'Chicago', 'Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', 'Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim.');
insert into coop_connect.company (id, name, industry, location, description, criteria) values (4, 'Ritchie, Ritchie and Romaguera', '20', 'Miami', 'Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla.', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl.');
insert into coop_connect.company (id, name, industry, location, description, criteria) values (5, 'Hettinger-Herman', '34', 'Toronto', 'Nunc rhoncus dui vel sem. Sed sagittis.', 'Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.');
insert into coop_connect.company (id, name, industry, location, description, criteria) values (6, 'Conroy and Sons', '29', 'Los Angeles', 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', 'Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst.');
insert into coop_connect.company (id, name, industry, location, description, criteria) values (7, 'Leuschke Inc', '13', 'London', 'Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio.', 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy.');
insert into coop_connect.company (id, name, industry, location, description, criteria) values (8, 'Considine LLC', '11', 'Toronto', 'Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue.', 'Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum.');
insert into coop_connect.company (id, name, industry, location, description, criteria) values (9, 'Grant, DuBuque and Yundt', '9', 'Toronto', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis. Donec semper sapien a libero.');
insert into coop_connect.company (id, name, industry, location, description, criteria) values (10, 'Haag and Sons', '24', 'Los Angeles', 'Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus.', 'Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula.');
insert into coop_connect.company (id, name, industry, location, description, criteria) values (11, 'Schmitt-Kiehn', '23', 'Boston', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci.', 'Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo.');
insert into coop_connect.company (id, name, industry, location, description, criteria) values (12, 'Kuvalis-Bahringer', '12', 'London', 'Vestibulum sed magna at nunc commodo placerat. Praesent blandit.', 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo.');
insert into coop_connect.company (id, name, industry, location, description, criteria) values (13, 'Schinner, Smitham and Gutkowski', '38', 'New York City', 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.', 'Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum.');
insert into coop_connect.company (id, name, industry, location, description, criteria) values (14, 'Gerlach-Kris', '25', 'Los Angeles', 'Duis at velit eu est congue elementum. In hac habitasse platea dictumst.', 'Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.');
insert into coop_connect.company (id, name, industry, location, description, criteria) values (15, 'Keebler-Lynch', '3', 'New York City', 'Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna.', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla.');
insert into coop_connect.company (id, name, industry, location, description, criteria) values (16, 'Mueller-McDermott', '15', 'Boston', 'Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum.', 'Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.');
insert into coop_connect.company (id, name, industry, location, description, criteria) values (17, 'Bartoletti, Runolfsdottir and Stamm', '19', 'New York City', 'Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat.', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum.');
insert into coop_connect.company (id, name, industry, location, description, criteria) values (18, 'McDermott Group', '7', 'Boston', 'Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus.', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus.');
insert into coop_connect.company (id, name, industry, location, description, criteria) values (19, 'Bode and Sons', '5', 'London', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum.');
insert into coop_connect.company (id, name, industry, location, description, criteria) values (20, 'Feest, Braun and Schaden', '1', 'Boston', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo.', 'Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc.');
insert into coop_connect.company (id, name, industry, location, description, criteria) values (21, 'Crona, Emmerich and Connelly', '37', 'Boston', 'In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.', 'Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis.');
insert into coop_connect.company (id, name, industry, location, description, criteria) values (22, 'Reinger, Dicki and Lowe', '14', 'Boston', 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit.', 'Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.');
insert into coop_connect.company (id, name, industry, location, description, criteria) values (23, 'Sipes Inc', '26', 'New York City', 'Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo.', 'Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus.');
insert into coop_connect.company (id, name, industry, location, description, criteria) values (24, 'Kirlin-Ankunding', '39', 'Miami', 'Aenean fermentum. Donec ut mauris eget massa tempor convallis.', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.');
insert into coop_connect.company (id, name, industry, location, description, criteria) values (25, 'Heller, Dare and Harvey', '18', 'Chicago', 'Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.', 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla.');
insert into coop_connect.company (id, name, industry, location, description, criteria) values (26, 'Cole and Sons', '21', 'Charlotte', 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 'Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst.');
insert into coop_connect.company (id, name, industry, location, description, criteria) values (27, 'Prohaska-Goyette', '6', 'New York City', 'Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc.', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst.');
insert into coop_connect.company (id, name, industry, location, description, criteria) values (28, 'Heidenreich-Daniel', '4', 'Miami', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.', 'Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices.');
insert into coop_connect.company (id, name, industry, location, description, criteria) values (29, 'Paucek Inc', '2', 'Toronto', 'Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc.', 'Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis.');
insert into coop_connect.company (id, name, industry, location, description, criteria) values (30, 'Grady Group', '30', 'Chicago', 'Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum.');
insert into coop_connect.company (id, name, industry, location, description, criteria) values (31, 'Davis, Jones and Bashirian', '27', 'Miami', 'Vivamus in felis eu sapien cursus vestibulum. Proin eu mi.', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum.');
insert into coop_connect.company (id, name, industry, location, description, criteria) values (32, 'Haag-Kassulke', '28', 'New York City', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.', 'Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo.');
insert into coop_connect.company (id, name, industry, location, description, criteria) values (33, 'Kunze-Herzog', '32', 'Charlotte', 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.', 'Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.');
insert into coop_connect.company (id, name, industry, location, description, criteria) values (34, 'Wiegand, Hilpert and Larkin', '10', 'Boston', 'Duis at velit eu est congue elementum. In hac habitasse platea dictumst.', 'Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.');
insert into coop_connect.company (id, name, industry, location, description, criteria) values (35, 'Johnston Inc', '33', 'London', 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', 'Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti.');
insert into coop_connect.company (id, name, industry, location, description, criteria) values (36, 'Cummings Group', '17', 'Boston', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam.', 'Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.');
insert into coop_connect.company (id, name, industry, location, description, criteria) values (37, 'Huel, Bernier and Goldner', '16', 'London', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum.', 'Proin risus. Praesent lectus. Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio.');
insert into coop_connect.company (id, name, industry, location, description, criteria) values (38, 'Durgan Group', '35', 'London', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet.');
insert into coop_connect.company (id, name, industry, location, description, criteria) values (39, 'Bartoletti and Sons', '40', 'Boston', 'Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus.', 'Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo.');
insert into coop_connect.company (id, name, industry, location, description, criteria) values (40, 'Hilll-Dicki', '22', 'Chicago', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo.', 'Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.');

-- Skill table data
insert into coop_connect.skill (id, name) values (1, 'Taleo');
insert into coop_connect.skill (id, name) values (2, 'JDeveloper');
insert into coop_connect.skill (id, name) values (3, 'Information Security Awareness');
insert into coop_connect.skill (id, name) values (4, 'Active TS/SCI Clearance');
insert into coop_connect.skill (id, name) values (5, 'Accounting');
insert into coop_connect.skill (id, name) values (6, 'Appraisals');
insert into coop_connect.skill (id, name) values (7, 'Youth Programs');
insert into coop_connect.skill (id, name) values (8, 'Public Speaking');
insert into coop_connect.skill (id, name) values (9, 'DC-DC');
insert into coop_connect.skill (id, name) values (10, 'FSMS');
insert into coop_connect.skill (id, name) values (11, 'Critical thinking');
insert into coop_connect.skill (id, name) values (12, 'Electronics');
insert into coop_connect.skill (id, name) values (13, 'CVD');
insert into coop_connect.skill (id, name) values (14, 'CTQ');
insert into coop_connect.skill (id, name) values (15, 'Aerial Lifts');
insert into coop_connect.skill (id, name) values (16, 'DXX');
insert into coop_connect.skill (id, name) values (17, 'Photo Shoots');
insert into coop_connect.skill (id, name) values (18, 'Servers');
insert into coop_connect.skill (id, name) values (19, 'Verilog');
insert into coop_connect.skill (id, name) values (20, 'PTC Creo');
insert into coop_connect.skill (id, name) values (21, 'GWAS');
insert into coop_connect.skill (id, name) values (22, 'Taxes');
insert into coop_connect.skill (id, name) values (23, 'MRB');
insert into coop_connect.skill (id, name) values (24, 'Youth Engagement');
insert into coop_connect.skill (id, name) values (25, 'AAAHC');
insert into coop_connect.skill (id, name) values (26, 'Executive Coaching');
insert into coop_connect.skill (id, name) values (27, 'DDA compliance');
insert into coop_connect.skill (id, name) values (28, 'TWiki');
insert into coop_connect.skill (id, name) values (29, 'SQL');
insert into coop_connect.skill (id, name) values (30, 'Urban Regeneration');
insert into coop_connect.skill (id, name) values (31, 'Disability Insurance');
insert into coop_connect.skill (id, name) values (32, 'Digital Printing');
insert into coop_connect.skill (id, name) values (33, 'IT Audit');
insert into coop_connect.skill (id, name) values (34, 'UX Design');
insert into coop_connect.skill (id, name) values (35, 'UCP 600');
insert into coop_connect.skill (id, name) values (36, 'JUNOS');
insert into coop_connect.skill (id, name) values (37, 'Python');
insert into coop_connect.skill (id, name) values (38, 'DXL');
insert into coop_connect.skill (id, name) values (39, 'iLife');
insert into coop_connect.skill (id, name) values (40, 'Russian');


-- Hiring manager table data
insert into coop_connect.hiring_manager (id, name, position, email, company_id) values (1, 'Marjie Pucknell', 'HR Director', 'mpucknell0@virginia.edu', '33');
insert into coop_connect.hiring_manager (id, name, position, email, company_id) values (2, 'Erminie Domek', 'Talent Acquisition Manager', 'edomek1@a8.net', '40');
insert into coop_connect.hiring_manager (id, name, position, email, company_id) values (3, 'Nadiya Gommes', 'Campus Recruiter', 'ngommes2@adobe.com', '4');
insert into coop_connect.hiring_manager (id, name, position, email, company_id) values (4, 'Boyce Dunkinson', 'HR Director', 'bdunkinson3@yandex.ru', '20');
insert into coop_connect.hiring_manager (id, name, position, email, company_id) values (5, 'Paddie Maile', 'HR Director', 'pmaile4@blogs.com', '36');
insert into coop_connect.hiring_manager (id, name, position, email, company_id) values (6, 'Maxie Crowche', 'HR Director', 'mcrowche5@deviantart.com', '30');
insert into coop_connect.hiring_manager (id, name, position, email, company_id) values (7, 'Alwin Stopher', 'Talent Acquisition Manager', 'astopher6@liveinternet.ru', '28');
insert into coop_connect.hiring_manager (id, name, position, email, company_id) values (8, 'Smitty Rolin', 'HR Director', 'srolin7@slashdot.org', '27');
insert into coop_connect.hiring_manager (id, name, position, email, company_id) values (9, 'Cary Staveley', 'HR Director', 'cstaveley8@hubpages.com', '29');
insert into coop_connect.hiring_manager (id, name, position, email, company_id) values (10, 'Anatola Bool', 'HR Director', 'abool9@blogspot.com', '26');
insert into coop_connect.hiring_manager (id, name, position, email, company_id) values (11, 'Arri Usmar', 'Talent Acquisition Manager', 'ausmara@cisco.com', '12');
insert into coop_connect.hiring_manager (id, name, position, email, company_id) values (12, 'Laurella Huckster', 'Talent Acquisition Manager', 'lhucksterb@lycos.com', '22');
insert into coop_connect.hiring_manager (id, name, position, email, company_id) values (13, 'Allison Chessman', 'HR Director', 'gchessmanc@globo.com', '31');
insert into coop_connect.hiring_manager (id, name, position, email, company_id) values (14, 'Sabrina Gillatt', 'HR Director', 'bgillattd@joomla.org', '17');
insert into coop_connect.hiring_manager (id, name, position, email, company_id) values (15, 'Binnie Salman', 'Talent Acquisition Manager', 'bsalmane@rakuten.co.jp', '39');
insert into coop_connect.hiring_manager (id, name, position, email, company_id) values (16, 'Benoite Ysson', 'Talent Acquisition Manager', 'byssonf@abc.net.au', '37');
insert into coop_connect.hiring_manager (id, name, position, email, company_id) values (17, 'Prudence Buyers', 'Campus Recruiter', 'pbuyersg@xing.com', '34');
insert into coop_connect.hiring_manager (id, name, position, email, company_id) values (18, 'Nonna Sarll', 'HR Director', 'nsarllh@admin.ch', '38');
insert into coop_connect.hiring_manager (id, name, position, email, company_id) values (19, 'Vito Bootman', 'Campus Recruiter', 'vbootmani@sciencedirect.com', '35');
insert into coop_connect.hiring_manager (id, name, position, email, company_id) values (20, 'Sarena Querree', 'Talent Acquisition Manager', 'squerreej@wordpress.com', '8');
insert into coop_connect.hiring_manager (id, name, position, email, company_id) values (21, 'May Howlin', 'HR Director', 'mhowlink@google.ru', '6');
insert into coop_connect.hiring_manager (id, name, position, email, company_id) values (22, 'Wynny Downs', 'HR Director', 'wdownsl@vistaprint.com', '7');
insert into coop_connect.hiring_manager (id, name, position, email, company_id) values (23, 'Felicia Crossthwaite', 'Campus Recruiter', 'fcrossthwaitem@indiatimes.com', '2');
insert into coop_connect.hiring_manager (id, name, position, email, company_id) values (24, 'Rhea Gossart', 'Campus Recruiter', 'rgossartn@mac.com', '14');
insert into coop_connect.hiring_manager (id, name, position, email, company_id) values (25, 'Egon Woollends', 'Campus Recruiter', 'ewoollendso@cdbaby.com', '19');
insert into coop_connect.hiring_manager (id, name, position, email, company_id) values (26, 'Nathaniel O'' Donohue', 'HR Director', 'nop@macromedia.com', '18');
insert into coop_connect.hiring_manager (id, name, position, email, company_id) values (27, 'Aline Borless', 'Talent Acquisition Manager', 'aborlessq@mozilla.org', '23');
insert into coop_connect.hiring_manager (id, name, position, email, company_id) values (28, 'Neila Boaler', 'Talent Acquisition Manager', 'nboalerr@twitpic.com', '5');
insert into coop_connect.hiring_manager (id, name, position, email, company_id) values (29, 'Titos Phelips', 'Campus Recruiter', 'tphelipss@nationalgeographic.com', '21');
insert into coop_connect.hiring_manager (id, name, position, email, company_id) values (30, 'Inez Vecard', 'HR Director', 'ivecardt@livejournal.com', '25');
insert into coop_connect.hiring_manager (id, name, position, email, company_id) values (31, 'Sigismundo Farny', 'HR Director', 'sfarnyu@reverbnation.com', '11');
insert into coop_connect.hiring_manager (id, name, position, email, company_id) values (32, 'Reilly Walklot', 'HR Director', 'rwalklotv@columbia.edu', '9');
insert into coop_connect.hiring_manager (id, name, position, email, company_id) values (33, 'Trevor Siney', 'Campus Recruiter', 'tsineyw@craigslist.org', '15');
insert into coop_connect.hiring_manager (id, name, position, email, company_id) values (34, 'Chad Winter', 'HR Director', 'cwinterx@amazon.de', '13');
insert into coop_connect.hiring_manager (id, name, position, email, company_id) values (35, 'Shena Calvard', 'Talent Acquisition Manager', 'scalvardy@hp.com', '10');
insert into coop_connect.hiring_manager (id, name, position, email, company_id) values (36, 'Glenden Tomaszek', 'Talent Acquisition Manager', 'gtomaszekz@house.gov', '3');
insert into coop_connect.hiring_manager (id, name, position, email, company_id) values (37, 'Camila Asple', 'Campus Recruiter', 'casple10@wix.com', '32');
insert into coop_connect.hiring_manager (id, name, position, email, company_id) values (38, 'Marysa Samper', 'Talent Acquisition Manager', 'msamper11@boston.com', '16');
insert into coop_connect.hiring_manager (id, name, position, email, company_id) values (39, 'Trent Costa', 'Campus Recruiter', 'tcosta12@bbc.co.uk', '1');
insert into coop_connect.hiring_manager (id, name, position, email, company_id) values (40, 'Dulcea Battram', 'HR Director', 'dbattram13@shutterfly.com', '24');


-- Hiring manager co-op advisor bridge table data
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('1', '37');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('33', '15');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('26', '39');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('16', '24');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('23', '25');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('34', '32');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('22', '13');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('14', '7');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('2', '27');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('8', '29');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('31', '23');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('37', '12');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('10', '22');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('20', '20');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('28', '21');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('35', '26');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('19', '16');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('6', '3');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('32', '30');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('40', '31');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('18', '4');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('29', '35');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('25', '36');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('21', '33');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('36', '40');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('13', '34');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('27', '6');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('9', '19');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('38', '3');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('3', '1');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('39', '10');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('15', '17');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('30', '7');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('11', '14');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('4', '8');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('24', '5');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('5', '18');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('12', '28');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('7', '11');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('17', '38');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('3', '28');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('32', '29');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('35', '18');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('26', '31');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('17', '31');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('30', '23');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('2', '34');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('9', '22');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('40', '15');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('7', '17');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('34', '27');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('20', '33');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('8', '14');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('4', '20');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('13', '35');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('39', '6');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('24', '40');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('1', '5');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('21', '26');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('5', '16');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('15', '19');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('19', '10');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('23', '12');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('6', '2');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('14', '9');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('10', '36');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('27', '8');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('29', '37');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('36', '1');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('25', '21');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('18', '5');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('38', '7');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('22', '30');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('12', '25');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('16', '32');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('11', '11');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('31', '24');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('28', '3');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('33', '38');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('37', '13');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('22', '37');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('20', '15');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('34', '5');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('32', '31');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('38', '26');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('7', '5');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('14', '40');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('25', '13');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('12', '21');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('18', '14');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('27', '2');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('35', '17');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('40', '10');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('4', '34');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('36', '33');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('29', '6');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('17', '18');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('21', '19');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('39', '32');
insert into coop_connect.hiring_manager_coop_advisor (hiring_manager_id, coop_advisor_id) values ('30', '22');


-- Job position table data
insert into coop_connect.job_position (id, title, description, still_accepting, num_applicants, postedAt, updatedAt, location, desired_skills, targeted_majors, company_id) values (1, 'Database Administrator II', 'Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis.', false, 27, '10/9/2024', '12/12/2024', 'London', 'Djembe', 'Suspendisse ornare consequat lectus.', '38');
insert into coop_connect.job_position (id, title, description, still_accepting, num_applicants, postedAt, updatedAt, location, desired_skills, targeted_majors, company_id) values (2, 'Web Designer IV', 'Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti.', true, 97, '10/28/2024', '10/28/2024', 'London', 'BDC', 'In hac habitasse platea dictumst.', '10');
insert into coop_connect.job_position (id, title, description, still_accepting, num_applicants, postedAt, updatedAt, location, desired_skills, targeted_majors, company_id) values (3, 'Nurse Practicioner', 'In eleifend quam a odio. In hac habitasse platea dictumst.', true, 57, '11/23/2024', '11/23/2024', 'Chicago', 'RPT', 'Nulla facilisi.', '34');
insert into coop_connect.job_position (id, title, description, still_accepting, num_applicants, postedAt, updatedAt, location, desired_skills, targeted_majors, company_id) values (4, 'Programmer Analyst IV', 'Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.', true, 13, '11/8/2024', '11/8/2024', 'Chicago', 'HTML5', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo.', '36');
insert into coop_connect.job_position (id, title, description, still_accepting, num_applicants, postedAt, updatedAt, location, desired_skills, targeted_majors, company_id) values (5, 'Help Desk Technician', 'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.', false, 22, '9/21/2024', '9/21/2024', 'Charlotte', 'VTK', 'Quisque id justo sit amet sapien dignissim vestibulum.', '9');
insert into coop_connect.job_position (id, title, description, still_accepting, num_applicants, postedAt, updatedAt, location, desired_skills, targeted_majors, company_id) values (6, 'Senior Cost Accountant', 'Integer a nibh. In quis justo.', false, 3, '9/29/2024', '12/15/2024', 'New York City', 'Programming', 'Nullam varius.', '25');
insert into coop_connect.job_position (id, title, description, still_accepting, num_applicants, postedAt, updatedAt, location, desired_skills, targeted_majors, company_id) values (7, 'Product Engineer', 'Aliquam erat volutpat. In congue. Etiam justo.', true, 19, '11/26/2024', '11/26/2024', 'Toronto', 'Water Resources', 'Duis aliquam convallis nunc.', '17');
insert into coop_connect.job_position (id, title, description, still_accepting, num_applicants, postedAt, updatedAt, location, desired_skills, targeted_majors, company_id) values (8, 'Dental Hygienist', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue.', true, 91, '9/29/2024', '10/29/2024', 'Chicago', 'Human Resource Planning', 'Nulla ac enim.', '16');
insert into coop_connect.job_position (id, title, description, still_accepting, num_applicants, postedAt, updatedAt, location, desired_skills, targeted_majors, company_id) values (9, 'Dental Hygienist', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem.', true, 74, '9/6/2024', '11/11/2024', 'Miami', 'MKS Integrity', 'In eleifend quam a odio.', '40');
insert into coop_connect.job_position (id, title, description, still_accepting, num_applicants, postedAt, updatedAt, location, desired_skills, targeted_majors, company_id) values (10, 'Sales Associate', 'In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices.', true, 66, '11/9/2024', '11/26/2024', 'Boston', 'TTCN', 'Cras non velit nec nisi vulputate nonummy.', '11');
insert into coop_connect.job_position (id, title, description, still_accepting, num_applicants, postedAt, updatedAt, location, desired_skills, targeted_majors, company_id) values (11, 'Senior Editor', 'Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl.', false, 48, '10/22/2024', '10/22/2024', 'New York City', 'Operational Planning', 'Nulla facilisi.', '23');
insert into coop_connect.job_position (id, title, description, still_accepting, num_applicants, postedAt, updatedAt, location, desired_skills, targeted_majors, company_id) values (12, 'Professor', 'Duis mattis egestas metus. Aenean fermentum.', false, 73, '11/16/2024', '12/12/2024', 'Miami', 'Lumion', 'Aenean sit amet justo.', '1');
insert into coop_connect.job_position (id, title, description, still_accepting, num_applicants, postedAt, updatedAt, location, desired_skills, targeted_majors, company_id) values (13, 'Nuclear Power Engineer', 'Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia.', true, 36, '11/20/2024', '11/20/2024', 'New York City', 'MCSA', 'Sed accumsan felis.', '20');
insert into coop_connect.job_position (id, title, description, still_accepting, num_applicants, postedAt, updatedAt, location, desired_skills, targeted_majors, company_id) values (14, 'VP Quality Control', 'Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', false, 98, '11/24/2024', '11/24/2024', 'Toronto', 'VCT', 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est.', '39');
insert into coop_connect.job_position (id, title, description, still_accepting, num_applicants, postedAt, updatedAt, location, desired_skills, targeted_majors, company_id) values (15, 'Project Manager', 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.', false, 98, '11/10/2024', '11/26/2024', 'Toronto', 'Geometric Dimensioning &amp; Tolerancing', 'Nullam sit amet turpis elementum ligula vehicula consequat.', '14');
insert into coop_connect.job_position (id, title, description, still_accepting, num_applicants, postedAt, updatedAt, location, desired_skills, targeted_majors, company_id) values (16, 'Desktop Support Technician', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.', true, 35, '9/23/2024', '12/1/2024', 'Boston', 'Wholesale Operations', 'Nulla ac enim.', '29');
insert into coop_connect.job_position (id, title, description, still_accepting, num_applicants, postedAt, updatedAt, location, desired_skills, targeted_majors, company_id) values (17, 'Web Developer I', 'Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor.', true, 72, '9/7/2024', '10/9/2024', 'Los Angeles', 'HDV', 'Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl.', '35');
insert into coop_connect.job_position (id, title, description, still_accepting, num_applicants, postedAt, updatedAt, location, desired_skills, targeted_majors, company_id) values (18, 'Help Desk Technician', 'In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy.', true, 47, '9/18/2024', '12/7/2024', 'Chicago', 'Abstracting', 'Sed ante.', '32');
insert into coop_connect.job_position (id, title, description, still_accepting, num_applicants, postedAt, updatedAt, location, desired_skills, targeted_majors, company_id) values (19, 'GIS Technical Architect', 'Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis.', true, 13, '11/5/2024', '11/5/2024', 'New York City', 'Industrial Ethernet', 'Donec ut mauris eget massa tempor convallis.', '18');
insert into coop_connect.job_position (id, title, description, still_accepting, num_applicants, postedAt, updatedAt, location, desired_skills, targeted_majors, company_id) values (20, 'Civil Engineer', 'In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem.', false, 90, '9/27/2024', '11/26/2024', 'Boston', 'Cluster', 'Nulla suscipit ligula in lacus.', '4');
insert into coop_connect.job_position (id, title, description, still_accepting, num_applicants, postedAt, updatedAt, location, desired_skills, targeted_majors, company_id) values (21, 'Financial Advisor', 'Proin at turpis a pede posuere nonummy. Integer non velit.', false, 40, '11/16/2024', '11/16/2024', 'New York City', 'Award Winner', 'Donec ut dolor.', '2');
insert into coop_connect.job_position (id, title, description, still_accepting, num_applicants, postedAt, updatedAt, location, desired_skills, targeted_majors, company_id) values (22, 'Marketing Manager', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.', true, 43, '9/13/2024', '9/13/2024', 'Los Angeles', 'RCP', 'Phasellus id sapien in sapien iaculis congue.', '28');
insert into coop_connect.job_position (id, title, description, still_accepting, num_applicants, postedAt, updatedAt, location, desired_skills, targeted_majors, company_id) values (23, 'Administrative Assistant III', 'Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula.', true, 49, '11/3/2024', '11/3/2024', 'Toronto', 'JCAHO', 'Nulla nisl.', '7');
insert into coop_connect.job_position (id, title, description, still_accepting, num_applicants, postedAt, updatedAt, location, desired_skills, targeted_majors, company_id) values (24, 'Web Developer II', 'In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat.', true, 10, '9/3/2024', '9/26/2024', 'New York City', 'LN', 'Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', '31');
insert into coop_connect.job_position (id, title, description, still_accepting, num_applicants, postedAt, updatedAt, location, desired_skills, targeted_majors, company_id) values (25, 'Research Associate', 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.', true, 54, '10/14/2024', '12/2/2024', 'Boston', 'Sybase IQ', 'Suspendisse potenti.', '27');
insert into coop_connect.job_position (id, title, description, still_accepting, num_applicants, postedAt, updatedAt, location, desired_skills, targeted_majors, company_id) values (26, 'Food Chemist', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue.', true, 60, '9/6/2024', '10/3/2024', 'New York City', 'nCloth', 'Vestibulum ac est lacinia nisi venenatis tristique.', '8');
insert into coop_connect.job_position (id, title, description, still_accepting, num_applicants, postedAt, updatedAt, location, desired_skills, targeted_majors, company_id) values (27, 'Marketing Assistant', 'Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', false, 55, '9/5/2024', '11/13/2024', 'Miami', 'Power Systems', 'Cras non velit nec nisi vulputate nonummy.', '22');
insert into coop_connect.job_position (id, title, description, still_accepting, num_applicants, postedAt, updatedAt, location, desired_skills, targeted_majors, company_id) values (28, 'Payment Adjustment Coordinator', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.', true, 65, '11/6/2024', '11/6/2024', 'Boston', 'CFII', 'Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis.', '5');
insert into coop_connect.job_position (id, title, description, still_accepting, num_applicants, postedAt, updatedAt, location, desired_skills, targeted_majors, company_id) values (29, 'Senior Sales Associate', 'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.', false, 76, '12/2/2024', '12/2/2024', 'Toronto', 'LDAP Administration', 'Etiam justo.', '15');
insert into coop_connect.job_position (id, title, description, still_accepting, num_applicants, postedAt, updatedAt, location, desired_skills, targeted_majors, company_id) values (30, 'Recruiting Manager', 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam.', true, 41, '10/30/2024', '10/30/2024', 'Chicago', 'BSP', 'Nulla ut erat id mauris vulputate elementum.', '13');
insert into coop_connect.job_position (id, title, description, still_accepting, num_applicants, postedAt, updatedAt, location, desired_skills, targeted_majors, company_id) values (31, 'VP Accounting', 'Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.', true, 97, '9/29/2024', '12/16/2024', 'Charlotte', 'Utilization Management', 'Duis consequat dui nec nisi volutpat eleifend.', '12');
insert into coop_connect.job_position (id, title, description, still_accepting, num_applicants, postedAt, updatedAt, location, desired_skills, targeted_majors, company_id) values (32, 'Web Designer IV', 'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum.', true, 83, '9/23/2024', '9/23/2024', 'Charlotte', 'FP7', 'Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.', '6');
insert into coop_connect.job_position (id, title, description, still_accepting, num_applicants, postedAt, updatedAt, location, desired_skills, targeted_majors, company_id) values (33, 'Nuclear Power Engineer', 'Duis at velit eu est congue elementum. In hac habitasse platea dictumst.', true, 28, '9/8/2024', '12/22/2024', 'Boston', 'Social Media Marketing', 'Donec vitae nisi.', '24');
insert into coop_connect.job_position (id, title, description, still_accepting, num_applicants, postedAt, updatedAt, location, desired_skills, targeted_majors, company_id) values (34, 'Senior Cost Accountant', 'Sed accumsan felis. Ut at dolor quis odio consequat varius.', true, 100, '10/18/2024', '11/17/2024', 'Boston', 'IAR', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc.', '26');
insert into coop_connect.job_position (id, title, description, still_accepting, num_applicants, postedAt, updatedAt, location, desired_skills, targeted_majors, company_id) values (35, 'Payment Adjustment Coordinator', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo.', true, 25, '11/3/2024', '12/21/2024', 'Chicago', 'Report Writing', 'Maecenas pulvinar lobortis est.', '19');
insert into coop_connect.job_position (id, title, description, still_accepting, num_applicants, postedAt, updatedAt, location, desired_skills, targeted_majors, company_id) values (36, 'Design Engineer', 'Duis bibendum. Morbi non quam nec dui luctus rutrum.', true, 11, '12/1/2024', '12/29/2024', 'Miami', 'EEPROM', 'Suspendisse accumsan tortor quis turpis.', '33');
insert into coop_connect.job_position (id, title, description, still_accepting, num_applicants, postedAt, updatedAt, location, desired_skills, targeted_majors, company_id) values (37, 'Operator', 'Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum.', true, 77, '11/14/2024', '11/14/2024', 'Boston', 'User Interface Design', 'Aenean fermentum.', '30');
insert into coop_connect.job_position (id, title, description, still_accepting, num_applicants, postedAt, updatedAt, location, desired_skills, targeted_majors, company_id) values (38, 'VP Marketing', 'Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla.', false, 56, '9/26/2024', '11/20/2024', 'Boston', 'IRI', 'Duis consequat dui nec nisi volutpat eleifend.', '37');
insert into coop_connect.job_position (id, title, description, still_accepting, num_applicants, postedAt, updatedAt, location, desired_skills, targeted_majors, company_id) values (39, 'Pharmacist', 'Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.', false, 96, '10/8/2024', '12/13/2024', 'Los Angeles', 'NRF', 'Praesent blandit lacinia erat.', '21');
insert into coop_connect.job_position (id, title, description, still_accepting, num_applicants, postedAt, updatedAt, location, desired_skills, targeted_majors, company_id) values (40, 'Physical Therapy Assistant', 'In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.', false, 33, '11/10/2024', '11/10/2024', 'Boston', 'Zines', 'In hac habitasse platea dictumst.', '3');

-- Student table data
insert into coop_connect.student (id, name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values (1, 'Sisely Duley', 'sduley0@hatena.ne.jp', 3.33, 1, 2028, '36', '28', '33');
insert into coop_connect.student (id, name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values (2, 'Chen Chalfont', 'cchalfont1@foxnews.com', 2.04, 2, 2026, '2', '6', '28');
insert into coop_connect.student (id, name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values (3, 'Justina McQueen', 'jmcqueen2@bigcartel.com', 1.95, 3, 2028, '9', '5', '2');
insert into coop_connect.student (id, name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values (4, 'Gertie Roskell', 'groskell3@fotki.com', 3.64, 4, 2026, '12', '15', '1');
insert into coop_connect.student (id, name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values (5, 'Max Banbury', 'mbanbury4@sourceforge.net', 1.65, 5, 2027, '30', '1', '13');
insert into coop_connect.student (id, name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values (6, 'Sonnie Harlin', 'sharlin5@soup.io', 3.75, 6, 2027, '6', '22', '35');
insert into coop_connect.student (id, name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values (7, 'Lind Pally', 'lpally6@examiner.com', 3.5, 7, 2025, '18', '36', '37');
insert into coop_connect.student (id, name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values (8, 'Gusty Murty', 'gmurty7@meetup.com', 2.7, 8, 2025, '19', '13', '19');
insert into coop_connect.student (id, name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values (9, 'Minetta Neward', 'mneward8@163.com', 3.23, 9, 2027, '3', '37', '17');
insert into coop_connect.student (id, name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values (10, 'Josy Groucutt', 'jgroucutt9@blog.com', 2.3, 10, 2026, '29', '38', '8');
insert into coop_connect.student (id, name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values (11, 'Jillane Tottle', 'jtottlea@aboutads.info', 3.7, 11, 2026, '37', '33', '26');
insert into coop_connect.student (id, name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values (12, 'Virgina Neal', 'vnealb@oakley.com', 1.99, 12, 2027, '16', '14', '11');
insert into coop_connect.student (id, name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values (13, 'Stevena Limpertz', 'slimpertzc@imdb.com', 3.78, 13, 2028, '1', '26', '4');
insert into coop_connect.student (id, name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values (14, 'Alon Reignould', 'areignouldd@so-net.ne.jp', 2.55, 14, 2025, '11', '34', '38');
insert into coop_connect.student (id, name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values (15, 'Ceil Bruneau', 'cbruneaue@newyorker.com', 1.19, 15, 2025, '40', '12', '21');
insert into coop_connect.student (id, name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values (16, 'Yancey Eastham', 'yeasthamf@networksolutions.com', 1.37, 16, 2025, '24', '23', '29');
insert into coop_connect.student (id, name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values (17, 'Dore Twiname', 'dtwinameg@com.com', 3.93, 17, 2025, '28', '8', '24');
insert into coop_connect.student (id, name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values (18, 'Jakie Breslauer', 'jbreslauerh@amazon.co.jp', 2.17, 18, 2025, '4', '2', '14');
insert into coop_connect.student (id, name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values (19, 'Calv Sullens', 'csullensi@alibaba.com', 3.53, 19, 2028, '33', '39', '39');
insert into coop_connect.student (id, name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values (20, 'Tallulah Peasee', 'tpeaseej@csmonitor.com', 3.7, 20, 2028, '14', '18', '30');
insert into coop_connect.student (id, name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values (21, 'Granthem Harkins', 'gharkinsk@bloglines.com', 1.57, 21, 2025, '22', '17', '27');
insert into coop_connect.student (id, name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values (22, 'Brigitta Audus', 'baudusl@howstuffworks.com', 2.88, 22, 2026, '26', '9', '6');
insert into coop_connect.student (id, name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values (23, 'Rozalie Koomar', 'rkoomarm@lulu.com', 2.94, 23, 2027, '10', '20', '7');
insert into coop_connect.student (id, name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values (24, 'Lynde Smidmore', 'lsmidmoren@bloomberg.com', 2.14, 24, 2027, '35', '19', '34');
insert into coop_connect.student (id, name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values (25, 'Madlen Shrimptone', 'mshrimptoneo@merriam-webster.com', 2.27, 25, 2026, '38', '30', '9');
insert into coop_connect.student (id, name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values (26, 'Vittoria Jozsa', 'vjozsap@zimbio.com', 3.94, 26, 2027, '15', '35', '32');
insert into coop_connect.student (id, name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values (27, 'Sheena Bussetti', 'sbussettiq@nhs.uk', 3.85, 27, 2028, '21', '40', '16');
insert into coop_connect.student (id, name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values (28, 'Jewelle Hortop', 'jhortopr@shareasale.com', 3.8, 28, 2025, '25', '32', '31');
insert into coop_connect.student (id, name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values (29, 'Joseph Daveren', 'jdaverens@delicious.com', 3.98, 29, 2028, '23', '16', '23');
insert into coop_connect.student (id, name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values (30, 'Lev Gomery', 'lgomeryt@pbs.org', 2.73, 30, 2025, '39', '3', '25');
insert into coop_connect.student (id, name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values (31, 'Tommie Sparks', 'tsparksu@plala.or.jp', 1.41, 31, 2028, '31', '29', '12');
insert into coop_connect.student (id, name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values (32, 'Ephraim Benettelli', 'ebenettelliv@samsung.com', 3.72, 32, 2028, '8', '10', '15');
insert into coop_connect.student (id, name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values (33, 'Maisey Kahn', 'mkahnw@businessweek.com', 2.34, 33, 2028, '5', '31', '36');
insert into coop_connect.student (id, name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values (34, 'Enid Lavalde', 'elavaldex@yellowbook.com', 1.46, 34, 2026, '20', '24', '22');
insert into coop_connect.student (id, name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values (35, 'Lothario Duffin', 'lduffiny@canalblog.com', 2.98, 35, 2026, '13', '21', '10');
insert into coop_connect.student (id, name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values (36, 'Oralle Urey', 'oureyz@cbc.ca', 1.58, 36, 2025, '27', '4', '3');
insert into coop_connect.student (id, name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values (37, 'Kari Leftbridge', 'kleftbridge10@photobucket.com', 2.56, 37, 2027, '32', '27', '18');
insert into coop_connect.student (id, name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values (38, 'Tedra Broy', 'tbroy11@disqus.com', 1.45, 38, 2026, '34', '11', '5');
insert into coop_connect.student (id, name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values (39, 'Ramonda Mincini', 'rmincini12@alibaba.com', 3.23, 39, 2025, '7', '25', '40');
insert into coop_connect.student (id, name, email, gpa, major_id, grad_year, advised_by, hired_by, past_job) values (40, 'Bibi Branson', 'bbranson13@goodreads.com', 2.27, 40, 2025, '17', '7', '20');

-- Bridge table data
insert into coop_connect.student_past_job (student_id, job_position_id) values ('38', '19');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('35', '29');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('40', '13');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('38', '15');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('35', '28');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('40', '19');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('3', '12');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('30', '30');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('5', '1');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('14', '13');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('10', '23');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('23', '27');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('31', '8');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('39', '37');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('37', '25');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('15', '7');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('21', '17');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('28', '20');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('7', '21');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('17', '14');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('29', '34');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('16', '6');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('6', '3');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('32', '32');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('27', '4');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('20', '9');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('26', '24');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('11', '40');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('4', '35');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('9', '33');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('34', '39');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('8', '2');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('25', '38');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('2', '16');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('13', '22');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('24', '29');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('22', '31');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('18', '26');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('19', '10');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('1', '36');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('33', '5');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('36', '11');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('12', '18');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('7', '37');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('35', '1');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('39', '35');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('19', '30');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('25', '12');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('15', '33');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('13', '24');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('31', '26');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('3', '5');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('37', '16');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('9', '40');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('5', '13');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('27', '3');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('10', '17');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('40', '32');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('32', '21');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('4', '4');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('20', '6');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('17', '36');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('8', '29');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('36', '25');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('21', '8');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('18', '20');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('30', '27');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('14', '38');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('26', '23');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('6', '2');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('22', '7');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('24', '14');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('2', '10');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('23', '22');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('29', '18');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('16', '9');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('11', '39');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('33', '34');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('12', '28');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('34', '31');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('1', '19');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('28', '11');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('10', '22');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('27', '26');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('3', '14');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('8', '13');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('26', '34');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('14', '27');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('38', '18');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('18', '37');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('25', '7');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('5', '4');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('23', '36');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('1', '24');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('4', '23');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('7', '32');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('15', '9');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('11', '11');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('32', '2');
insert into coop_connect.student_past_job (student_id, job_position_id) values ('12', '39');

-- Review table data
insert into coop_connect.review (id, rating, review, student_id, job_position_id) values (1, 1.3, 'Cras pellentesque volutpat dui.', '28', '16');
insert into coop_connect.review (id, rating, review, student_id, job_position_id) values (2, 2.4, 'Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum.', '37', '33');
insert into coop_connect.review (id, rating, review, student_id, job_position_id) values (3, 4.4, 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla.', '27', '9');
insert into coop_connect.review (id, rating, review, student_id, job_position_id) values (4, 3.6, 'Praesent id massa id nisl venenatis lacinia.', '22', '32');
insert into coop_connect.review (id, rating, review, student_id, job_position_id) values (5, 3.1, 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.', '18', '14');
insert into coop_connect.review (id, rating, review, student_id, job_position_id) values (6, 2.5, 'Vivamus tortor.', '8', '38');
insert into coop_connect.review (id, rating, review, student_id, job_position_id) values (7, 3.1, 'Suspendisse potenti.', '14', '2');
insert into coop_connect.review (id, rating, review, student_id, job_position_id) values (8, 1.2, 'Integer a nibh. In quis justo.', '39', '13');
insert into coop_connect.review (id, rating, review, student_id, job_position_id) values (9, 4.0, 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti.', '19', '8');
insert into coop_connect.review (id, rating, review, student_id, job_position_id) values (10, 3.3, 'Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero. Nullam sit amet turpis elementum ligula vehicula consequat.', '13', '30');
insert into coop_connect.review (id, rating, review, student_id, job_position_id) values (11, 1.6, 'Cras in purus eu magna vulputate luctus.', '33', '15');
insert into coop_connect.review (id, rating, review, student_id, job_position_id) values (12, 4.0, 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit.', '38', '27');
insert into coop_connect.review (id, rating, review, student_id, job_position_id) values (13, 1.4, 'Nullam sit amet turpis elementum ligula vehicula consequat.', '34', '35');
insert into coop_connect.review (id, rating, review, student_id, job_position_id) values (14, 3.9, 'In sagittis dui vel nisl.', '26', '29');
insert into coop_connect.review (id, rating, review, student_id, job_position_id) values (15, 3.9, 'Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.', '12', '11');
insert into coop_connect.review (id, rating, review, student_id, job_position_id) values (16, 2.0, 'Sed vel enim sit amet nunc viverra dapibus.', '35', '39');
insert into coop_connect.review (id, rating, review, student_id, job_position_id) values (17, 2.1, 'In congue. Etiam justo. Etiam pretium iaculis justo.', '7', '4');
insert into coop_connect.review (id, rating, review, student_id, job_position_id) values (18, 4.4, 'Mauris lacinia sapien quis libero.', '31', '40');
insert into coop_connect.review (id, rating, review, student_id, job_position_id) values (19, 1.9, 'Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.', '5', '37');
insert into coop_connect.review (id, rating, review, student_id, job_position_id) values (20, 1.0, 'Morbi a ipsum. Integer a nibh. In quis justo.', '36', '3');
insert into coop_connect.review (id, rating, review, student_id, job_position_id) values (21, 1.8, 'Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum.', '25', '34');
insert into coop_connect.review (id, rating, review, student_id, job_position_id) values (22, 3.2, 'Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue.', '15', '20');
insert into coop_connect.review (id, rating, review, student_id, job_position_id) values (23, 3.4, 'Sed sagittis.', '17', '1');
insert into coop_connect.review (id, rating, review, student_id, job_position_id) values (24, 3.0, 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis.', '6', '22');
insert into coop_connect.review (id, rating, review, student_id, job_position_id) values (25, 4.8, 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.', '1', '25');
insert into coop_connect.review (id, rating, review, student_id, job_position_id) values (26, 4.1, 'Phasellus sit amet erat. Nulla tempus.', '11', '12');
insert into coop_connect.review (id, rating, review, student_id, job_position_id) values (27, 3.9, 'Donec ut mauris eget massa tempor convallis.', '10', '31');
insert into coop_connect.review (id, rating, review, student_id, job_position_id) values (28, 2.6, 'Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien.', '4', '6');
insert into coop_connect.review (id, rating, review, student_id, job_position_id) values (29, 1.3, 'In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl.', '20', '5');
insert into coop_connect.review (id, rating, review, student_id, job_position_id) values (30, 3.5, 'Curabitur at ipsum ac tellus semper interdum.', '40', '24');
insert into coop_connect.review (id, rating, review, student_id, job_position_id) values (31, 2.5, 'Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', '21', '28');
insert into coop_connect.review (id, rating, review, student_id, job_position_id) values (32, 3.4, 'Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam.', '29', '21');
insert into coop_connect.review (id, rating, review, student_id, job_position_id) values (33, 2.8, 'Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla.', '3', '19');
insert into coop_connect.review (id, rating, review, student_id, job_position_id) values (34, 4.6, 'Integer tincidunt ante vel ipsum.', '16', '26');
insert into coop_connect.review (id, rating, review, student_id, job_position_id) values (35, 2.5, 'Pellentesque ultrices mattis odio.', '23', '23');
insert into coop_connect.review (id, rating, review, student_id, job_position_id) values (36, 3.9, 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.', '30', '36');
insert into coop_connect.review (id, rating, review, student_id, job_position_id) values (37, 2.3, 'Quisque id justo sit amet sapien dignissim vestibulum.', '24', '17');
insert into coop_connect.review (id, rating, review, student_id, job_position_id) values (38, 2.6, 'Donec semper sapien a libero.', '2', '18');
insert into coop_connect.review (id, rating, review, student_id, job_position_id) values (39, 4.1, 'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc.', '32', '10');
insert into coop_connect.review (id, rating, review, student_id, job_position_id) values (40, 4.7, 'In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.', '9', '7');

-- Interview question table data
insert into coop_connect.interview_question (id, question, job_position_id, author_id) values (1, 'Donec dapibus. Duis at velit eu est congue elementum.', '38', '40');
insert into coop_connect.interview_question (id, question, job_position_id, author_id) values (2, 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue.', '35', '12');
insert into coop_connect.interview_question (id, question, job_position_id, author_id) values (3, 'Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci.', '31', '4');
insert into coop_connect.interview_question (id, question, job_position_id, author_id) values (4, 'Quisque ut erat.', '29', '22');
insert into coop_connect.interview_question (id, question, job_position_id, author_id) values (5, 'Ut tellus. Nulla ut erat id mauris vulputate elementum.', '6', '33');
insert into coop_connect.interview_question (id, question, job_position_id, author_id) values (6, 'Duis bibendum. Morbi non quam nec dui luctus rutrum.', '11', '18');
insert into coop_connect.interview_question (id, question, job_position_id, author_id) values (7, 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien.', '20', '3');
insert into coop_connect.interview_question (id, question, job_position_id, author_id) values (8, 'Duis at velit eu est congue elementum. In hac habitasse platea dictumst.', '8', '20');
insert into coop_connect.interview_question (id, question, job_position_id, author_id) values (9, 'Nullam porttitor lacus at turpis.', '40', '38');
insert into coop_connect.interview_question (id, question, job_position_id, author_id) values (10, 'Maecenas ut massa quis augue luctus tincidunt.', '33', '32');
insert into coop_connect.interview_question (id, question, job_position_id, author_id) values (11, 'Proin interdum mauris non ligula pellentesque ultrices.', '37', '14');
insert into coop_connect.interview_question (id, question, job_position_id, author_id) values (12, 'Praesent blandit. Nam nulla.', '24', '9');
insert into coop_connect.interview_question (id, question, job_position_id, author_id) values (13, 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi.', '34', '25');
insert into coop_connect.interview_question (id, question, job_position_id, author_id) values (14, 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.', '25', '13');
insert into coop_connect.interview_question (id, question, job_position_id, author_id) values (15, 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo.', '28', '35');
insert into coop_connect.interview_question (id, question, job_position_id, author_id) values (16, 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy.', '32', '30');
insert into coop_connect.interview_question (id, question, job_position_id, author_id) values (17, 'Integer ac leo.', '39', '2');
insert into coop_connect.interview_question (id, question, job_position_id, author_id) values (18, 'Mauris sit amet eros.', '26', '5');
insert into coop_connect.interview_question (id, question, job_position_id, author_id) values (19, 'Sed ante. Vivamus tortor.', '27', '8');
insert into coop_connect.interview_question (id, question, job_position_id, author_id) values (20, 'Nullam molestie nibh in lectus. Pellentesque at nulla.', '22', '6');
insert into coop_connect.interview_question (id, question, job_position_id, author_id) values (21, 'Donec semper sapien a libero.', '10', '21');
insert into coop_connect.interview_question (id, question, job_position_id, author_id) values (22, 'Nulla justo. Aliquam quis turpis eget elit sodales scelerisque.', '19', '15');
insert into coop_connect.interview_question (id, question, job_position_id, author_id) values (23, 'In hac habitasse platea dictumst.', '12', '7');
insert into coop_connect.interview_question (id, question, job_position_id, author_id) values (24, 'Duis aliquam convallis nunc.', '21', '27');
insert into coop_connect.interview_question (id, question, job_position_id, author_id) values (25, 'Aliquam erat volutpat.', '7', '34');
insert into coop_connect.interview_question (id, question, job_position_id, author_id) values (26, 'Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.', '14', '24');
insert into coop_connect.interview_question (id, question, job_position_id, author_id) values (27, 'Nullam molestie nibh in lectus. Pellentesque at nulla.', '30', '17');
insert into coop_connect.interview_question (id, question, job_position_id, author_id) values (28, 'Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla.', '17', '29');
insert into coop_connect.interview_question (id, question, job_position_id, author_id) values (29, 'In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt.', '23', '37');
insert into coop_connect.interview_question (id, question, job_position_id, author_id) values (30, 'In eleifend quam a odio.', '5', '36');
insert into coop_connect.interview_question (id, question, job_position_id, author_id) values (31, 'Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo.', '15', '26');
insert into coop_connect.interview_question (id, question, job_position_id, author_id) values (32, 'Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.', '3', '23');
insert into coop_connect.interview_question (id, question, job_position_id, author_id) values (33, 'In sagittis dui vel nisl. Duis ac nibh.', '4', '1');
insert into coop_connect.interview_question (id, question, job_position_id, author_id) values (34, 'Praesent blandit lacinia erat.', '18', '11');
insert into coop_connect.interview_question (id, question, job_position_id, author_id) values (35, 'Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam. Nam tristique tortor eu pede.', '13', '10');
insert into coop_connect.interview_question (id, question, job_position_id, author_id) values (36, 'Sed ante.', '2', '16');
insert into coop_connect.interview_question (id, question, job_position_id, author_id) values (37, 'In sagittis dui vel nisl.', '9', '31');
insert into coop_connect.interview_question (id, question, job_position_id, author_id) values (38, 'Sed ante.', '1', '39');
insert into coop_connect.interview_question (id, question, job_position_id, author_id) values (39, 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien.', '16', '19');
insert into coop_connect.interview_question (id, question, job_position_id, author_id) values (40, 'Integer a nibh.', '36', '28');

-- Application table data
insert into coop_connect.application (id, applicant_id, job_position_id, status, applied_at) values (1, '5', '10', 'Accepted', '10/30/2024');
insert into coop_connect.application (id, applicant_id, job_position_id, status, applied_at) values (2, '11', '31', 'Rejected', '10/17/2024');
insert into coop_connect.application (id, applicant_id, job_position_id, status, applied_at) values (3, '26', '13', 'Pending', '11/30/2024');
insert into coop_connect.application (id, applicant_id, job_position_id, status, applied_at) values (4, '25', '15', 'Rejected', '10/15/2024');
insert into coop_connect.application (id, applicant_id, job_position_id, status, applied_at) values (5, '1', '6', 'Accepted', '10/25/2024');
insert into coop_connect.application (id, applicant_id, job_position_id, status, applied_at) values (6, '18', '32', 'Rejected', '11/13/2024');
insert into coop_connect.application (id, applicant_id, job_position_id, status, applied_at) values (7, '3', '3', 'Rejected', '10/24/2024');
insert into coop_connect.application (id, applicant_id, job_position_id, status, applied_at) values (8, '35', '9', 'Pending', '11/18/2024');
insert into coop_connect.application (id, applicant_id, job_position_id, status, applied_at) values (9, '32', '24', 'Rejected', '11/17/2024');
insert into coop_connect.application (id, applicant_id, job_position_id, status, applied_at) values (10, '4', '7', 'Rejected', '12/2/2024');
insert into coop_connect.application (id, applicant_id, job_position_id, status, applied_at) values (11, '16', '39', 'Rejected', '12/1/2024');
insert into coop_connect.application (id, applicant_id, job_position_id, status, applied_at) values (12, '7', '36', 'Accepted', '12/1/2024');
insert into coop_connect.application (id, applicant_id, job_position_id, status, applied_at) values (13, '34', '20', 'Pending', '11/16/2024');
insert into coop_connect.application (id, applicant_id, job_position_id, status, applied_at) values (14, '36', '16', 'Accepted', '11/18/2024');
insert into coop_connect.application (id, applicant_id, job_position_id, status, applied_at) values (15, '12', '38', 'Accepted', '11/7/2024');
insert into coop_connect.application (id, applicant_id, job_position_id, status, applied_at) values (16, '33', '28', 'Accepted', '10/13/2024');
insert into coop_connect.application (id, applicant_id, job_position_id, status, applied_at) values (17, '37', '17', 'Accepted', '10/26/2024');
insert into coop_connect.application (id, applicant_id, job_position_id, status, applied_at) values (18, '24', '5', 'Pending', '11/28/2024');
insert into coop_connect.application (id, applicant_id, job_position_id, status, applied_at) values (19, '19', '26', 'Accepted', '11/5/2024');
insert into coop_connect.application (id, applicant_id, job_position_id, status, applied_at) values (20, '39', '14', 'Rejected', '11/22/2024');
insert into coop_connect.application (id, applicant_id, job_position_id, status, applied_at) values (21, '6', '35', 'Rejected', '11/30/2024');
insert into coop_connect.application (id, applicant_id, job_position_id, status, applied_at) values (22, '14', '33', 'Pending', '10/24/2024');
insert into coop_connect.application (id, applicant_id, job_position_id, status, applied_at) values (23, '20', '4', 'Accepted', '11/20/2024');
insert into coop_connect.application (id, applicant_id, job_position_id, status, applied_at) values (24, '9', '11', 'Rejected', '10/30/2024');
insert into coop_connect.application (id, applicant_id, job_position_id, status, applied_at) values (25, '22', '2', 'Rejected', '10/2/2024');
insert into coop_connect.application (id, applicant_id, job_position_id, status, applied_at) values (26, '21', '25', 'Rejected', '11/4/2024');
insert into coop_connect.application (id, applicant_id, job_position_id, status, applied_at) values (27, '31', '29', 'Rejected', '11/28/2024');
insert into coop_connect.application (id, applicant_id, job_position_id, status, applied_at) values (28, '8', '22', 'Pending', '11/21/2024');
insert into coop_connect.application (id, applicant_id, job_position_id, status, applied_at) values (29, '40', '34', 'Accepted', '10/23/2024');
insert into coop_connect.application (id, applicant_id, job_position_id, status, applied_at) values (30, '23', '21', 'Accepted', '11/1/2024');
insert into coop_connect.application (id, applicant_id, job_position_id, status, applied_at) values (31, '15', '19', 'Rejected', '11/3/2024');
insert into coop_connect.application (id, applicant_id, job_position_id, status, applied_at) values (32, '10', '40', 'Accepted', '10/29/2024');
insert into coop_connect.application (id, applicant_id, job_position_id, status, applied_at) values (33, '27', '23', 'Rejected', '10/29/2024');
insert into coop_connect.application (id, applicant_id, job_position_id, status, applied_at) values (34, '2', '8', 'Pending', '10/31/2024');
insert into coop_connect.application (id, applicant_id, job_position_id, status, applied_at) values (35, '28', '27', 'Pending', '10/28/2024');
insert into coop_connect.application (id, applicant_id, job_position_id, status, applied_at) values (36, '17', '30', 'Accepted', '11/13/2024');
insert into coop_connect.application (id, applicant_id, job_position_id, status, applied_at) values (37, '13', '37', 'Rejected', '10/9/2024');
insert into coop_connect.application (id, applicant_id, job_position_id, status, applied_at) values (38, '30', '12', 'Pending', '11/30/2024');
insert into coop_connect.application (id, applicant_id, job_position_id, status, applied_at) values (39, '38', '1', 'Rejected', '10/28/2024');
insert into coop_connect.application (id, applicant_id, job_position_id, status, applied_at) values (40, '29', '18', 'Accepted', '10/1/2024');
