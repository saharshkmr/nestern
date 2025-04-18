import 'package:flutter/material.dart';

class StudentTrainingHelpCenter extends StatelessWidget {
  const StudentTrainingHelpCenter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Training Help Center'),
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
                    icon: Icons.play_circle_outline,
                    title: 'Training',
                    description: 'Learn about training programs',
                  ),
                  _buildHelpOptionCard(
                    icon: Icons.access_time,
                    title: 'Time & Mode of Delivery',
                    description: 'Know about training schedules and delivery',
                  ),
                  _buildHelpOptionCard(
                    icon: Icons.card_membership,
                    title: 'Certificate',
                    description: 'Get details about your certificates',
                  ),
                  _buildHelpOptionCard(
                    icon: Icons.payment,
                    title: 'Payment',
                    description: 'Resolve payment-related queries',
                  ),
                  _buildHelpOptionCard(
                    icon: Icons.help_outline,
                    title: 'Need Further Assistance?',
                    description: 'Submit your request for additional help',
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