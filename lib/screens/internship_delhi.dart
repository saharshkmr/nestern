import 'package:flutter/material.dart';

class InternshipPageDelhi extends StatelessWidget {
  const InternshipPageDelhi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Internships in Delhi'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Title
            Text(
              '4 Internships in Delhi',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            // Subtitle
            Text(
              'Latest Intern Jobs in Delhi',
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
                    title: 'Architecture',
                    company: 'Nagalia Associates 5D Studio',
                    location: 'Noida',
                    duration: '6 Months',
                    stipend: '₹11,000 - ₹15,000 /month',
                    posted: 'Today',
                    isEarlyApplicant: true,
                    isActivelyHiring: true,
                  ),
                  _buildInternshipCard(
                    title: 'Sales',
                    company: 'Value4Media',
                    location: 'Noida',
                    duration: '6 Months',
                    stipend: '₹10,000 /month',
                    posted: '2 weeks ago',
                    isEarlyApplicant: false,
                    isActivelyHiring: true,
                  ),
                  _buildInternshipCard(
                    title: 'Sales Consultant (Female)',
                    company: 'THE FAIRYTALE\'S',
                    location: 'Delhi, West Patel Nagar, Gurgaon, South',
                    duration: '1 Month',
                    stipend: '₹10,000 /month',
                    posted: '3 weeks ago',
                    isEarlyApplicant: false,
                    isActivelyHiring: true,
                  ),
                  _buildInternshipCard(
                    title: 'Human Resource Operations',
                    company: 'Freecharge Payments Technology Private Limited',
                    location: 'Gurgaon',
                    duration: '6 Months',
                    stipend: '₹15,000 /month',
                    posted: '3 weeks ago',
                    isEarlyApplicant: false,
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
          ],
        ),
      ),
    );
  }
}