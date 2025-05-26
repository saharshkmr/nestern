import 'package:flutter/material.dart';
import 'package:nestern/models/course.dart';
import 'package:nestern/models/job.dart';
import 'package:nestern/screens/dashboard.dart';
import 'package:nestern/screens/data_science_course.dart';
import 'package:nestern/screens/employer/course_details.dart';
import 'package:nestern/screens/employer/internship_details.dart';
import 'package:nestern/screens/employer/job_details.dart';
import 'package:nestern/screens/employer_signup.dart';
import 'package:nestern/screens/full_stack_course.dart';
import 'package:nestern/screens/internship_bangalore.dart';
import 'package:nestern/screens/internship_delhi.dart';
import 'package:nestern/screens/internship_mumbai.dart';
import 'package:nestern/screens/login.dart';
import 'package:nestern/screens/student_signup.dart';
import 'package:nestern/services/course_service.dart';
import 'package:nestern/services/internship_service.dart';
import 'package:nestern/services/job_service.dart';
import 'package:nestern/widgets/hoverableDropdown.dart';
import 'package:nestern/models/internship.dart';
import 'package:nestern/widgets/mobile_internship_card.dart'; // Make sure this path matches where your Internship class is defined

class InternshipsPage extends StatefulWidget {
  InternshipsPage({Key? key}) : super(key: key);

  @override
  _InternshipsPageState createState() => _InternshipsPageState();
}

class _InternshipsPageState extends State<InternshipsPage> {
  List<Internship> _latestInternships = [];

  @override
  void initState() {
    super.initState();
    fetchLatestInternships();
  fetchLatestJobs();
  fetchLatestCourses(); // <-- ADD THIS LINE
  }

  
  Future<void> fetchLatestJobs() async {
    try {
      final jobService = JobService();
      final jobs = await jobService.getRecentJobs(); // Adjust method name as per your service
      setState(() {
        _latestJobs = jobs;
      });
    } catch (e) {
      // Handle error, e.g. show a snackbar or log
      print('Failed to fetch jobs: $e');
    }
  }

    Future<void> fetchLatestInternships() async {
    try {
      final internshipService = InternshipService();
      final internships = await internshipService.getRecentInternships(); // Adjust method name as per your service
      setState(() {
        _latestInternships = internships.cast<Internship>();
      });
    } catch (e) {
      print('Failed to fetch internships: $e');
    }
  }
  
  Future<void> fetchLatestCourses() async {
  try {
    final courseService = CourseService();
    final courses = await courseService.getAllCourses(); // Implement this!
    setState(() {
      _latestCourses = courses;
    });
  } catch (e) {
    print('Failed to fetch courses: $e');
  }
}

List<Job> _latestJobs = []; 
List<Course> _latestCourses = [];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60), // Set the height of the custom header
        child: _buildHeader(context), // Use the custom header
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Title
            Text(
              '${_latestInternships.length} Total Internships',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            // Subtitle
            Text(
              'Latest Summer Internships in India',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16),
            // Internship Cards
            Expanded(
              child: ListView(
                children: _latestInternships.map((internship) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: MobileInternshipCard(
                      internship: internship,
                    ),
                  );
                }).toList(),
              ),
            ),  
          ],
        ),
      ),
    );
  }

  // Define the _buildHeader method
  Widget _buildHeader(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: screenWidth < 1260,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Dashboard()),
                    );
                  },
                  child: screenWidth < 700
                      ? Text(
                          'NESTERN',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        )
                      : Image.asset(
                          'assets/main_logo.png',
                          width: 120,
                          height: 40,
                        ),
                ),
                SizedBox(width: 16),
                if (screenWidth >= 1260) ...[
                  HoverableDropdown(
                    title: 'Internships',
                    items: _latestInternships
                        .take(6)
                        .map((internship) => PopupMenuItem<String>(
                              value: internship.title,
                              child: Text(internship.title),
                            ))
                        .toList(),
                    onSelected: (selectedInternshipTitle) {
                      final selectedInternship = _latestInternships.firstWhere(
                        (i) => i.title == selectedInternshipTitle,
                        orElse: () => _latestInternships.first,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InternshipDetailsPage(internship: selectedInternship),
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 16),
                  HoverableDropdown(
                    title: 'Jobs',
                    items: _latestJobs
                        .take(6)
                        .map((job) => PopupMenuItem<String>(
                              value: job.title,
                              child: Text(job.title),
                            ))
                        .toList(),
                    onSelected: (selectedJobTitle) {
                      final selectedJob = _latestJobs.firstWhere(
                        (j) => j.title == selectedJobTitle,
                        orElse: () => _latestJobs.first,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JobDetailsPage(job: selectedJob),
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 16),
                  HoverableDropdown(
                    title: 'Courses',
                    items: _latestCourses
                        .take(6)
                        .map((course) => PopupMenuItem<String>(
                              value: course.title,
                              child: Text(course.title),
                            ))
                        .toList(),
                    badge: Container(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'OFFER',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                    onSelected: (selectedCourseTitle) {
                      final selectedCourse = _latestCourses.firstWhere(
                        (c) => c.title == selectedCourseTitle,
                        orElse: () => _latestCourses.first,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CourseDetailsPage(course: selectedCourse),
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 16),
                ],
              ],
            ),
            Row(
              children: [
                if (screenWidth > 991)
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue,
                      side: BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Text('Login'),
                  ),
                SizedBox(width: 8),
                if (screenWidth > 767) ...[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StudentSignUpPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Text('Candidate Sign-up'),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EmployerSignUpPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Text('Employer Sign-up'),
                  ),
                ] else ...[
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: DropdownButton<String>(
                      hint: Text(
                        'Register',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      icon: Icon(Icons.arrow_drop_down, color: Colors.white, size: 20),
                      items: [
                        DropdownMenuItem(
                          value: 'student',
                          child: Text(
                            'As a Student',
                            style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontSize: 14),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'employer',
                          child: Text(
                            'As an Employer',
                            style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontSize: 14),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == 'student') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => StudentSignUpPage()),
                          );
                        } else if (value == 'employer') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EmployerSignUpPage()),
                          );
                        }
                      },
                      underline: SizedBox(),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}