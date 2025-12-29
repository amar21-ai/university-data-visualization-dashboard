"""
University Dashboard - Flask Backend
Connects to MySQL database and serves data via API
"""

from flask import Flask, render_template, jsonify, send_from_directory
from flask_cors import CORS
import mysql.connector
from mysql.connector import Error
from datetime import datetime

app = Flask(__name__)
CORS(app)  # Enable CORS for API calls

# Database configuration
DB_CONFIG = {
    'host': '127.0.0.1',           # Use 127.0.0.1 instead of localhost
    'port': 3305,
    'user': 'root',
    'password': 'Amar2020#',            # Change this if your password is different
    'database': 'university_dashboard',
    'auth_plugin': 'mysql_native_password'
}

# Database connection helper
def get_db_connection():
    """Create database connection"""
    try:
        connection = mysql.connector.connect(**DB_CONFIG)
        return connection
    except Error as e:
        print(f"Error connecting to database: {e}")
        return None

# Helper function to execute queries
def execute_query(query, params=None):
    """Execute a SELECT query and return results"""
    connection = get_db_connection()
    if not connection:
        return []
    
    try:
        cursor = connection.cursor(dictionary=True)
        if params:
            cursor.execute(query, params)
        else:
            cursor.execute(query)
        results = cursor.fetchall()
        cursor.close()
        connection.close()
        return results
    except Error as e:
        print(f"Error executing query: {e}")
        return []

# ============================================
# ROUTES
# ============================================

@app.route('/')
def index():
    """Render main dashboard page"""
    return render_template('dashboard.html')

@app.route('/static/<path:filename>')
def serve_static(filename):
    """Serve static files (CSS, JS, images)"""
    return send_from_directory('static', filename)

# ============================================
# API ENDPOINTS
# ============================================

@app.route('/api/kpi-summary')
def get_kpi_summary():
    """Get summary KPIs for dashboard cards"""
    from flask import request
    department = request.args.get('department')
    year = request.args.get('year')
    
    try:
        # Base queries with optional filters
        students_where = "WHERE 1=1"
        params = []
        
        if department and department != 'all':
            students_where += " AND department = %s"
            params.append(department)
        if year and year != 'all':
            students_where += " AND enrollment_year = %s"
            params.append(int(year))
        
        # Total students with filters
        students_query = f"SELECT COUNT(*) as total FROM students {students_where}"
        students_result = execute_query(students_query, params if params else None)
        total_students = students_result[0]['total'] if students_result else 0
        
        # Total professors (filter by department only)
        prof_params = []
        prof_where = "WHERE 1=1"
        if department and department != 'all':
            prof_where += " AND department = %s"
            prof_params.append(department)
        
        prof_query = f"SELECT COUNT(*) as total, AVG(salary) as avg_salary FROM professors {prof_where}"
        prof_result = execute_query(prof_query, prof_params if prof_params else None)
        total_professors = prof_result[0]['total'] if prof_result else 0
        avg_salary = prof_result[0]['avg_salary'] if prof_result else 0
        
        # Total courses
        courses_query = f"SELECT COUNT(*) as total FROM courses {prof_where if department and department != 'all' else ''}"
        courses_result = execute_query(courses_query, prof_params if prof_params else None)
        total_courses = courses_result[0]['total'] if courses_result else 0
        
        # Average fee
        fees_query = "SELECT AVG(annual_fee) as avg_fee FROM fees WHERE academic_year = '2024-2025'"
        fees_result = execute_query(fees_query)
        avg_fee = fees_result[0]['avg_fee'] if fees_result else 0
        
        # Employment rate
        employment_query = """
            SELECT 
                COUNT(*) as total,
                SUM(CASE WHEN employment_status = 'Employed' THEN 1 ELSE 0 END) as employed
            FROM graduate_employment
        """
        employment_result = execute_query(employment_query)
        employment_rate = 0
        if employment_result and employment_result[0]['total'] > 0:
            employment_rate = (employment_result[0]['employed'] / employment_result[0]['total']) * 100
        
        return jsonify({
            'total_students': total_students,
            'total_professors': total_professors,
            'avg_salary': float(avg_salary) if avg_salary else 0,
            'total_courses': total_courses,
            'avg_fee': float(avg_fee) if avg_fee else 0,
            'employment_rate': round(employment_rate, 1)
        })
    except Exception as e:
        print(f"Error in KPI summary: {e}")
        return jsonify({'error': str(e)}), 500

