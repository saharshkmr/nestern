import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nestern/screens/dashboard.dart';
import 'package:nestern/screens/employer/employer_dashboard.dart';
import 'package:nestern/screens/login.dart';
import 'package:nestern/screens/student_signup.dart';
import 'package:nestern/widgets/custom_input_field.dart';
import 'package:nestern/widgets/hoverableDropdown.dart';

class EmployerSignUpPage extends StatefulWidget {
  @override
  _EmployerSignUpPageState createState() => _EmployerSignUpPageState();
}

class _EmployerSignUpPageState extends State<EmployerSignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  void _signUp() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign-up successful!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => EmployerDashboard()),
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
        child: _buildHeader(context), // Use the header from Dashboard
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 600, // Set a maximum width for the form
              ),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Email Field
                      CustomInputField(
                        controller: emailController,
                        labelText: "Official Email Id",
                        hintText: "name@company.com",
                        prefixIcon: Icons.email,
                      ),
                      SizedBox(height: 16),
                      // Password Field
                      CustomInputField(
                        controller: passwordController,
                        labelText: "Password",
                        hintText: "Minimum 6 characters",
                        prefixIcon: Icons.lock,
                        obscureText: true,
                      ),
                      SizedBox(height: 16),
                      // First Name and Last Name Fields
                      Row(
                        children: [
                          Expanded(
                            child: CustomInputField(
                              controller: firstNameController,
                              labelText: "First Name",
                              hintText: "Your First Name",
                              prefixIcon: Icons.person,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: CustomInputField(
                              controller: lastNameController,
                              labelText: "Last Name",
                              hintText: "Your Last Name",
                              prefixIcon: Icons.person_outline,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      // Terms and Conditions
                      Text(
                        "By clicking on Post for Free, you agree to our T&C.",
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      // Post for Free Button
                      ElevatedButton(
                        onPressed: _signUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          minimumSize: Size(double.infinity, 40),
                        ),
                        child: Text("Post for Free"),
                      ),
                      SizedBox(height: 16),
                      // Already Registered Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already registered? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LoginPage()),
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
      bottomNavigationBar: _buildFooter(), // Add the footer
    );
  }

  // Header Widget from Dashboard
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
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: Offset(0, -2),
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
          return Container(
            color: Colors.black,
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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