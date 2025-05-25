import 'package:flutter/material.dart';
import '../models/internship.dart'; // Adjust the path as needed

class InternshipCard extends StatefulWidget {
  final Internship internship;
  final VoidCallback? onViewDetails;

  const InternshipCard({
    Key? key,
    required this.internship,
    this.onViewDetails,
  }) : super(key: key);

  @override
  State<InternshipCard> createState() => _InternshipCardState();
}

class _InternshipCardState extends State<InternshipCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final internship = widget.internship;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedScale(
        scale: _isHovering ? 1.04 : 1.0,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: Container(
          width: 250,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Actively Hiring Badge
              if (internship.status.toLowerCase() == "actively hiring")
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    "Actively hiring",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              SizedBox(height: 8),
              // Title
              Text(
                internship.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 4),
              // Company Name
              Text(
                internship.company,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 16),
              // Location, Salary, and Job Type
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    internship.location != null && internship.locationType != null
                        ? "${internship.location} (${internship.locationType})"
                        : internship.location ?? "",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.attach_money, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    internship.salaryRange ?? "Not specified",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.work, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(
                    internship.jobType,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Job and View Details Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "Job",
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onViewDetails,
                    child: Text(
                      "View details >",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}