@app.route('/api/students-by-year')
def get_students_by_year():
    """Get student enrollment by year"""
    from flask import request
    department = request.args.get('department')
    year = request.args.get('year')
    
    query = """
        SELECT 
            enrollment_year as year,
            COUNT(*) as count
        FROM students
        WHERE 1=1
    """
    params = []
    
    if department:
        query += " AND department = %s"
        params.append(department)
    
    if year:
        query += " AND enrollment_year = %s"
        params.append(int(year))
    
    query += " GROUP BY enrollment_year ORDER BY enrollment_year"
    
    results = execute_query(query, params if params else None)
    return jsonify(results)

@app.route('/api/students-by-department')
def get_students_by_department():
    """Get student count by department"""
    from flask import request
    year = request.args.get('year')
    
    query = """
        SELECT 
            department,
            COUNT(*) as count,
            AVG(gpa) as avg_gpa,
            SUM(CASE WHEN gender = 'Male' THEN 1 ELSE 0 END) as male,
            SUM(CASE WHEN gender = 'Female' THEN 1 ELSE 0 END) as female
        FROM students
        WHERE 1=1
    """
    params = []
    
    if year:
        query += " AND enrollment_year = %s"
        params.append(int(year))
    
    query += " GROUP BY department ORDER BY count DESC"
    
    results = execute_query(query, params if params else None)
    # Convert Decimal to float for JSON serialization
    for row in results:
        if row['avg_gpa']:
            row['avg_gpa'] = float(row['avg_gpa'])
    return jsonify(results)

@app.route('/api/professors-by-department')
def get_professors_by_department():
    """Get professor count by department"""
    query = """
        SELECT 
            department,
            COUNT(*) as count
        FROM professors
        GROUP BY department
        ORDER BY count DESC
    """
    results = execute_query(query)
    return jsonify(results)

@app.route('/api/salaries-by-position')
def get_salaries_by_position():
    """Get salary distribution by position"""
    query = """
        SELECT 
            position,
            AVG(salary) as salary,
            COUNT(*) as count
        FROM professors
        GROUP BY position
        ORDER BY salary DESC
    """
    results = execute_query(query)
    # Convert Decimal to float
    for row in results:
        row['salary'] = float(row['salary'])
    return jsonify(results)

@app.route('/api/popular-courses')
def get_popular_courses():
    """Get most popular courses"""
    from flask import request
    department = request.args.get('department')
    
    query = """
        SELECT 
            course_name as course,
            enrolled_students as students,
            rating,
            department
        FROM courses
        WHERE 1=1
    """
    params = []
    
    if department:
        query += " AND department = %s"
        params.append(department)
    
    query += " ORDER BY enrolled_students DESC LIMIT 10"
    
    results = execute_query(query, params if params else None)
    # Convert Decimal to float
    for row in results:
        if row['rating']:
            row['rating'] = float(row['rating'])
    return jsonify(results)

@app.route('/api/fees-by-program')
def get_fees_by_program():
    """Get fees by program type"""
    query = """
        SELECT 
            program_type as program,
            annual_fee as fee
        FROM fees
        WHERE academic_year = '2024-2025'
        ORDER BY annual_fee DESC
    """
    results = execute_query(query)
    # Convert Decimal to float
    for row in results:
        row['fee'] = float(row['fee'])
    return jsonify(results)

@app.route('/api/performance-by-department')
def get_performance_by_department():
    """Get academic performance by department"""
    from flask import request
    year = request.args.get('year')
    
    query = """
        SELECT 
            department,
            AVG(gpa) as gpa
        FROM students
        WHERE 1=1
    """
    params = []
    
    if year:
        query += " AND enrollment_year = %s"
        params.append(int(year))
    
    query += " GROUP BY department ORDER BY gpa DESC"
    
    results = execute_query(query, params if params else None)
    # Convert Decimal to float
    for row in results:
        row['gpa'] = float(row['gpa'])
    return jsonify(results)

