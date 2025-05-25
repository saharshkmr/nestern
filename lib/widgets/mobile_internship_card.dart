import 'package:flutter/material.dart';
import '../models/internship.dart';
import '../screens/employer/internship_details.dart'; // Make sure this import path is correct
import 'package:intl/intl.dart';

class MobileInternshipCard extends StatelessWidget {
  final Internship internship;
  final String? additionalBadge;

  const MobileInternshipCard({
    Key? key,
    required this.internship,
    this.additionalBadge,
  }) : super(key: key);

  String getPostedAgo(String postedDate) {
    if (postedDate.isEmpty) return '';
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
    final bool isActivelyHiring = internship.status.toLowerCase().contains('active');
    final String postedAgo = getPostedAgo(internship.postedDate);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InternshipDetailsPage(internship: internship),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Actively Hiring badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      internship.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (isActivelyHiring)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
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
              const SizedBox(height: 8),
              Text(
                internship.company,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    internship.location ?? '',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.access_time, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    internship.duration ?? '',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.money, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    (internship.salaryRange != null && internship.salaryRange!.isNotEmpty)
                        ? internship.salaryRange!
                        : 'Not specified',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    postedAgo,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ],
              ),
              if (additionalBadge != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    additionalBadge!,
                    style: const TextStyle(
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
      ),
    );
  }
}