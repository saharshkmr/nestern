import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:nestern/models/course.dart';

class CourseDetailsPage extends StatelessWidget {
  final Course course;

  const CourseDetailsPage({Key? key, required this.course}) : super(key: key);

  Widget _buildSectionTitle(String title) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
      );

  Widget _buildChipList(List<String> items) {
    if (items.isEmpty) return Text('Not specified', style: TextStyle(color: Colors.grey));
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: items.map((e) => Chip(label: Text(e))).toList(),
    );
  }

  Widget _buildQuillDescription(String jsonDescription) {
    try {
      final delta = jsonDecode(jsonDescription);
      final doc = quill.Document.fromJson(delta);
      final controller = quill.QuillController(
        document: doc,
        selection: const TextSelection.collapsed(offset: 0),
      );
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: quill.QuillEditor.basic(
          configurations: quill.QuillEditorConfigurations(
            controller: controller,
            // readOnly: true,
            sharedConfigurations: const quill.QuillSharedConfigurations(),
          ),
        ),
      );
    } catch (e) {
      return Text(jsonDescription);
    }
  }

  Widget _buildTextOrNA(String? value) {
    if (value == null || value.trim().isEmpty) {
      return Text('Not specified', style: TextStyle(color: Colors.grey));
    }
    return Text(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.title),
        backgroundColor: Colors.blue[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Course Image and Title
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: (course.imageUrl.isNotEmpty
                              ? Image.network(course.imageUrl, width: 80, height: 80, fit: BoxFit.cover)
                              : Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.blue[50],
                                  child: Icon(Icons.school, size: 40, color: Colors.blue),
                                )),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        course.title,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.person, color: Colors.deepPurple),
                    SizedBox(width: 8),
                    Text('Instructor: ${course.instructorName}'),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.timer, color: Colors.green),
                    SizedBox(width: 8),
                    Text('Duration: ${course.duration}'),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.bar_chart, color: Colors.orange),
                    SizedBox(width: 8),
                    Text('Level: ${course.level}'),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.attach_money, color: Colors.amber),
                    SizedBox(width: 8),
                    Text('Price: ₹${course.price.toStringAsFixed(2)}'),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.redAccent),
                    SizedBox(width: 8),
                    Text('Location: ${course.location}'),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.computer, color: Colors.teal),
                    SizedBox(width: 8),
                    Text('Mode: ${course.mode ?? course.courseMode}'),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.group, color: Colors.blueGrey),
                    SizedBox(width: 8),
                    Text('Teaching: ${course.teachingMode}'),
                  ],
                ),
                Divider(height: 32),

                _buildSectionTitle('Description'),
                course.description.trim().startsWith('[')
                    ? _buildQuillDescription(course.description)
                    : _buildTextOrNA(course.description),

                SizedBox(height: 16),
                _buildSectionTitle('Categories'),
                _buildChipList(course.category),

                SizedBox(height: 16),
                _buildSectionTitle('Skills You Will Gain'),
                _buildChipList(course.skill),

                SizedBox(height: 16),
                _buildSectionTitle('Topics Covered'),
                _buildChipList(course.topics.map((t) => t.title).toList()),

                SizedBox(height: 16),
                _buildSectionTitle('Access Devices'),
                _buildChipList(course.accessDevices),

                SizedBox(height: 16),
                _buildSectionTitle('Certificate Platforms'),
                _buildChipList(course.certificatePlatforms),

                SizedBox(height: 16),
                _buildSectionTitle('Company Profile'),
                _buildTextOrNA(course.companyProfile),

                SizedBox(height: 16),
                _buildSectionTitle('Background Fit'),
                _buildTextOrNA(course.backgroundFit),

                SizedBox(height: 16),
                _buildSectionTitle('Tailor My Learning Plan'),
                _buildTextOrNA(course.tailorLearningPlan),

                SizedBox(height: 16),
                _buildSectionTitle('Am I a Good Fit?'),
                _buildTextOrNA(course.goodFit),

                SizedBox(height: 16),
                _buildSectionTitle('Connect With'),
                _buildTextOrNA(course.connectWith),

                SizedBox(height: 16),
                _buildSectionTitle('Meet the Teaching Team'),
                _buildTextOrNA(course.teachingTeam),

                SizedBox(height: 24),
                Center(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.shopping_cart),
                    label: Text('Enroll Now'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Enrolled successfully!')),
                      );
                      Future.delayed(const Duration(seconds: 1), () {
                        Navigator.of(context).pushNamedAndRemoveUntil('/dashboard', (route) => false);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}