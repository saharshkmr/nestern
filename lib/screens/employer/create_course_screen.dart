import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:nestern/models/course.dart';
import 'package:nestern/models/user.dart';
import 'package:nestern/screens/employer/add_topic_screen.dart';
import 'package:nestern/services/course_service.dart';
import 'package:nestern/services/user_service.dart';
import 'package:nestern/services/location_service.dart';
import 'package:nestern/widgets/dropdown_widget.dart';
import 'package:nestern/widgets/input_widget.dart';
// import 'package:nestern/theme/app_theme.dart';

class CreateCourseScreen extends StatefulWidget {
  final User user;
  final Course? course;

  const CreateCourseScreen({Key? key, required this.user, this.course})
      : super(key: key);

  @override
  _CreateCourseScreenState createState() => _CreateCourseScreenState();
}

class _CreateCourseScreenState extends State<CreateCourseScreen> {
  quill.QuillController _descriptionController = quill.QuillController.basic();

  final CourseService _courseService = CourseService();
  final UserService _userService = UserService();
  final LocationService _locationService = LocationService();
  final _formKey = GlobalKey<FormState>();

  // Fields and controllers as per nestern file
  String title = '';
  String description = '';
  String duration = '';
  double price = 0.0;
  String imagePath = '';
  Uint8List? imageBytes;
  List<String> skills = [];
  DateTime? startDate;
  DateTime? endDate;
  bool _addTopic = false;

  String selectedCategory = 'Select Category';
  String selectedLevel = 'Select Level';
  String selectedStatus = 'Select Status';

  String selectedCourseMode = 'Online';
  final List<String> courseModes = ['Online', 'Offline', 'Hybrid'];

  String selectedLocation = '';
  List<String> availableLocations = [];
  bool isCustomLocation = false;
  final TextEditingController _locationController = TextEditingController();

  bool get canCreateMultipleCourses => true;

  final List<String> categories = [
    'Select Category',
    'Programming',
    'Data Science',
    'AI/ML',
    'Cybersecurity',
    'Business'
  ];
  final List<String> levels = [
    'Select Level',
    'Beginner',
    'Intermediate',
    'Advanced'
  ];
  final List<String> statuses = [
    'Select Status',
    'Active',
    'Inactive',
    'Upcoming'
  ];

  String selectedTeachingMode = 'Self-paced';
  final List<String> teachingModes = ['Self-paced', 'Instructor-led'];
  DateTime? createdAt;
  DateTime? updatedAt;
  final TextEditingController _companyProfileController = TextEditingController();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _instructorNameController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _skillController = TextEditingController();

  final TextEditingController _connectNameController = TextEditingController();
  final TextEditingController _connectExperienceController = TextEditingController();
  final TextEditingController _connectDescriptionController = TextEditingController();
  final TextEditingController _teachingNameController = TextEditingController();
  final TextEditingController _teachingExperienceController = TextEditingController();
  final TextEditingController _teachingDescriptionController = TextEditingController();

  String? _courseId;

  Uint8List? connectImageBytes;
  String connectImagePath = '';
  Uint8List? teachingImageBytes;
  String teachingImagePath = '';

  int _currentPage = 0;
  final PageController _pageController = PageController();

  bool _isLoading = true;

  String _getMostRecentExperience(List<String>? experiences) {
    if (experiences != null && experiences.isNotEmpty) {
      return experiences.first;
    }
    return "No experience specified";
  }

