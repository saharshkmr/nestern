import 'package:flutter/material.dart';

class StudentInternshipHelpcenter extends StatelessWidget {
  const StudentInternshipHelpcenter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Help Center'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting Text
            Center(
              child: Text(
                'Hi,\nwhat can we help you with?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 24),
            // Help Options Grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 3, // Number of columns
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5, // Adjust card height
                children: [
                  _buildHelpOptionCard(
                    icon: Icons.person,
                    title: 'Account / Profile',
                    description: 'Manage your Nestern account',
                  ),
                  _buildHelpOptionCard(
                    icon: Icons.search,
                    title: 'Find Internships & Jobs',
                    description:
                        'Find internships and jobs matching your preferences on Nestern',
                  ),
                  _buildHelpOptionCard(
                    icon: Icons.file_copy,
                    title: 'My Applications',
                    description: 'Know about your current application status',
                  ),
                  _buildHelpOptionCard(
                    icon: Icons.error,
                    title: 'Facing an issue',
                    description:
                        'Report any complaint you may have against an internship or job',
                  ),
                  _buildHelpOptionCard(
                    icon: Icons.settings,
                    title: 'Technical Issues',
                    description:
                        'Report any technical difficulty you are facing here',
                  ),
                  _buildHelpOptionCard(
                    icon: Icons.help,
                    title: 'Need Further Assistance?',
                    description:
                        'Can’t find what you are looking for? Submit your request here',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build each help option card
  Widget _buildHelpOptionCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}