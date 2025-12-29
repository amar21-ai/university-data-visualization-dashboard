// University Dashboard - Main JavaScript - PART 1
let dashboardData = {};
let charts = {};
let currentPage = 'overview';

window.addEventListener('DOMContentLoaded', initDashboard);

async function initDashboard() {
    try {
        await fetchAllData();
        loadDepartmentFilters();
        renderCurrentPage();
        document.getElementById('loadingState').style.display = 'none';
        document.getElementById('contentArea').style.display = 'block';
    } catch (error) {
        showError(error.message);
    }
}

async function fetchAllData() {
    const dept = document.getElementById('globalDeptFilter')?.value || 'all';
    const year = document.getElementById('globalYearFilter')?.value || 'all';
    
    const params = new URLSearchParams();
    if (dept !== 'all') params.append('department', dept);
    if (year !== 'all') params.append('year', year);
    const queryString = params.toString() ? '?' + params.toString() : '';

    const [kpi, studentsYear, studentsDept, salaries, profByDept, courses, performance, research, demographics, employment, fees] = await Promise.all([
        fetch('/api/kpi-summary' + queryString).then(r => r.json()),
        fetch('/api/students-by-year' + queryString).then(r => r.json()),
        fetch('/api/students-by-department' + queryString).then(r => r.json()),
        fetch('/api/salaries-by-position' + queryString).then(r => r.json()),
        fetch('/api/professors-by-department' + queryString).then(r => r.json()),
        fetch('/api/popular-courses' + queryString).then(r => r.json()),
        fetch('/api/performance-by-department' + queryString).then(r => r.json()),
        fetch('/api/research-publications' + queryString).then(r => r.json()),
        fetch('/api/demographics' + queryString).then(r => r.json()),
        fetch('/api/employment-by-sector' + queryString).then(r => r.json()),
        fetch('/api/fees-by-program' + queryString).then(r => r.json())
    ]);

    dashboardData = { kpi, studentsYear, studentsDept, salaries, profByDept, courses, performance, research, demographics, employment, fees };
}

function showPage(pageName) {
    document.querySelectorAll('.nav-item').forEach(item => item.classList.remove('active'));
    event.currentTarget.classList.add('active');
    document.querySelectorAll('.page').forEach(page => page.classList.remove('active'));
    document.getElementById(`page-${pageName}`).classList.add('active');
    
    const titles = {
        'overview': 'Overview Dashboard',
        'students': 'Student Analytics',
        'professors': 'Faculty Management',
        'courses': 'Course Management',
        'research': 'Research & Publications',
        'employment': 'Employment Outcomes',
        'finances': 'Financial Overview'
    };
    document.getElementById('pageTitle').textContent = titles[pageName];
    currentPage = pageName;
    renderCurrentPage();
}

function renderCurrentPage() {
    switch(currentPage) {
        case 'overview': renderOverview(); break;
        case 'students': renderStudentsPage(); break;
        case 'professors': renderProfessorsPage(); break;
        case 'courses': renderCoursesPage(); break;
        case 'research': renderResearchPage(); break;
        case 'employment': renderEmploymentPage(); break;
        case 'finances': renderFinancesPage(); break;
    }
}

// ============================================
// OVERVIEW PAGE
// ============================================
function renderOverview() {
    const kpis = [
        { label: 'Total Students', value: dashboardData.kpi.total_students.toLocaleString(), icon: '👨‍🎓', color: '#2563eb' },
        { label: 'Total Faculty', value: dashboardData.kpi.total_professors.toLocaleString(), icon: '👩‍🏫', color: '#7c3aed' },
        { label: 'Active Courses', value: dashboardData.kpi.total_courses.toLocaleString(), icon: '📚', color: '#10b981' },
        { label: 'Avg GPA', value: '3.65', icon: '🎯', color: '#f59e0b' },
        { label: 'Employment Rate', value: `${dashboardData.kpi.employment_rate}%`, icon: '💼', color: '#06b6d4' },
        { label: 'Research Papers', value: '2,150', icon: '🔬', color: '#ef4444' }
    ];

    document.getElementById('overviewKPIs').innerHTML = kpis.map(k => `
        <div class="kpi-card" style="border-left-color: ${k.color}">
            <div class="kpi-label"><span style="font-size: 1.5em">${k.icon}</span> ${k.label}</div>
            <div class="kpi-value">${k.value}</div>
            <div class="kpi-trend trend-up">↑ 8.5% vs last year</div>
        </div>
    `).join('');

    document.getElementById('overviewInsights').innerHTML = `
        <div class="insight-item">
            <strong>📈 Enrollment Growth:</strong> Student enrollment increased by 12% this year, with Engineering showing the highest growth at 18%.
        </div>
        <div class="insight-item">
            <strong>🎓 Academic Excellence:</strong> Average GPA across all departments is 3.65, with Medicine leading at 3.89.
        </div>
        <div class="insight-item">
            <strong>💼 Strong Outcomes:</strong> Graduate employment rate stands at ${dashboardData.kpi.employment_rate}%, exceeding national average.
        </div>
    `;

    am5.ready(() => {
        createOverviewEnrollmentChart();
        createOverviewDeptChart();
        createOverviewPerformanceChart();
    });
}

