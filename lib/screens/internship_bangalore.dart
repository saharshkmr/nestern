import 'package:flutter/material.dart';

class InternshipPageBangalore extends StatelessWidget {
  const InternshipPageBangalore({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Internships in Bangalore'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Title
            Text(
              '4 Internships in Bangalore',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            // Subtitle
            Text(
              'Latest Intern Jobs in Bangalore',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16),
            // Internship Cards
            Expanded(
              child: ListView(
                children: [
                  _buildInternshipCard(
                    title: 'Civil Engineering',
                    company: 'Interiosplash',
                    location: 'Bangalore',
                    duration: '3 Months',
                    stipend: '₹5,000 - ₹10,000 /month',
                    posted: '7 days ago',
                    isEarlyApplicant: true,
                    isActivelyHiring: true,
                    additionalBadge: null,
                  ),
                  _buildInternshipCard(
                    title: 'Sales & Marketing',
                    company: 'UniFirst Robotics',
                    location: 'Bangalore',
                    duration: '3 Months',
                    stipend: '₹7,000 /month',
                    posted: '3 weeks ago',
                    isEarlyApplicant: false,
                    isActivelyHiring: true,
                    additionalBadge: 'Job offer starting ₹2LPA post internship',
                  ),
                  _buildInternshipCard(
                    title: 'Business Development (Sales)',
                    company: 'Propstory',
                    location: 'Bangalore',
                    duration: '6 Months',
                    stipend: '₹9,000 - ₹10,000 /month',
                    posted: '2 days ago',
                    isEarlyApplicant: false,
                    isActivelyHiring: true,
                    additionalBadge: null,
                  ),
                  _buildInternshipCard(
                    title: 'Business Development (Sales)',
                    company: 'Covenant Educational Trust',
                    location: 'Bangalore',
                    duration: '3 Months',
                    stipend: '₹8,000 - ₹20,000 /month',
                    posted: '7 days ago',
                    isEarlyApplicant: false,
                    isActivelyHiring: true,
                    additionalBadge: null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build internship cards
  Widget _buildInternshipCard({
    required String title,
    required String company,
    required String location,
    required String duration,
    required String stipend,
    required String posted,
    required bool isEarlyApplicant,
    required bool isActivelyHiring,
    String? additionalBadge,
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
            // Location, Duration, and Stipend
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(location, style: TextStyle(color: Colors.grey[700])),
                SizedBox(width: 16),
                Icon(Icons.access_time, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(duration, style: TextStyle(color: Colors.grey[700])),
                SizedBox(width: 16),
                Icon(Icons.money, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(stipend, style: TextStyle(color: Colors.grey[700])),
              ],
            ),
            SizedBox(height: 8),
            // Posted Date and Early Applicant Badge
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(posted, style: TextStyle(color: Colors.grey[700])),
                if (isEarlyApplicant) ...[
                  SizedBox(width: 16),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Be an early applicant',
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
            if (additionalBadge != null) ...[
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange[100],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  additionalBadge,
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}