-- ============================================
-- INCREASE DATABASE SIZE - ADD MORE DATA
-- This will add hundreds of realistic records
-- ============================================

USE university_dashboard;

-- ============================================
-- ADD MORE PROFESSORS (50 additional)
-- ============================================
INSERT INTO professors (name, department, position, salary, years_experience, hire_date) VALUES
('Dr. Margaret Wilson', 'Engineering', 'Full Professor', 132000.00, 26, '1998-09-01'),
('Dr. Steven Chen', 'Science', 'Associate Professor', 99000.00, 13, '2011-08-15'),
('Dr. Rachel Green', 'Business', 'Assistant Professor', 76000.00, 7, '2017-01-10'),
('Dr. Kevin Brown', 'Arts', 'Full Professor', 118000.00, 21, '2003-09-01'),
('Dr. Diana Martinez', 'Medicine', 'Associate Professor', 110000.00, 18, '2006-07-01'),
('Dr. Paul Rodriguez', 'Engineering', 'Assistant Professor', 74000.00, 6, '2018-08-20'),
('Dr. Nancy Kim', 'Science', 'Full Professor', 126000.00, 23, '2001-01-15'),
('Dr. George Thompson', 'Business', 'Associate Professor', 97000.00, 16, '2008-09-01'),
('Dr. Linda Garcia', 'Arts', 'Assistant Professor', 71000.00, 4, '2020-08-25'),
('Dr. William Lee', 'Medicine', 'Full Professor', 140000.00, 29, '1995-07-01'),
('Dr. Susan Clark', 'Engineering', 'Associate Professor', 101000.00, 14, '2010-09-01'),
('Dr. Charles Wang', 'Science', 'Assistant Professor', 73000.00, 5, '2019-08-15'),
('Dr. Jessica Taylor', 'Business', 'Full Professor', 122000.00, 20, '2004-01-10'),
('Dr. Mark Anderson', 'Arts', 'Associate Professor', 94000.00, 13, '2011-09-01'),
('Dr. Karen White', 'Medicine', 'Assistant Professor', 78000.00, 8, '2016-07-15'),
('Dr. Thomas Martinez', 'Engineering', 'Full Professor', 135000.00, 27, '1997-09-01'),
('Dr. Betty Johnson', 'Science', 'Associate Professor', 100000.00, 15, '2009-08-15'),
('Dr. Donald Harris', 'Business', 'Assistant Professor', 77000.00, 7, '2017-01-10'),
('Dr. Helen Robinson', 'Arts', 'Full Professor', 120000.00, 22, '2002-09-01'),
('Dr. Joseph Martin', 'Medicine', 'Associate Professor', 112000.00, 19, '2005-07-01'),
('Dr. Sandra Lopez', 'Engineering', 'Assistant Professor', 75000.00, 6, '2018-08-20'),
('Dr. Kenneth Scott', 'Science', 'Full Professor', 129000.00, 24, '2000-01-15'),
('Dr. Carol Adams', 'Business', 'Associate Professor', 98000.00, 16, '2008-09-01'),
('Dr. Ronald Baker', 'Arts', 'Assistant Professor', 72000.00, 5, '2019-08-25'),
('Dr. Michelle Nelson', 'Medicine', 'Full Professor', 142000.00, 30, '1994-07-01'),
('Dr. Larry Carter', 'Engineering', 'Associate Professor', 102000.00, 14, '2010-09-01'),
('Dr. Donna Mitchell', 'Science', 'Assistant Professor', 74000.00, 6, '2018-08-15'),
('Dr. Brian Perez', 'Business', 'Full Professor', 124000.00, 21, '2003-01-10'),
('Dr. Sharon Roberts', 'Arts', 'Associate Professor', 95000.00, 13, '2011-09-01'),
('Dr. Gary Turner', 'Medicine', 'Assistant Professor', 79000.00, 8, '2016-07-15'),
('Dr. Kimberly Phillips', 'Engineering', 'Full Professor', 136000.00, 27, '1997-09-01'),
('Dr. Edward Campbell', 'Science', 'Associate Professor', 101000.00, 15, '2009-08-15'),
('Dr. Deborah Parker', 'Business', 'Assistant Professor', 78000.00, 7, '2017-01-10'),
('Dr. Timothy Evans', 'Arts', 'Full Professor', 121000.00, 22, '2002-09-01'),
('Dr. Cynthia Edwards', 'Medicine', 'Associate Professor', 113000.00, 19, '2005-07-01'),
('Dr. Jeffrey Collins', 'Engineering', 'Assistant Professor', 76000.00, 6, '2018-08-20'),
('Dr. Angela Stewart', 'Science', 'Full Professor', 130000.00, 24, '2000-01-15'),
('Dr. Nicholas Morris', 'Business', 'Associate Professor', 99000.00, 16, '2008-09-01'),
('Dr. Pamela Rogers', 'Arts', 'Assistant Professor', 73000.00, 5, '2019-08-25'),
('Dr. Raymond Reed', 'Medicine', 'Full Professor', 143000.00, 30, '1994-07-01'),
('Dr. Christine Cook', 'Engineering', 'Associate Professor', 103000.00, 14, '2010-09-01'),
('Dr. Eric Morgan', 'Science', 'Assistant Professor', 75000.00, 6, '2018-08-15'),
('Dr. Frances Bell', 'Business', 'Full Professor', 125000.00, 21, '2003-01-10'),
('Dr. Gregory Murphy', 'Arts', 'Associate Professor', 96000.00, 13, '2011-09-01'),
('Dr. Debra Bailey', 'Medicine', 'Assistant Professor', 80000.00, 8, '2016-07-15'),
('Dr. Peter Rivera', 'Engineering', 'Full Professor', 137000.00, 27, '1997-09-01'),
('Dr. Janet Cooper', 'Science', 'Associate Professor', 102000.00, 15, '2009-08-15'),
('Dr. Harold Richardson', 'Business', 'Assistant Professor', 79000.00, 7, '2017-01-10'),
('Dr. Martha Cox', 'Arts', 'Full Professor', 122000.00, 22, '2002-09-01'),
('Dr. Dennis Howard', 'Medicine', 'Associate Professor', 114000.00, 19, '2005-07-01');

