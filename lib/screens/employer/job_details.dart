import 'package:flutter/material.dart';
import 'package:nestern/models/job.dart'; // Make sure you have a Job model

class JobDetailsPage extends StatelessWidget {
  final Job job;

  const JobDetailsPage({Key? key, required this.job}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(job.title),
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
                // Company Logo and Name
                Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundImage: job.companyLogo != null && job.companyLogo!.isNotEmpty
                          ? NetworkImage(job.companyLogo!)
                          : null,
                      child: (job.companyLogo == null || job.companyLogo!.isEmpty)
                          ? Icon(Icons.business, size: 32)
                          : null,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        job.company,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Title, Location, Type
                Row(
                  children: [
                    Icon(Icons.work_outline, color: Colors.blue),
                    SizedBox(width: 8),
                    Text(job.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, color: Colors.redAccent),
                    SizedBox(width: 8),
                    Text(job.location ?? 'Location not specified'),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.green),
                    SizedBox(width: 8),
                    Text(job.jobType ?? 'Job Type not specified'),
                  ],
                ),
                Divider(height: 32),

                // Description
                _buildSectionTitle('Description'),
                Text(job.description ?? 'No description provided.'),

                SizedBox(height: 16),
                _buildSectionTitle('Responsibilities'),
                _buildChipList(job.responsibilities ?? []),

                SizedBox(height: 16),
                _buildSectionTitle('Requirements'),
                _buildChipList(job.requirements ?? []),

                SizedBox(height: 16),
                _buildSectionTitle('Benefits'),
                _buildChipList(job.benefits ?? []),

                SizedBox(height: 16),
                _buildSectionTitle('Required Skills'),
                _buildChipList(job.requiredSkills ?? []),

                SizedBox(height: 16),
                _buildSectionTitle('Preferred Skills'),
                _buildChipList(job.preferredSkills ?? []),

                SizedBox(height: 16),
                _buildSectionTitle('Other Details'),
                Row(
                  children: [
                    Icon(Icons.school, color: Colors.deepPurple),
                    SizedBox(width: 8),
                    Text('Education: ${job.education ?? "Not specified"}'),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.monetization_on, color: Colors.amber),
                    SizedBox(width: 8),
                    Text('Salary: ${job.salaryRange ?? "Not specified"}'),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.people, color: Colors.teal),
                    SizedBox(width: 8),
                    Text('Openings: ${job.openings ?? "Not specified"}'),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.blueGrey),
                    SizedBox(width: 8),
                    Text('Posted: ${job.postedDate?.split('T').first ?? "Not specified"}'),
                  ],
                ),
                SizedBox(height: 24),
                Center(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.send),
                    label: Text('Apply Now'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Application submitted successfully!')),
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