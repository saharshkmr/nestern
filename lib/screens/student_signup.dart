import 'package:flutter/material.dart';
import 'package:nestern/screens/dashboard.dart';
import 'package:nestern/screens/employer_signup.dart';
import 'package:nestern/widgets/custom_input_field.dart';
import 'package:nestern/widgets/hoverableDropdown.dart';
import 'package:nestern/screens/login.dart';
import 'package:nestern/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nestern/screens/student/student_dashboard.dart';

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
    super.dispose();
  }
  void _signUp() async {
  String email = emailController.text;
  String password = passwordController.text;
  String firstName = firstNameController.text;
  String lastName = lastNameController.text;

  try {
    User? user = await _auth.studentSignUpWithEmailAndPassword(email, password);
    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign-up successful!')),
      );
      Navigator.push(context,MaterialPageRoute(builder: (context) => StudentDashboard()),
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
                      CustomInputField(
                        labelText: "Email",
                        hintText: "john@example.com",
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.email, // Add email icon
                      ),
                      SizedBox(height: 16),
                      // Password Field
                      CustomInputField(
                        labelText: "Password",
                        hintText: "Must be at least 6 characters",
                        controller: passwordController,
                        obscureText: true,
                        prefixIcon: Icons.lock, // Add lock icon
                      ),
                      SizedBox(height: 16),
                      // First Name and Last Name Fields
                      Row(
                        children: [
                          Expanded(
                            child: CustomInputField(
                              labelText: "First Name",
                              hintText: "John",
                              controller: firstNameController,
                              prefixIcon: Icons.person, // Add person icon
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: CustomInputField(
                              labelText: "Last Name",
                              hintText: "Doe",
                              controller: lastNameController,
                              prefixIcon: Icons.person_outline, // Add person outline icon
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      // Terms and Conditions
                      Text(
                        "By signing up, you agree to our Terms and Conditions.",
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      // Sign-Up Button
                      ElevatedButton(
                        onPressed: _signUp,
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
      bottomNavigationBar: _buildFooter(),
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
                          width: 120, // Smaller logo for larger screens
                          height: 40,  // Adjust height accordingly
                        ),
                ),
                SizedBox(width: 16),
                if (screenWidth >= 1260) ...[
                  HoverableDropdown(
                    title: 'Internships',
                    items: [
                      PopupMenuItem(
                          value: 'Internship in India',
                          child: Text('Internship in India')),
                      PopupMenuItem(
                          value: 'Internship in Delhi',
                          child: Text('Internship in Delhi')),
                      PopupMenuItem(
                          value: 'Internship in Bangalore',
                          child: Text('Internship in Bangalore')),
                    ],
                  ),
                  SizedBox(width: 16),
                  HoverableDropdown(
                    title: 'Jobs',
                    items: [
                      PopupMenuItem(
                          value: 'Jobs in Delhi', child: Text('Jobs in Delhi')),
                      PopupMenuItem(
                          value: 'Jobs in Mumbai',
                          child: Text('Jobs in Mumbai')),
                      PopupMenuItem(
                          value: 'Jobs in Bangalore',
                          child: Text('Jobs in Bangalore')),
                    ],
                  ),
                  SizedBox(width: 16),
                  HoverableDropdown(
                    title: 'Courses',
                    items: [
                      PopupMenuItem(
                          value: 'Full Stack Development',
                          child: Text('Full Stack Development')),
                      PopupMenuItem(
                          value: 'Data Science', child: Text('Data Science')),
                      PopupMenuItem(
                          value: 'UI/UX Design', child: Text('UI/UX Design')),
                    ],
                    badge: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4, vertical: 2),
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
                        MaterialPageRoute(
                            builder: (context) => StudentSignUpPage()),
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
                        MaterialPageRoute(
                            builder: (context) => EmployerSignUpPage()),
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

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    onGenerateRoute: (settings) {
      switch (settings.name) {
        case '/':
          return MaterialPageRoute(builder: (context) => StudentSignUpPage());
        case '/Dashboard':
          return MaterialPageRoute(builder: (context) => StudentDashboard());
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