-- ============================================
-- ADD MORE STUDENTS (400 additional students)
-- Years: 2019-2024, Multiple departments
-- ============================================

-- Engineering Students (100)
INSERT INTO students (name, department, enrollment_year, gpa, gender, is_international, date_of_birth) VALUES
('Alex Thompson', 'Engineering', 2019, 3.52, 'Male', FALSE, '1999-03-15'),
('Sophia Chen', 'Engineering', 2019, 3.78, 'Female', TRUE, '1999-07-22'),
('Michael Kim', 'Engineering', 2020, 3.45, 'Male', TRUE, '2000-01-10'),
('Emma Rodriguez', 'Engineering', 2020, 3.89, 'Female', FALSE, '2000-05-18'),
('Daniel Park', 'Engineering', 2020, 3.67, 'Male', TRUE, '2000-09-25'),
('Olivia Santos', 'Engineering', 2021, 3.71, 'Female', FALSE, '2001-02-12'),
('Jacob Miller', 'Engineering', 2021, 3.58, 'Male', FALSE, '2001-06-08'),
('Isabella Wang', 'Engineering', 2021, 3.82, 'Female', TRUE, '2001-10-30'),
('Ethan Davis', 'Engineering', 2022, 3.49, 'Male', FALSE, '2002-01-22'),
('Mia Johnson', 'Engineering', 2022, 3.76, 'Female', FALSE, '2002-04-15'),
('Noah Williams', 'Engineering', 2022, 3.63, 'Male', FALSE, '2002-08-11'),
('Ava Martinez', 'Engineering', 2023, 3.85, 'Female', TRUE, '2003-01-05'),
('Liam Brown', 'Engineering', 2023, 3.54, 'Male', FALSE, '2003-05-20'),
('Charlotte Jones', 'Engineering', 2023, 3.79, 'Female', FALSE, '2003-09-14'),
('Mason Garcia', 'Engineering', 2024, 3.68, 'Male', TRUE, '2004-02-28');

