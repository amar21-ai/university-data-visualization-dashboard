-- ============================================
-- UNIVERSITY DASHBOARD DATABASE
-- Complete SQL Script for MySQL/MariaDB
-- ============================================

-- Create Database
CREATE DATABASE IF NOT EXISTS university_dashboard;
USE university_dashboard;

-- ============================================
-- TABLE 1: STUDENTS
-- ============================================
CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(50) NOT NULL,
    enrollment_year INT NOT NULL,
    gpa DECIMAL(3,2),
    gender ENUM('Male', 'Female') NOT NULL,
    is_international BOOLEAN DEFAULT FALSE,
    date_of_birth DATE,
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- TABLE 2: PROFESSORS
-- ============================================
CREATE TABLE professors (
    professor_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(50) NOT NULL,
    position ENUM('Full Professor', 'Associate Professor', 'Assistant Professor', 'Lecturer') NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    years_experience INT,
    email VARCHAR(100),
    hire_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- TABLE 3: COURSES
-- ============================================
CREATE TABLE courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(150) NOT NULL,
    course_code VARCHAR(20) UNIQUE NOT NULL,
    department VARCHAR(50) NOT NULL,
    credits INT DEFAULT 3,
    enrolled_students INT DEFAULT 0,
    max_capacity INT DEFAULT 100,
    professor_id INT,
    rating DECIMAL(2,1),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (professor_id) REFERENCES professors(professor_id) ON DELETE SET NULL
);

-- ============================================
-- TABLE 4: ENROLLMENTS
-- ============================================
CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE NOT NULL,
    grade VARCHAR(2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE
);

-- ============================================
-- TABLE 5: FEES
-- ============================================
CREATE TABLE fees (
    fee_id INT PRIMARY KEY AUTO_INCREMENT,
    program_type ENUM('Undergraduate', 'Graduate', 'PhD', 'Certificate') NOT NULL,
    annual_fee DECIMAL(10,2) NOT NULL,
    semester_fee DECIMAL(10,2) NOT NULL,
    academic_year VARCHAR(10) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- TABLE 6: RESEARCH PUBLICATIONS
-- ============================================
CREATE TABLE research_publications (
    publication_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    professor_id INT NOT NULL,
    department VARCHAR(50) NOT NULL,
    publication_year INT NOT NULL,
    citations INT DEFAULT 0,
    journal_name VARCHAR(150),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (professor_id) REFERENCES professors(professor_id) ON DELETE CASCADE
);

-- ============================================
-- TABLE 7: DEPARTMENTS
-- ============================================
CREATE TABLE departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(50) UNIQUE NOT NULL,
    budget DECIMAL(12,2),
    building_location VARCHAR(100),
    head_professor_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (head_professor_id) REFERENCES professors(professor_id) ON DELETE SET NULL
);

-- ============================================
-- TABLE 8: GRADUATE EMPLOYMENT
-- ============================================
CREATE TABLE graduate_employment (
    employment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    graduation_year INT NOT NULL,
    employment_status ENUM('Employed', 'Unemployed', 'Further Study', 'Unknown') DEFAULT 'Unknown',
    sector VARCHAR(50),
    starting_salary DECIMAL(10,2),
    company_name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE
);

-- ============================================
-- INSERT SAMPLE DATA - DEPARTMENTS
-- ============================================
INSERT INTO departments (department_name, budget, building_location) VALUES
('Engineering', 5000000.00, 'North Campus Building A'),
('Science', 4500000.00, 'Science Complex'),
('Business', 3500000.00, 'Business School Tower'),
('Arts', 2800000.00, 'Humanities Building'),
('Medicine', 6000000.00, 'Medical Center');

