import 'package:flutter/material.dart';

class InternshipPageMumbai extends StatelessWidget {
  const InternshipPageMumbai({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Internships in Mumbai'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Title
            Text(
              '4 Internships in Mumbai',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            // Subtitle
            Text(
              'Latest Intern Jobs in Mumbai',
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
                    title: 'Interior Design',
                    company: 'NAKSH GRUHAM DESIGN STUDIO',
                    location: 'Mumbai',
                    duration: '6 Months',
                    stipend: '₹7,000 - ₹10,000 /month',
                    posted: '2 weeks ago',
                    isActivelyHiring: true,
                  ),
                  _buildInternshipCard(
                    title: 'Social Media (Digital Media)',
                    company: 'Wehire Talent Solutions',
                    location: 'Mumbai, Dahisar, Borivali, Bandra, Mira Road',
                    duration: '3 Months',
                    stipend: '₹5,000 /month',
                    posted: '3 days ago',
                    isActivelyHiring: true,
                  ),
                  _buildInternshipCard(
                    title: 'Marketing Executive (Onfield + Online)',
                    company: 'Wehire Talent Solutions (Mumbai, India)',
                    location: 'Mumbai, Dahisar, Mira Road (Canada), Borivali, Bandra',
                    duration: '3 Months',
                    stipend: '₹5,000 /month',
                    posted: '3 days ago',
                    isActivelyHiring: true,
                  ),
                  _buildInternshipCard(
                    title: 'Graphic Design',
                    company: 'Mending Mind',
                    location: 'Mumbai (Hybrid)',
                    duration: '4 Months',
                    stipend: '₹7,000 - ₹10,000 /month',
                    posted: '3 weeks ago',
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
            // Posted Date
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(posted, style: TextStyle(color: Colors.grey[700])),
              ],
            ),
          ],
        ),
      ),
    );
  }
}