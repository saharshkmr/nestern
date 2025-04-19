import 'package:flutter/material.dart';
import 'package:nestern/screens/employer/post.dart';
import 'package:nestern/screens/employer/profile.dart'; // Import the EmployerProfilePage

class EmployerDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes the back button
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/main_logo.png', // Replace with your logo asset
              width: 120,
              height: 40,
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    // Navigate to Dashboard
                  },
                  child: Text(
                    "Dashboard",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(width: 16),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PostPage()),
                    );
                  },
                  child: Text(
                    "Post Internship/Job",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(width: 16),
                IconButton(
                  icon: Icon(Icons.account_circle, color: Colors.black),
                  onPressed: () {
                    // Navigate to EmployerProfilePage
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EmployerProfilePage()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: () {
                          // Navigate to Internships Tab
                        },
                        child: Text(
                          "Internships",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      TextButton(
                        onPressed: () {
                          // Navigate to Jobs Tab
                        },
                        child: Text(
                          "Jobs",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  // Table Section
                  Expanded(
                    child: ListView(
                      children: [
                        Table(
                          border: TableBorder.all(color: Colors.grey),
                          columnWidths: {
                            0: FlexColumnWidth(2),
                            1: FlexColumnWidth(2),
                            2: FlexColumnWidth(1),
                            3: FlexColumnWidth(2),
                            4: FlexColumnWidth(2),
                          },
                          children: [
                            TableRow(
                              decoration: BoxDecoration(color: Colors.grey[200]),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "PROFILE",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "STATUS",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "TOTAL VIEWS",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "ACTION",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "UPGRADE TO PREMIUM",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Anchoring"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Under Review",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(""),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextButton(
                                    onPressed: () {
                                      // Handle Action
                                    },
                                    child: Text("Upgrade"),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(""),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}