  Widget buildDecoratedTextField({
    required String label,
    required TextEditingController controller,
    String? hintText,
    IconData? icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
        border: const OutlineInputBorder(),
      ),
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
          imageBytes = result.files.single.bytes;
          imagePath = result.files.single.name;
        });
      } else if (result.files.single.path != null) {
        setState(() {
          imagePath = result.files.single.path!;
          imageBytes = null;
        });
      }
    }
  }

  Future<void> _pickConnectImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result != null) {
      if (kIsWeb) {
        setState(() {
          connectImageBytes = result.files.single.bytes;
          connectImagePath = result.files.single.name;
        });
      } else if (result.files.single.path != null) {
        setState(() {
          connectImagePath = result.files.single.path!;
          connectImageBytes = null;
        });
      }
    }
  }

  Future<void> _pickTeachingImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result != null) {
      if (kIsWeb) {
        setState(() {
          teachingImageBytes = result.files.single.bytes;
          teachingImagePath = result.files.single.name;
        });
      } else if (result.files.single.path != null) {
        setState(() {
          teachingImagePath = result.files.single.path!;
          teachingImageBytes = null;
        });
      }
    }
  }

  Future<void> _pickDate(BuildContext context, bool isStartDate) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  Future<void> _pickCreatedAt(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: createdAt ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        createdAt = picked;
      });
    }
  }

  Future<void> _pickUpdatedAt(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: updatedAt ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        updatedAt = picked;
      });
    }
  }

  Future<void> _fetchLocations() async {
    try {
      final locations = await _locationService.getLocations();
      setState(() {
        availableLocations = ['Select Location', ...locations];
        if (selectedLocation.isEmpty) {
          selectedLocation = 'Select Location';
        }
      });
    } catch (e) {
      setState(() {
        availableLocations = [
          'Select Location',
          'DevelUp COE, Peenya',
          'TechHub, Whitefield',
          'Innovation Center, Electronic City',
          'Learning Center, Koramangala'
        ];
        if (selectedLocation.isEmpty) {
          selectedLocation = 'Select Location';
        }
      });
    }
  }

  Future<void> _addNewLocation(String location) async {
    if (location.isEmpty) return;
    try {
      await _locationService.addLocation(location);
      setState(() {
        if (!availableLocations.contains(location)) {
          availableLocations.add(location);
        }
        selectedLocation = location;
        isCustomLocation = false;
        _locationController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location "$location" added successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add location: $e')),
      );
    }
  }

  void _populateFields() async {
    if (widget.course != null) {
      Course course = widget.course!;
      _courseId = course.id;
      _titleController.text = course.title;

      if (course.description.isNotEmpty) {
        final delta = jsonDecode(course.description);
        final doc = quill.Document.fromJson(delta);
        _descriptionController = quill.QuillController(
          document: doc,
          selection: const TextSelection.collapsed(offset: 0),
        );
        description = course.description;
      }

      _instructorNameController.text = course.instructorName;
      _durationController.text = course.duration;
      _priceController.text = course.price.toString();
      _skillController.text = course.skill.join(', ');
      selectedCategory = course.category.isNotEmpty
          ? course.category.first
          : 'Select Category';
      selectedLevel = course.level;
      selectedStatus = course.status;

      if (courseModes.contains(course.courseMode)) {
        selectedCourseMode = course.courseMode;
      }
      if (course.location.isNotEmpty) {
        selectedLocation = course.location;
      }
      selectedTeachingMode = course.teachingMode;
      startDate = course.startDate;
      endDate = course.endDate;
      createdAt = course.createdAt;
      updatedAt = course.updatedAt;
      imagePath = course.url;
      _companyProfileController.text = course.companyProfile;

      List<String> connectParts = course.connectWith.split('(Image:');
      if (connectParts.length >= 2) {
        List<String> detailParts = connectParts[0].split('-');
        if (detailParts.length >= 1) {
          _connectNameController.text = detailParts[0].trim();
        }
        if (detailParts.length >= 2) {
          _connectExperienceController.text = detailParts[1].trim();
        }
        if (detailParts.length >= 3) {
          _connectDescriptionController.text = detailParts[2].trim();
        }
        connectImagePath = connectParts[1].replaceAll(')', '').trim();
      } else {
        _connectNameController.text = widget.user.profileName;
      }

      List<String> teachingParts = course.teachingTeam.split('(Image:');
      if (teachingParts.length >= 2) {
        List<String> detailParts = teachingParts[0].split('-');
        if (detailParts.length >= 1) {
          _teachingNameController.text = detailParts[0].trim();
        }
        if (detailParts.length >= 2) {
          _teachingExperienceController.text = detailParts[1].trim();
        }
        if (detailParts.length >= 3) {
          _teachingDescriptionController.text = detailParts[2].trim();
        }
        teachingImagePath = teachingParts[1].replaceAll(')', '').trim();
      } else {
        _teachingNameController.text = widget.user.profileName;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchLocations();
    if (widget.course != null) {
      _populateFields();
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<String> _uploadImage() async {
    if ((imageBytes != null) || (imagePath.isNotEmpty)) {
      String fileName = "${DateTime.now().millisecondsSinceEpoch}_" +
          (kIsWeb ? imagePath : imagePath.split('/').last);
      Reference storageRef =
          FirebaseStorage.instance.ref().child("courseImages/$fileName");
      UploadTask uploadTask;
      if (kIsWeb && imageBytes != null) {
        uploadTask = storageRef.putData(imageBytes!);
      } else {
        File file = File(imagePath);
        uploadTask = storageRef.putFile(file);
      }
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    }
    return "";
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      try {
        if (!_addTopic && widget.course == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('You must add a topic to create a course')),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }

        if (_instructorNameController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter the instructor name')),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }

        String locationValue = '';
        if (isCustomLocation && _locationController.text.isNotEmpty) {
          locationValue = _locationController.text;
        } else if (selectedLocation != 'Select Location') {
          locationValue = selectedLocation;
        }

        if (locationValue.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select or enter a location')),
          );
          setState(() {
            _isLoading = false;
          });
          return;
        }

        String connectName = _connectNameController.text.isNotEmpty
            ? _connectNameController.text
            : widget.user.profileName;
        String connectExperience = _connectExperienceController.text.isNotEmpty
            ? _connectExperienceController.text
            : _getMostRecentExperience(widget.user.experiences);
        String connectDescription = _connectDescriptionController.text;

        String teachingName = _teachingNameController.text.isNotEmpty
            ? _teachingNameController.text
            : widget.user.profileName;
        String teachingExperience =
            _teachingExperienceController.text.isNotEmpty
                ? _teachingExperienceController.text
                : _getMostRecentExperience(widget.user.experiences);
        String teachingDescription = _teachingDescriptionController.text;

        String connectWithValue =
            "$connectName - $connectExperience - $connectDescription (Image: $connectImagePath)";
        String teachingTeamValue =
            "$teachingName - $teachingExperience - $teachingDescription (Image: $teachingImagePath)";

        String imageUrl = "";
        if ((imageBytes != null) || (imagePath.isNotEmpty)) {
          imageUrl = await _uploadImage();
        }

        Course newCourse = Course(
          id: _courseId ?? '',
          title: _titleController.text,
          description:
              jsonEncode(_descriptionController.document.toDelta().toJson()),
          category: [selectedCategory],
          skill: _skillController.text.split(',').map((s) => s.trim()).toList(),
          instructorName: _instructorNameController.text,
          instructorUrl: '',
          topics: widget.course != null ? widget.course!.topics : [],
          duration: _durationController.text,
          level: selectedLevel,
          location: locationValue,
          mode: selectedCourseMode,
          price: double.tryParse(_priceController.text) ?? 0.0,
          url: imageUrl,
          status: selectedStatus,
          startDate: startDate,
          endDate: endDate,
          createrId: widget.user.id,
          userId: '',
          courseMode: selectedCourseMode,
          teachingMode: selectedTeachingMode,
          createdAt: createdAt,
          updatedAt: updatedAt,
          accessDevices: [],
          certificatePlatforms: [],
          companyProfile: _companyProfileController.text,
          backgroundFit: '',
          tailorLearningPlan: '',
          goodFit: '',
          connectWith: connectWithValue,
          teachingTeam: teachingTeamValue,
          profileName: widget.user.profileName,
          imageUrl: imageUrl,
          uid: widget.user.id,
        );

        if (_courseId == null) {
          _courseId = await _courseService.createCourse(newCourse);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Course created successfully')),
          );

          if (_addTopic) {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTopicScreen(courseId: _courseId!),
              ),
            );
          }
          Navigator.pop(context);
        } else {
          await _courseService.updateCourse(newCourse, newCourse);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Course updated successfully')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating/updating course: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

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

  Widget _buildDateField(String label, DateTime? date, VoidCallback onTap) {
    final text = date == null ? '' : "${date.toLocal()}".split(' ')[0];
    return GestureDetector(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        child: Text(text),
      ),
    );
  }

  Widget _buildGrid(List<Widget> children) {
    return Wrap(
      spacing: 15,
      runSpacing: 15,
      children: children
          .map((e) => Container(
                width: MediaQuery.of(context).size.width * 0.5 - 30,
                padding: const EdgeInsets.all(8.0),
                child: e,
              ))
          .toList(),
    );
  }

  Widget _buildCourseImagePreview() {
    if (imageBytes != null) {
      return Image.memory(
        imageBytes!,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else if (imagePath.isNotEmpty) {
      if (imagePath.startsWith("http")) {
        return Image.network(
          imagePath,
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
        );
      } else if (!kIsWeb) {
        return Image.file(
          File(imagePath),
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
        );
      }
    }
    return Container(
      height: 200,
      color: Colors.grey[300],
      child: const Center(child: Text('No image selected')),
    );
  }

  Widget _buildLocationSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isCustomLocation)
          buildDropdown<String>(
            context: context,
            label: "Location",
            value: selectedLocation,
            items: availableLocations,
            onChanged: (value) {
              setState(() {
                if (value == 'Add New Location') {
                  isCustomLocation = true;
                  _locationController.clear();
                } else {
                  selectedLocation = value!;
                }
              });
            },
            validator: (value) => value == null || value == 'Select Location'
                ? 'Please select a location'
                : null,
          ),
        if (!isCustomLocation)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  isCustomLocation = true;
                  _locationController.clear();
                });
              },
              icon: const Icon(Icons.add),
              label: const Text('Add New Location'),
            ),
          ),
        if (isCustomLocation)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextField(
                context,
                'Enter New Location',
                _locationController,
                (value) => value!.isEmpty ? 'Please enter a location' : null,
                (value) {},
                icon: Icons.location_on,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isCustomLocation = false;
                      });
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_locationController.text.isNotEmpty) {
                        _addNewLocation(_locationController.text);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please enter a location')),
                        );
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildPage1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionTitle("Course Details",
              textStyle:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          buildTextField(
            context,
            'Course Title',
            _titleController,
            (value) => value!.isEmpty ? 'Please enter a course title' : null,
            (value) => title = value!,
            icon: Icons.title,
          ),
          const SizedBox(height: 16),
          buildQuillEditor(),
          const SizedBox(height: 16),
          _sectionTitle("Instructor Information",
              textStyle:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          buildTextField(
            context,
            'Instructor Name',
            _instructorNameController,
            (value) =>
                value!.isEmpty ? 'Please enter the instructor name' : null,
            (value) {},
            icon: Icons.person,
          ),
          const SizedBox(height: 16),
          _sectionTitle("Course Image",
              textStyle:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          _buildCourseImagePreview(),
          TextButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.image),
            label: const Text('Pick Image from Gallery'),
          ),
        ],
      ),
    );
  }

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

  Widget _buildPage2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionTitle("Course Information",
              textStyle:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          buildDropdown<String>(
            context: context,
            label: "Category",
            value: selectedCategory,
            items: categories,
            onChanged: (value) {
              setState(() {
                selectedCategory = value!;
              });
            },
            validator: (value) => value == null || value == 'Select Category'
                ? 'Please select a category'
                : null,
          ),
          const SizedBox(height: 16),
          buildTextField(
            context,
            'Skills (comma-separated)',
            _skillController,
            null,
            (value) => skills = value!.split(',').map((s) => s.trim()).toList(),
            icon: Icons.list,
          ),
          const SizedBox(height: 16),
          buildTextField(
            context,
            'Duration',
            _durationController,
            (value) =>
                value!.isEmpty ? 'Please enter the course duration' : null,
            (value) => duration = value!,
            icon: Icons.timelapse,
            isNumeric: true,
          ),
          const SizedBox(height: 16),
          buildDropdown<String>(
            context: context,
            label: "Level",
            value: selectedLevel,
            items: levels,
            onChanged: (value) {
              setState(() {
                selectedLevel = value!;
              });
            },
            validator: (value) => value == null || value == 'Select Level'
                ? 'Please select a level'
                : null,
          ),
          const SizedBox(height: 16),
          _sectionTitle("Course Mode & Location",
              textStyle:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          buildDropdown<String>(
            context: context,
            label: "Course Mode",
            value: selectedCourseMode,
            items: courseModes,
            onChanged: (value) {
              setState(() {
                selectedCourseMode = value!;
              });
            },
            validator: (value) =>
                value == null ? 'Please select a course mode' : null,
          ),
          const SizedBox(height: 16),
          _buildLocationSelector(),
          const SizedBox(height: 16),
          _sectionTitle("Pricing & Availability",
              textStyle:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          buildTextField(
            context,
            'Price',
            _priceController,
            (value) => value!.isEmpty ? 'Please enter the course price' : null,
            (value) => price = double.tryParse(value!) ?? 0.0,
            isNumeric: true,
            icon: Icons.attach_money,
          ),
          const SizedBox(height: 16),
          _buildGrid([
            _buildDateField(
                "Start Date", startDate, () => _pickDate(context, true)),
            _buildDateField(
                "End Date", endDate, () => _pickDate(context, false)),
          ]),
          const SizedBox(height: 16),
          buildDropdown<String>(
            context: context,
            label: "Status",
            value: selectedStatus,
            items: statuses,
            onChanged: (value) {
              setState(() {
                selectedStatus = value!;
              });
            },
            validator: (value) => value == null || value == 'Select Status'
                ? 'Please select a status'
                : null,
          ),
          const SizedBox(height: 16),
          buildDropdown<String>(
            context: context,
            label: "Teaching Mode",
            value: selectedTeachingMode,
            items: teachingModes,
            onChanged: (value) {
              setState(() {
                selectedTeachingMode = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPage3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sectionTitle("Additional Course Information",
              textStyle:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          _buildGrid([
            _buildDateField(
                "Created At", createdAt, () => _pickCreatedAt(context)),
            _buildDateField(
                "Updated At", updatedAt, () => _pickUpdatedAt(context)),
          ]),
          const SizedBox(height: 16),
          buildTextField(
            context,
            'Company Profile',
            _companyProfileController,
            null,
            (value) {},
            icon: Icons.business,
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          _sectionTitle("People you can connect with",
              textStyle:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: connectImageBytes != null
                    ? MemoryImage(connectImageBytes!)
                    : (connectImagePath.isNotEmpty &&
                            connectImagePath.startsWith("http")
                        ? NetworkImage(connectImagePath) as ImageProvider
                        : null),
                child: (connectImageBytes == null &&
                        (connectImagePath.isEmpty ||
                            !connectImagePath.startsWith("http")))
                    ? const Icon(Icons.person)
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildDecoratedTextField(
                      label: 'Name',
                      controller: _connectNameController,
                      hintText: widget.user.profileName,
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 8),
                    buildDecoratedTextField(
                      label: 'Experience Role',
                      controller: _connectExperienceController,
                      hintText:
                          _getMostRecentExperience(widget.user.experiences),
                      icon: Icons.work,
                    ),
                    const SizedBox(height: 8),
                    buildDecoratedTextField(
                      label: 'Description',
                      controller: _connectDescriptionController,
                      hintText: 'Enter a description about this person',
                      icon: Icons.description,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.image),
                onPressed: _pickConnectImage,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _sectionTitle("Meet the teaching team",
              textStyle:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: teachingImageBytes != null
                    ? MemoryImage(teachingImageBytes!)
                    : (teachingImagePath.isNotEmpty &&
                            teachingImagePath.startsWith("http")
                        ? NetworkImage(teachingImagePath) as ImageProvider
                        : null),
                child: (teachingImageBytes == null &&
                        (teachingImagePath.isEmpty ||
                            !teachingImagePath.startsWith("http")))
                    ? const Icon(Icons.person)
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildDecoratedTextField(
                      label: 'Name',
                      controller: _teachingNameController,
                      hintText: widget.user.profileName,
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 8),
                    buildDecoratedTextField(
                      label: 'Experience Role',
                      controller: _teachingExperienceController,
                      hintText:
                          _getMostRecentExperience(widget.user.experiences),
                      icon: Icons.work,
                    ),
                    const SizedBox(height: 8),
                    buildDecoratedTextField(
                      label: 'Description',
                      controller: _teachingDescriptionController,
                      hintText: 'Enter a description about this teacher',
                      icon: Icons.description,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.image),
                onPressed: _pickTeachingImage,
              ),
            ],
          ),
          const SizedBox(height: 24),
          CheckboxListTile(
            title: const Text("Add Topic"),
            value: _addTopic,
            onChanged: (bool? value) {
              setState(() {
                _addTopic = value ?? false;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPageWithButtons(Widget pageContent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: pageContent,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentPage > 0)
                ElevatedButton(
                  onPressed: () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Back',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              if (_currentPage < 2)
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
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
                  child: const Text(
                    'Next',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              if (_currentPage == 2)
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Create Course',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course != null ? 'Edit Course' : 'Create Course',
            style: const TextStyle(fontSize: 22)),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
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
                  _buildPageWithButtons(_buildPage3()),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _instructorNameController.dispose();
    _durationController.dispose();
    _priceController.dispose();
    _skillController.dispose();
    _locationController.dispose();
    _companyProfileController.dispose();
    _connectNameController.dispose();
    _connectExperienceController.dispose();
    _connectDescriptionController.dispose();
    _teachingNameController.dispose();
    _teachingExperienceController.dispose();
    _teachingDescriptionController.dispose();
    super.dispose();
  }
}