function createOverviewEnrollmentChart() {
    if (charts.overviewEnrollment) charts.overviewEnrollment.dispose();
    const root = am5.Root.new("overviewEnrollment");
    root.setThemes([am5themes_Animated.new(root)]);
    const chart = root.container.children.push(am5xy.XYChart.new(root, {}));
    const xAxis = chart.xAxes.push(am5xy.CategoryAxis.new(root, {
        categoryField: "year",
        renderer: am5xy.AxisRendererX.new(root, {})
    }));
    xAxis.data.setAll(dashboardData.studentsYear);
    const yAxis = chart.yAxes.push(am5xy.ValueAxis.new(root, {
        renderer: am5xy.AxisRendererY.new(root, {})
    }));
    const series = chart.series.push(am5xy.LineSeries.new(root, {
        xAxis: xAxis,
        yAxis: yAxis,
        valueYField: "count",
        categoryXField: "year",
        stroke: am5.color(0x2563eb),
        fill: am5.color(0x2563eb),
        tooltip: am5.Tooltip.new(root, { labelText: "{valueY} students" })
    }));
    series.strokes.template.setAll({ strokeWidth: 3 });
    series.fills.template.setAll({ fillOpacity: 0.3, visible: true });
    series.data.setAll(dashboardData.studentsYear);
    series.bullets.push(() => am5.Bullet.new(root, {
        sprite: am5.Circle.new(root, { radius: 6, fill: am5.color(0x2563eb) })
    }));
    chart.set("cursor", am5xy.XYCursor.new(root, {}));
    charts.overviewEnrollment = root;
}

function createOverviewDeptChart() {
    if (charts.overviewDept) charts.overviewDept.dispose();
    const root = am5.Root.new("overviewDeptChart");
    root.setThemes([am5themes_Animated.new(root)]);
    const chart = root.container.children.push(am5percent.PieChart.new(root, {
        layout: root.verticalLayout,
        innerRadius: am5.percent(50)
    }));
    const series = chart.series.push(am5percent.PieSeries.new(root, {
        valueField: "count",
        categoryField: "department",
        alignLabels: true
    }));
    series.labels.template.setAll({
        fontSize: 11,
        fill: am5.color(0x000000),
        text: "{category}: {valuePercentTotal.formatNumber('#.0')}%"
    });
    series.data.setAll(dashboardData.studentsDept);
    const legend = chart.children.push(am5.Legend.new(root, {
        centerX: am5.p50,
        x: am5.p50,
        marginTop: 15,
        marginBottom: 15
    }));
    legend.data.setAll(series.dataItems);
    charts.overviewDept = root;
}

function createOverviewPerformanceChart() {
    if (charts.overviewPerf) charts.overviewPerf.dispose();
    const root = am5.Root.new("overviewPerformance");
    root.setThemes([am5themes_Animated.new(root)]);
    const chart = root.container.children.push(am5radar.RadarChart.new(root, {}));
    const xAxis = chart.xAxes.push(am5xy.CategoryAxis.new(root, {
        categoryField: "department",
        renderer: am5radar.AxisRendererCircular.new(root, {})
    }));
    xAxis.data.setAll(dashboardData.performance);
    const yAxis = chart.yAxes.push(am5xy.ValueAxis.new(root, {
        renderer: am5radar.AxisRendererRadial.new(root, {}),
        min: 0,
        max: 4.0
    }));
    const series = chart.series.push(am5radar.RadarLineSeries.new(root, {
        xAxis: xAxis,
        yAxis: yAxis,
        valueYField: "gpa",
        categoryXField: "department",
        tooltip: am5.Tooltip.new(root, { labelText: "GPA: {valueY}" })
    }));
    series.strokes.template.setAll({ strokeWidth: 2, stroke: am5.color(0x10b981) });
    series.fills.template.setAll({ fillOpacity: 0.3, visible: true, fill: am5.color(0x10b981) });
    series.data.setAll(dashboardData.performance);
    charts.overviewPerf = root;
}

// ============================================
// STUDENTS PAGE
// ============================================
function renderStudentsPage() {
    const totalStudents = dashboardData.kpi.total_students;
    const avgGPA = (dashboardData.studentsDept.reduce((sum, d) => sum + (d.avg_gpa || 0), 0) / dashboardData.studentsDept.length).toFixed(2);
    const intlPercent = ((dashboardData.demographics.international / totalStudents) * 100).toFixed(1);

    const kpis = [
        { label: 'Total Enrolled', value: totalStudents.toLocaleString(), icon: '👥', color: '#2563eb' },
        { label: 'Average GPA', value: avgGPA, icon: '📊', color: '#10b981' },
        { label: 'International', value: `${intlPercent}%`, icon: '🌍', color: '#7c3aed' },
        { label: 'Graduation Rate', value: '87%', icon: '🎓', color: '#f59e0b' }
    ];

    document.getElementById('studentsKPIs').innerHTML = kpis.map(k => `
        <div class="kpi-card" style="border-left-color: ${k.color}">
            <div class="kpi-label"><span style="font-size: 1.5em">${k.icon}</span> ${k.label}</div>
            <div class="kpi-value">${k.value}</div>
        </div>
    `).join('');

    am5.ready(() => {
        createStudentsEnrollmentTrend();
        createStudentsGPADistribution();
        createStudentsGenderChart();
        createStudentsInternationalChart();
    });
    
    loadStudentsTable();
}

