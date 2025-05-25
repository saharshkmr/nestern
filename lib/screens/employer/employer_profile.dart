import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nestern/models/user.dart' as my_model;

class EmployerProfilePage extends StatefulWidget {
  final my_model.User user;

  EmployerProfilePage({required this.user});

  @override
  _EmployerProfilePageState createState() => _EmployerProfilePageState();
}

class _EmployerProfilePageState extends State<EmployerProfilePage> {
  Map<String, dynamic>? employerData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEmployerData();
  }

  Future<void> fetchEmployerData() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .get();

    setState(() {
      employerData = doc.data();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Employer Profile')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (employerData == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Employer Profile')),
        body: Center(child: Text('No data found.')),
      );
    }

    return Scaffold(
  appBar: AppBar(
    title: Text('Employer Profile'),
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
              backgroundImage: employerData!['url'] != null && employerData!['url'] != ''
                  ? NetworkImage(employerData!['url'])
                  : AssetImage('assets/company_logo.png') as ImageProvider,
            ),
          ),
          SizedBox(height: 16),
          Center(
            child: Text(
              employerData!['companyName'] ?? 'No Company Name',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 8),
          Center(
            child: Text(
              employerData!['email'] ?? '',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ),
          SizedBox(height: 8),
          if (employerData!['name'] != null && employerData!['name'] != '')
            Center(
              child: Text(
                employerData!['name'],
                style: TextStyle(fontSize: 18, color: Colors.grey[800]),
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
            subtitle: Text(employerData!['phone'] ?? ''),
          ),
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text('Address'),
            subtitle: Text(employerData!['address'] ?? ''),
          ),
          if (employerData!['website'] != null && employerData!['website'] != '')
            ListTile(
              leading: Icon(Icons.web),
              title: Text('Website'),
              subtitle: Text(employerData!['website']),
            ),
          if (employerData!['bio'] != null && employerData!['bio'] != '')
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('Bio'),
              subtitle: Text(employerData!['bio']),
            ),
          Divider(),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditEmployerProfilePage(
                      user: widget.user,
                      initialData: employerData!,
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

class EditEmployerProfilePage extends StatefulWidget {
  final my_model.User user;
  final Map<String, dynamic> initialData;

  EditEmployerProfilePage({required this.user, required this.initialData});

  @override
  _EditEmployerProfilePageState createState() => _EditEmployerProfilePageState();
}

// ...existing code...
class _EditEmployerProfilePageState extends State<EditEmployerProfilePage> {
  late TextEditingController _companyNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _nameController;
  late TextEditingController _websiteController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _companyNameController = TextEditingController(text: widget.initialData['companyName'] ?? '');
    _emailController = TextEditingController(text: widget.initialData['email'] ?? '');
    _phoneController = TextEditingController(text: widget.initialData['phone'] ?? '');
    _addressController = TextEditingController(text: widget.initialData['address'] ?? '');
    _nameController = TextEditingController(text: widget.initialData['name'] ?? '');
    _websiteController = TextEditingController(text: widget.initialData['website'] ?? '');
    _bioController = TextEditingController(text: widget.initialData['bio'] ?? '');
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _nameController.dispose();
    _websiteController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> saveProfile() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .update({
      'companyName': _companyNameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'address': _addressController.text,
      'name': _nameController.text,
      'website': _websiteController.text,
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
                controller: _companyNameController,
                decoration: InputDecoration(
                  labelText: 'Company Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
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
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _websiteController,
                decoration: InputDecoration(
                  labelText: 'Website',
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