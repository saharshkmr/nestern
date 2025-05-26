import 'package:flutter/material.dart';
import 'package:nestern/models/course.dart';
import 'package:nestern/models/internship.dart';
import 'package:nestern/models/job.dart';
import 'package:nestern/models/user.dart' as my_model;
import 'package:nestern/screens/employer/course_details.dart';
import 'package:nestern/screens/employer/internship_details.dart';
import 'package:nestern/screens/employer/job_details.dart';
import 'package:nestern/screens/student/student_dashboard.dart';
import 'package:nestern/screens/internships.dart';
import 'package:nestern/services/course_service.dart';
import 'package:nestern/services/internship_service.dart';
import 'package:nestern/services/job_service.dart';
import 'package:nestern/widgets/hoverableDropdown.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Notification extends StatefulWidget {
  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<Notification> {
  final List<String> applications = []; // Replace with your dynamic data source

  my_model.User? user; // <-- Use your model type here
  List<Internship> _latestInternships = [];
  List<Job> _latestJobs = []; 
  List<Course> _latestCourses = [];

  @override
  void initState() {
    super.initState();
    fetchLatestInternships();
    fetchLatestJobs();
    fetchLatestCourses(); // <-- ADD THIS LINE
    fetchCurrentUser(); // <-- Add this
  }

  Future<void> fetchLatestInternships() async {
    try {
      final internshipService = InternshipService();
      final fetchedInternships = await internshipService.getRecentInternships();
      setState(() {
        _latestInternships = fetchedInternships.cast<Internship>();
        // isLoading = false; // <-- Set loading to false here (add if needed)
      });
    } catch (e) {
      print('Failed to fetch internships: $e');
      setState(() {
        // isLoading = false; // <-- Also set loading to false on error (add if needed)
      });
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

  Future<void> fetchCurrentUser() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get();
      setState(() {
        user = my_model.User.fromMap(userDoc.data() as Map<String, dynamic>);
      });
    }
  }


  Widget _buildHeader(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Background color of the header
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Shadow color
            spreadRadius: 2, // Spread radius
            blurRadius: 4, // Blur radius
            offset: Offset(0, 2), // Offset in the downward direction
          ),
        ],
      ),
      child: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // Remove default AppBar shadow
        automaticallyImplyLeading: screenWidth < 1260, // Remove the back button
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo and HoverableDropdowns grouped together
            Row(
              children: [
                // Logo or Text based on screen width
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StudentDashboard()),
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
                          width: 120, // Smaller logo for larger screens
                          height: 40, // Adjust height accordingly
                        ),
                ),
                SizedBox(width: 16), // Space between logo and dropdowns
                if (screenWidth >= 1260) ...[
                  // HoverableDropdowns for larger screens
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
            Row(
              children: [
                SizedBox(width: 16), // Space between search bar and icons
                IconButton(
                  icon: Icon(Icons.notifications, color: Colors.black),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('No new notifications')),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.account_circle, color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InternshipsPage()),
                    );
                  },
                ),
                TextButton(
                  onPressed: () {
                    // if (appUser != null) {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(builder: (context) => ProfilePage(user: appUser!)),
                    //   );
                    // } else {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(content: Text('User data not loaded yet')),
                    //   );
                    // }
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                    side: BorderSide(color: Colors.blue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Text('Logout'),
                ),
              ],
            ),
          ],
          ]),
      ])),
      );
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: _buildHeader(context),
      ),
      body: applications.isEmpty
          ? Center(
              child: Text(
                'No Notification yet',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            )
          : ListView.builder(
              itemCount: applications.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(applications[index]),
                );
              },
            ),
    );
  }

}