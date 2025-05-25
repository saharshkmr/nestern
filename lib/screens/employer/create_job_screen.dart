import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nestern/models/job.dart';
import 'package:nestern/models/user.dart';
import 'package:nestern/services/job_service.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:file_picker/file_picker.dart';
// import 'package:nestern/theme/app_theme.dart';
import 'package:flutter/foundation.dart'; // Needed for kIsWeb
import 'dart:io'; // Needed for File class (non-web)
import 'package:firebase_storage/firebase_storage.dart'; // Add this import
import 'package:nestern/widgets/dropdown_widget.dart';

class CreateJobScreen extends StatefulWidget {
  // final User user;
  final Job? job; // Optional job parameter for editing

  const CreateJobScreen({Key? key, this.job}) : super(key: key);

  @override
  _CreateJobScreenState createState() => _CreateJobScreenState();
}


class _CreateJobScreenState extends State<CreateJobScreen> {
  quill.QuillController _descriptionController = quill.QuillController.basic();
  final JobService _jobService = JobService();
  final _formKey = GlobalKey<FormState>();

  Uint8List? companyLogoBytes; // For web
  Uint8List? imageBytes; // For previewing the image
  String imagePath = ''; // For previewing the image path

  bool _isValidJson(String str) {
    try {
      final decoded = jsonDecode(str);
      return decoded is List;
    } catch (_) {
      return false;
    }
  }
  // Flag to check if we're editing or creating
  bool _isEditing = false;
  Job? _originalJob; // Store the original job for comparison when updating

  // Job Data
  String title = '';
  String industry = '';
  String company = '';
  String location = '';
  String locationType = '';
  String description = '';
  String companyLogo = '';
  String jobType = '';
  String experienceLevel = '';
  String salaryRange = '';
  List<String> responsibilities = [];
  List<String> requirements = [];
  List<String> benefits = [];
  List<String> skills = [];
  String email = '';
  String? openings = '';

  // Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _industryController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _locationTypeController = TextEditingController();
  final TextEditingController _jobTypeController = TextEditingController();
  final TextEditingController _experienceLevelController = TextEditingController();
  final TextEditingController _salaryRangeController = TextEditingController();
  final TextEditingController _responsibilitiesController = TextEditingController();
  final TextEditingController _requirementsController = TextEditingController();
  final TextEditingController _openingsController = TextEditingController();
  final TextEditingController _benefitsController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _companyLogoController = TextEditingController();

  // Focus Node
  final FocusNode _editorFocusNode = FocusNode();

  // Page Management
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _isEditing = widget.job != null;
    _originalJob = widget.job;

    if (_isEditing) {
      // Pre-fill form fields with existing job data
      _populateFormFields();
    }
  }

