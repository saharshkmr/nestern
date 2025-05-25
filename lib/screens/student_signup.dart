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
import 'package:nestern/screens/student/profile_page.dart';
import 'package:nestern/screens/ui_ux_design_course.dart';
import 'package:nestern/widgets/input_widget.dart';
import 'package:nestern/widgets/hoverableDropdown.dart';
import 'package:nestern/screens/login.dart';
import 'package:nestern/services/auth_service.dart';
import 'package:nestern/screens/student/student_dashboard.dart';
import 'package:nestern/screens/student/user_details_form.dart';
import 'package:nestern/services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:nestern/models/user.dart' as app_model;

class StudentSignUpPage extends StatefulWidget {
  @override
  _StudentSignUpPageState createState() => _StudentSignUpPageState();
}

class _StudentSignUpPageState extends State<StudentSignUpPage> {
  
  final FirebaseAuthService _auth = FirebaseAuthService();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
final TextEditingController confirmPasswordController = TextEditingController();
bool obscureStudentPassword = true;
bool obscureConfirmPassword = true;


bool agreedToTerms = false;
  void toggleTermsAgreement() {
    setState(() {
      agreedToTerms = !agreedToTerms;
    });
  }

// void _signUp() async {
//   String email = emailController.text;
//   String password = passwordController.text;
//   String firstName = firstNameController.text;
//   String lastName = lastNameController.text;

//   try {
//     firebase_auth.User? firebaseUser = await _auth.studentSignUpWithEmailAndPassword(email, password);
//     if (firebaseUser != null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Sign-up successful!')),
//       );
//       // Convert firebase_auth.User to your app's User model before passing
//       final appUser = app_model.User(
//         id: firebaseUser.uid,
//         company: '', // or provide a default/empty value
//         profileName: '$firstName $lastName', // or use another logic
//         mobile: '', // or provide a default/empty value
//         role: 'student', // or provide a default/empty value
//         skills: [], // or provide a default/empty list
//         uid: firebaseUser.uid,
//         email: firebaseUser.email ?? '',
//         // Add other fields as required by your User model
//       );
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => UserDetailsForm(user: appUser)),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Sign-up failed. Please try again.')),
//       );
//     }
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Error: ${e.toString()}')),
//     );
//   }
// }
String? passwordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Password is required';
  }
  if (value.length < 6) {
    return 'Password must be at least 6 characters';
  }
  if (!RegExp(r'[0-9]').hasMatch(value)) {
    return 'Password must contain at least one number';
  }
  if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
    return 'Password must contain at least one special character';
  }
  return null;
}

String? confirmPasswordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Confirm your password';
  }
  if (value != passwordController.text) {
    return 'Passwords do not match';
  }
  // Reuse password rules
  return passwordValidator(value);
}

void _signUp() async {
  String email = emailController.text;
  String password = passwordController.text;
  String firstName = firstNameController.text;
  String lastName = lastNameController.text;

  try {
    fb_auth.User? firebaseUser =
        await _auth.studentSignUpWithEmailAndPassword(email, password);

    if (firebaseUser != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign-up successful!')),
      );

      // Create your custom User model
      final user = app_model.User(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        uid: firebaseUser.uid,
        company: '',
        profileName: '$firstName $lastName',
        mobile: '',
        role: 'student',
        skills: [],
      );

      // Navigate and pass the User
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => UserDetailsForm(user: user),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign-up failed. Please try again.')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.toString()}')),
    );
  }
}



@override
Widget build(BuildContext context) {
  return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: _buildHeader(context),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width > 600
                  ? 500
                  : double.infinity, // Adjust width for larger screens
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title
                      Text(
                        "Sign-up and apply for free",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      // Subtitle
                      Text(
                        "1,50,000+ companies hiring on Nestern",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24),
                      // Email Field
                      buildTextField(
                        context,
                        "Email",
                        emailController,
                        null, // validator if needed
                        (value) {}, // onSaved if needed
                        icon: Icons.email,
                      ),
                      SizedBox(height: 16),
                      // Password Field
                      buildTextField(
                        context,
                        "Password",
                        passwordController,
                        passwordValidator, // <-- Add validator here
                        (value) {},
                        icon: Icons.lock,
                        isPassword: true,
                        obscure: obscureStudentPassword,
                        toggleObscure: () {
                          setState(() {
                            obscureStudentPassword = !obscureStudentPassword;
                          });
                        },
                      ),
                      SizedBox(height: 16),
                      // Confirm Password Field
                      buildTextField(
                        context,
                        "Confirm Password",
                        confirmPasswordController,
                        confirmPasswordValidator, // <-- Add validator here
                        (value) {},
                        icon: Icons.lock,
                        isPassword: true,
                        obscure: obscureConfirmPassword,
                        toggleObscure: () {
                          setState(() {
                            obscureConfirmPassword = !obscureConfirmPassword;
                          });
                        },
                      ),
                      SizedBox(height: 16),
                      // First Name and Last Name Fields
                      Row(
                        children: [
                          Expanded(
                            child: buildTextField(
                              context,
                              "First Name",
                              firstNameController,
                              null,
                              (value) {},
                              icon: Icons.person,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: buildTextField(
                              context,
                              "Last Name",
                              lastNameController,
                              null,
                              (value) {},
                              icon: Icons.person_outline,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      // Terms and Conditions
                        // Terms and Conditions Checkbox
                        Row(
                          children: [
                            Checkbox(
                              value: agreedToTerms,
                              onChanged: (value) {
                                setState(() {
                                  agreedToTerms = value ?? false;
                                });
                              },
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    agreedToTerms = !agreedToTerms;
                                  });
                                },
                                child: Text(
                                  "I agree to the Terms & Conditions",
                                  style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                      // Sign-Up Button
                      ElevatedButton(
                        onPressed: () {
                          if (!agreedToTerms) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('You must agree to the Terms & Conditions')),
                              );
                              return;
                            }
                            _signUp();
                          },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 24),
                        ),
                        child: Text("Sign up"),
                      ),
                      SizedBox(height: 16),
                      // Already Registered
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already registered? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                              );
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      // bottomNavigationBar: _buildFooter(),
    );
  }
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
//         // Show the footer content as shown in the image for smaller screens
//         return Container(
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
//           padding: EdgeInsets.symmetric(vertical: 16),
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
//         // Show the original footer content for larger screens
//         return Container(
//           color: Colors.black,
//           padding: EdgeInsets.all(16.0),
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
//                       // Icon(Icons.twitter, color: Colors.white),
//                       // SizedBox(width: 8),
//                       // Icon(Icons.instagram, color: Colors.white),
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
// }

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    onGenerateRoute: (settings) {
      switch (settings.name) {
        case '/':
          return MaterialPageRoute(builder: (context) => StudentSignUpPage());
        case '/Dashboard':
          // Get the current Firebase user
          final firebaseUser = fb_auth.FirebaseAuth.instance.currentUser;
          if (firebaseUser != null) {
            // You may need to fetch additional user data from Firestore if required
            return MaterialPageRoute(
              builder: (context) => ProfilePage(
                user: app_model.User(
                  id: firebaseUser.uid,
                  company: '',
                  profileName: firebaseUser.displayName ?? '',
                  email: firebaseUser.email ?? '',
                  mobile: '',
                  role: 'student',
                  skills: [],
                  uid: firebaseUser.uid,
                ),
            ));
          } else {
            // If not logged in, redirect to sign up or login
            return MaterialPageRoute(builder: (context) => StudentSignUpPage());
          }
        default:
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              body: Center(child: Text('Page not found')),
            ),
          );
      }
    },
  ));
}
