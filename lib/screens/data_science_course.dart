import 'package:flutter/material.dart';
import 'package:nestern/widgets/custom_input_field.dart';
import 'package:nestern/widgets/date_widget.dart';

class DataScienceCoursePage extends StatelessWidget {
  const DataScienceCoursePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Section
            Container(
              color: Color(0xFF0D47A1), // Blue gradient background
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
                    'Data Science Course with Placement',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  // Subtitle
                  Text(
                    'Get confirmed ₹40,000 total stipend',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 16),
                  // Features
                  Row(
                    children: [
                      _buildFeature('4.5/5'),
                      SizedBox(width: 16),
                      _buildFeature('Introducing Live Bootcamp'),
                      SizedBox(width: 16),
                      _buildFeature('6 months Online course'),
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
                                '₹42,000',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                '50,000',
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
                          Expanded(child: buildDateField(context, 'Education', TextEditingController(), () {})),
                          SizedBox(width: 16),
                          Expanded(child: buildDateField(context, 'Date of Birth', TextEditingController(), () {})),
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
                    'Reviews from placed students',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'AVERAGE RATING',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '4.5',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.star, color: Colors.orange, size: 24),
                      Icon(Icons.star, color: Colors.orange, size: 24),
                      Icon(Icons.star, color: Colors.orange, size: 24),
                      Icon(Icons.star, color: Colors.orange, size: 24),
                      Icon(Icons.star_half, color: Colors.orange, size: 24),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildReviewCard(
                        name: 'Yashwant',
                        role: 'GO-AI Associate, Amazon',
                        review:
                            'It was my dream to work at one of the MAANG companies. This course helped me achieve that.',
                      ),
                      _buildReviewCard(
                        name: 'Alka Verma',
                        role: '₹9 LPA\nOperations Head, Gloqal Inc',
                        review:
                            'The course provided me with the skills and confidence to excel in my career.',
                      ),
                      _buildReviewCard(
                        name: 'Ganesh Baravkar',
                        role: 'Flipkart',
                        review:
                            'I had some doubts initially, but the course turned out to be a game-changer for my career.',
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


  // Helper method to build review cards
  Widget _buildReviewCard({
    required String name,
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