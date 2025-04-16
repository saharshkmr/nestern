import 'package:flutter/material.dart';

class EmployerSignUpPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "INTERNSHALA",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          // Handle "Hire for Top Profiles" action
                        },
                        child: Text(
                          "Hire for Top Profiles",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(width: 16),
                      TextButton(
                        onPressed: () {
                          // Handle "Hire for Top Locations" action
                        },
                        child: Text(
                          "Hire for Top Locations",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Handle Login action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                        child: Text("Login"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Main Content Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Section (Image or Description)
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hire Interns & Freshers faster",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Post Internships for Free & Hire Talent with up to 2 Years of Experience",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 16),
                        // Placeholder for image
                        Image.asset(
                          'assets/employer_image.png', // Replace with your image asset
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  // Right Section (Form)
                  Expanded(
                    flex: 1,
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
                            TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                labelText: "Official Email Id",
                                hintText: "name@company.com",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(height: 16),
                            // Password Field
                            TextField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: "Password",
                                hintText: "Minimum 6 characters",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(height: 16),
                            // First Name and Last Name Fields
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: firstNameController,
                                    decoration: InputDecoration(
                                      labelText: "First Name",
                                      hintText: "Your First Name",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: TextField(
                                    controller: lastNameController,
                                    decoration: InputDecoration(
                                      labelText: "Last Name",
                                      hintText: "Your Last Name",
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            // Mobile Number Field
                            TextField(
                              controller: mobileController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelText: "Mobile Number",
                                hintText: "+91 Enter mobile number",
                                border: OutlineInputBorder(),
                              ),
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
                              onPressed: () {
                                // Handle Post for Free action
                              },
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
                                    // Navigate to Login Page
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: EmployerSignUpPage(),
  ));
}