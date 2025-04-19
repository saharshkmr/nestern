import 'package:flutter/material.dart';
import 'package:nestern/screens/dashboard.dart';
import 'package:nestern/screens/data_science_course.dart';
import 'package:nestern/screens/employer_helpcenter.dart';
import 'package:nestern/screens/employer_signup.dart';
import 'package:nestern/screens/full_stack_course.dart';
import 'package:nestern/screens/internship_bangalore.dart';
import 'package:nestern/screens/internship_delhi.dart';
import 'package:nestern/screens/internship_mumbai.dart';
import 'package:nestern/screens/job_banglaore.dart';
import 'package:nestern/screens/job_delhi.dart';
import 'package:nestern/screens/job_mumbai.dart';
import 'package:nestern/screens/login.dart';
import 'package:nestern/screens/student_internship_helpcenter.dart';
import 'package:nestern/screens/student_signup.dart';
import 'package:nestern/screens/student_training_helpcenter.dart';
import 'package:nestern/screens/ui_ux_design_course.dart';
import 'package:nestern/widgets/hoverableDropdown.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({Key? key}) : super(key: key);

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