-- ============================================
-- INSERT SAMPLE DATA - PROFESSORS
-- ============================================
INSERT INTO professors (name, department, position, salary, years_experience, hire_date) VALUES
('Dr. Robert Smith', 'Engineering', 'Full Professor', 125000.00, 25, '1999-09-01'),
('Dr. Jennifer Brown', 'Science', 'Full Professor', 128000.00, 22, '2002-08-15'),
('Dr. Michael Johnson', 'Business', 'Associate Professor', 95000.00, 15, '2009-01-10'),
('Dr. Sarah Williams', 'Arts', 'Associate Professor', 92000.00, 12, '2012-09-01'),
('Dr. David Jones', 'Medicine', 'Full Professor', 135000.00, 28, '1996-07-01'),
('Dr. Emily Davis', 'Engineering', 'Assistant Professor', 72000.00, 5, '2019-08-20'),
('Dr. James Miller', 'Science', 'Associate Professor', 98000.00, 14, '2010-01-15'),
('Dr. Maria Wilson', 'Business', 'Assistant Professor', 75000.00, 6, '2018-09-01'),
('Dr. John Moore', 'Arts', 'Full Professor', 115000.00, 20, '2004-08-25'),
('Dr. Lisa Taylor', 'Medicine', 'Associate Professor', 105000.00, 16, '2008-07-01'),
('Dr. Richard Anderson', 'Engineering', 'Full Professor', 130000.00, 24, '2000-09-01'),
('Dr. Patricia Thomas', 'Science', 'Assistant Professor', 74000.00, 4, '2020-08-15'),
('Dr. Christopher Jackson', 'Business', 'Full Professor', 120000.00, 19, '2005-01-10'),
('Dr. Barbara White', 'Arts', 'Assistant Professor', 70000.00, 3, '2021-09-01'),
('Dr. Daniel Harris', 'Medicine', 'Associate Professor', 108000.00, 17, '2007-07-15');

-- ============================================
-- INSERT SAMPLE DATA - STUDENTS
-- ============================================
INSERT INTO students (name, department, enrollment_year, gpa, gender, is_international, date_of_birth) VALUES
('John Smith', 'Engineering', 2024, 3.45, 'Male', FALSE, '2002-05-15'),
('Jane Doe', 'Science', 2024, 3.82, 'Female', FALSE, '2003-08-22'),
('Ahmed Ali', 'Engineering', 2023, 3.67, 'Male', TRUE, '2001-11-10'),
('Maria Garcia', 'Business', 2024, 3.51, 'Female', TRUE, '2002-03-18'),
('David Lee', 'Science', 2023, 3.78, 'Male', FALSE, '2002-07-25'),
('Sarah Johnson', 'Arts', 2024, 3.92, 'Female', FALSE, '2003-01-30'),
('Michael Brown', 'Medicine', 2023, 3.88, 'Male', FALSE, '2001-09-12'),
('Emma Wilson', 'Engineering', 2022, 3.55, 'Female', FALSE, '2000-12-05'),
('James Taylor', 'Business', 2024, 3.41, 'Male', FALSE, '2003-04-20'),
('Olivia Martinez', 'Science', 2023, 3.73, 'Female', TRUE, '2002-06-08'),
('William Anderson', 'Engineering', 2024, 3.62, 'Male', FALSE, '2002-10-15'),
('Sophia Thomas', 'Arts', 2023, 3.85, 'Female', FALSE, '2001-02-28'),
('Robert Jackson', 'Medicine', 2024, 3.91, 'Male', TRUE, '2003-07-14'),
('Isabella White', 'Science', 2022, 3.68, 'Female', FALSE, '2000-11-22'),
('Christopher Harris', 'Business', 2024, 3.47, 'Male', FALSE, '2003-05-09'),
('Mia Martin', 'Engineering', 2023, 3.76, 'Female', FALSE, '2002-08-17'),
('Daniel Thompson', 'Arts', 2024, 3.59, 'Male', FALSE, '2003-03-25'),
('Emily Garcia', 'Medicine', 2023, 3.94, 'Female', TRUE, '2001-10-30'),
('Matthew Robinson', 'Science', 2024, 3.71, 'Male', FALSE, '2002-12-11'),
('Abigail Clark', 'Business', 2022, 3.53, 'Female', FALSE, '2000-06-19'),
('Andrew Rodriguez', 'Engineering', 2024, 3.64, 'Male', TRUE, '2003-09-05'),
('Elizabeth Lewis', 'Arts', 2023, 3.87, 'Female', FALSE, '2001-04-12'),
('Joshua Lee', 'Medicine', 2024, 3.89, 'Male', FALSE, '2003-11-28'),
('Charlotte Walker', 'Science', 2023, 3.66, 'Female', FALSE, '2002-01-16'),
('Ryan Hall', 'Business', 2024, 3.49, 'Male', FALSE, '2003-07-23'),
('Amelia Allen', 'Engineering', 2022, 3.72, 'Female', TRUE, '2000-10-07'),
('Alexander Young', 'Science', 2024, 3.81, 'Male', FALSE, '2002-05-14'),
('Harper King', 'Arts', 2023, 3.58, 'Female', FALSE, '2001-08-21'),
('Ethan Wright', 'Medicine', 2024, 3.93, 'Male', FALSE, '2003-02-18'),
('Evelyn Lopez', 'Business', 2023, 3.44, 'Female', TRUE, '2002-09-25'),
('Benjamin Hill', 'Engineering', 2024, 3.69, 'Male', FALSE, '2002-12-03'),
('Avery Scott', 'Science', 2023, 3.74, 'Female', FALSE, '2001-06-29'),
('Lucas Green', 'Arts', 2024, 3.61, 'Male', TRUE, '2003-10-15'),
('Ella Adams', 'Medicine', 2022, 3.86, 'Female', FALSE, '2000-03-22'),
('Henry Baker', 'Business', 2024, 3.52, 'Male', FALSE, '2003-08-08'),
('Scarlett Nelson', 'Engineering', 2023, 3.77, 'Female', FALSE, '2002-11-12'),
('Sebastian Carter', 'Science', 2024, 3.70, 'Male', TRUE, '2003-04-27'),
('Grace Mitchell', 'Arts', 2023, 3.83, 'Female', FALSE, '2001-07-19'),
('Jack Perez', 'Medicine', 2024, 3.90, 'Male', FALSE, '2003-01-06'),
('Chloe Roberts', 'Business', 2023, 3.48, 'Female', TRUE, '2002-10-14');