Future<String> _uploadImage() async {
  if ((companyLogoBytes != null) || (companyLogo.isNotEmpty)) {
    // Get the original file extension
    String extension = '';
    if (companyLogo.isNotEmpty) {
      extension = companyLogo.split('.').last;
    } else if (imagePath.isNotEmpty) {
      extension = imagePath.split('.').last;
    }

    // Fallback to 'jpg' if extension is not found
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

  // Populate form fields with existing job data
  void _populateFormFields() {
    final job = widget.job!;

    // Set text controllers
    _titleController.text = job.title;
    _industryController.text = job.industry ?? '';
    _companyController.text = job.company;
    _locationController.text = job.location ?? '';
    _locationTypeController.text = job.locationType ?? '';
    _jobTypeController.text = job.jobType;
    _experienceLevelController.text = job.experienceLevel;
    _salaryRangeController.text = job.salaryRange ?? '';
    _responsibilitiesController.text = job.responsibilities.join(', ');
    _benefitsController.text = job.benefits.join(', ');
    _openingsController.text = job.openings ?? '';
    _skillsController.text = job.preferredSkills.join(', ');
    _skillsController.text = job.requiredSkills.join(', ');
    _emailController.text = job.email ?? '';
    _companyLogoController.text = job.companyLogo;

    // Set state variables
    title = job.title;
    industry = job.industry ?? '';
    company = job.company;
    location = job.location ?? '';
    locationType = job.locationType ?? '';
    jobType = job.jobType;
    experienceLevel = job.experienceLevel;
    salaryRange = job.salaryRange ?? '';
    responsibilities = List<String>.from(job.responsibilities);
    openings = job.openings;
    requirements = List<String>.from(job.requirements);
    benefits = List<String>.from(job.benefits);
    skills = List<String>.from(job.preferredSkills);
    skills = List<String>.from(job.requiredSkills);
    email = job.email ?? '';
    companyLogo = job.companyLogo;

    // Set description in Quill editor
  if (job.description.isNotEmpty) {
    if (_isValidJson(job.description)) {
      final delta = jsonDecode(job.description);
      final doc = quill.Document.fromJson(delta);
      _descriptionController = quill.QuillController(
        document: doc,
        selection: const TextSelection.collapsed(offset: 0),
      );
      description = job.description;
    } else {
      // Fallback: treat as plain text
      final doc = quill.Document()..insert(0, job.description);
      _descriptionController = quill.QuillController(
        document: doc,
        selection: const TextSelection.collapsed(offset: 0),
      );
      description = job.description;
    }
  };
  }

  // Function to build the input field.
  Widget buildTextField(
    String label,
    TextEditingController controller,
    String? Function(String?)? validator,
    void Function(String?)? onSaved, {
    Widget? prefixIcon,
  }) {
    return InputWidget(
      // Use the defined InputWidget
      label: label,
      controller: controller,
      validator: validator,
      onSaved: onSaved,
      prefixIcon: prefixIcon,
    );
  }

  // Function to build the section title
  Widget _sectionTitle(String title, {TextStyle? textStyle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: textStyle ??
            const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Function to build the file upload widget
  Widget buildFileUploadWidget() {
    return GestureDetector(
      onTap: () async {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['jpeg', 'jpg', 'png'],
        );

        if (result != null) {
          String? filePath = result.files.single.path;
          if (filePath != null) {
            setState(() {
              _companyLogoController.text = filePath;
              companyLogo = filePath;
            });
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No file selected')),
          );
        }
      },
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[200],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_upload, size: 50, color: Colors.blue),
            const SizedBox(height: 8),
            const Text(
              'Drag files to upload',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['jpeg', 'jpg', 'png'],
                );

                if (result != null) {
                  String? filePath = result.files.single.path;
                  if (filePath != null) {
                    setState(() {
                      _companyLogoController.text = filePath;
                      companyLogo = filePath;
                    });
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('No file selected')),
                  );
                }
              },
              child: const Text('Select files to upload'),
            ),
          ],
        ),
      ),
    );
  }

  //build quill editor
  Widget buildQuillEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Description',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Job' : 'Create Job',
            style: const TextStyle(fontSize: 22, color: Colors.white)),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(
            color: Colors.white), // Set back button color to white
      ),
      body: Form(
        key: _formKey,
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(), // Disable swipe
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

  // Helper function to wrap page content with navigation buttons
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
                    backgroundColor:
                        Colors.blue, // Set background color
                    foregroundColor: Colors.white, // Set text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                  ),
                  child: const Text(
                    'Back',
                    style: TextStyle(fontSize: 18), // Font size for the text
                  ),
                ),
              if (_currentPage > 0) const Spacer(), // Add space between buttons
              if (!isLastPage)
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save(); // Save current page data
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.blue, // Set background color
                    foregroundColor: Colors.white, // Set text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(fontSize: 18), // Font size for the text
                  ),
                ),
              if (isLastPage)
                ElevatedButton(
                  onPressed: () async {
                    print('Create/Update button pressed');
                    if (_formKey.currentState!.validate()) {
                      print('Form validated');
                      _formKey.currentState!.save();
                      description = jsonEncode(_descriptionController.document.toDelta().toJson());

                      if (_isEditing) {
                        print('Updating job...');
                        await _updateJob();
                      } else {
                        print('Creating job...');
                        await _createJob();
                      }
                    } else {
                      print('Form validation failed');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.blue, // Set background color
                    foregroundColor: Colors.white, // Set text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                  ),
                  child: Text(
                    _isEditing ? 'Update Job' : 'Create Job',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // Create a new job
  Future<void> _createJob() async {
  String uploadedLogoUrl = companyLogo;
  if ((companyLogoBytes != null) || (companyLogo.isNotEmpty && !companyLogo.startsWith('http'))) {
    uploadedLogoUrl = await _uploadImage();
  }

  Job newJob = Job(
    id: '',
    title: title,
    industry: industry,
    company: company,
    jobType: jobType,
    description: jsonEncode(_descriptionController.document.toDelta().toJson()),
    experienceLevel: experienceLevel,
    salaryRange: salaryRange,
    responsibilities: responsibilities,
    requirements: requirements,
    education: _originalJob?.education ?? '',
    openings: _originalJob?.openings.toString() ?? '1',
    benefits: benefits,
    requiredSkills: skills,
    preferredSkills: skills,
    location: location,
    locationType: locationType,
    email: email,
    companyLogo: uploadedLogoUrl,
    postedDate: DateTime.now().toIso8601String(),
    status: 'Open',
    userId: _originalJob?.userId ?? '', // Provide a valid userId here
    applyClickCount: 0,
  );

  try {
    String jobId = await _jobService.createJob(newJob);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Job created successfully with ID: $jobId')),
    );
    Navigator.pop(context);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error creating job: $e')),
    );
  }
}

// Update _updateJob to upload image before updating the job
Future<void> _updateJob() async {
  if (_originalJob == null) return;

  String uploadedLogoUrl = companyLogo;
  if ((companyLogoBytes != null) || (companyLogo.isNotEmpty && !companyLogo.startsWith('http'))) {
    uploadedLogoUrl = await _uploadImage();
  }

  Job updatedJob = Job(
    id: _originalJob!.id,
    title: title,
    industry: industry,
    company: company,
    jobType: jobType,
    description: description,
    experienceLevel: experienceLevel,
    salaryRange: salaryRange,
    responsibilities: responsibilities,
    education: _originalJob!.education,
    openings: _originalJob!.openings,
    requirements: requirements,
    benefits: benefits,
    requiredSkills: skills,
    preferredSkills: skills,
    location: location,
    locationType: locationType,
    email: email,
    companyLogo: uploadedLogoUrl,
    postedDate: _originalJob!.postedDate,
    status: _originalJob!.status,
    userId: _originalJob!.userId,
    applyClickCount: _originalJob!.applyClickCount,
  );

  try {
    await _jobService.updateJob(updatedJob, _originalJob!);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Job updated successfully')),
    );
    Navigator.pop(context, updatedJob);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error updating job: $e')),
    );
  }
}

  // Page 1: Job Details
  Widget _buildPage1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionTitle("Job Details",
              textStyle:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          buildTextField(
            'Job Title',
            _titleController,
            (value) => value!.isEmpty ? 'Please enter a job title' : null,
            (value) => title = value!,
            prefixIcon: Icon(Icons.work, color: Colors.blue),
          ),
          const SizedBox(height: 16),
          buildDropdown<String>(
            context: context,
            label: 'Industry',
            value: industry.isNotEmpty ? industry : 'Please select',
            items: ['Please select', 'Technical', 'Banking', 'Sales', 'HR',  'Marketing', 'Others'],
            onChanged: (value) {
              setState(() {
                industry = value!;
              });
            },
            validator: (value) => value == null || value == 'Please select'
                ? 'Please select an industry'
                : null,
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
          buildDropdown<String>(
            context: context,
            label: 'Location Type',
            value: locationType.isNotEmpty ? locationType : 'Please select',
            items: ['Please select', 'Onsite', 'Hybrid', 'Remote'],
            onChanged: (value) {
              setState(() {
                locationType = value!;
              });
            },
            validator: (value) => value == null || value == 'Please select'
                ? 'Please select a location type'
                : null,
          ),
          const SizedBox(height: 16),
          buildTextField(
            'Location',
            _locationController,
            (value) => value!.isEmpty ? 'Please enter a location' : null,
            (value) => location = value!,
            prefixIcon: Icon(Icons.location_on, color: Colors.blue),
          ),
          const SizedBox(height: 16),
          buildQuillEditor(),
        ],
      ),
    );
  }

  // Page 2: Additional Information
  Widget _buildPage2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionTitle("Additional Information",
              textStyle:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          buildTextField(
            'Job Type',
            _jobTypeController,
            (value) => value!.isEmpty ? 'Please enter a job type' : null,
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
            prefixIcon:
                Icon(Icons.check_circle_outline, color: Colors.blue),
          ),
          const SizedBox(height: 16),
          buildTextField(
            'Openings',
            _openingsController,
            null,
            (value) {
              final values = value!
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList();
              openings = values.isNotEmpty ? values.first : null;
            },
            prefixIcon:
                Icon(Icons.work, color: Colors.blue),
          ),
        ],
      ),
    );
  }

  // Page 3: Company Details and Final Submission
  Widget _buildPage3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionTitle("Company Details",
              textStyle:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
            'Skills (comma-separated)',
            _skillsController,
            null,
            (value) => skills = value!
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList(),
            prefixIcon:
                Icon(Icons.developer_mode, color: Colors.blue),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }


