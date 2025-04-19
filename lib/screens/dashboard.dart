import 'package:flutter/material.dart';
import 'package:nestern/screens/contact_us.dart';
import 'package:nestern/screens/data_science_course.dart';
// import 'package:nestern/screens/employer/employer_dashboard.dart';
import 'package:nestern/screens/employer_signup.dart';
import 'package:nestern/screens/full_stack_course.dart';
import 'package:nestern/screens/internship_delhi.dart';
import 'package:nestern/screens/internships.dart';
import 'package:nestern/screens/internship_bangalore.dart';
import 'package:nestern/screens/internship_mumbai.dart';
import 'package:nestern/screens/job_banglaore.dart';
import 'package:nestern/screens/job_delhi.dart';
import 'package:nestern/screens/job_mumbai.dart';
import 'package:nestern/screens/jobs.dart';
// import 'package:nestern/screens/student/student_dashboard.dart';
import 'package:nestern/screens/student_signup.dart';
import 'package:nestern/screens/ui_ux_design_course.dart';
import 'package:nestern/widgets/hoverableDropdown.dart';
import 'package:nestern/screens/login.dart';
import 'package:nestern/widgets/internship_card.dart';
import 'package:nestern/widgets/job__card.dart';
import 'package:nestern/widgets/trending_card.dart'; // Import the TrendingSection widget

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
            title: Text('Register - As a Student'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StudentSignUpPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Register - As an Employer'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EmployerSignUpPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Login'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
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
                child: Text(
                  "Latest internships on Nestern",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    InternshipCard(
                      title: "Talent Acquisition",
                      company: "CollegeDekho.com",
                      location: "Jaipur",
                      stipend: "₹ 8,000 - 12,000 /month",
                      duration: "2 Months",
                    ),
                    SizedBox(width: 16),
                    InternshipCard(
                      title: "Law/Legal",
                      company: "Thomas Cook",
                      location: "Mumbai",
                      stipend: "₹ 5,000 /month",
                      duration: "3 Months",
                    ),
                    SizedBox(width: 16),
                    InternshipCard(
                      title: "Sourcing",
                      company: "FirstCry.com",
                      location: "Pune",
                      stipend: "₹ 7,000 - 9,000 /month",
                      duration: "2 Months",
                    ),
                    SizedBox(width: 16),
                    InternshipCard(
                      title: "Human Resources - L&D",
                      company: "Gourmet Investments Private Limited",
                      location: "Mumbai",
                      stipend: "₹ 10,000 - 13,000 /month",
                      duration: "6 Months",
                    ),
                    SizedBox(width: 16),
                    InternshipCard(
                      title: "Digital Marketing",
                      company: "Educate Girls",
                      location: "Mumbai (Hybrid)",
                      stipend: "₹ 5,000 - 15,000 /month",
                      duration: "2 Months",
                    ),
                    SizedBox(width: 16),
                    InternshipCard(
                      title: "Event Management",
                      company: "Emerson (NI is Now Emerson)",
                      location: "Banglore",
                      stipend: "₹ 30,000 /month",
                      duration: "6 Months",
                    ),
                    SizedBox(width: 16),
                    InternshipCard(
                      title: "Human Resources (HR)",
                      company: "Sat Kartar Shopping Limited",
                      location: "Delhi, Noida",
                      stipend: "₹ 4,000 - 5,000 /month",
                      duration: "6 Months",
                    ),
                    SizedBox(width: 16),
                    InternshipCard(
                      title: "Content Writing",
                      company: "HT Media",
                      location: "Mumbai",
                      stipend: "₹ 3,000 - 5,000 /month",
                      duration: "3 Months",
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                          child: Text(
                            "Latest jobs on Nestern",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                  SizedBox(height: 8),
                  // Popular Categories
                  Center(
  child: SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center, // Center the chips
      children: [
        _buildCategoryChip("Big brands", isSelected: true, onTap: () {
          // Handle click for "Big brands"
          print("Big brands clicked");
        }),
        SizedBox(width: 8),
        _buildCategoryChip("Work from home", onTap: () {
          // Handle click for "Work from home"
          print("Work from home clicked");
        }),
        SizedBox(width: 8),
        _buildCategoryChip("Part-time", onTap: () {
          // Handle click for "Part-time"
          print("Part-time clicked");
        }),
        SizedBox(width: 8),
        _buildCategoryChip("MBA", onTap: () {
          // Handle click for "MBA"
          print("MBA clicked");
        }),
        SizedBox(width: 8),
        _buildCategoryChip("Engineering", onTap: () {
          // Handle click for "Engineering"
          print("Engineering clicked");
        }),
        SizedBox(width: 8),
        _buildCategoryChip("Media", onTap: () {
          // Handle click for "Media"
          print("Media clicked");
        }),
        SizedBox(width: 8),
        _buildCategoryChip("Design", onTap: () {
          // Handle click for "Design"
          print("Design clicked");
        }),
        SizedBox(width: 8),
        _buildCategoryChip("Data Science", onTap: () {
          // Handle click for "Data Science"
          print("Data Science clicked");
        }),
      ],
    ),
  ),
),
                  SizedBox(height: 16),
                  // Job Cards
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        JobCard(
                          title: "Subject Matter Expert",
                          company: "CollegeDekho.com",
                          location: "Jaipur",
                          salary: "₹ 3,00,000 - 4,00,000 /year",
                          isActivelyHiring: true,
                        ),
                        SizedBox(width: 16),
                        JobCard(
                          title: "Inside Sales Associate",
                          company: "PlanetSpark",
                          location: "Delhi, Gurgaon, Noida",
                          salary: "₹ 6,50,000 - 7,50,000 /year",
                          isActivelyHiring: true,
                        ),
                        SizedBox(width: 16),
                        JobCard(
                          title: "Corporate Sales Associate",
                          company: "PlanetSpark",
                          location: "Chennai, Hyderabad, Bangalore",
                          salary: "₹ 6,50,000 - 7,50,000 /year",
                          isActivelyHiring: true,
                        ),
                        SizedBox(width: 16),
                        JobCard(
                          title: "Research Associate (Finance)",
                          company: "Netscribes (India) Private Limited",
                          location: "Kolkata (Hybrid)",
                          salary: "₹ 2,00,000 - 2,25,000 /year",
                          isActivelyHiring: true,
                        ),
                      ],
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
                  if (screenWidth >= 1260) ...[
                  // HoverableDropdowns for larger screens
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
                  if (screenWidth >= 1260) ...[
                  // HoverableDropdowns for larger screens
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
            ]
          ]
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
}