-- ============================================
-- INSERT SAMPLE DATA - COURSES
-- ============================================
INSERT INTO courses (course_name, course_code, department, credits, enrolled_students, max_capacity, professor_id, rating) VALUES
('Introduction to Artificial Intelligence', 'CS401', 'Engineering', 4, 850, 1000, 1, 4.7),
('Data Structures and Algorithms', 'CS301', 'Engineering', 3, 780, 800, 6, 4.5),
('Business Strategy and Management', 'BUS302', 'Business', 3, 720, 750, 3, 4.6),
('Organic Chemistry I', 'CHEM201', 'Science', 4, 680, 700, 2, 4.3),
('Creative Writing Workshop', 'ENG305', 'Arts', 3, 650, 700, 4, 4.8),
('Machine Learning Fundamentals', 'CS501', 'Engineering', 4, 620, 650, 11, 4.9),
('Financial Accounting', 'ACC201', 'Business', 3, 580, 600, 8, 4.2),
('Human Anatomy and Physiology', 'MED101', 'Medicine', 5, 550, 600, 5, 4.6),
('Modern Literature', 'LIT301', 'Arts', 3, 520, 550, 9, 4.5),
('Quantum Physics', 'PHY401', 'Science', 4, 480, 500, 7, 4.4),
('Database Systems', 'CS302', 'Engineering', 3, 450, 500, 6, 4.3),
('Marketing Principles', 'MKT201', 'Business', 3, 420, 450, 13, 4.1),
('Calculus III', 'MATH301', 'Science', 4, 390, 400, 12, 4.0),
('Art History', 'ART201', 'Arts', 3, 360, 400, 14, 4.7),
('Medical Ethics', 'MED401', 'Medicine', 3, 340, 350, 10, 4.8);

-- ============================================
-- INSERT SAMPLE DATA - FEES
-- ============================================
INSERT INTO fees (program_type, annual_fee, semester_fee, academic_year) VALUES
('Undergraduate', 38000.00, 19000.00, '2024-2025'),
('Graduate', 48000.00, 24000.00, '2024-2025'),
('PhD', 52000.00, 26000.00, '2024-2025'),
('Certificate', 15000.00, 7500.00, '2024-2025'),
('Undergraduate', 36000.00, 18000.00, '2023-2024'),
('Graduate', 45000.00, 22500.00, '2023-2024'),
('PhD', 50000.00, 25000.00, '2023-2024'),
('Certificate', 14000.00, 7000.00, '2023-2024');

-- ============================================
-- INSERT SAMPLE DATA - RESEARCH PUBLICATIONS
-- ============================================
INSERT INTO research_publications (title, professor_id, department, publication_year, citations, journal_name) VALUES
('Advances in Neural Network Architecture', 1, 'Engineering', 2024, 145, 'IEEE Transactions on AI'),
('Quantum Computing Applications', 2, 'Science', 2024, 89, 'Nature Physics'),
('Sustainable Business Models', 3, 'Business', 2023, 67, 'Harvard Business Review'),
('Modern Art and Society', 4, 'Arts', 2024, 34, 'Art Quarterly'),
('Cancer Treatment Innovation', 5, 'Medicine', 2024, 203, 'The Lancet'),
('Machine Learning in Robotics', 11, 'Engineering', 2023, 178, 'Robotics Journal'),
('Climate Change Impact Studies', 7, 'Science', 2024, 112, 'Environmental Science'),
('Digital Marketing Trends', 13, 'Business', 2023, 45, 'Journal of Marketing'),
('Renaissance Literature Analysis', 9, 'Arts', 2024, 28, 'Literature Review'),
('Genetic Research Breakthrough', 10, 'Medicine', 2023, 256, 'Nature Medicine'),
('Deep Learning Optimization', 1, 'Engineering', 2023, 198, 'ACM Computing'),
('Particle Physics Discovery', 2, 'Science', 2023, 134, 'Physical Review'),
('Corporate Finance Strategies', 3, 'Business', 2024, 56, 'Finance Quarterly'),
('Contemporary Art Movements', 4, 'Arts', 2023, 41, 'Modern Arts'),
('Immunology Research', 5, 'Medicine', 2023, 187, 'Journal of Immunology');