@app.route('/api/research-publications')
def get_research_publications():
    """Get research publications by year"""
    query = """
        SELECT 
            publication_year as year,
            COUNT(*) as count,
            SUM(citations) as total_citations
        FROM research_publications
        GROUP BY publication_year
        ORDER BY publication_year
    """
    results = execute_query(query)
    return jsonify(results)

@app.route('/api/demographics')
def get_demographics():
    """Get student demographics"""
    query = """
        SELECT 
            SUM(CASE WHEN is_international = TRUE THEN 1 ELSE 0 END) as international,
            SUM(CASE WHEN is_international = FALSE THEN 1 ELSE 0 END) as domestic
        FROM students
    """
    results = execute_query(query)
    if results:
        return jsonify({
            'international': results[0]['international'],
            'domestic': results[0]['domestic']
        })
    return jsonify({'international': 0, 'domestic': 0})

@app.route('/api/employment-by-sector')
def get_employment_by_sector():
    """Get graduate employment by sector"""
    query = """
        SELECT 
            sector,
            COUNT(*) as count,
            AVG(starting_salary) as avg_salary
        FROM graduate_employment
        WHERE employment_status = 'Employed'
        GROUP BY sector
        ORDER BY count DESC
    """
    results = execute_query(query)
    # Convert Decimal to float
    for row in results:
        if row['avg_salary']:
            row['avg_salary'] = float(row['avg_salary'])
    return jsonify(results)

@app.route('/api/departments')
def get_departments():
    """Get all departments for filters"""
    query = "SELECT DISTINCT department FROM students ORDER BY department"
    results = execute_query(query)
    return jsonify(results)

@app.route('/api/test-connection')
def test_connection():
    """Test database connection"""
    connection = get_db_connection()
    if connection:
        connection.close()
        return jsonify({'status': 'success', 'message': 'Database connected successfully!'})
    return jsonify({'status': 'error', 'message': 'Failed to connect to database'}), 500

@app.route('/api/students-table')
def get_students_table():
    """Get students for table display"""
    from flask import request
    department = request.args.get('department')
    year = request.args.get('year')
    limit = request.args.get('limit', 20)
    
    query = """
        SELECT 
            name,
            department,
            enrollment_year as year,
            gpa,
            CASE WHEN is_international = TRUE THEN 'International' ELSE 'Domestic' END as status
        FROM students
        WHERE 1=1
    """
    params = []
    
    if department and department != 'all':
        query += " AND department = %s"
        params.append(department)
    if year and year != 'all':
        query += " AND enrollment_year = %s"
        params.append(int(year))
    
    query += f" ORDER BY gpa DESC LIMIT {limit}"
    
    results = execute_query(query, params if params else None)
    for row in results:
        if row['gpa']:
            row['gpa'] = float(row['gpa'])
    return jsonify(results)

@app.route('/api/professors-table')
def get_professors_table():
    """Get professors for table display"""
    from flask import request
    department = request.args.get('department')
    limit = request.args.get('limit', 20)
    
    query = """
        SELECT 
            name,
            department,
            position,
            years_experience as experience,
            salary
        FROM professors
        WHERE 1=1
    """
    params = []
    
    if department and department != 'all':
        query += " AND department = %s"
        params.append(department)
    
    query += f" ORDER BY salary DESC LIMIT {limit}"
    
    results = execute_query(query, params if params else None)
    for row in results:
        row['salary'] = float(row['salary'])
    return jsonify(results)

# ============================================
# ERROR HANDLERS
# ============================================

@app.errorhandler(404)
def not_found(error):
    return jsonify({'error': 'Endpoint not found'}), 404

@app.errorhandler(500)
def internal_error(error):
    return jsonify({'error': 'Internal server error'}), 500

# ============================================
# RUN APPLICATION
# ============================================

if __name__ == '__main__':
    print("\n" + "="*50)
    print("UNIVERSITY DASHBOARD - Starting Server")
    print("="*50)
    print("Dashboard URL: http://localhost:5000")
    print("API Base URL: http://localhost:5000/api/")
    print("="*50 + "\n")
    
    # Test database connection on startup
    connection = get_db_connection()
    if connection:
        print("✓ Database connection successful!\n")
        connection.close()
    else:
        print("✗ Warning: Could not connect to database!")
        print("  Please check your DB_CONFIG settings in app.py\n")
    
    app.run(debug=True, port=5000)