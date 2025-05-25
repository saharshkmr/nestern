import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:nestern/services/internship_service.dart';
import '../../models/internship.dart';
import 'package:nestern/models/user.dart';

class CreateInternshipScreen extends StatefulWidget {
  final User user;
  final Internship? internship;

  const CreateInternshipScreen({Key? key, required this.user, this.internship}) : super(key: key);

  @override
  State<CreateInternshipScreen> createState() => _CreateInternshipScreenState();
}

class _CreateInternshipScreenState extends State<CreateInternshipScreen> {
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Internship Data
  String title = '';
  String? industry = '';
  String company = '';
  String jobType = '';
  String description = '';
  String? education = '';
  String? gender = '';
  String experienceLevel = '';
  String? salaryRange = '';
  List<String> responsibilities = [];
  List<String> requirements = [];
  List<String> benefits = [];
  List<String> requiredSkills = [];
  List<String> preferredSkills = [];
  String? location = '';
  String? openings = '';
  String? locationType = '';
  String? email = '';
  String companyLogo = '';
  String status = 'Open';
  // ...existing code...
String? duration = '';
final TextEditingController _durationController = TextEditingController();
// ...existing code...

  // Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _industryController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _jobTypeController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _experienceLevelController = TextEditingController();
  final TextEditingController _salaryRangeController = TextEditingController();
  final TextEditingController _responsibilitiesController = TextEditingController();
  final TextEditingController _requirementsController = TextEditingController();
  final TextEditingController _benefitsController = TextEditingController();
  final TextEditingController _requiredSkillsController = TextEditingController();
  final TextEditingController _preferredSkillsController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _openingsController = TextEditingController();
  final TextEditingController _locationTypeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _companyLogoController = TextEditingController();
  

  quill.QuillController _descriptionController = quill.QuillController.basic();

  Uint8List? companyLogoBytes;
  Uint8List? imageBytes;
  String imagePath = '';

  @override
  void initState() {
    super.initState();
    if (widget.internship != null) {
      _populateFormFields();
    }
  }

  void _populateFormFields() {
    final i = widget.internship!;
    _titleController.text = i.title;
    _industryController.text = i.industry ?? '';
    _companyController.text = i.company;
    _jobTypeController.text = i.jobType;
    _educationController.text = i.education ?? '';
    _genderController.text = i.gender ?? '';
    _experienceLevelController.text = i.experienceLevel;
    _salaryRangeController.text = i.salaryRange ?? '';
    _responsibilitiesController.text = i.responsibilities.join(', ');
    _requirementsController.text = i.requirements.join(', ');
    _benefitsController.text = i.benefits.join(', ');
    _requiredSkillsController.text = i.requiredSkills.join(', ');
    _preferredSkillsController.text = i.preferredSkills.join(', ');
    _locationController.text = i.location ?? '';
    _openingsController.text = i.openings ?? '';
    _locationTypeController.text = i.locationType ?? '';
    _emailController.text = i.email ?? '';
    _companyLogoController.text = i.companyLogo;
    _durationController.text = i.duration ?? '';

    duration = i.duration;
    title = i.title;
    industry = i.industry;
    company = i.company;
    jobType = i.jobType;
    education = i.education;
    gender = i.gender;
    experienceLevel = i.experienceLevel;
    salaryRange = i.salaryRange;
    responsibilities = List<String>.from(i.responsibilities);
    requirements = List<String>.from(i.requirements);
    benefits = List<String>.from(i.benefits);
    requiredSkills = List<String>.from(i.requiredSkills);
    preferredSkills = List<String>.from(i.preferredSkills);
    location = i.location;
    openings = i.openings;
    locationType = i.locationType;
    email = i.email;
    companyLogo = i.companyLogo;
    status = i.status;

    // Description
    if (i.description.isNotEmpty) {
      try {
        final delta = jsonDecode(i.description);
        final doc = quill.Document.fromJson(delta);
        _descriptionController = quill.QuillController(
          document: doc,
          selection: const TextSelection.collapsed(offset: 0),
        );
        description = i.description;
      } catch (_) {
        final doc = quill.Document()..insert(0, i.description);
        _descriptionController = quill.QuillController(
          document: doc,
          selection: const TextSelection.collapsed(offset: 0),
        );
        description = i.description;
      }
    }
  }

