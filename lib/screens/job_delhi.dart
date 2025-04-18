import 'package:flutter/material.dart';

class JobPageDelhi extends StatelessWidget {
  const JobPageDelhi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs in Delhi'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Title
            Text(
              '4 Jobs in Delhi',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            // Subtitle
            Text(
              'Search for Delhi Jobs and Apply to Latest Job Vacancies in Delhi NCR',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16),
            // Promoted Section
            _buildPromotedSection(),
            SizedBox(height: 16),
            // Job Cards
            Expanded(
              child: ListView(
                children: [
                  _buildJobCard(
                    title: 'Field Sales Executive',
                    company: 'EVERSEAL',
                    location: 'Delhi',
                    experience: '0 year(s)',
                    salary: '₹4,00,000 - ₹5,00,000',
                    posted: '2 weeks ago',
                    isFresherJob: true,
                    isActivelyHiring: true,
                  ),
                  _buildJobCard(
                    title: 'Business Development Executive',
                    company: 'Finvtech',
                    location: 'Noida',
                    experience: '0 year(s)',
                    salary: '₹2,10,000',
                    posted: '1 week ago',
                    isFresherJob: true,
                    isActivelyHiring: true,
                  ),
                  _buildJobCard(
                    title: 'Corporate Sales Executive',
                    company: 'Fall For Flora',
                    location: 'Noida',
                    experience: '1 year(s)',
                    salary: '₹3,00,000 - ₹3,50,000',
                    posted: '7 days ago',
                    isFresherJob: false,
                    isActivelyHiring: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build the promoted section
  Widget _buildPromotedSection() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Promoted Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Get hired with Placement Guarantee courses',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Promoted',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            // Subtitle
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Online course with guaranteed placement',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8),
            // Details
            Text(
              'Get confirmed package upto ₹5 lac',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            Text(
              'Top companies hiring like Delhivery, PhonePe, FedEx, and many',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),
            // Apply Now Button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Handle Apply Now action
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Apply now',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.arrow_forward, color: Colors.blue, size: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build job cards
  Widget _buildJobCard({
    required String title,
    required String company,
    required String location,
    required String experience,
    required String salary,
    required String posted,
    required bool isFresherJob,
    required bool isActivelyHiring,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Actively Hiring Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isActivelyHiring)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Actively hiring',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 8),
            // Company Name
            Text(
              company,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),
            // Location, Experience, and Salary
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(location, style: TextStyle(color: Colors.grey[700])),
                SizedBox(width: 16),
                Icon(Icons.access_time, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(experience, style: TextStyle(color: Colors.grey[700])),
                SizedBox(width: 16),
                Icon(Icons.money, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(salary, style: TextStyle(color: Colors.grey[700])),
              ],
            ),
            SizedBox(height: 8),
            // Posted Date and Fresher Job Badge
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(posted, style: TextStyle(color: Colors.grey[700])),
                if (isFresherJob) ...[
                  SizedBox(width: 16),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Fresher Job',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}