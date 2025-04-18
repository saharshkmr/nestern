import 'package:flutter/material.dart';

class EmployerHelpCenterPage extends StatefulWidget {
  const EmployerHelpCenterPage({Key? key}) : super(key: key);

  @override
  _EmployerHelpCenterPageState createState() => _EmployerHelpCenterPageState();
}

class _EmployerHelpCenterPageState extends State<EmployerHelpCenterPage> {
  int? _selectedIndex; // To track the expanded question index

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employer Help Center'),
        backgroundColor: Colors.blue,
      ),
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 200,
            color: Colors.grey[200],
            child: ListView(
              children: [
                _buildSidebarItem('Getting Started', 0),
                _buildSidebarItem('Account', 1),
                _buildSidebarItem('Opportunities Posted', 2),
                _buildSidebarItem('Application Received', 3),
                _buildSidebarItem('Candidates Selected', 4),
                _buildSidebarItem('Payment & Refunds', 5),
                _buildSidebarItem('Need Assistance', 6),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  _buildQuestionItem(
                    index: 0,
                    question: 'How do I hire interns/freshers using Internshala?',
                    answer:
                        'To hire interns or freshers, you can post your requirements on Internshala and review applications from candidates.',
                  ),
                  _buildQuestionItem(
                    index: 1,
                    question:
                        'What benefits do I get if I upgrade my internship/job to premium?',
                    answer:
                        'Upgrading to premium gives you access to additional features like highlighted listings, priority support, and more visibility.',
                  ),
                  _buildQuestionItem(
                    index: 2,
                    question:
                        'Will you share the list/database of candidates with me?',
                    answer:
                        'No, we do not share the database of candidates. You can review applications submitted for your job postings.',
                  ),
                  _buildQuestionItem(
                    index: 3,
                    question:
                        'Can I find candidates with prior work experience on Internshala?',
                    answer:
                        'Yes, you can find candidates with prior work experience by specifying your requirements in the job posting.',
                  ),
                  _buildQuestionItem(
                    index: 4,
                    question:
                        'Is there any criteria of a minimum stipend/CTC to post internships/jobs on Internshala?',
                    answer:
                        'Yes, there are minimum stipend/CTC requirements to ensure fair compensation for candidates.',
                  ),
                  _buildQuestionItem(
                    index: 5,
                    question: 'What is the hiring process I should follow?',
                    answer:
                        'The hiring process includes posting your requirements, reviewing applications, shortlisting candidates, and conducting interviews.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build sidebar items
  Widget _buildSidebarItem(String title, int index) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          color: index == _selectedIndex ? Colors.blue : Colors.black,
          fontWeight: index == _selectedIndex ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
    );
  }

  // Helper method to build question items
  Widget _buildQuestionItem({
    required int index,
    required String question,
    required String answer,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 2,
      child: ExpansionTile(
        key: Key(index.toString()),
        title: Text(
          question,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              answer,
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}