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