import 'package:flutter/material.dart';
import 'package:nestern/models/course.dart';
import 'package:nestern/models/job.dart';
import 'package:nestern/screens/contact_us.dart';
import 'package:nestern/screens/dashboard.dart';
import 'package:nestern/screens/employer/course_details.dart';
import 'package:nestern/screens/employer/internship_details.dart';
import 'package:nestern/screens/employer/job_details.dart';
import 'package:nestern/screens/employer_signup.dart';
import 'package:nestern/screens/internships.dart';
import 'package:nestern/screens/jobs.dart';
import 'package:nestern/screens/student_signup.dart';
import 'package:nestern/services/course_service.dart';
import 'package:nestern/services/internship_service.dart';
import 'package:nestern/models/internship.dart'; // Make sure this path matches where your Internship model is defined
import 'package:nestern/services/job_service.dart';
import 'package:nestern/widgets/hoverableDropdown.dart';
import 'package:nestern/screens/login.dart';
import 'package:nestern/widgets/internship_card.dart';
import 'package:nestern/widgets/job__card.dart';
import 'package:nestern/widgets/trending_card.dart'; // Import the TrendingSection widget
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nestern/models/user.dart' as my_model;

class StudentDashboard extends StatefulWidget {
  @override
  _StudentDashboardState createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {


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

final firebaseUser = FirebaseAuth.instance.currentUser;
my_model.User? user; // <-- Use your model type here
  List<Internship> _latestInternships = [];
  List<Job> _latestJobs = []; 

    String category = "Big brands"; // Default selected category

    final List<String> categories = [
    "Big brands",
    "Work from home",
    "Part-time",
    "MBA",
    "Engineering",
    "Media",
    "Design",
    "Data Science",
    "Finance",
    "Marketing",
    "Human Resources",
    "Operations",
    "Content Writing",
    "Graphic Design",
    "Sales",
    "Law",
    "Consulting",
    "Education",
    "NGO",
    "Hospitality",
    "Architecture",
    "Others",
  ];

  


List<Course> _latestCourses = [];

bool isLoading = true;

@override
void initState() {
  super.initState();
  fetchLatestInternships();
  fetchLatestJobs();
  fetchLatestCourses();
  fetchCurrentUser();
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
  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: PreferredSize(
      preferredSize: Size.fromHeight(60.0),
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
              style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontSize: 24, fontWeight: FontWeight.bold),
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
    body: ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        // Main Content
        Text(
          'Make your dream career a reality',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8), // Add spacing between the text and the image
        Image.asset(
          'assets/curved_line.png', // Replace with the actual path to your image
          height: 30, // Adjust the height as needed
          fit: BoxFit.contain,
          alignment: Alignment.center,
        ),
        SizedBox(height: 16),
        // Trending Section
        TrendingSection(),
        SizedBox(height: 32),
        // Latest Internships Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: _buildHorizontalSection(
                'Latest internships on Nestern',
                  _latestInternships
                    .map(
                      (internship) => InternshipCard(
                        internship: internship,
                        onViewDetails: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InternshipDetailsPage(internship: internship),
                            ),
                          );
                        },
                      ),
                    )
                    .toList(),
                280, // Adjust height as needed for your card
                null, // Or a ScrollController if you want to control scroll
              ),),
              SizedBox(height: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                          child: _buildHorizontalSection(
                            'Latest jobs on Nestern',
                              _latestJobs.isEmpty
                                ? [
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text('No jobs available'),
                                      ),
                                    )
                                  ]
                                : _latestJobs
                                    .map(
                                      (job) => JobCard(
                                        job: job,
                                        onViewDetails: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => JobDetailsPage(job: job),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                    .toList(),
                            260, // Adjust height as needed for your card
                            null, // Or a ScrollController if you want to control scroll
                          ),
                        ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 32),
        // Footer Section
        // _buildFooter(), // Include the footer here
      ],
    ),
  );
}

  Widget _buildCategoryChip(String label, {bool isSelected = false, VoidCallback? onTap}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: isSelected ? Colors.blue : Colors.grey[200],
      borderRadius: BorderRadius.circular(16),
    ),
    child: GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

  // Header Widget
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

