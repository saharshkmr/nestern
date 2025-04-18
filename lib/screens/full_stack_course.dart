import 'package:flutter/material.dart';

class FullStackCoursePage extends StatelessWidget {
  const FullStackCoursePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Section
            Container(
              color: Color(0xFF4A148C), // Purple background
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tags
                  Row(
                    children: [
                      _buildTag('Government-certified'),
                      SizedBox(width: 8),
                      _buildTag('AI-Powered'),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Title
                  Text(
                    'Full Stack Development Course with Guaranteed Placement',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  // Subtitle
                  Text(
                    'Get placed with ₹3-10 LPA salary',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  // Features
                  Row(
                    children: [
                      _buildFeature('Live Coding Practice'),
                      SizedBox(width: 16),
                      _buildFeature('4 months Online course'),
                      SizedBox(width: 16),
                      _buildFeature('100% refund if not hired!'),
                    ],
                  ),
                  SizedBox(height: 32),
                  // Admission and Fee Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ADMISSION CLOSES ON',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              _buildTag('Limited seats'),
                              SizedBox(width: 8),
                              Text(
                                '23rd Apr',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'COURSE FEE',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                '₹40,000',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                '48,000',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Save ₹8,000/-',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.greenAccent,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Form Section
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Interested? Apply Now',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      _buildTextField('First Name'),
                      SizedBox(height: 16),
                      _buildTextField('Last Name (Optional)'),
                      SizedBox(height: 16),
                      _buildTextField('Email id'),
                      SizedBox(height: 16),
                      _buildTextField('Phone number'),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: _buildDropdown('Education')),
                          SizedBox(width: 16),
                          Expanded(child: _buildDropdown('Graduation Year')),
                        ],
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // Handle Apply Now action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                        ),
                        child: Center(
                          child: Text(
                            'Apply now',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'By continuing to apply, you agree to our T&C.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Reviews Section
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Guaranteed Placement Reviews',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildReviewCard(
                        name: 'Gaurav',
                        salary: '₹7.8 LPA',
                        role: 'Full Stack Developer, Nurture Labs',
                        review:
                            'It gave me the necessary skills & boosted my confidence. I particularly enjoyed the masterclasses & projects which helped me build a strong portfolio.',
                      ),
                      _buildReviewCard(
                        name: 'Gagan Ganapathy',
                        salary: 'Marmeto',
                        role: '',
                        review:
                            'The course had quick doubt resolution and helpful assignments. I enjoyed building an e-commerce website, which improved my skills.',
                      ),
                      _buildReviewCard(
                        name: 'Madhav',
                        salary: 'Dploy',
                        role: '',
                        review:
                            'I was a web developer before joining the course. The industry projects, live sessions, and doubt-clearing support were really helpful.',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build tags
  Widget _buildTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  // Helper method to build features
  Widget _buildFeature(String text) {
    return Row(
      children: [
        Icon(Icons.check_circle, color: Colors.white, size: 16),
        SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  // Helper method to build text fields
  Widget _buildTextField(String hintText) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  // Helper method to build dropdowns
  Widget _buildDropdown(String hintText) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      items: [],
      onChanged: (value) {},
    );
  }

  // Helper method to build review cards
  Widget _buildReviewCard({
    required String name,
    required String salary,
    required String role,
    required String review,
  }) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                salary,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 8),
              Text(
                role,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 8),
              Text(
                review,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}