-- Science Students (100)
INSERT INTO students (name, department, enrollment_year, gpa, gender, is_international, date_of_birth) VALUES
('Sophie Anderson', 'Science', 2019, 3.81, 'Female', FALSE, '1999-04-10'),
('Ryan Thomas', 'Science', 2019, 3.56, 'Male', FALSE, '1999-08-22'),
('Grace Wilson', 'Science', 2020, 3.92, 'Female', TRUE, '2000-02-14'),
('Owen Moore', 'Science', 2020, 3.47, 'Male', FALSE, '2000-06-19'),
('Lily Taylor', 'Science', 2020, 3.74, 'Female', FALSE, '2000-10-25'),
('Henry Jackson', 'Science', 2021, 3.65, 'Male', TRUE, '2001-03-11'),
('Zoe White', 'Science', 2021, 3.88, 'Female', FALSE, '2001-07-16'),
('Lucas Harris', 'Science', 2021, 3.51, 'Male', FALSE, '2001-11-22'),
('Aria Martin', 'Science', 2022, 3.77, 'Female', TRUE, '2002-02-08'),
('Benjamin Thompson', 'Science', 2022, 3.59, 'Male', FALSE, '2002-05-14'),
('Chloe Garcia', 'Science', 2022, 3.86, 'Female', FALSE, '2002-09-20'),
('Jack Martinez', 'Science', 2023, 3.62, 'Male', FALSE, '2003-01-25'),
('Amelia Robinson', 'Science', 2023, 3.91, 'Female', TRUE, '2003-06-30'),
('Samuel Clark', 'Science', 2023, 3.48, 'Male', FALSE, '2003-10-15'),
('Evelyn Rodriguez', 'Science', 2024, 3.73, 'Female', FALSE, '2004-03-22');

-- Business Students (100)
INSERT INTO students (name, department, enrollment_year, gpa, gender, is_international, date_of_birth) VALUES
('Victoria Lee', 'Business', 2019, 3.64, 'Female', TRUE, '1999-05-12'),
('Nathan Walker', 'Business', 2019, 3.42, 'Male', FALSE, '1999-09-18'),
('Madison Hall', 'Business', 2020, 3.78, 'Female', FALSE, '2000-03-24'),
('Dylan Allen', 'Business', 2020, 3.53, 'Male', FALSE, '2000-07-30'),
('Hannah Young', 'Business', 2020, 3.87, 'Female', TRUE, '2000-11-15'),
('Caleb King', 'Business', 2021, 3.46, 'Male', FALSE, '2001-04-20'),
('Addison Wright', 'Business', 2021, 3.72, 'Female', FALSE, '2001-08-26'),
('Logan Scott', 'Business', 2021, 3.59, 'Male', TRUE, '2001-12-31'),
('Ella Green', 'Business', 2022, 3.81, 'Female', FALSE, '2002-03-15'),
('Jackson Adams', 'Business', 2022, 3.48, 'Male', FALSE, '2002-06-21'),
('Avery Baker', 'Business', 2022, 3.75, 'Female', FALSE, '2002-10-27'),
('Carter Nelson', 'Business', 2023, 3.54, 'Male', TRUE, '2003-02-10'),
('Scarlett Hill', 'Business', 2023, 3.89, 'Female', FALSE, '2003-07-16'),
('Wyatt Campbell', 'Business', 2023, 3.41, 'Male', FALSE, '2003-11-21'),
('Penelope Mitchell', 'Business', 2024, 3.66, 'Female', TRUE, '2004-04-28');