Widget _buildCompanyLogoPreview() {
  Widget imageWidget;

  // 1. Show immediate preview if imageBytes is set (just uploaded)
  if (imageBytes != null) {
    imageWidget = Image.memory(
      imageBytes!,
      fit: BoxFit.cover,
      width: 120,
      height: 120,
    );
  }
  // 2. Show preview from imagePath (local file or network)
  else if (imagePath.isNotEmpty) {
    if (imagePath.startsWith("http")) {
      imageWidget = Image.network(
        imagePath,
        fit: BoxFit.cover,
        width: 120,
        height: 120,
      );
    } else if (!kIsWeb) {
      imageWidget = Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        width: 120,
        height: 120,
      );
    } else {
      imageWidget = const Icon(Icons.image, size: 60, color: Colors.grey);
    }
  }
  // 3. Show from companyLogo (network or file)
  else if (companyLogo.isNotEmpty) {
    if (companyLogo.startsWith("http")) {
      imageWidget = Image.network(
        companyLogo,
        fit: BoxFit.cover,
        width: 120,
        height: 120,
      );
    } else if (kIsWeb && companyLogoBytes != null) {
      imageWidget = Image.memory(
        companyLogoBytes!,
        fit: BoxFit.cover,
        width: 120,
        height: 120,
      );
    } else if (!kIsWeb) {
      imageWidget = Image.file(
        File(companyLogo),
        fit: BoxFit.cover,
        width: 120,
        height: 120,
      );
    } else {
      imageWidget = const Icon(Icons.image, size: 60, color: Colors.grey);
    }
  }
  // 4. Default placeholder
  else {
    imageWidget = const Icon(Icons.image, size: 60, color: Colors.grey);
  }

  // Show remove button only if a logo is present
  bool showRemove = imageBytes != null ||
      imagePath.isNotEmpty ||
      companyLogo.isNotEmpty;

  return Stack(
    alignment: Alignment.center,
    children: [
      CircleAvatar(
        radius: 60,
        backgroundColor: Colors.grey[300],
        child: ClipOval(
          child: SizedBox(
            width: 120,
            height: 120,
            child: imageWidget,
          ),
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
    withData: true, // For web support.
  );
  if (result != null) {
    if (kIsWeb) {
      setState(() {
        companyLogoBytes = result.files.single.bytes;
        imageBytes = result.files.single.bytes;
        imagePath = result.files.single.name;
        companyLogo = ''; // Not needed for web preview
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

  @override
  void dispose() {
    _pageController.dispose();
    _titleController.dispose();
    _industryController.dispose();
    _companyController.dispose();
    _locationController.dispose();
    _locationTypeController.dispose();
    _jobTypeController.dispose();
    _experienceLevelController.dispose();
    _salaryRangeController.dispose();
    _responsibilitiesController.dispose();
    _requirementsController.dispose();
    _openingsController.dispose();
    _benefitsController.dispose();
    _skillsController.dispose();
    _emailController.dispose();
    _companyLogoController.dispose();
    _descriptionController.dispose();
    _editorFocusNode.dispose();
    super.dispose();
  }
}

// InputWidget Definition
class InputWidget extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final IconData? icon;
  final Widget? prefixIcon;

  const InputWidget({
    Key? key,
    required this.label,
    required this.controller,
    this.validator,
    this.onSaved,
    this.icon,
    this.prefixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: prefixIcon ?? (icon != null ? Icon(icon) : null),
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }

  // File picker for "People you can connect with".
  // Future<void> _pickConnectImage() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.image,
  //     withData: true,
  //   );
  //   if (result != null) {
  //     if (kIsWeb) {
  //       setState(() {
  //         connectImageBytes = result.files.single.bytes;
  //         connectImagePath = result.files.single.name;
  //       });
  //     } else if (result.files.single.path != null) {
  //       setState(() {
  //         connectImagePath = result.files.single.path!;
  //         connectImageBytes = null;
  //       });
  //     }
  //   }
  // }
}
