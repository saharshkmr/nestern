import 'package:flutter/material.dart';
import 'package:nestern/screens/employer/employer_dashboard.dart';
import 'package:nestern/screens/employer_signup.dart';
import 'package:nestern/screens/student/student_dashboard.dart';
import 'package:nestern/screens/student_signup.dart';
import 'package:nestern/widgets/custom_input_field.dart'; // Import the reusable input field
import 'package:nestern/services/auth_service.dart'; // Import FirebaseAuthService
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth for User class
import 'package:flutter/gestures.dart'; // Import for TapGestureRecognizer

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  final _studentEmail = TextEditingController();  
  final _studentPassword = TextEditingController();
  final _companyEmail = TextEditingController();
  final _companyPassword = TextEditingController();

  @override
  void dispose() {
    _studentEmail.dispose();
    _studentPassword.dispose();
    _companyEmail.dispose();
    _companyPassword.dispose();
    super.dispose();
  }

  void _studentSignIn() async {
  String email = _studentEmail.text;
  String password = _studentPassword.text;

  try {
    User? user = await _auth.studentSignInWithEmailAndPassword(email, password);
    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Student Login successful!')),
      );
      // Navigate to StudentDashboard using MaterialPageRoute
      Navigator.push(context,MaterialPageRoute(builder: (context) => StudentDashboard()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Student Login failed. Please try again.')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.toString()}')),
    );
  }
}

  // Employer Sign-In Method
  void _employerSignIn() async {
    String email = _companyEmail.text;
    String password = _companyPassword.text;

    try {
      User? user = await _auth.employerSignInWithEmailAndPassword(email, password);
      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Employer Login successful!')),
        );
        Navigator.push(context,MaterialPageRoute(builder: (context) => EmployerDashboard()),
         ); // Navigate to Employer Dashboard
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Employer Login failed. Please try again.')),
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
    // Show the login popup immediately when this page is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent closing the dialog by tapping outside
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              width: 400, // Set a fixed width for the dialog
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Close button
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the popup
                        Navigator.of(context).pop(); // Navigate back to the previous page
                      },
                    ),
                  ),
                  // Tab bar for Student and Employer
                  DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        TabBar(
                          labelColor: Colors.blue,
                          unselectedLabelColor: Colors.black,
                          indicatorColor: Colors.blue,
                          tabs: [
                            Tab(text: 'Student'),
                            Tab(text: 'Employer / T&P'),
                          ],
                        ),
                        SizedBox(height: 16),
                        // Tab content
                        Container(
                          height: 400, // Set a fixed height for the tab content
                          child: TabBarView(
                            children: [
                              Column(
                                children: [
                                  CustomInputField(
                                    labelText: 'Email',
                                    hintText: 'john@example.com',
                                    keyboardType: TextInputType.emailAddress,
                                    controller: _studentEmail,
                                    prefixIcon: Icons.email, // Add email icon
                                  ),
                                  SizedBox(height: 16),
                                  CustomInputField(
                                    labelText: 'Password',
                                    hintText: 'Must be at least 6 characters',
                                    obscureText: true,
                                    controller: _studentPassword,
                                    prefixIcon: Icons.lock, // Add lock icon
                                  ),
                                  SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {
                                        // Handle forgot password
                                      },
                                      child: Text('Forgot password?'),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: _studentSignIn,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: Text('Login'),
                                  ),
                                  SizedBox(height: 16),
                                  Text.rich(
                                    TextSpan(
                                      text: 'New to Nestern? Register ',
                                      children: [
                                        TextSpan(
                                          text: 'Student',
                                          style: TextStyle(color: Colors.blue),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => StudentSignUpPage()),
                                              );
                                            },
                                        ),
                                        TextSpan(text: ' / '),
                                        TextSpan(
                                          text: 'Company',
                                          style: TextStyle(color: Colors.blue),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => EmployerSignUpPage()),
                                              );
                                            },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              // Employer / T&P Login Tab
                              Column(
                                children: [
                                  CustomInputField(
                                    labelText: 'Company Email',
                                    hintText: 'company@example.com',
                                    keyboardType: TextInputType.emailAddress,
                                    controller: _companyEmail,
                                    prefixIcon: Icons.email, // Add email icon
                                  ),
                                  SizedBox(height: 16),
                                  CustomInputField(
                                    labelText: 'Password',
                                    hintText: 'Enter your password',
                                    obscureText: true,
                                    controller: _companyPassword,
                                    prefixIcon: Icons.lock, // Add lock icon
                                  ),
                                  SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {
                                        // Handle forgot password
                                      },
                                      child: Text('Forgot password?'),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: _employerSignIn,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: Text('Login'),
                                  ),
                                  SizedBox(height: 16),
                                  Text.rich(
                                    TextSpan(
                                      text: 'New to Nestern? Register ',
                                      children: [
                                        TextSpan(
                                          text: 'Student',
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                        TextSpan(text: ' / '),
                                        TextSpan(
                                          text: 'Company',
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });

    // Return an empty Scaffold to maintain the page structure
    return Scaffold(
      backgroundColor: Colors.transparent, // Make the background transparent
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LoginPage(),
    routes: {
      '/StudentDashboard': (context) => StudentDashboard(
          ),
      '/EmployerDashboard': (context) => Scaffold(
            appBar: AppBar(title: Text('Employer Dashboard')),
            body: Center(child: Text('Welcome to the Employer Dashboard!')),
          ),
    },
  ));
}