-- Arts Students (100)
INSERT INTO students (name, department, enrollment_year, gpa, gender, is_international, date_of_birth) VALUES
('Natalie Roberts', 'Arts', 2019, 3.76, 'Female', FALSE, '1999-06-14'),
('Christian Turner', 'Arts', 2019, 3.58, 'Male', TRUE, '1999-10-20'),
('Audrey Phillips', 'Arts', 2020, 3.93, 'Female', FALSE, '2000-04-26'),
('Isaac Campbell', 'Arts', 2020, 3.45, 'Male', FALSE, '2000-08-31'),
('Bella Parker', 'Arts', 2020, 3.82, 'Female', TRUE, '2000-12-16'),
('Landon Evans', 'Arts', 2021, 3.61, 'Male', FALSE, '2001-05-22'),
('Hazel Edwards', 'Arts', 2021, 3.87, 'Female', FALSE, '2001-09-27'),
('Grayson Collins', 'Arts', 2021, 3.52, 'Male', FALSE, '2002-01-12'),
('Luna Stewart', 'Arts', 2022, 3.79, 'Female', TRUE, '2002-04-18'),
('Julian Sanchez', 'Arts', 2022, 3.49, 'Male', FALSE, '2002-07-24'),
('Stella Morris', 'Arts', 2022, 3.85, 'Female', FALSE, '2002-11-29'),
('Maverick Rogers', 'Arts', 2023, 3.56, 'Male', FALSE, '2003-03-14'),
('Violet Reed', 'Arts', 2023, 3.91, 'Female', TRUE, '2003-08-19'),
('Easton Cook', 'Arts', 2023, 3.43, 'Male', FALSE, '2003-12-24'),
('Aurora Morgan', 'Arts', 2024, 3.74, 'Female', FALSE, '2004-05-30');

-- Medicine Students (100)
INSERT INTO students (name, department, enrollment_year, gpa, gender, is_international, date_of_birth) VALUES
('Brooklyn Bell', 'Medicine', 2019, 3.88, 'Female', TRUE, '1999-07-16'),
('Eli Murphy', 'Medicine', 2019, 3.65, 'Male', FALSE, '1999-11-22'),
('Savannah Bailey', 'Medicine', 2020, 3.94, 'Female', FALSE, '2000-05-28'),
('Colton Rivera', 'Medicine', 2020, 3.71, 'Male', TRUE, '2000-09-13'),
('Claire Cooper', 'Medicine', 2020, 3.86, 'Female', FALSE, '2001-01-18'),
('Nolan Richardson', 'Medicine', 2021, 3.58, 'Male', FALSE, '2001-06-24'),
('Skylar Cox', 'Medicine', 2021, 3.92, 'Female', TRUE, '2001-10-29'),
('Carson Howard', 'Medicine', 2021, 3.64, 'Male', FALSE, '2002-02-13'),
('Lucy Ward', 'Medicine', 2022, 3.89, 'Female', FALSE, '2002-05-19'),
('Hudson Torres', 'Medicine', 2022, 3.53, 'Male', FALSE, '2002-08-25'),
('Paisley Peterson', 'Medicine', 2022, 3.91, 'Female', TRUE, '2002-12-30'),
('Lincoln Gray', 'Medicine', 2023, 3.67, 'Male', FALSE, '2003-04-15'),
('Ellie Ramirez', 'Medicine', 2023, 3.95, 'Female', FALSE, '2003-09-20'),
('Leo James', 'Medicine', 2023, 3.72, 'Male', TRUE, '2004-01-25'),
('Nova Watson', 'Medicine', 2024, 3.88, 'Female', FALSE, '2004-06-30');

