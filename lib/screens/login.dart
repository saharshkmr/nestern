import 'package:flutter/material.dart';
import 'package:nestern/widgets/custom_input_field.dart'; // Import the reusable input field

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                              // Student Login Tab
                              Column(
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      // Handle Google login
                                    },
                                    icon: Icon(Icons.g_mobiledata, color: Colors.red),
                                    label: Text('Login with Google'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.black,
                                      side: BorderSide(color: Colors.grey),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(child: Divider()),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8),
                                        child: Text('OR'),
                                      ),
                                      Expanded(child: Divider()),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  CustomInputField(
                                    labelText: 'Email',
                                    hintText: 'john@example.com',
                                    keyboardType: TextInputType.emailAddress,
                                    controller: _studentEmail,
                                  ),
                                  SizedBox(height: 16),
                                  CustomInputField(
                                    labelText: 'Password',
                                    hintText: 'Must be at least 6 characters',
                                    obscureText: true,
                                    controller: _studentPassword,
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
                                    onPressed: () {
                                      // Handle login logic
                                    },
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
                              // Employer / T&P Login Tab
                              Column(
                                children: [
                                  CustomInputField(
                                    labelText: 'Company Email',
                                    hintText: 'company@example.com',
                                    keyboardType: TextInputType.emailAddress,
                                    controller: _companyEmail,
                                  ),
                                  SizedBox(height: 16),
                                  CustomInputField(
                                    labelText: 'Password',
                                    hintText: 'Enter your password',
                                    obscureText: true,
                                    controller: _companyPassword,
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
                                    onPressed: () {
                                      // Handle login logic
                                    },
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
  ));
}