// Footer Widget
//   Widget _buildFooter() {
//   return LayoutBuilder(
//     builder: (context, constraints) {
//       final screenWidth = constraints.maxWidth;

//       if (screenWidth < 767) {
//         // Footer for smaller screens
//         return Container(
//           width: double.infinity, // Ensure the footer spans the full width
//           decoration: BoxDecoration(
//             color: Colors.white,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.2), // Shadow color
//                 spreadRadius: 2, // Spread radius
//                 blurRadius: 4, // Blur radius
//                 offset: Offset(0, -2), // Offset in the upward direction
//               ),
//             ],
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               InkWell(
//                 onTap: () {
//                   // Navigate to Home
//                 },
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(Icons.home, color: Colors.blue),
//                     SizedBox(height: 4),
//                     Text(
//                       'Home',
//                       style: TextStyle(color: Colors.blue, fontSize: 12),
//                     ),
//                   ],
//                 ),
//               ),
//               InkWell(
//                 onTap: () {
//                   // Navigate to Internships
//                 },
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(Icons.send, color: Colors.black),
//                     SizedBox(height: 4),
//                     Text(
//                       'Internships',
//                       style: TextStyle(color: Colors.black, fontSize: 12),
//                     ),
//                   ],
//                 ),
//               ),
//               InkWell(
//                 onTap: () {
//                   // Navigate to Jobs
//                 },
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(Icons.work, color: Colors.black),
//                     SizedBox(height: 4),
//                     Text(
//                       'Jobs',
//                       style: TextStyle(color: Colors.black, fontSize: 12),
//                     ),
//                   ],
//                 ),
//               ),
//               InkWell(
//                 onTap: () {
//                   // Navigate to Courses
//                 },
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Stack(
//                       alignment: Alignment.topRight,
//                       children: [
//                         Icon(Icons.tv, color: Colors.black),
//                         Positioned(
//                           top: 0,
//                           right: 0,
//                           child: Container(
//                             width: 8,
//                             height: 8,
//                             decoration: BoxDecoration(
//                               color: Colors.orange,
//                               shape: BoxShape.circle,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       'Courses',
//                       style: TextStyle(color: Colors.black, fontSize: 12),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       } else {
//         // Footer for larger screens
//         return Container(
//           width: double.infinity, // Ensure the footer spans the full width
//           color: Colors.black,
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Footer Links
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   _buildFooterColumn('Internships by places', [
//                     'Internship in India',
//                     'Internship in Delhi',
//                     'Internship in Bangalore',
//                     'View all internships',
//                   ]),
//                   _buildFooterColumn('Internship by Stream', [
//                     'Computer Science Internship',
//                     'Electronics Internship',
//                     'Finance Internship',
//                     'View all internships',
//                   ]),
//                   _buildFooterColumn('Jobs by Places', [
//                     'Jobs in Delhi',
//                     'Jobs in Mumbai',
//                     'Jobs in Bangalore',
//                     'View all jobs',
//                   ]),
//                   _buildFooterColumn('Placement Guarantee Courses', [
//                     'Full Stack Development',
//                     'Data Science',
//                     'UI/UX Design',
//                     'View all courses',
//                   ]),
//                 ],
//               ),
//               Divider(color: Colors.white),
//               SizedBox(height: 8),
//               // Footer Bottom Section
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     '© Copyright 2025 Nestern',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   Row(
//                     children: [
//                       Icon(Icons.facebook, color: Colors.white),
//                       SizedBox(width: 8),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       }
//     },
//   );
// }

//   // Helper method to build footer columns
//   Widget _buildFooterColumn(String title, List<String> items) {
//     return Expanded(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 8),
//           ...items.map((item) => Text(item, style: TextStyle(color: Colors.white))),
//         ],
//       ),
//     );
//   }


Widget _buildHorizontalSection(
  String title,
  List<Widget> cards,
  double height,
  ScrollController? controller,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      SizedBox(height: 8),
      SizedBox(
        height: height,
        child: cards.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('No internships available'),
                ),
              )
            : ListView.separated(
                controller: controller,
                scrollDirection: Axis.horizontal,
                itemCount: cards.length,
                separatorBuilder: (_, __) => SizedBox(width: 16),
                itemBuilder: (context, index) => cards[index],
              ),
      ),
    ],
  );
}