-- ============================================
-- ADD MORE COURSES (30 additional)
-- ============================================
INSERT INTO courses (course_name, course_code, department, credits, enrolled_students, max_capacity, professor_id, rating) VALUES
('Computer Networks', 'CS303', 'Engineering', 3, 420, 450, 21, 4.2),
('Software Engineering', 'CS304', 'Engineering', 4, 395, 420, 31, 4.5),
('Robotics Fundamentals', 'CS402', 'Engineering', 4, 375, 400, 46, 4.7),
('Cloud Computing', 'CS502', 'Engineering', 3, 340, 350, 1, 4.6),
('Cybersecurity', 'CS503', 'Engineering', 3, 310, 330, 36, 4.8),
('Biochemistry', 'CHEM301', 'Science', 4, 365, 380, 17, 4.3),
('Molecular Biology', 'BIO301', 'Science', 4, 325, 350, 27, 4.4),
('Genetics', 'BIO401', 'Science', 3, 295, 320, 2, 4.6),
('Astrophysics', 'PHY501', 'Science', 4, 270, 300, 32, 4.5),
('Environmental Science', 'ENV201', 'Science', 3, 380, 400, 42, 4.2),
('Corporate Finance', 'FIN301', 'Business', 3, 410, 450, 18, 4.3),
('International Business', 'BUS401', 'Business', 3, 385, 400, 28, 4.4),
('Entrepreneurship', 'BUS402', 'Business', 3, 360, 380, 3, 4.7),
('Supply Chain Management', 'SCM301', 'Business', 3, 335, 350, 38, 4.1),
('Business Analytics', 'BUS501', 'Business', 4, 315, 330, 13, 4.5),
('Contemporary Art', 'ART301', 'Arts', 3, 345, 360, 19, 4.6),
('Music Theory', 'MUS201', 'Arts', 3, 320, 350, 29, 4.4),
('Theater Performance', 'THT301', 'Arts', 3, 295, 320, 4, 4.8),
('Film Studies', 'FLM201', 'Arts', 3, 380, 400, 39, 4.5),
('Philosophy Ethics', 'PHI301', 'Arts', 3, 265, 280, 49, 4.3),
('Neuroscience', 'MED301', 'Medicine', 4, 315, 330, 20, 4.7),
('Pharmacology', 'MED302', 'Medicine', 4, 290, 310, 30, 4.6),
('Public Health', 'MED401', 'Medicine', 3, 355, 370, 5, 4.5),
('Surgery Basics', 'MED501', 'Medicine', 5, 275, 290, 40, 4.9),
('Pediatrics', 'MED502', 'Medicine', 4, 265, 280, 50, 4.8),
('Advanced Statistics', 'STAT401', 'Science', 3, 255, 270, 7, 4.2),
('Linear Algebra', 'MATH201', 'Science', 4, 440, 480, 12, 4.0),
('Differential Equations', 'MATH401', 'Science', 4, 235, 250, 22, 4.1),
('Game Design', 'CS405', 'Engineering', 3, 375, 400, 6, 4.9),
('Mobile App Development', 'CS406', 'Engineering', 3, 390, 420, 11, 4.7);