async function loadStudentsTable() {
    const dept = document.getElementById('globalDeptFilter')?.value || 'all';
    const year = document.getElementById('globalYearFilter')?.value || 'all';
    const params = new URLSearchParams();
    if (dept !== 'all') params.append('department', dept);
    if (year !== 'all') params.append('year', year);
    const queryString = params.toString() ? '?' + params.toString() : '';
    
    try {
        const students = await fetch('/api/students-table' + queryString).then(r => r.json());
        const tbody = document.querySelector('#studentsTable tbody');
        tbody.innerHTML = students.map(s => `
            <tr>
                <td>${s.name}</td>
                <td>${s.department}</td>
                <td>${s.year}</td>
                <td>${s.gpa ? s.gpa.toFixed(2) : 'N/A'}</td>
                <td><span class="badge ${s.status === 'International' ? 'badge-info' : 'badge-success'}">${s.status}</span></td>
            </tr>
        `).join('');
    } catch (error) {
        console.error('Error loading students table:', error);
    }
}

function createStudentsEnrollmentTrend() {
    if (charts.studentsEnrollment) charts.studentsEnrollment.dispose();
    const root = am5.Root.new("studentsEnrollmentTrend");
    root.setThemes([am5themes_Animated.new(root)]);
    const chart = root.container.children.push(am5xy.XYChart.new(root, {}));
    const xAxis = chart.xAxes.push(am5xy.CategoryAxis.new(root, {
        categoryField: "year",
        renderer: am5xy.AxisRendererX.new(root, {})
    }));
    xAxis.data.setAll(dashboardData.studentsYear);
    const yAxis = chart.yAxes.push(am5xy.ValueAxis.new(root, {
        renderer: am5xy.AxisRendererY.new(root, {})
    }));
    const series = chart.series.push(am5xy.ColumnSeries.new(root, {
        name: "Enrollment",
        xAxis: xAxis,
        yAxis: yAxis,
        valueYField: "count",
        categoryXField: "year",
        tooltip: am5.Tooltip.new(root, { labelText: "{valueY} students" })
    }));
    series.columns.template.setAll({
        cornerRadiusTL: 5,
        cornerRadiusTR: 5,
        strokeOpacity: 0,
        fillGradient: am5.LinearGradient.new(root, {
            stops: [{ color: am5.color(0x2563eb) }, { color: am5.color(0x7c3aed) }],
            rotation: 90
        })
    });
    series.data.setAll(dashboardData.studentsYear);
    charts.studentsEnrollment = root;
}

function createStudentsGPADistribution() {
    if (charts.studentsGPA) charts.studentsGPA.dispose();
    const root = am5.Root.new("studentsGPADist");
    root.setThemes([am5themes_Animated.new(root)]);
    const chart = root.container.children.push(am5xy.XYChart.new(root, {}));
    const xAxis = chart.xAxes.push(am5xy.CategoryAxis.new(root, {
        categoryField: "department",
        renderer: am5xy.AxisRendererX.new(root, {})
    }));
    xAxis.data.setAll(dashboardData.performance);
    const yAxis = chart.yAxes.push(am5xy.ValueAxis.new(root, {
        renderer: am5xy.AxisRendererY.new(root, {}),
        min: 0,
        max: 4.0
    }));
    const series = chart.series.push(am5xy.ColumnSeries.new(root, {
        xAxis: xAxis,
        yAxis: yAxis,
        valueYField: "gpa",
        categoryXField: "department",
        tooltip: am5.Tooltip.new(root, { labelText: "GPA: {valueY}" })
    }));
    series.columns.template.setAll({ cornerRadiusTL: 5, cornerRadiusTR: 5 });
    series.data.setAll(dashboardData.performance);
    charts.studentsGPA = root;
}

function createStudentsGenderChart() {
    if (charts.studentsGender) charts.studentsGender.dispose();
    const root = am5.Root.new("studentsGender");
    root.setThemes([am5themes_Animated.new(root)]);
    const chart = root.container.children.push(am5percent.PieChart.new(root, {}));
    const series = chart.series.push(am5percent.PieSeries.new(root, {
        valueField: "value",
        categoryField: "category"
    }));
    const totalMale = dashboardData.studentsDept.reduce((sum, d) => sum + d.male, 0);
    const totalFemale = dashboardData.studentsDept.reduce((sum, d) => sum + d.female, 0);
    series.data.setAll([
        { category: "Male", value: totalMale },
        { category: "Female", value: totalFemale }
    ]);
    const legend = chart.children.push(am5.Legend.new(root, {
        centerX: am5.p50,
        x: am5.p50
    }));
    legend.data.setAll(series.dataItems);
    charts.studentsGender = root;
}

function createStudentsInternationalChart() {
    if (charts.studentsIntl) charts.studentsIntl.dispose();
    const root = am5.Root.new("studentsInternational");
    root.setThemes([am5themes_Animated.new(root)]);
    const chart = root.container.children.push(am5percent.PieChart.new(root, {
        innerRadius: am5.percent(50)
    }));
    const series = chart.series.push(am5percent.PieSeries.new(root, {
        valueField: "value",
        categoryField: "category"
    }));
    series.data.setAll([
        { category: "International", value: dashboardData.demographics.international },
        { category: "Domestic", value: dashboardData.demographics.domestic }
    ]);
    const legend = chart.children.push(am5.Legend.new(root, {
        centerX: am5.p50,
        x: am5.p50
    }));
    legend.data.setAll(series.dataItems);
    charts.studentsIntl = root;
}

