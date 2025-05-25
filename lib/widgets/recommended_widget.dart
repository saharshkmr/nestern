import 'package:flutter/material.dart';
import 'package:nestern/models/internship.dart';

class RecommendedInternshipCard extends StatelessWidget {
  final Internship internship;
  final VoidCallback? onTap;

  const RecommendedInternshipCard({
    Key? key,
    required this.internship,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          internship.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(internship.company),
            Text(
              internship.location ?? 'Location not specified',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        trailing: Icon(Icons.arrow_forward, color: Colors.blue),
        onTap: onTap,
      ),
    );
  }
}