-- ============================================
-- INSERT SAMPLE DATA - ENROLLMENTS
-- ============================================
INSERT INTO enrollments (student_id, course_id, enrollment_date, grade) VALUES
(1, 1, '2024-01-15', 'A'),
(1, 2, '2024-01-15', 'B+'),
(2, 4, '2024-01-15', 'A'),
(2, 10, '2024-01-15', 'A-'),
(3, 1, '2023-09-01', 'B'),
(3, 11, '2023-09-01', 'A'),
(4, 3, '2024-01-15', 'B+'),
(4, 7, '2024-01-15', 'A-'),
(5, 4, '2023-09-01', 'A'),
(6, 5, '2024-01-15', 'A+'),
(7, 8, '2023-09-01', 'A'),
(8, 2, '2022-09-01', 'B+'),
(9, 3, '2024-01-15', 'B'),
(10, 10, '2023-09-01', 'A-');

-- ============================================
-- INSERT SAMPLE DATA - GRADUATE EMPLOYMENT
-- ============================================
INSERT INTO graduate_employment (student_id, graduation_year, employment_status, sector, starting_salary, company_name) VALUES
(8, 2024, 'Employed', 'Technology', 95000.00, 'Google'),
(14, 2024, 'Employed', 'Healthcare', 72000.00, 'Mayo Clinic'),
(20, 2024, 'Employed', 'Finance', 88000.00, 'Goldman Sachs'),
(26, 2024, 'Further Study', 'Education', NULL, 'Stanford University'),
(34, 2024, 'Employed', 'Healthcare', 78000.00, 'Johns Hopkins');

-- ============================================
-- USEFUL VIEWS FOR DASHBOARD
-- ============================================

-- View: Student Statistics by Department
CREATE VIEW vw_students_by_department AS
SELECT 
    department,
    COUNT(*) as total_students,
    AVG(gpa) as avg_gpa,
    SUM(CASE WHEN is_international = TRUE THEN 1 ELSE 0 END) as international_students
FROM students
GROUP BY department;

-- View: Professor Statistics by Department
CREATE VIEW vw_professors_by_department AS
SELECT 
    department,
    COUNT(*) as total_professors,
    AVG(salary) as avg_salary,
    AVG(years_experience) as avg_experience
FROM professors
GROUP BY department;

-- View: Course Enrollment Statistics
CREATE VIEW vw_course_statistics AS
SELECT 
    c.course_name,
    c.department,
    c.enrolled_students,
    c.rating,
    p.name as professor_name
FROM courses c
LEFT JOIN professors p ON c.professor_id = p.professor_id
ORDER BY c.enrolled_students DESC;

-- View: Research Output by Department
CREATE VIEW vw_research_by_department AS
SELECT 
    department,
    COUNT(*) as total_publications,
    SUM(citations) as total_citations,
    publication_year
FROM research_publications
GROUP BY department, publication_year
ORDER BY publication_year DESC, total_publications DESC;

-- View: Employment Statistics
CREATE VIEW vw_employment_statistics AS
SELECT 
    sector,
    COUNT(*) as total_employed,
    AVG(starting_salary) as avg_salary
FROM graduate_employment
WHERE employment_status = 'Employed'
GROUP BY sector;

-- ============================================
-- INDEXES FOR PERFORMANCE
-- ============================================
CREATE INDEX idx_student_department ON students(department);
CREATE INDEX idx_student_year ON students(enrollment_year);
CREATE INDEX idx_professor_department ON professors(department);
CREATE INDEX idx_course_department ON courses(department);
CREATE INDEX idx_publication_year ON research_publications(publication_year);

-- ============================================
-- END OF SQL SCRIPT
-- ============================================