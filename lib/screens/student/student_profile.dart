import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nestern/models/user.dart' as my_model;

class StudentProfilePage extends StatefulWidget {
  final my_model.User user;

  StudentProfilePage({required this.user});

  @override
  _StudentProfilePageState createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  Map<String, dynamic>? studentData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStudentData();
  }

  Future<void> fetchStudentData() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .get();

    setState(() {
      studentData = doc.data();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Student Profile')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (studentData == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Student Profile')),
        body: Center(child: Text('No data found.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Student Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: studentData!['url'] != null && studentData!['url'] != ''
                      ? NetworkImage(studentData!['url'])
                      : AssetImage('assets/default_profile.png') as ImageProvider,
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: Text(
                  studentData!['name'] ?? 'No Name',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 8),
              Center(
                child: Text(
                  studentData!['email'] ?? '',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ),
              SizedBox(height: 16),
              Divider(),
              Text(
                'Profile Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text('Phone'),
                subtitle: Text(studentData!['phone'] ?? ''),
              ),
              ListTile(
                leading: Icon(Icons.school),
                title: Text('College'),
                subtitle: Text(studentData!['college'] ?? ''),
              ),
              ListTile(
                leading: Icon(Icons.book),
                title: Text('Course'),
                subtitle: Text(studentData!['course'] ?? ''),
              ),
              ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text('Year'),
                subtitle: Text(studentData!['year'] ?? ''),
              ),
              if (studentData!['bio'] != null && studentData!['bio'] != '')
                ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('Bio'),
                  subtitle: Text(studentData!['bio']),
                ),
              Divider(),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditStudentProfilePage(
                          user: widget.user,
                          initialData: studentData!,
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.edit),
                  label: Text('Edit Profile'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditStudentProfilePage extends StatefulWidget {
  final my_model.User user;
  final Map<String, dynamic> initialData;

  EditStudentProfilePage({required this.user, required this.initialData});

  @override
  _EditStudentProfilePageState createState() => _EditStudentProfilePageState();
}

class _EditStudentProfilePageState extends State<EditStudentProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _collegeController;
  late TextEditingController _courseController;
  late TextEditingController _yearController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialData['name'] ?? '');
    _emailController = TextEditingController(text: widget.initialData['email'] ?? '');
    _phoneController = TextEditingController(text: widget.initialData['phone'] ?? '');
    _collegeController = TextEditingController(text: widget.initialData['college'] ?? '');
    _courseController = TextEditingController(text: widget.initialData['course'] ?? '');
    _yearController = TextEditingController(text: widget.initialData['year'] ?? '');
    _bioController = TextEditingController(text: widget.initialData['bio'] ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _collegeController.dispose();
    _courseController.dispose();
    _yearController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> saveProfile() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .update({
      'name': _nameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'college': _collegeController.text,
      'course': _courseController.text,
      'year': _yearController.text,
      'bio': _bioController.text,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profile updated successfully!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _collegeController,
                decoration: InputDecoration(
                  labelText: 'College',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _courseController,
                decoration: InputDecoration(
                  labelText: 'Course',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _yearController,
                decoration: InputDecoration(
                  labelText: 'Year',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _bioController,
                decoration: InputDecoration(
                  labelText: 'Bio',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: saveProfile,
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}