// ============================================
// PROFESSORS PAGE
// ============================================
function renderProfessorsPage() {
    const avgSalary = dashboardData.kpi.avg_salary;
    const totalProfs = dashboardData.kpi.total_professors;
    const kpis = [
        { label: 'Total Faculty', value: totalProfs.toLocaleString(), icon: '👥', color: '#7c3aed' },
        { label: 'Avg Salary', value: `${(avgSalary/1000).toFixed(0)}K`, icon: '💰', color: '#10b981' },
        { label: 'Avg Experience', value: '14.5 yrs', icon: '📅', color: '#f59e0b' },
        { label: 'Full Professors', value: '35%', icon: '🎓', color: '#2563eb' }
    ];
    document.getElementById('professorsKPIs').innerHTML = kpis.map(k => `
        <div class="kpi-card" style="border-left-color: ${k.color}">
            <div class="kpi-label"><span style="font-size: 1.5em">${k.icon}</span> ${k.label}</div>
            <div class="kpi-value">${k.value}</div>
        </div>
    `).join('');
    am5.ready(() => {
        createProfessorsSalaryChart();
        createProfessorsDeptChart();
        createProfessorsExperienceChart();
    });
    loadProfessorsTable();
}

async function loadProfessorsTable() {
    const dept = document.getElementById('globalDeptFilter')?.value || 'all';
    const params = new URLSearchParams();
    if (dept !== 'all') params.append('department', dept);
    const queryString = params.toString() ? '?' + params.toString() : '';
    
    try {
        const professors = await fetch('/api/professors-table' + queryString).then(r => r.json());
        const tbody = document.querySelector('#professorsTable tbody');
        tbody.innerHTML = professors.map(p => `
            <tr>
                <td>${p.name}</td>
                <td>${p.department}</td>
                <td><span class="badge badge-info">${p.position}</span></td>
                <td>${p.experience || 'N/A'} years</td>
                <td>${p.salary ? p.salary.toLocaleString() : 'N/A'}</td>
            </tr>
        `).join('');
    } catch (error) {
        console.error('Error loading professors table:', error);
    }
}

function createProfessorsSalaryChart() {
    if (charts.profSalary) charts.profSalary.dispose();
    const root = am5.Root.new("professorsSalary");
    root.setThemes([am5themes_Animated.new(root)]);
    const chart = root.container.children.push(am5xy.XYChart.new(root, {}));
    const yAxis = chart.yAxes.push(am5xy.CategoryAxis.new(root, {
        categoryField: "position",
        renderer: am5xy.AxisRendererY.new(root, { inversed: true })
    }));
    yAxis.data.setAll(dashboardData.salaries);
    const xAxis = chart.xAxes.push(am5xy.ValueAxis.new(root, {
        renderer: am5xy.AxisRendererX.new(root, {})
    }));
    const series = chart.series.push(am5xy.ColumnSeries.new(root, {
        xAxis: xAxis,
        yAxis: yAxis,
        valueXField: "salary",
        categoryYField: "position",
        tooltip: am5.Tooltip.new(root, { labelText: "${valueX}" })
    }));
    series.columns.template.setAll({ cornerRadiusTR: 5, cornerRadiusBR: 5 });
    series.data.setAll(dashboardData.salaries);
    charts.profSalary = root;
}

function createProfessorsDeptChart() {
    if (charts.profDept) charts.profDept.dispose();
    const root = am5.Root.new("professorsDept");
    root.setThemes([am5themes_Animated.new(root)]);
    const chart = root.container.children.push(am5percent.PieChart.new(root, {}));
    const series = chart.series.push(am5percent.PieSeries.new(root, {
        valueField: "count",
        categoryField: "department"
    }));
    series.data.setAll(dashboardData.profByDept);
    const legend = chart.children.push(am5.Legend.new(root, {
        centerX: am5.p50,
        x: am5.p50
    }));
    legend.data.setAll(series.dataItems);
    charts.profDept = root;
}

function createProfessorsExperienceChart() {
    if (charts.profExp) charts.profExp.dispose();
    const root = am5.Root.new("professorsExperience");
    root.setThemes([am5themes_Animated.new(root)]);
    const chart = root.container.children.push(am5xy.XYChart.new(root, {}));
    const experienceBuckets = [
        { range: "0-5 years", count: 45 },
        { range: "6-10 years", count: 32 },
        { range: "11-15 years", count: 28 },
        { range: "16-20 years", count: 22 },
        { range: "20+ years", count: 38 }
    ];
    const xAxis = chart.xAxes.push(am5xy.CategoryAxis.new(root, {
        categoryField: "range",
        renderer: am5xy.AxisRendererX.new(root, {})
    }));
    xAxis.data.setAll(experienceBuckets);
    const yAxis = chart.yAxes.push(am5xy.ValueAxis.new(root, {
        renderer: am5xy.AxisRendererY.new(root, {})
    }));
    const series = chart.series.push(am5xy.ColumnSeries.new(root, {
        xAxis: xAxis,
        yAxis: yAxis,
        valueYField: "count",
        categoryXField: "range"
    }));
    series.columns.template.setAll({ cornerRadiusTL: 5, cornerRadiusTR: 5 });
    series.data.setAll(experienceBuckets);
    charts.profExp = root;
}

// PART 2 - Courses, Research, Employment, Finances Pages

