import 'package:flutter/material.dart';
import 'package:nestern/screens/employer_signup.dart';
import 'package:nestern/screens/student_signup.dart';
import 'package:nestern/widgets/hoverableDropdown.dart';
import 'package:nestern/screens/login.dart';

class Dashboard extends StatelessWidget {
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
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.work),
              title: Text('Internships'),
              onTap: () {
                // Handle navigation
              },
            ),
            ListTile(
              leading: Icon(Icons.business),
              title: Text('Jobs'),
              onTap: () {
                // Handle navigation
              },
            ),
            ListTile(
              leading: Icon(Icons.school),
              title: Text('Courses'),
              onTap: () {
                // Handle navigation
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
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          // Add other sections here...
        ],
      ),
      bottomNavigationBar: _buildFooter(),
    );
  }

  // Header Widget
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
              screenWidth < 700
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
                      height: 40,  // Adjust height accordingly
                    ),
              SizedBox(width: 16), // Space between logo and dropdowns
              if (screenWidth >= 1260) ...[
                // HoverableDropdowns for larger screens
                HoverableDropdown(
                  title: 'Internships',
                  items: [
                    PopupMenuItem(value: 'Internship in India', child: Text('Internship in India')),
                    PopupMenuItem(value: 'Internship in Delhi', child: Text('Internship in Delhi')),
                    PopupMenuItem(value: 'Internship in Bangalore', child: Text('Internship in Bangalore')),
                  ],
                ),
                SizedBox(width: 16),
                HoverableDropdown(
                  title: 'Jobs',
                  items: [
                    PopupMenuItem(value: 'Jobs in Delhi', child: Text('Jobs in Delhi')),
                    PopupMenuItem(value: 'Jobs in Mumbai', child: Text('Jobs in Mumbai')),
                    PopupMenuItem(value: 'Jobs in Bangalore', child: Text('Jobs in Bangalore')),
                  ],
                ),
                SizedBox(width: 16),
                HoverableDropdown(
                  title: 'Courses',
                  items: [
                    PopupMenuItem(value: 'Full Stack Development', child: Text('Full Stack Development')),
                    PopupMenuItem(value: 'Data Science', child: Text('Data Science')),
                    PopupMenuItem(value: 'UI/UX Design', child: Text('UI/UX Design')),
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
                      // Handle dropdown selection
                      if (value == 'student') {
                        // Navigate to student registration
                      } else if (value == 'employer') {
                        // Navigate to employer registration
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

  // Footer Widget
  Widget _buildFooter() {
  return LayoutBuilder(
    builder: (context, constraints) {
      final screenWidth = constraints.maxWidth;

      if (screenWidth < 767) {
        // Show the footer content as shown in the image for smaller screens
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // Shadow color
                spreadRadius: 2, // Spread radius
                blurRadius: 4, // Blur radius
                offset: Offset(0, -2), // Offset in the upward direction
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  // Navigate to Home
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.home, color: Colors.blue),
                    SizedBox(height: 4),
                    Text(
                      'Home',
                      style: TextStyle(color: Colors.blue, fontSize: 12),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  // Navigate to Internships
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.send, color: Colors.black),
                    SizedBox(height: 4),
                    Text(
                      'Internships',
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  // Navigate to Jobs
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.work, color: Colors.black),
                    SizedBox(height: 4),
                    Text(
                      'Jobs',
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  // Navigate to Courses
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Icon(Icons.tv, color: Colors.black),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Courses',
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      } else {
        // Show the original footer content for larger screens
        return Container(
          color: Colors.black,
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Footer Links
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildFooterColumn('Internships by places', [
                    'Internship in India',
                    'Internship in Delhi',
                    'Internship in Bangalore',
                    'View all internships',
                  ]),
                  _buildFooterColumn('Internship by Stream', [
                    'Computer Science Internship',
                    'Electronics Internship',
                    'Finance Internship',
                    'View all internships',
                  ]),
                  _buildFooterColumn('Jobs by Places', [
                    'Jobs in Delhi',
                    'Jobs in Mumbai',
                    'Jobs in Bangalore',
                    'View all jobs',
                  ]),
                  _buildFooterColumn('Placement Guarantee Courses', [
                    'Full Stack Development',
                    'Data Science',
                    'UI/UX Design',
                    'View all courses',
                  ]),
                ],
              ),
              Divider(color: Colors.white),
              SizedBox(height: 8),
              // Footer Bottom Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '© Copyright 2025 Internshala',
                    style: TextStyle(color: Colors.white),
                  ),
                  Row(
                    children: [
                      Icon(Icons.facebook, color: Colors.white),
                      SizedBox(width: 8),
                      // Icon(Icons.twitter, color: Colors.white),
                      // SizedBox(width: 8),
                      // Icon(Icons.instagram, color: Colors.white),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      }
    },
  );
}

  // Helper method to build footer columns
  Widget _buildFooterColumn(String title, List<String> items) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          ...items.map((item) => Text(item, style: TextStyle(color: Colors.white))),
        ],
      ),
    );
  }
}