import 'package:flutter/material.dart';
import 'package:nestern/screens/dashboard.dart';
import 'package:nestern/screens/data_science_course.dart';
import 'package:nestern/screens/employer_signup.dart';
import 'package:nestern/screens/full_stack_course.dart';
import 'package:nestern/screens/internship_bangalore.dart';
import 'package:nestern/screens/internship_delhi.dart';
import 'package:nestern/screens/internship_mumbai.dart';
import 'package:nestern/screens/job_banglaore.dart';
import 'package:nestern/screens/job_delhi.dart';
import 'package:nestern/screens/job_mumbai.dart';
import 'package:nestern/screens/login.dart';
import 'package:nestern/screens/student_signup.dart';
import 'package:nestern/screens/ui_ux_design_course.dart';
import 'package:nestern/widgets/hoverableDropdown.dart';

class InternshipsPage extends StatelessWidget {
  const InternshipsPage({Key? key}) : super(key: key);

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
              '4 Total Internships',
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
                children: [
                  _buildInternshipCard(
                    title: 'Travel Consultant',
                    company: 'Happiness Plans',
                    location: 'Indore',
                    duration: '3 Months',
                    stipend: '₹5,000 - ₹10,000 /month',
                    posted: '2 weeks ago',
                    isActivelyHiring: true,
                    additionalBadge: null,
                  ),
                  _buildInternshipCard(
                    title: 'Interior Design',
                    company: 'NAKSH GRUHAM DESIGN STUDIO',
                    location: 'Mumbai',
                    duration: '6 Months',
                    stipend: '₹7,000 - ₹10,000 /month',
                    posted: '2 weeks ago',
                    isActivelyHiring: true,
                    additionalBadge: null,
                  ),
                  _buildInternshipCard(
                    title: 'Business Development (Sales)',
                    company: 'Sneh Academic Services Private Limited',
                    location: 'Ahmedabad',
                    duration: '2 Months',
                    stipend: '₹10,000 /month',
                    posted: '3 weeks ago',
                    isActivelyHiring: true,
                    additionalBadge: 'Job offer upto ₹4LPA post internship',
                  ),
                  _buildInternshipCard(
                    title: 'Business Development (Sales)',
                    company: 'Sarvajnaya',
                    location: 'Indore',
                    duration: '3 Months',
                    stipend: '₹2,000 - ₹5,000 /month',
                    posted: '3 weeks ago',
                    isActivelyHiring: true,
                    additionalBadge: 'Job offer upto ₹3LPA post internship',
                  ),
                ],
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
                          width: 120, // Smaller logo for larger screens
                          height: 40, // Adjust height accordingly
                        ),
                ),
                SizedBox(width: 16), // Space between logo and dropdowns
                if (screenWidth >= 1260) ...[
                  // HoverableDropdowns for larger screens
                  HoverableDropdown(
                    title: 'Internships',
                    items: [
                      PopupMenuItem(
                        value: 'Internship in Delhi',
                        child: Text('Internship in Delhi'),
                      ),
                      PopupMenuItem(
                        value: 'Internship in Mumbai',
                        child: Text('Internship in Mumbai'),
                      ),
                      PopupMenuItem(
                        value: 'Internship in Bangalore',
                        child: Text('Internship in Bangalore'),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'Internship in Delhi') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => InternshipPageDelhi()),
                        );
                      } else if (value == 'Internship in Mumbai') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => InternshipPageMumbai()),
                        );
                      } else if (value == 'Internship in Bangalore') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => InternshipPageBangalore()),
                        );
                      }
                    },
                  ),
                  SizedBox(width: 16),
                  HoverableDropdown(
                    title: 'Jobs',
                    items: [
                      PopupMenuItem(
                        value: 'Jobs in Delhi',
                        child: Text('Jobs in Delhi'),
                      ),
                      PopupMenuItem(
                        value: 'Jobs in Mumbai',
                        child: Text('Jobs in Mumbai'),
                      ),
                      PopupMenuItem(
                        value: 'Jobs in Bangalore',
                        child: Text('Jobs in Bangalore'),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'Jobs in Delhi') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => JobPageDelhi()),
                        );
                      } else if (value == 'Jobs in Mumbai') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => JobPageMumbai()),
                        );
                      } else if (value == 'Jobs in Bangalore') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => JobPageBangalore()),
                        );
                      }
                    },
                  ),
                  SizedBox(width: 16),
                  HoverableDropdown(
                    title: 'Courses',
                    items: [
                      PopupMenuItem(
                        value: 'Full Stack Development',
                        child: Text('Full Stack Development'),
                      ),
                      PopupMenuItem(
                        value: 'Data Science',
                        child: Text('Data Science'),
                      ),
                      PopupMenuItem(
                        value: 'UI/UX Design',
                        child: Text('UI/UX Design'),
                      ),
                    ],
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
                    onSelected: (value) {
                      if (value == 'Full Stack Development') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FullStackCoursePage()),
                        );
                      } else if (value == 'Data Science') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DataScienceCoursePage()),
                        );
                      } else if (value == 'UI/UX Design') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UIUXDesignCoursePage()),
                        );
                      }
                    },
                  ),
                ],
              ],
            ),
            // Buttons for larger screens
            Row(
              children: [
                if (screenWidth > 991) // Show Login button only if screen width > 991
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
                    height: 40, // Set the height of the box
                    decoration: BoxDecoration(
                      color: Colors.blue, // Set the background color of the button to blue
                      borderRadius: BorderRadius.circular(4), // Optional: Add rounded corners
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Adjust padding to match HoverableDropdown
                    child: DropdownButton<String>(
                      hint: Text(
                        'Register',
                        style: TextStyle(
                          color: Colors.white, // Set the text color to white for contrast
                          fontWeight: FontWeight.bold,
                          fontSize: 14, // Adjust font size to match HoverableDropdown
                        ),
                      ),
                      icon: Icon(Icons.arrow_drop_down, color: Colors.white, size: 20), // Adjust icon size to match HoverableDropdown
                      items: [
                        DropdownMenuItem(
                          value: 'student',
                          child: Text(
                            'As a Student',
                            style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontSize: 14), // Adjust text size for dropdown items
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'employer',
                          child: Text(
                            'As an Employer',
                            style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontSize: 14), // Adjust text size for dropdown items
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
                      underline: SizedBox(), // Remove the default underline
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

  // Helper method to build internship cards
  Widget _buildInternshipCard({
    required String title,
    required String company,
    required String location,
    required String duration,
    required String stipend,
    required String posted,
    required bool isActivelyHiring,
    String? additionalBadge,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isActivelyHiring)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Actively hiring',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              company,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(location, style: TextStyle(color: Colors.grey[700])),
                SizedBox(width: 16),
                Icon(Icons.access_time, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(duration, style: TextStyle(color: Colors.grey[700])),
                SizedBox(width: 16),
                Icon(Icons.money, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(stipend, style: TextStyle(color: Colors.grey[700])),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(posted, style: TextStyle(color: Colors.grey[700])),
              ],
            ),
            if (additionalBadge != null) ...[
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  additionalBadge,
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}