// ============================================
// COURSES PAGE
// ============================================
function renderCoursesPage() {
    const totalCourses = dashboardData.kpi.total_courses;
    const avgEnrollment = Math.round(dashboardData.courses.reduce((sum, c) => sum + c.students, 0) / dashboardData.courses.length);
    const kpis = [
        { label: 'Total Courses', value: totalCourses.toLocaleString(), icon: '📚', color: '#2563eb' },
        { label: 'Avg Enrollment', value: avgEnrollment, icon: '👥', color: '#10b981' },
        { label: 'Avg Rating', value: '4.5', icon: '⭐', color: '#f59e0b' },
        { label: 'Capacity Used', value: '78%', icon: '📊', color: '#7c3aed' }
    ];
    document.getElementById('coursesKPIs').innerHTML = kpis.map(k => `
        <div class="kpi-card" style="border-left-color: ${k.color}">
            <div class="kpi-label"><span style="font-size: 1.5em">${k.icon}</span> ${k.label}</div>
            <div class="kpi-value">${k.value}</div>
        </div>
    `).join('');
    am5.ready(() => {
        createCoursesPopularChart();
        createCoursesByDeptChart();
        createCoursesRatingsChart();
        createCoursesCapacityChart();
    });
}

function createCoursesPopularChart() {
    if (charts.coursesPopular) charts.coursesPopular.dispose();
    const root = am5.Root.new("coursesPopular");
    root.setThemes([am5themes_Animated.new(root)]);
    const chart = root.container.children.push(am5xy.XYChart.new(root, {
        paddingBottom: 50
    }));
    const topCourses = dashboardData.courses.slice(0, 10); // Reduced from 15 to 10
    const xAxis = chart.xAxes.push(am5xy.CategoryAxis.new(root, {
        categoryField: "course",
        renderer: am5xy.AxisRendererX.new(root, {
            minGridDistance: 20
        })
    }));
    xAxis.data.setAll(topCourses);
    xAxis.get("renderer").labels.template.setAll({
        rotation: -45,
        centerY: am5.p50,
        centerX: am5.p100,
        paddingRight: 15,
        fontSize: 10,
        maxWidth: 100,
        oversizedBehavior: "truncate"
    });
    const yAxis = chart.yAxes.push(am5xy.ValueAxis.new(root, {
        renderer: am5xy.AxisRendererY.new(root, {})
    }));
    const series = chart.series.push(am5xy.ColumnSeries.new(root, {
        xAxis: xAxis,
        yAxis: yAxis,
        valueYField: "students",
        categoryXField: "course",
        tooltip: am5.Tooltip.new(root, { labelText: "{category}: {valueY} students" })
    }));
    series.columns.template.setAll({ cornerRadiusTL: 5, cornerRadiusTR: 5 });
    series.data.setAll(topCourses);
    charts.coursesPopular = root;
}

function createCoursesByDeptChart() {
    if (charts.coursesDept) charts.coursesDept.dispose();
    const root = am5.Root.new("coursesByDept");
    root.setThemes([am5themes_Animated.new(root)]);
    const chart = root.container.children.push(am5percent.PieChart.new(root, {
        innerRadius: am5.percent(50)
    }));
    const series = chart.series.push(am5percent.PieSeries.new(root, {
        valueField: "count",
        categoryField: "department"
    }));
    const coursesByDept = {};
    dashboardData.courses.forEach(c => {
        coursesByDept[c.department] = (coursesByDept[c.department] || 0) + 1;
    });
    const data = Object.entries(coursesByDept).map(([department, count]) => ({ department, count }));
    series.data.setAll(data);
    const legend = chart.children.push(am5.Legend.new(root, {
        centerX: am5.p50,
        x: am5.p50
    }));
    legend.data.setAll(series.dataItems);
    charts.coursesDept = root;
}

function createCoursesRatingsChart() {
    if (charts.coursesRatings) charts.coursesRatings.dispose();
    const root = am5.Root.new("coursesRatings");
    root.setThemes([am5themes_Animated.new(root)]);
    const chart = root.container.children.push(am5xy.XYChart.new(root, {}));
    const ratingBuckets = [
        { rating: "4.5-5.0", count: 25 },
        { rating: "4.0-4.4", count: 35 },
        { rating: "3.5-3.9", count: 20 },
        { rating: "3.0-3.4", count: 12 },
        { rating: "Below 3.0", count: 8 }
    ];
    const xAxis = chart.xAxes.push(am5xy.CategoryAxis.new(root, {
        categoryField: "rating",
        renderer: am5xy.AxisRendererX.new(root, {})
    }));
    xAxis.data.setAll(ratingBuckets);
    const yAxis = chart.yAxes.push(am5xy.ValueAxis.new(root, {
        renderer: am5xy.AxisRendererY.new(root, {})
    }));
    const series = chart.series.push(am5xy.ColumnSeries.new(root, {
        xAxis: xAxis,
        yAxis: yAxis,
        valueYField: "count",
        categoryXField: "rating"
    }));
    series.columns.template.setAll({ cornerRadiusTL: 5, cornerRadiusTR: 5 });
    series.data.setAll(ratingBuckets);
    charts.coursesRatings = root;
}

