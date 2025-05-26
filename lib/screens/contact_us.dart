import 'package:flutter/material.dart';
import 'package:nestern/models/course.dart';
import 'package:nestern/models/internship.dart';
import 'package:nestern/models/job.dart';
import 'package:nestern/screens/dashboard.dart';
import 'package:nestern/screens/employer/course_details.dart';
import 'package:nestern/screens/employer/internship_details.dart';
import 'package:nestern/screens/employer/job_details.dart';
import 'package:nestern/screens/employer_helpcenter.dart';
import 'package:nestern/screens/employer_signup.dart';
import 'package:nestern/screens/login.dart';
import 'package:nestern/screens/student_internship_helpcenter.dart';
import 'package:nestern/screens/student_signup.dart';
import 'package:nestern/screens/student_training_helpcenter.dart';
import 'package:nestern/services/course_service.dart';
import 'package:nestern/services/internship_service.dart';
import 'package:nestern/services/job_service.dart';
import 'package:nestern/widgets/hoverableDropdown.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  List<Internship> _latestInternships = [];
  List<Job> _latestJobs = [];
  List<Course> _latestCourses = [];

  @override
  void initState() {
    super.initState();
    fetchLatestInternships();
    fetchLatestJobs();
    fetchLatestCourses();
  }

  Future<void> fetchLatestJobs() async {
    try {
      final jobService = JobService();
      final jobs = await jobService.getRecentJobs();
      setState(() {
        _latestJobs = jobs;
      });
    } catch (e) {
      print('Failed to fetch jobs: $e');
    }
  }

  Future<void> fetchLatestInternships() async {
    try {
      final internshipService = InternshipService();
      final internships = await internshipService.getRecentInternships();
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
      final courses = await courseService.getAllCourses();
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
        preferredSize: Size.fromHeight(60), // Set the height of the custom header
        child: _buildHeader(context), // Use the custom header
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Title
            Center(
              child: Text(
                'Contact us',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 24),
            // Help Center Cards
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 835) {
                  // Display cards in a column for smaller screens
                  return Column(
                    children: [
                      _buildHelpCenterCard(
                        title: 'Students - Internships & Jobs',
                        description:
                            'For internships and jobs related queries, visit Student Help Center',
                        buttonText: 'Visit student help center',
                        onPressed: () {
                          // Handle navigation to student help center
                        },
                      ),
                      SizedBox(height: 16),
                      _buildHelpCenterCard(
                        title: 'Student - Trainings',
                        description:
                            'For trainings related queries, visit Trainings Help Center',
                        buttonText: 'Visit trainings help center',
                        onPressed: () {
                          // Handle navigation to trainings help center
                        },
                      ),
                      SizedBox(height: 16),
                      _buildHelpCenterCard(
                        title: 'Employers',
                        description:
                            'For employer queries, visit Employer Help Center',
                        buttonText: 'Visit employer help center',
                        onPressed: () {
                          // Handle navigation to employer help center
                        },
                      ),
                    ],
                  );
                } else {
                  // Display cards in a row for larger screens
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildHelpCenterCard(
                          title: 'Students - Internships & Jobs',
                          description:
                              'For internships and jobs related queries, visit Student Help Center',
                          buttonText: 'Visit student help center',
                          onPressed: () {
                            Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => StudentInternshipHelpcenter()),
                        );// Handle navigation to student help center
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildHelpCenterCard(
                          title: 'Student - Trainings',
                          description:
                              'For trainings related queries, visit Trainings Help Center',
                          buttonText: 'Visit trainings help center',
                          onPressed: () {
                            Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => StudentTrainingHelpCenter()),
                        );// Handle navigation to trainings help center
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildHelpCenterCard(
                          title: 'Employers',
                          description:
                              'For employer queries, visit Employer Help Center',
                          buttonText: 'Visit employer help center',
                          onPressed: () {
                            Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EmployerHelpCenterPage()),
                        );
                            // Handle navigation to employer help center
                          },
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
            SizedBox(height: 24),
            // For Others Section
            Text(
              'For others',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            _buildContactInfo(
              title: 'University/college associations',
              email: 'university.relations@nestern.com',
            ),
            _buildContactInfo(
              title: 'Media queries',
              email: 'pr@nestern.com',
            ),
            _buildContactInfo(
              title: 'Fest sponsorships',
              email: 'pr@nestern.com',
            ),
            _buildContactInfo(
              title: 'For everything else',
              email: 'sarvesh@nestern.com',
            ),
            SizedBox(height: 24),
            // Address Section
            Text(
              'Address',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Sarla Birla university campus, Tatisilvae, Jharkhand 835103',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.red, size: 24),
                SizedBox(width: 8),
                Text(
                  'Working Hours: Monday to Friday, 09:00 AM – 05:00 PM',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
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


  // Helper method to build Help Center Cards
  Widget _buildHelpCenterCard({
    required String title,
    required String description,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 200, // Set a fixed height for all cards
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                child: Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                  maxLines: 3, // Limit the number of lines for consistency
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  textStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(buttonText),
                    Icon(Icons.arrow_forward, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build Contact Info
  Widget _buildContactInfo({required String title, required String email}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'Email us: $email',
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}