import 'package:flutter/material.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Title
            Center(
              child: Text(
                'Contact us',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 24),
            // Help Center Cards
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 835) {
                  // Display cards in a column for smaller screens
                  return Column(
                    children: [
                      _buildHelpCenterCard(
                        title: 'Students - Internships & Jobs',
                        description:
                            'For internships and jobs related queries, visit Student Help Center',
                        buttonText: 'Visit student help center',
                        onPressed: () {
                          // Handle navigation to student help center
                        },
                      ),
                      SizedBox(height: 16),
                      _buildHelpCenterCard(
                        title: 'Student - Trainings',
                        description:
                            'For trainings related queries, visit Trainings Help Center',
                        buttonText: 'Visit trainings help center',
                        onPressed: () {
                          // Handle navigation to trainings help center
                        },
                      ),
                      SizedBox(height: 16),
                      _buildHelpCenterCard(
                        title: 'Employers',
                        description:
                            'For employer queries, visit Employer Help Center',
                        buttonText: 'Visit employer help center',
                        onPressed: () {
                          // Handle navigation to employer help center
                        },
                      ),
                    ],
                  );
                } else {
                  // Display cards in a row for larger screens
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildHelpCenterCard(
                          title: 'Students - Internships & Jobs',
                          description:
                              'For internships and jobs related queries, visit Student Help Center',
                          buttonText: 'Visit student help center',
                          onPressed: () {
                            // Handle navigation to student help center
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildHelpCenterCard(
                          title: 'Student - Trainings',
                          description:
                              'For trainings related queries, visit Trainings Help Center',
                          buttonText: 'Visit trainings help center',
                          onPressed: () {
                            // Handle navigation to trainings help center
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildHelpCenterCard(
                          title: 'Employers',
                          description:
                              'For employer queries, visit Employer Help Center',
                          buttonText: 'Visit employer help center',
                          onPressed: () {
                            // Handle navigation to employer help center
                          },
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
            SizedBox(height: 24),
            // For Others Section
            Text(
              'For others',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            _buildContactInfo(
              title: 'University/college associations',
              email: 'university.relations@internshala.com',
            ),
            _buildContactInfo(
              title: 'Media queries',
              email: 'pr@internshala.com',
            ),
            _buildContactInfo(
              title: 'Fest sponsorships',
              email: 'pr@internshala.com',
            ),
            _buildContactInfo(
              title: 'For everything else',
              email: 'sarvesh@internshala.com',
            ),
            SizedBox(height: 24),
            // Address Section
            Text(
              'Address',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Scholiverse Educare Pvt. Ltd. 901A/B, Iris Tech Park, Sector 48, Gurugram, Haryana, India - 122018',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.red, size: 24),
                SizedBox(width: 8),
                Text(
                  'Working Hours: Monday to Friday, 10:00 AM – 6:00 PM',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build Help Center Cards
  Widget _buildHelpCenterCard({
  required String title,
  required String description,
  required String buttonText,
  required VoidCallback onPressed,
}) {
  return SizedBox(
    height: 200, // Set a fixed height for all cards
    child: Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
                maxLines: 3, // Limit the number of lines for consistency
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                textStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(buttonText),
                  Icon(Icons.arrow_forward, size: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  // Helper method to build Contact Info
  Widget _buildContactInfo({required String title, required String email}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'Email us: $email',
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}