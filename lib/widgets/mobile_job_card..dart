import 'package:flutter/material.dart';
import '../models/job.dart';
import '../screens/employer/job_details.dart';

class MobileJobCard extends StatelessWidget {
  final Job job;

  const MobileJobCard({
    Key? key,
    required this.job,
  }) : super(key: key);

  String getPostedAgo(String? postedDate) {
    if (postedDate == null || postedDate.isEmpty) return '';
    DateTime? posted;
    try {
      posted = DateTime.parse(postedDate);
    } catch (_) {
      return '';
    }
    final now = DateTime.now();
    final diff = now.difference(posted);

    if (diff.inDays >= 30) {
      final months = (diff.inDays / 30).floor();
      return months == 1 ? '1 month ago' : '$months months ago';
    } else if (diff.inDays >= 7) {
      final weeks = (diff.inDays / 7).floor();
      return weeks == 1 ? '1 week ago' : '$weeks weeks ago';
    } else if (diff.inDays > 0) {
      return diff.inDays == 1 ? '1 day ago' : '${diff.inDays} days ago';
    } else if (diff.inHours > 0) {
      return diff.inHours == 1 ? '1 hour ago' : '${diff.inHours} hours ago';
    } else if (diff.inMinutes > 0) {
      return diff.inMinutes == 1 ? '1 minute ago' : '${diff.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
  borderRadius: BorderRadius.circular(12),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JobDetailsPage(job: job),
      ),
    );
  },
  child: Card(
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            job.title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            job.company,
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 4),
          Text('${job.location ?? ''} • ${job.experienceLevel ?? ''}'),
          const SizedBox(height: 4),
          Text('Salary: ${job.salaryRange ?? 'Not specified'}'),
          const SizedBox(height: 4),
          Text('Posted: ${getPostedAgo(job.postedDate)}'),
          const SizedBox(height: 8),
          if (job.status.toLowerCase().contains('active'))
            Chip(
              label: const Text('Actively Hiring'),
              backgroundColor: Colors.green[100],
            ),
        ],
      ),
    ),
  ),
    );
  }
}