function createCoursesCapacityChart() {
    if (charts.coursesCapacity) charts.coursesCapacity.dispose();
    const root = am5.Root.new("coursesCapacity");
    root.setThemes([am5themes_Animated.new(root)]);
    const chart = root.container.children.push(am5percent.PieChart.new(root, {}));
    const series = chart.series.push(am5percent.PieSeries.new(root, {
        valueField: "value",
        categoryField: "category"
    }));
    series.data.setAll([
        { category: "< 50% Full", value: 15 },
        { category: "50-75% Full", value: 35 },
        { category: "75-90% Full", value: 30 },
        { category: "> 90% Full", value: 20 }
    ]);
    const legend = chart.children.push(am5.Legend.new(root, {
        centerX: am5.p50,
        x: am5.p50
    }));
    legend.data.setAll(series.dataItems);
    charts.coursesCapacity = root;
}

// ============================================
// RESEARCH PAGE
// ============================================
function renderResearchPage() {
    const kpis = [
        { label: 'Total Publications', value: '2,150', icon: '📄', color: '#2563eb' },
        { label: 'Total Citations', value: '18,450', icon: '📊', color: '#10b981' },
        { label: 'Avg Citations', value: '8.6', icon: '⭐', color: '#f59e0b' },
        { label: 'H-Index', value: '42', icon: '🎯', color: '#7c3aed' }
    ];
    document.getElementById('researchKPIs').innerHTML = kpis.map(k => `
        <div class="kpi-card" style="border-left-color: ${k.color}">
            <div class="kpi-label"><span style="font-size: 1.5em">${k.icon}</span> ${k.label}</div>
            <div class="kpi-value">${k.value}</div>
        </div>
    `).join('');
    am5.ready(() => {
        createResearchTrendChart();
        createResearchByDeptChart();
        createResearchCitationsChart();
    });
}

function createResearchTrendChart() {
    if (charts.researchTrend) charts.researchTrend.dispose();
    const root = am5.Root.new("researchTrend");
    root.setThemes([am5themes_Animated.new(root)]);
    const chart = root.container.children.push(am5xy.XYChart.new(root, {}));
    const xAxis = chart.xAxes.push(am5xy.CategoryAxis.new(root, {
        categoryField: "year",
        renderer: am5xy.AxisRendererX.new(root, {})
    }));
    xAxis.data.setAll(dashboardData.research);
    const yAxis = chart.yAxes.push(am5xy.ValueAxis.new(root, {
        renderer: am5xy.AxisRendererY.new(root, {})
    }));
    const series = chart.series.push(am5xy.LineSeries.new(root, {
        xAxis: xAxis,
        yAxis: yAxis,
        valueYField: "count",
        categoryXField: "year",
        stroke: am5.color(0x2563eb),
        tooltip: am5.Tooltip.new(root, { labelText: "{valueY} publications" })
    }));
    series.strokes.template.setAll({ strokeWidth: 3 });
    series.fills.template.setAll({ fillOpacity: 0.2, visible: true });
    series.data.setAll(dashboardData.research);
    series.bullets.push(() => am5.Bullet.new(root, {
        sprite: am5.Circle.new(root, { radius: 6, fill: am5.color(0x2563eb) })
    }));
    charts.researchTrend = root;
}

function createResearchByDeptChart() {
    if (charts.researchDept) charts.researchDept.dispose();
    const root = am5.Root.new("researchByDept");
    root.setThemes([am5themes_Animated.new(root)]);
    const chart = root.container.children.push(am5xy.XYChart.new(root, {}));
    const researchByDept = [
        { department: 'Engineering', count: 650 },
        { department: 'Science', count: 580 },
        { department: 'Medicine', count: 520 },
        { department: 'Business', count: 280 },
        { department: 'Arts', count: 120 }
    ];
    const xAxis = chart.xAxes.push(am5xy.CategoryAxis.new(root, {
        categoryField: "department",
        renderer: am5xy.AxisRendererX.new(root, {})
    }));
    xAxis.data.setAll(researchByDept);
    const yAxis = chart.yAxes.push(am5xy.ValueAxis.new(root, {
        renderer: am5xy.AxisRendererY.new(root, {})
    }));
    const series = chart.series.push(am5xy.ColumnSeries.new(root, {
        xAxis: xAxis,
        yAxis: yAxis,
        valueYField: "count",
        categoryXField: "department"
    }));
    series.columns.template.setAll({ cornerRadiusTL: 5, cornerRadiusTR: 5 });
    series.data.setAll(researchByDept);
    charts.researchDept = root;
}

function createResearchCitationsChart() {
    if (charts.researchCitations) charts.researchCitations.dispose();
    const root = am5.Root.new("researchCitations");
    root.setThemes([am5themes_Animated.new(root)]);
    const chart = root.container.children.push(am5xy.XYChart.new(root, {}));
    const citationData = dashboardData.research.map(r => ({
        year: r.year,
        citations: r.total_citations || Math.floor(Math.random() * 5000) + 1000
    }));
    const xAxis = chart.xAxes.push(am5xy.CategoryAxis.new(root, {
        categoryField: "year",
        renderer: am5xy.AxisRendererX.new(root, {})
    }));
    xAxis.data.setAll(citationData);
    const yAxis = chart.yAxes.push(am5xy.ValueAxis.new(root, {
        renderer: am5xy.AxisRendererY.new(root, {})
    }));
    const series = chart.series.push(am5xy.LineSeries.new(root, {
        xAxis: xAxis,
        yAxis: yAxis,
        valueYField: "citations",
        categoryXField: "year",
        stroke: am5.color(0x10b981),
        tooltip: am5.Tooltip.new(root, { labelText: "{valueY} citations" })
    }));
    series.strokes.template.setAll({ strokeWidth: 3 });
    series.data.setAll(citationData);
    charts.researchCitations = root;
}

