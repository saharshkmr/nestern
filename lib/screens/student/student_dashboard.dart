import 'package:flutter/material.dart';

class StudentDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Student Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // Handle notifications
            },
          ),
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {
              // Navigate to Profile Page
              Navigator.pushNamed(context, '/profilePage');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Text(
              'Welcome, [Student Name]!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Explore internships and jobs tailored for you.',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 16),

            // Navigation Options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDashboardCard(
                  context,
                  icon: Icons.work,
                  title: 'My Applications',
                  onTap: () {
                    // Navigate to My Applications Page
                  },
                ),
                _buildDashboardCard(
                  context,
                  icon: Icons.book,
                  title: 'Courses',
                  onTap: () {
                    // Navigate to Courses Page
                  },
                ),
                _buildDashboardCard(
                  context,
                  icon: Icons.favorite,
                  title: 'Saved Jobs',
                  onTap: () {
                    // Navigate to Saved Jobs Page
                  },
                ),
              ],
            ),
            SizedBox(height: 16),

            // Recommended Section
            Text(
              'Recommended for You',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: 5, // Replace with dynamic data
                itemBuilder: (context, index) {
                  return _buildJobCard(
                    title: 'Internship Title $index',
                    company: 'Company Name $index',
                    location: 'Location $index',
                    onTap: () {
                      // Navigate to Job Details Page
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget for Dashboard Cards
  Widget _buildDashboardCard(BuildContext context,
      {required IconData icon, required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width / 3.5,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget for Job Cards
  Widget _buildJobCard(
      {required String title,
      required String company,
      required String location,
      required VoidCallback onTap}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(company),
            Text(location, style: TextStyle(color: Colors.grey)),
          ],
        ),
        trailing: Icon(Icons.arrow_forward, color: Colors.blue),
        onTap: onTap,
      ),
    );
  }
}