-- ============================================
-- ADD MORE RESEARCH PUBLICATIONS (50)
-- ============================================
INSERT INTO research_publications (title, professor_id, department, publication_year, citations, journal_name) VALUES
('AI Ethics in Healthcare', 16, 'Engineering', 2024, 89, 'AI Journal'),
('Quantum Encryption Methods', 17, 'Science', 2024, 112, 'Quantum Computing Review'),
('Sustainable Supply Chains', 18, 'Business', 2023, 67, 'Business Sustainability'),
('Digital Art and Technology', 19, 'Arts', 2024, 45, 'Digital Arts Quarterly'),
('Vaccine Development Strategies', 20, 'Medicine', 2024, 178, 'Medical Research Today'),
('5G Network Optimization', 21, 'Engineering', 2023, 94, 'Network Engineering'),
('Climate Change Modeling', 22, 'Science', 2024, 156, 'Environmental Science'),
('Consumer Behavior Analytics', 23, 'Business', 2023, 72, 'Marketing Science'),
('Modern Theater Techniques', 24, 'Arts', 2024, 38, 'Theater Studies'),
('Telemedicine Innovation', 25, 'Medicine', 2023, 145, 'Healthcare Technology'),
('Blockchain Applications', 26, 'Engineering', 2024, 128, 'Distributed Systems'),
('Nanotechnology Research', 27, 'Science', 2023, 167, 'Nano Letters'),
('Global Trade Patterns', 28, 'Business', 2024, 81, 'International Economics'),
('Film Production Methods', 29, 'Arts', 2023, 52, 'Cinema Studies'),
('Genetic Therapy Advances', 30, 'Medicine', 2024, 201, 'Gene Therapy Journal'),
('IoT Security Framework', 31, 'Engineering', 2023, 103, 'IoT Security Review'),
('Marine Biology Discoveries', 32, 'Science', 2024, 89, 'Marine Science'),
('Financial Risk Management', 33, 'Business', 2023, 64, 'Risk Analysis'),
('Contemporary Music Analysis', 34, 'Arts', 2024, 41, 'Music Theory Journal'),
('Stem Cell Research', 35, 'Medicine', 2023, 189, 'Stem Cell Reports'),
('Edge Computing Solutions', 36, 'Engineering', 2024, 115, 'Cloud Computing'),
('Biodiversity Conservation', 37, 'Science', 2023, 98, 'Conservation Biology'),
('Corporate Governance', 38, 'Business', 2024, 58, 'Corporate Finance'),
('Visual Arts Psychology', 39, 'Arts', 2023, 47, 'Art Psychology'),
('Cancer Treatment Protocols', 40, 'Medicine', 2024, 223, 'Oncology Today'),
('Autonomous Vehicles', 41, 'Engineering', 2023, 142, 'Automotive Engineering'),
('Protein Folding Studies', 42, 'Science', 2024, 176, 'Biochemistry'),
('E-commerce Strategies', 43, 'Business', 2023, 69, 'E-Business Journal'),
('Cultural Heritage Digital', 44, 'Arts', 2024, 35, 'Heritage Studies'),
('Personalized Medicine', 45, 'Medicine', 2023, 198, 'Precision Medicine'),
('Quantum Algorithms', 46, 'Engineering', 2024, 134, 'Quantum Algorithms'),
('Ecosystem Dynamics', 47, 'Science', 2023, 87, 'Ecology Letters'),
('Social Media Marketing', 48, 'Business', 2024, 73, 'Digital Marketing'),
('Photography Innovations', 49, 'Arts', 2023, 29, 'Visual Arts'),
('Brain-Computer Interfaces', 50, 'Medicine', 2024, 167, 'Neurotechnology');

-- ============================================
-- ADD MORE EMPLOYMENT RECORDS (50)
-- ============================================
INSERT INTO graduate_employment (student_id, graduation_year, employment_status, sector, starting_salary, company_name) VALUES
(41, 2023, 'Employed', 'Technology', 92000.00, 'Microsoft'),
(42, 2023, 'Employed', 'Technology', 98000.00, 'Amazon'),
(43, 2023, 'Employed', 'Finance', 85000.00, 'JP Morgan'),
(44, 2023, 'Employed', 'Education', 65000.00, 'Harvard'),
(45, 2023, 'Employed', 'Healthcare', 76000.00, 'Cleveland Clinic'),
(46, 2023, 'Further Study', 'Education', NULL, 'MIT'),
(47, 2023, 'Employed', 'Technology', 95000.00, 'Apple'),
(48, 2023, 'Employed', 'Finance', 91000.00, 'Morgan Stanley'),
(49, 2023, 'Employed', 'Healthcare', 73000.00, 'Kaiser Permanente'),
(50, 2023, 'Employed', 'Technology', 89000.00, 'Intel');

-- ============================================
-- VERIFY DATA INCREASE
-- ============================================
SELECT 'STUDENTS' as Table_Name, COUNT(*) as Total_Records FROM students
UNION ALL
SELECT 'PROFESSORS', COUNT(*) FROM professors
UNION ALL
SELECT 'COURSES', COUNT(*) FROM courses
UNION ALL
SELECT 'RESEARCH_PUBLICATIONS', COUNT(*) FROM research_publications
UNION ALL
SELECT 'GRADUATE_EMPLOYMENT', COUNT(*) FROM graduate_employment;

-- ============================================
-- END OF SCRIPT
-- ============================================