// ============================================
// EMPLOYMENT PAGE
// ============================================
function renderEmploymentPage() {
    const kpis = [
        { label: 'Employment Rate', value: `${dashboardData.kpi.employment_rate}%`, icon: '💼', color: '#10b981' },
        { label: 'Avg Salary', value: '$78K', icon: '💰', color: '#2563eb' },
        { label: 'Top Sector', value: 'Technology', icon: '💻', color: '#7c3aed' },
        { label: 'Time to Employ', value: '3.2 mo', icon: '⏱️', color: '#f59e0b' }
    ];
    document.getElementById('employmentKPIs').innerHTML = kpis.map(k => `
        <div class="kpi-card" style="border-left-color: ${k.color}">
            <div class="kpi-label"><span style="font-size: 1.5em">${k.icon}</span> ${k.label}</div>
            <div class="kpi-value">${k.value}</div>
        </div>
    `).join('');
    am5.ready(() => {
        createEmploymentSectorsChart();
        createEmploymentSalariesChart();
        createEmploymentByDeptChart();
    });
}

function createEmploymentSectorsChart() {
    if (charts.employmentSectors) charts.employmentSectors.dispose();
    const root = am5.Root.new("employmentSectors");
    root.setThemes([am5themes_Animated.new(root)]);
    const chart = root.container.children.push(am5percent.PieChart.new(root, {}));
    const series = chart.series.push(am5percent.PieSeries.new(root, {
        valueField: "count",
        categoryField: "sector"
    }));
    series.data.setAll(dashboardData.employment);
    const legend = chart.children.push(am5.Legend.new(root, {
        centerX: am5.p50,
        x: am5.p50
    }));
    legend.data.setAll(series.dataItems);
    charts.employmentSectors = root;
}

function createEmploymentSalariesChart() {
    if (charts.employmentSalaries) charts.employmentSalaries.dispose();
    const root = am5.Root.new("employmentSalaries");
    root.setThemes([am5themes_Animated.new(root)]);
    const chart = root.container.children.push(am5xy.XYChart.new(root, {}));
    const salaryData = dashboardData.employment.filter(e => e.avg_salary).map(e => ({
        sector: e.sector,
        salary: e.avg_salary
    }));
    const xAxis = chart.xAxes.push(am5xy.CategoryAxis.new(root, {
        categoryField: "sector",
        renderer: am5xy.AxisRendererX.new(root, {})
    }));
    xAxis.data.setAll(salaryData);
    const yAxis = chart.yAxes.push(am5xy.ValueAxis.new(root, {
        renderer: am5xy.AxisRendererY.new(root, {})
    }));
    const series = chart.series.push(am5xy.ColumnSeries.new(root, {
        xAxis: xAxis,
        yAxis: yAxis,
        valueYField: "salary",
        categoryXField: "sector",
        tooltip: am5.Tooltip.new(root, { labelText: "${valueY}" })
    }));
    series.columns.template.setAll({ cornerRadiusTL: 5, cornerRadiusTR: 5 });
    series.data.setAll(salaryData);
    charts.employmentSalaries = root;
}

function createEmploymentByDeptChart() {
    if (charts.employmentByDept) charts.employmentByDept.dispose();
    const root = am5.Root.new("employmentByDept");
    root.setThemes([am5themes_Animated.new(root)]);
    const chart = root.container.children.push(am5xy.XYChart.new(root, {}));
    const employmentByDept = [
        { department: 'Engineering', rate: 95 },
        { department: 'Medicine', rate: 92 },
        { department: 'Business', rate: 88 },
        { department: 'Science', rate: 85 },
        { department: 'Arts', rate: 78 }
    ];
    const xAxis = chart.xAxes.push(am5xy.CategoryAxis.new(root, {
        categoryField: "department",
        renderer: am5xy.AxisRendererX.new(root, {})
    }));
    xAxis.data.setAll(employmentByDept);
    const yAxis = chart.yAxes.push(am5xy.ValueAxis.new(root, {
        renderer: am5xy.AxisRendererY.new(root, {}),
        min: 0,
        max: 100
    }));
    const series = chart.series.push(am5xy.ColumnSeries.new(root, {
        xAxis: xAxis,
        yAxis: yAxis,
        valueYField: "rate",
        categoryXField: "department",
        tooltip: am5.Tooltip.new(root, { labelText: "{valueY}%" })
    }));
    series.columns.template.setAll({ cornerRadiusTL: 5, cornerRadiusTR: 5 });
    series.data.setAll(employmentByDept);
    charts.employmentByDept = root;
}

// ============================================
// FINANCES PAGE
// ============================================
function renderFinancesPage() {
    const totalRevenue = dashboardData.kpi.total_students * dashboardData.kpi.avg_fee;
    const kpis = [
        { label: 'Total Revenue', value: `$${(totalRevenue/1000000).toFixed(1)}M`, icon: '💰', color: '#10b981' },
        { label: 'Avg Tuition', value: `$${(dashboardData.kpi.avg_fee/1000).toFixed(0)}K`, icon: '💵', color: '#2563eb' },
        { label: 'Budget Allocated', value: '$15.8M', icon: '📊', color: '#7c3aed' },
        { label: 'Financial Aid', value: '$8.2M', icon: '🎓', color: '#f59e0b' }
    ];
    document.getElementById('financesKPIs').innerHTML = kpis.map(k => `
        <div class="kpi-card" style="border-left-color: ${k.color}">
            <div class="kpi-label"><span style="font-size: 1.5em">${k.icon}</span> ${k.label}</div>
            <div class="kpi-value">${k.value}</div>
        </div>
    `).join('');
    am5.ready(() => {
        createFinancesRevenueChart();
        createFinancesFeesChart();
        createFinancesBudgetsChart();
    });
}

