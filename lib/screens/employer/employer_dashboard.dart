import 'package:flutter/material.dart';
import 'package:nestern/screens/dashboard.dart';
import 'package:nestern/screens/employer/create_course_screen.dart';
import 'package:nestern/screens/employer/create_internship.dart';
import 'package:nestern/screens/employer/create_job_screen.dart';
import 'package:nestern/screens/employer/employer_profile.dart';
import 'package:nestern/screens/employer/post.dart';
import 'package:nestern/screens/login.dart';
import 'package:nestern/screens/student/enrolled_courses.dart';
import 'package:nestern/screens/student/myapplications.dart';
import 'package:nestern/screens/student/saved.dart';
import 'package:nestern/screens/student/student_dashboard.dart';
import 'package:nestern/screens/internships.dart';
import 'package:nestern/screens/jobs.dart';
import 'package:nestern/screens/contact_us.dart';
import 'package:nestern/models/user.dart' as model_user;
import 'package:nestern/services/course_service.dart';
import 'package:nestern/services/internship_service.dart';
import 'package:nestern/services/job_service.dart';
import '../../models/internship.dart';
import '../../models/job.dart';
import '../../models/course.dart';

class EmployerDashboard extends StatefulWidget {
  final model_user.User user;
  EmployerDashboard({Key? key, required this.user}) : super(key: key);

  @override
  State<EmployerDashboard> createState() => _EmployerDashboardState();
}

class _EmployerDashboardState extends State<EmployerDashboard> {
  List<Internship> allInternships = [];
  List<Job> allJobs = [];
  List<Course> allCourses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAllData();
  }

Future<void> fetchAllData() async {
  allInternships = await InternshipService().getAllInternships();
  allJobs = await JobService().getAllJobs();
  allCourses = await CourseService().getAllCourses();
  print('Internships: ${allInternships.length}');
  print('Jobs: ${allJobs.length}');
  print('Courses: ${allCourses.length}');
  setState(() {
    isLoading = false;
  });
}


  @override
  Widget build(BuildContext context) {
  // Use the state variables, NOT new empty lists!
  List<Internship> userInternships = allInternships.where((i) => i.userId == widget.user.id).toList();
  List<Job> userJobs = allJobs.where((j) => j.userId == widget.user.id).toList();
  List<Course> userCourses = allCourses.where((c) => c.userId == widget.user.id).toList();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60), // Set the height of the custom header
        child: _buildHeader(context), // Use the custom header
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
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EmployerDashboard(user: widget.user)),
                  );
                },
                child: Text(
                  'Dashboard',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.work),
              title: Text('Post Internship'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateInternshipScreen(user: widget.user)),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.work),
              title: Text('Post Job'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateJobScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.work),
              title: Text('Post Course'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateCourseScreen(user: widget.user)),
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
      body: Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // ...existing tab and divider code...
                Expanded(
                  child: ListView(
                    children: [
                      Table(
                        border: TableBorder.all(color: Colors.grey),
                        columnWidths: {
                          0: FlexColumnWidth(2),
                          1: FlexColumnWidth(2),
                          2: FlexColumnWidth(1),
                          3: FlexColumnWidth(2),
                          4: FlexColumnWidth(2),
                        },
                        children: [
                          TableRow(
                            decoration: BoxDecoration(color: Colors.grey[200]),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("PROFILE", style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("STATUS", style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("TOTAL VIEWS", style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("ACTION", style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("UPGRADE TO PREMIUM", style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          // Internships
                          ...userInternships.map((internship) => TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(internship.title),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                internship.status,
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text((internship.applyClickCount ?? 0).toString()),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextButton(
                                onPressed: () {
                                  // Handle Action
                                },
                                child: Text("Upgrade"),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Internship"), // <-- Category here
                            ),
                          ],
                        )),
                          // Jobs
                          ...userJobs.map((job) => TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(job.title),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  job.status,
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text((job.applyClickCount ?? 0).toString()),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextButton(
                                  onPressed: () {
                                    // Handle Action
                                  },
                                  child: Text("Upgrade"),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(""),
                              ),
                            ],
                          )),
                          // Courses
                          ...userCourses.map((course) => TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(course.title),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  course.status,
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextButton(
                                  onPressed: () {
                                    // Handle Action
                                  },
                                  child: Text("Upgrade"),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(""),
                              ),
                            ],
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
      automaticallyImplyLeading: screenWidth < 1260, // Remove the back button
      title: Row(
        children: [
          // Logo aligned to the left
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Dashboard()),
              );
            },
            child: Image.asset(
              'assets/main_logo.png',
              width: 120, // Adjust logo size
              height: 40, // Adjust height accordingly
            ),
          ),
          Spacer(), // Push the other elements to the extreme right
          if (screenWidth >= 700) ...[
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateInternshipScreen(user: widget.user)),
                );
              },
              child: Text(
                "Post Internship",
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(width: 16),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateJobScreen()),
                );
              },
              child: Text(
                "Post Job",
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(width: 16),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateCourseScreen(user: widget.user)),
                );
              },
              child: Text(
                "Post Course",
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(width: 16),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  // MaterialPageRoute(builder: (context) => Dashboard()),
                  
                  MaterialPageRoute(builder: (context) => Dashboard()),
                );
              },
              child: Text(
                "Logout",
                style: TextStyle(color: Colors.black),
              ),
            ),
            
            IconButton(
              icon: Icon(Icons.account_circle, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EmployerProfilePage(user: widget.user)),
                );
              },
            ),
          ] else ...[
            // Only Logout and Account Circle for smaller screens
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Dashboard()),
                );
              },
              child: Text(
                "Logout",
                style: TextStyle(color: Colors.black),
              ),
            ),
            IconButton(
              icon: Icon(Icons.account_circle, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EmployerProfilePage(user: widget.user)),
                );
              },
            ),
          ],
        ],
      ),
    ),
  );
}
}