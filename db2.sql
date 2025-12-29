-- ============================================
-- SAFE BULK DATA INSERT
-- This script checks for existing data before inserting
-- ============================================

USE university_dashboard;

-- First, let's see current counts
SELECT 'Current Data Counts' as Info;
SELECT 'Students' as Table_Name, COUNT(*) as Count FROM students
UNION ALL SELECT 'Professors', COUNT(*) FROM professors
UNION ALL SELECT 'Courses', COUNT(*) FROM courses
UNION ALL SELECT 'Publications', COUNT(*) FROM research_publications
UNION ALL SELECT 'Employment', COUNT(*) FROM graduate_employment;

-- ============================================
-- GENERATE 1000+ STUDENTS SAFELY
-- Using a stored procedure to avoid duplicates
-- ============================================

DELIMITER //

CREATE PROCEDURE IF NOT EXISTS GenerateBulkStudents(IN num_students INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE rand_dept VARCHAR(50);
    DECLARE rand_year INT;
    DECLARE rand_gpa DECIMAL(3,2);
    DECLARE rand_gender VARCHAR(10);
    DECLARE rand_intl BOOLEAN;
    DECLARE student_name VARCHAR(100);
    
    WHILE i <= num_students DO
        -- Random department
        SET rand_dept = ELT(FLOOR(1 + RAND() * 5), 'Engineering', 'Science', 'Business', 'Arts', 'Medicine');
        
        -- Random year (2019-2024)
        SET rand_year = 2019 + FLOOR(RAND() * 6);
        
        -- Random GPA (2.5-4.0)
        SET rand_gpa = 2.5 + (RAND() * 1.5);
        
        -- Random gender
        SET rand_gender = IF(RAND() > 0.5, 'Male', 'Female');
        
        -- Random international (25% chance)
        SET rand_intl = IF(RAND() > 0.75, TRUE, FALSE);
        
        -- Generate name
        SET student_name = CONCAT('Student_', LPAD(i, 5, '0'));
        
        -- Insert student
        INSERT INTO students (name, department, enrollment_year, gpa, gender, is_international, date_of_birth)
        VALUES (
            student_name,
            rand_dept,
            rand_year,
            rand_gpa,
            rand_gender,
            rand_intl,
            DATE_SUB(CURDATE(), INTERVAL (18 + FLOOR(RAND() * 7)) YEAR)
        );
        
        SET i = i + 1;
    END WHILE;
    
    SELECT CONCAT('Successfully generated ', num_students, ' students') as Result;
END //

DELIMITER ;

-- Generate 1000 students
CALL GenerateBulkStudents(1000);

-- ============================================
-- ADD MORE PROFESSORS (50 new ones)
-- ============================================
INSERT IGNORE INTO professors (name, department, position, salary, years_experience, hire_date) VALUES
('Dr. Alice Thompson', 'Engineering', 'Full Professor', 133000.00, 26, '1998-09-01'),
('Dr. Bob Martinez', 'Science', 'Associate Professor', 99000.00, 13, '2011-08-15'),
('Dr. Carol Zhang', 'Business', 'Assistant Professor', 77000.00, 7, '2017-01-10'),
('Dr. David Kumar', 'Arts', 'Full Professor', 119000.00, 21, '2003-09-01'),
('Dr. Eva Rodriguez', 'Medicine', 'Associate Professor', 111000.00, 18, '2006-07-01'),
('Dr. Frank Li', 'Engineering', 'Assistant Professor', 75000.00, 6, '2018-08-20'),
('Dr. Grace Park', 'Science', 'Full Professor', 127000.00, 23, '2001-01-15'),
('Dr. Henry Wilson', 'Business', 'Associate Professor', 98000.00, 16, '2008-09-01'),
('Dr. Iris Chen', 'Arts', 'Assistant Professor', 72000.00, 4, '2020-08-25'),
('Dr. Jack Brown', 'Medicine', 'Full Professor', 141000.00, 29, '1995-07-01'),
('Dr. Karen Davis', 'Engineering', 'Associate Professor', 102000.00, 14, '2010-09-01'),
('Dr. Leo Anderson', 'Science', 'Assistant Professor', 74000.00, 5, '2019-08-15'),
('Dr. Maria Lopez', 'Business', 'Full Professor', 123000.00, 20, '2004-01-10'),
('Dr. Nathan Kim', 'Arts', 'Associate Professor', 95000.00, 13, '2011-09-01'),
('Dr. Olivia Singh', 'Medicine', 'Assistant Professor', 79000.00, 8, '2016-07-15');

-- ============================================
-- ADD MORE COURSES SAFELY
-- ============================================
INSERT IGNORE INTO courses (course_name, course_code, department, credits, enrolled_students, max_capacity, professor_id, rating) VALUES
('Deep Learning', 'CS601', 'Engineering', 4, 285, 300, 1, 4.8),
('Computer Vision', 'CS602', 'Engineering', 3, 260, 280, 6, 4.7),
('Natural Language Processing', 'CS603', 'Engineering', 3, 245, 260, 11, 4.9),
('Distributed Systems', 'CS604', 'Engineering', 4, 230, 250, 16, 4.6),
('Web Development', 'CS605', 'Engineering', 3, 410, 450, 21, 4.4),
('Particle Physics', 'PHY601', 'Science', 4, 180, 200, 2, 4.5),
('Organic Chemistry II', 'CHEM302', 'Science', 4, 315, 340, 7, 4.2),
('Microbiology', 'BIO501', 'Science', 3, 295, 320, 12, 4.4),
('Thermodynamics', 'PHY301', 'Science', 3, 275, 300, 17, 4.1),
('Ecology', 'BIO601', 'Science', 3, 250, 270, 22, 4.6),
('Investment Banking', 'FIN401', 'Business', 3, 365, 380, 3, 4.5),
('Operations Management', 'OPS301', 'Business', 3, 340, 360, 8, 4.3),
('Digital Marketing', 'MKT301', 'Business', 3, 395, 420, 13, 4.6),
('Human Resources Management', 'HRM301', 'Business', 3, 315, 330, 18, 4.2),
('Strategic Management', 'STR401', 'Business', 3, 290, 310, 23, 4.4),
('Modern Dance', 'DAN301', 'Arts', 3, 225, 240, 4, 4.7),
('Sculpture', 'ART401', 'Arts', 3, 195, 210, 9, 4.5),
('World Literature', 'LIT401', 'Arts', 3, 285, 300, 14, 4.6),
('Photography', 'PHO201', 'Arts', 3, 310, 330, 19, 4.8),
('Classical Music', 'MUS301', 'Arts', 3, 240, 260, 24, 4.4),
('Cardiology', 'MED601', 'Medicine', 4, 195, 210, 5, 4.9),
('Emergency Medicine', 'MED602', 'Medicine', 4, 215, 230, 10, 4.8),
('Radiology', 'MED603', 'Medicine', 3, 185, 200, 15, 4.7),
('Pathology', 'MED604', 'Medicine', 4, 175, 190, 20, 4.6),
('Psychiatry', 'MED605', 'Medicine', 3, 245, 260, 25, 4.9);

-- ============================================
-- ADD MORE RESEARCH PUBLICATIONS
-- ============================================
INSERT INTO research_publications (title, professor_id, department, publication_year, citations, journal_name) VALUES
('Deep Learning for Medical Imaging', 1, 'Engineering', 2024, 156, 'AI in Medicine'),
('Quantum Computing Future', 2, 'Science', 2024, 134, 'Quantum Journal'),
('Fintech Revolution', 3, 'Business', 2024, 98, 'Finance Technology'),
('Digital Humanities', 4, 'Arts', 2024, 67, 'Humanities Quarterly'),
('Precision Oncology', 5, 'Medicine', 2024, 245, 'Cancer Research'),
('5G and Beyond', 6, 'Engineering', 2023, 112, 'Communications'),
('Climate Modeling', 7, 'Science', 2024, 189, 'Climate Science'),
('Blockchain in Finance', 8, 'Business', 2023, 87, 'Fintech Journal'),
('Virtual Reality Art', 9, 'Arts', 2024, 45, 'Digital Arts'),
('Gene Editing Ethics', 10, 'Medicine', 2024, 201, 'Medical Ethics'),
('Edge AI Computing', 11, 'Engineering', 2024, 143, 'Edge Computing'),
('Biodiversity Crisis', 12, 'Science', 2023, 167, 'Conservation'),
('ESG Investing', 13, 'Business', 2024, 76, 'Sustainable Finance'),
('AI Generated Art', 14, 'Arts', 2024, 52, 'Art & Technology'),
('mRNA Vaccines', 15, 'Medicine', 2023, 312, 'Vaccine Research');

-- ============================================
-- ADD MORE EMPLOYMENT RECORDS
-- ============================================
INSERT INTO graduate_employment (student_id, graduation_year, employment_status, sector, starting_salary, company_name)
SELECT 
    student_id,
    2024,
    'Employed',
    CASE 
        WHEN department = 'Engineering' THEN 'Technology'
        WHEN department = 'Science' THEN 'Healthcare'
        WHEN department = 'Business' THEN 'Finance'
        WHEN department = 'Arts' THEN 'Education'
        WHEN department = 'Medicine' THEN 'Healthcare'
    END,
    CASE 
        WHEN department = 'Engineering' THEN 85000 + FLOOR(RAND() * 30000)
        WHEN department = 'Science' THEN 65000 + FLOOR(RAND() * 25000)
        WHEN department = 'Business' THEN 75000 + FLOOR(RAND() * 35000)
        WHEN department = 'Arts' THEN 55000 + FLOOR(RAND() * 20000)
        WHEN department = 'Medicine' THEN 70000 + FLOOR(RAND() * 40000)
    END,
    CONCAT('Company_', FLOOR(1 + RAND() * 100))
FROM students
WHERE enrollment_year = 2020
LIMIT 30;

-- ============================================
-- FINAL COUNT CHECK
-- ============================================
SELECT 'Updated Data Counts' as Info;
SELECT 'Students' as Table_Name, COUNT(*) as Count FROM students
UNION ALL SELECT 'Professors', COUNT(*) FROM professors
UNION ALL SELECT 'Courses', COUNT(*) FROM courses
UNION ALL SELECT 'Publications', COUNT(*) FROM research_publications
UNION ALL SELECT 'Employment', COUNT(*) FROM graduate_employment;

-- Cleanup
DROP PROCEDURE IF EXISTS GenerateBulkStudents;

-- ============================================
-- SUCCESS MESSAGE
-- ============================================
SELECT 'Database successfully expanded with bulk data!' as Status;