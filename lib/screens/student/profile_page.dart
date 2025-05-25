import 'package:flutter/material.dart';
import 'package:nestern/models/course.dart';
import 'package:nestern/models/job.dart';
import 'package:nestern/screens/dashboard.dart';
import 'package:nestern/screens/employer/course_details.dart';
import 'package:nestern/screens/employer/internship_details.dart';
import 'package:nestern/screens/employer/job_details.dart';
import 'package:nestern/screens/job_banglaore.dart';
import 'package:nestern/screens/job_delhi.dart';
import 'package:nestern/screens/job_mumbai.dart';
import 'package:nestern/screens/login.dart';
import 'package:nestern/screens/student/enrolled_courses.dart';
import 'package:nestern/screens/student/myapplications.dart';
import 'package:nestern/screens/student/saved.dart';
import 'package:nestern/screens/student/student_dashboard.dart';
import 'package:nestern/screens/student/student_profile.dart';
import 'package:nestern/screens/student_signup.dart';
import 'package:nestern/screens/employer_signup.dart';
import 'package:nestern/screens/internship_bangalore.dart';
import 'package:nestern/screens/internship_delhi.dart';
import 'package:nestern/screens/internship_mumbai.dart';
import 'package:nestern/screens/full_stack_course.dart';
import 'package:nestern/screens/data_science_course.dart';
import 'package:nestern/screens/ui_ux_design_course.dart';
import 'package:nestern/screens/internships.dart';
import 'package:nestern/screens/jobs.dart';
import 'package:nestern/screens/contact_us.dart';
import 'package:nestern/services/course_service.dart';
import 'package:nestern/services/internship_service.dart';
import 'package:nestern/services/job_service.dart';
import 'package:nestern/widgets/hoverableDropdown.dart';
import 'package:nestern/models/user.dart' as my_model;
import 'package:nestern/widgets/recommended_widget.dart';
import 'package:nestern/models/internship.dart'; // Add this import for Internship model
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';



class ProfilePage extends StatefulWidget {
  final my_model.User? user;

  ProfilePage({required this.user});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Internship> internships = [];
  bool isLoading = true;

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

final firebaseUser = FirebaseAuth.instance.currentUser;
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

  Future<void> fetchInternships() async {
    final snapshot = await FirebaseFirestore.instance.collection('internships').get();
    final data = snapshot.docs.map((doc) => Internship.fromJson(doc.data())).toList();
    setState(() {
      internships = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: _buildHeader(context),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/drawer.jpeg'), // Replace with your image path
                  fit: BoxFit.cover, // Ensures the image covers the entire header
                ),
              ),
              child: Text(
                'Dashboard',
                style: TextStyle(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.work),
              title: Text('Internships'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InternshipsPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.work),
              title: Text('Jobs'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JobsPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.contact_mail),
              title: Text('Contact Us'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContactUsPage()),
                );
              },
            ),
            Divider(color: Colors.grey),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Logout'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Dashboard()),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
          Text(
            'Welcome, ${widget.user?.profileName ?? "User"}!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
            SizedBox(height: 8),
            Text(
              'Explore internships and jobs tailored for you.',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 16),

            // Navigation Options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDashboardCard(
                  context,
                  icon: Icons.work,
                  title: 'My Applications',
                  onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyApplicationsPage()),
                  );
                    // Navigate to My Applications Page
                  },
                ),
                _buildDashboardCard(
                  context,
                  icon: Icons.book,
                  title: 'Courses',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyCoursesPage()),
                    );
                    // Navigate to Courses Page
                  },
                ),
                _buildDashboardCard(
                  context,
                  icon: Icons.favorite,
                  title: 'Saved Jobs',
                  onTap: () {Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Saved()),
                    );
                    // Navigate to Saved Jobs Page
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Recommended for You',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : internships.isEmpty
                      ? Center(child: Text('No internships found.'))
                      : ListView.builder(
                          itemCount: internships.length,
                          itemBuilder: (context, index) {
                            final internship = internships[index];
                            return RecommendedInternshipCard(
                              internship: internship,
                              onTap: () {
                                // Navigate to Job Details Page or show details
                              },
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  // Add the _buildHeader widget here
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
        automaticallyImplyLeading: screenWidth < 1260, // Automatically show the drawer icon for small screens
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
            // Buttons for larger screens
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
                    if (user != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage(user: user)),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('User data not loaded yet')),
                      );
                    }
                  },
                ),
                TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Dashboard()),
                  );
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
      ],),
    ),
  );
  }

  // Helper Widget for Dashboard Cards
  Widget _buildDashboardCard(BuildContext context,
      {required IconData icon, required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width / 3.5,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget for Job Cards
  Widget _buildJobCard(
      {required String title,
      required String company,
      required String location,
      required VoidCallback onTap}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(company),
            Text(location, style: TextStyle(color: Colors.grey)),
          ],
        ),
        trailing: Icon(Icons.arrow_forward, color: Colors.blue),
        onTap: onTap,
      ),
    );
  }
}