  Future<String> _uploadImage() async {
    if ((companyLogoBytes != null) || (companyLogo.isNotEmpty)) {
      String extension = '';
      if (companyLogo.isNotEmpty) {
        extension = companyLogo.split('.').last;
      } else if (imagePath.isNotEmpty) {
        extension = imagePath.split('.').last;
      }
      if (extension.isEmpty) extension = 'jpg';
      String fileName = "${DateTime.now().millisecondsSinceEpoch}.$extension";
      Reference storageRef = FirebaseStorage.instance.ref().child("companyLogos/$fileName");
      UploadTask uploadTask;
      if (kIsWeb && companyLogoBytes != null) {
        uploadTask = storageRef.putData(companyLogoBytes!);
      } else {
        File file = File(companyLogo);
        uploadTask = storageRef.putFile(file);
      }
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    }
    return "";
  }

  Widget buildTextField(
    String label,
    TextEditingController controller,
    String? Function(String?)? validator,
    void Function(String?)? onSaved, {
    Widget? prefixIcon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }

  Widget _sectionTitle(String title, {TextStyle? textStyle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: textStyle ?? const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildQuillEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Description', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          height: 200,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: quill.QuillEditor.basic(
            configurations: quill.QuillEditorConfigurations(
              controller: _descriptionController,
              sharedConfigurations: const quill.QuillSharedConfigurations(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        quill.QuillToolbar.simple(
          configurations: quill.QuillSimpleToolbarConfigurations(
            controller: _descriptionController,
            sharedConfigurations: const quill.QuillSharedConfigurations(),
          ),
        ),
      ],
    );
  }

  Widget _buildCompanyLogoPreview() {
    Widget imageWidget;
    if (imageBytes != null) {
      imageWidget = Image.memory(imageBytes!, fit: BoxFit.cover, width: 120, height: 120);
    } else if (imagePath.isNotEmpty) {
      if (imagePath.startsWith("http")) {
        imageWidget = Image.network(imagePath, fit: BoxFit.cover, width: 120, height: 120);
      } else if (!kIsWeb) {
        imageWidget = Image.file(File(imagePath), fit: BoxFit.cover, width: 120, height: 120);
      } else {
        imageWidget = const Icon(Icons.image, size: 60, color: Colors.grey);
      }
    } else if (companyLogo.isNotEmpty) {
      if (companyLogo.startsWith("http")) {
        imageWidget = Image.network(companyLogo, fit: BoxFit.cover, width: 120, height: 120);
      } else if (kIsWeb && companyLogoBytes != null) {
        imageWidget = Image.memory(companyLogoBytes!, fit: BoxFit.cover, width: 120, height: 120);
      } else if (!kIsWeb) {
        imageWidget = Image.file(File(companyLogo), fit: BoxFit.cover, width: 120, height: 120);
      } else {
        imageWidget = const Icon(Icons.image, size: 60, color: Colors.grey);
      }
    } else {
      imageWidget = const Icon(Icons.image, size: 60, color: Colors.grey);
    }
    bool showRemove = imageBytes != null || imagePath.isNotEmpty || companyLogo.isNotEmpty;
    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.grey[300],
          child: ClipOval(
            child: SizedBox(width: 120, height: 120, child: imageWidget),
          ),
        ),
        if (showRemove)
          Positioned(
            top: 4,
            right: 4,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    imageBytes = null;
                    imagePath = '';
                    companyLogo = '';
                    companyLogoBytes = null;
                    _companyLogoController.clear();
                  });
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(4),
                  child: const Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result != null) {
      if (kIsWeb) {
        setState(() {
          companyLogoBytes = result.files.single.bytes;
          imageBytes = result.files.single.bytes;
          imagePath = result.files.single.name;
          companyLogo = '';
          _companyLogoController.text = result.files.single.name;
        });
      } else if (result.files.single.path != null) {
        setState(() {
          companyLogo = result.files.single.path!;
          imagePath = result.files.single.path!;
          imageBytes = null;
          _companyLogoController.text = result.files.single.path!;
          companyLogoBytes = null;
        });
      }
    }
  }

  Widget _buildPageWithButtons(Widget pageContent, {bool isLastPage = false}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          pageContent,
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentPage > 0)
                ElevatedButton(
                  onPressed: () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Back', style: TextStyle(fontSize: 18)),
                ),
              if (_currentPage > 0) const Spacer(),
              if (!isLastPage)
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Next', style: TextStyle(fontSize: 18)),
                ),
              if (isLastPage)
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      description = jsonEncode(_descriptionController.document.toDelta().toJson());
                      await _createInternship();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Create Internship', style: TextStyle(fontSize: 18)),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // Page 1: Internship Details
  Widget _buildPage1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionTitle("Internship Details"),
        buildTextField(
          'Title',
          _titleController,
          (value) => value!.isEmpty ? 'Please enter a title' : null,
          (value) => title = value!,
          prefixIcon: Icon(Icons.work, color: Colors.blue),
        ),
        const SizedBox(height: 16),
        buildTextField(
          'Industry',
          _industryController,
          null,
          (value) => industry = value!,
          prefixIcon: Icon(Icons.business, color: Colors.blue),
        ),
        const SizedBox(height: 16),
        buildTextField(
          'Company',
          _companyController,
          (value) => value!.isEmpty ? 'Please enter a company name' : null,
          (value) => company = value!,
          prefixIcon: Icon(Icons.business, color: Colors.blue),
        ),
        const SizedBox(height: 16),
        buildTextField(
          'Location Type',
          _locationTypeController,
          null,
          (value) => locationType = value!,
          prefixIcon: Icon(Icons.location_city, color: Colors.blue),
        ),
        const SizedBox(height: 16),
        buildTextField(
          'Location',
          _locationController,
          null,
          (value) => location = value!,
          prefixIcon: Icon(Icons.location_on, color: Colors.blue),
        ),
        const SizedBox(height: 16),
        buildTextField(
          'Duration',
          _durationController,
          null,
          (value) => duration = value,
          prefixIcon: Icon(Icons.access_time, color: Colors.blue),
        ),
        const SizedBox(height: 16),
        buildQuillEditor(),
      ],
    );
  }

  // Page 2: Additional Information
  Widget _buildPage2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionTitle("Additional Information"),
        buildTextField(
          'Job Type',
          _jobTypeController,
          null,
          (value) => jobType = value!,
          prefixIcon: Icon(Icons.work_outline, color: Colors.blue),
        ),
        const SizedBox(height: 16),
        buildTextField(
          'Experience Level',
          _experienceLevelController,
          null,
          (value) => experienceLevel = value!,
          prefixIcon: Icon(Icons.star, color: Colors.blue),
        ),
        const SizedBox(height: 16),
        buildTextField(
          'Salary Range',
          _salaryRangeController,
          null,
          (value) => salaryRange = value!,
          prefixIcon: Icon(Icons.attach_money, color: Colors.blue),
        ),
        const SizedBox(height: 16),
        buildTextField(
          'Responsibilities (comma-separated)',
          _responsibilitiesController,
          null,
          (value) => responsibilities = value!
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList(),
          prefixIcon: Icon(Icons.list, color: Colors.blue),
        ),
        const SizedBox(height: 16),
        buildTextField(
          'Requirements (comma-separated)',
          _requirementsController,
          null,
          (value) => requirements = value!
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList(),
          prefixIcon: Icon(Icons.check_circle_outline, color: Colors.blue),
        ),
        const SizedBox(height: 16),
        buildTextField(
          'Openings',
          _openingsController,
          null,
          (value) => openings = value,
          prefixIcon: Icon(Icons.work, color: Colors.blue),
        ),
      ],
    );
  }

  // Page 3: Company Details and Final Submission
  Widget _buildPage3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionTitle("Company Details"),
        buildTextField(
          'Email',
          _emailController,
          null,
          (value) => email = value!,
          prefixIcon: Icon(Icons.email, color: Colors.blue),
        ),
        const SizedBox(height: 16),
        _buildCompanyLogoPreview(),
        TextButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.image),
          label: const Text('Pick Image from Gallery'),
        ),
        const SizedBox(height: 16),
        buildTextField(
          'Benefits (comma-separated)',
          _benefitsController,
          null,
          (value) => benefits = value!
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList(),
          prefixIcon: Icon(Icons.star_border, color: Colors.blue),
        ),
        const SizedBox(height: 16),
        buildTextField(
          'Required Skills (comma-separated)',
          _requiredSkillsController,
          null,
          (value) => requiredSkills = value!
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList(),
          prefixIcon: Icon(Icons.developer_mode, color: Colors.blue),
        ),
        const SizedBox(height: 16),
        buildTextField(
          'Preferred Skills (comma-separated)',
          _preferredSkillsController,
          null,
          (value) => preferredSkills = value!
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList(),
          prefixIcon: Icon(Icons.developer_board, color: Colors.blue),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Future<void> _createInternship() async {
  String uploadedLogoUrl = companyLogo;
  if ((companyLogoBytes != null) || (companyLogo.isNotEmpty && !companyLogo.startsWith('http'))) {
    uploadedLogoUrl = await _uploadImage();
  }
  Internship newInternship = Internship(
    id: '',
    title: title,
    industry: industry,
    company: company,
    jobType: jobType,
    description: jsonEncode(_descriptionController.document.toDelta().toJson()),
    education: education,
    experienceLevel: experienceLevel,
    salaryRange: salaryRange,
    responsibilities: responsibilities,
    requirements: requirements,
    benefits: benefits,
    requiredSkills: requiredSkills,
    preferredSkills: preferredSkills,
    location: location,
    locationType: locationType,
    openings: openings,
    email: email,
    companyLogo: uploadedLogoUrl,
    postedDate: DateTime.now().toIso8601String(),
    status: status,
    userId: widget.user.id,
    AIscore: null,
    AIreason: null,
    applyClickCount: 0,
  );
  try {
    // Use InternshipService to create the internship
    final internshipService = InternshipService();
    String internshipId = await internshipService.createInternship(newInternship);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Internship created successfully with ID: $internshipId')),
    );
    Navigator.pop(context);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error creating internship: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Internship', style: TextStyle(fontSize: 22, color: Colors.white)),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: _formKey,
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            setState(() {
              _currentPage = index;
            });
          },
          children: [
            _buildPageWithButtons(_buildPage1()),
            _buildPageWithButtons(_buildPage2()),
            _buildPageWithButtons(_buildPage3(), isLastPage: true),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _titleController.dispose();
    _industryController.dispose();
    _companyController.dispose();
    _jobTypeController.dispose();
    _educationController.dispose();
    _genderController.dispose();
    _experienceLevelController.dispose();
    _salaryRangeController.dispose();
    _responsibilitiesController.dispose();
    _requirementsController.dispose();
    _benefitsController.dispose();
    _requiredSkillsController.dispose();
    _preferredSkillsController.dispose();
    _locationController.dispose();
    _openingsController.dispose();
    _locationTypeController.dispose();
    _emailController.dispose();
    _companyLogoController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}