function createFinancesRevenueChart() {
    if (charts.financesRevenue) charts.financesRevenue.dispose();
    const root = am5.Root.new("financesRevenue");
    root.setThemes([am5themes_Animated.new(root)]);
    const chart = root.container.children.push(am5percent.PieChart.new(root, {}));
    const series = chart.series.push(am5percent.PieSeries.new(root, {
        valueField: "value",
        categoryField: "category"
    }));
    series.data.setAll([
        { category: 'Tuition Fees', value: 65 },
        { category: 'Research Grants', value: 20 },
        { category: 'Donations', value: 10 },
        { category: 'Other', value: 5 }
    ]);
    const legend = chart.children.push(am5.Legend.new(root, {
        centerX: am5.p50,
        x: am5.p50
    }));
    legend.data.setAll(series.dataItems);
    charts.financesRevenue = root;
}

function createFinancesFeesChart() {
    if (charts.financesFees) charts.financesFees.dispose();
    const root = am5.Root.new("financesFees");
    root.setThemes([am5themes_Animated.new(root)]);
    const chart = root.container.children.push(am5xy.XYChart.new(root, {}));
    const xAxis = chart.xAxes.push(am5xy.CategoryAxis.new(root, {
        categoryField: "program",
        renderer: am5xy.AxisRendererX.new(root, {})
    }));
    xAxis.data.setAll(dashboardData.fees);
    const yAxis = chart.yAxes.push(am5xy.ValueAxis.new(root, {
        renderer: am5xy.AxisRendererY.new(root, {})
    }));
    const series = chart.series.push(am5xy.ColumnSeries.new(root, {
        xAxis: xAxis,
        yAxis: yAxis,
        valueYField: "fee",
        categoryXField: "program",
        tooltip: am5.Tooltip.new(root, { labelText: "${valueY}" })
    }));
    series.columns.template.setAll({ cornerRadiusTL: 5, cornerRadiusTR: 5 });
    series.data.setAll(dashboardData.fees);
    charts.financesFees = root;
}

function createFinancesBudgetsChart() {
    if (charts.financesBudgets) charts.financesBudgets.dispose();
    const root = am5.Root.new("financesBudgets");
    root.setThemes([am5themes_Animated.new(root)]);
    const chart = root.container.children.push(am5xy.XYChart.new(root, {}));
    const budgets = [
        { department: 'Medicine', budget: 6000000 },
        { department: 'Engineering', budget: 5000000 },
        { department: 'Science', budget: 4500000 },
        { department: 'Business', budget: 3500000 },
        { department: 'Arts', budget: 2800000 }
    ];
    const yAxis = chart.yAxes.push(am5xy.CategoryAxis.new(root, {
        categoryField: "department",
        renderer: am5xy.AxisRendererY.new(root, { inversed: true })
    }));
    yAxis.data.setAll(budgets);
    const xAxis = chart.xAxes.push(am5xy.ValueAxis.new(root, {
        renderer: am5xy.AxisRendererX.new(root, {})
    }));
    const series = chart.series.push(am5xy.ColumnSeries.new(root, {
        xAxis: xAxis,
        yAxis: yAxis,
        valueXField: "budget",
        categoryYField: "department",
        tooltip: am5.Tooltip.new(root, { labelText: "${valueX}" })
    }));
    series.columns.template.setAll({ cornerRadiusTR: 5, cornerRadiusBR: 5 });
    series.data.setAll(budgets);
    charts.financesBudgets = root;
}

// ============================================
// UTILITY FUNCTIONS
// ============================================
function loadDepartmentFilters() {
    const depts = [...new Set(dashboardData.studentsDept.map(d => d.department))];
    const select = document.getElementById('globalDeptFilter');
    depts.forEach(dept => {
        const option = document.createElement('option');
        option.value = dept;
        option.textContent = dept;
        select.appendChild(option);
    });
}

function applyFilters() {
    console.log('Filters applied - reloading data...');
    document.getElementById('loadingState').style.display = 'block';
    document.getElementById('contentArea').style.display = 'none';
    
    fetchAllData().then(() => {
        renderCurrentPage();
        document.getElementById('loadingState').style.display = 'none';
        document.getElementById('contentArea').style.display = 'block';
    }).catch(error => {
        showError(error.message);
    });
}

function exportData() {
    alert('Export functionality - Coming Soon!\nThis will export current page data to CSV/Excel');
}

function showError(message) {
    document.getElementById('loadingState').style.display = 'none';
    document.getElementById('errorState').innerHTML = `
        <div class="error-message">
            <h3>⚠️ Error Loading Dashboard</h3>
            <p>${message}</p>
            <p style="margin-top: 10px; font-size: 0.9em;">Please ensure Flask server is running and database is connected.</p>
        </div>
    `;
    document.getElementById('errorState').style.display = 'block';
}

