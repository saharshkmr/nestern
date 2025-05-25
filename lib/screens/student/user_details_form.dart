import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:nestern/models/user.dart';
import 'package:nestern/screens/student/profile_page.dart';
import 'package:nestern/services/user_service.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/services.dart';
import 'package:nestern/models/user.dart'; // Import AppUser class
// import 'package:nestern/theme/app_theme.dart';

class UserDetailsForm extends StatefulWidget {
  final User user;

  const UserDetailsForm({Key? key, required this.user}) : super(key: key);

  @override
  _UserDetailsFormState createState() => _UserDetailsFormState();
}

class _UserDetailsFormState extends State<UserDetailsForm> {
  final UserService _userService = UserService();
  final _formKey = GlobalKey<FormState>();

  late String name;
  late String bio;
  late String company;
  late String mobile;
  late String email;
  String countryCode = '+91'; // Default country code

  // Variables for profile image preview (local)
  File? _profileImage; // for mobile
  Uint8List? _webProfileImageBytes; // for web
  String? _selectedProfileImageName;
  // Uploaded image URL stored separately
  String? _uploadedProfileImageUrl;
  bool isImageUploading = false;
bool agreedToTerms = false;
  // Text controllers for each field
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize with values from the passed user
    name = widget.user.profileName ?? '';
    bio = widget.user.bio ?? '';
    mobile = widget.user.mobile ?? '';
    company = widget.user.company ?? '';
    email = widget.user.email ?? '';

    _nameController.text = name;
    _mobileController.text = mobile;
    _bioController.text = bio;
    _companyController.text = company;
    _emailController.text = email;

    // Set the uploaded URL if already available.
    _uploadedProfileImageUrl = widget.user.url;
  }

  /// Pick profile image using file_picker.
  /// The chosen image is stored as a local preview and remains until the user selects edit.
  Future<void> _pickProfileImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      setState(() {
        // Clear the previous uploaded URL so that we show the local preview.
        _uploadedProfileImageUrl = null;
      });
      if (result.files.single.bytes != null) {
        // For web
        setState(() {
          _webProfileImageBytes = result.files.single.bytes;
          _selectedProfileImageName = result.files.single.name;
          _profileImage = null; // Clear mobile file if any.
        });
      } else if (result.files.single.path != null) {
        // For mobile
        setState(() {
          _profileImage = File(result.files.single.path!);
        });
      }
      // Note: We do not automatically upload here so that the preview remains intact.
    } else {
      // No file selected.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No image selected.')),
      );
    }
  }

  /// Upload the selected profile image and update the uploaded URL.
  /// This method is called only when the user taps "Save and Continue".
  Future<String?> _uploadProfileImageIfNeeded() async {
    // Check if a new local image is selected.
    if ((kIsWeb && _webProfileImageBytes != null) ||
        (!kIsWeb && _profileImage != null)) {
      setState(() => isImageUploading = true);
      try {
        String url;
        if (kIsWeb) {
          final fileName = _selectedProfileImageName ?? "profile.jpg";
          url = (await _userService.uploadProfileImageFromBytes(
              widget.user.id, _webProfileImageBytes!, fileName))!;
        } else {
          url = (await _userService.uploadProfileImage(
              widget.user.id, _profileImage!))!;
        }
        return url;
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading image: $e')),
        );
      } finally {
        setState(() => isImageUploading = false);
      }
    }
    return _uploadedProfileImageUrl;
  }

  /// Helper widget to create a decorated field with a label.
  Widget buildDecoratedField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required FormFieldSetter<String> onSaved,
    FormFieldValidator<String>? validator,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Using theme's text style for titles
        Text(label,
            style:
                Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20)),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
            ),
            onSaved: onSaved,
            validator: validator,
            maxLines: maxLines,
          ),
        ),
      ],
    );
  }

  /// Mobile field with country code picker.
  Widget buildMobileField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Mobile',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Row(
          children: [
            CountryCodePicker(
              onChanged: (country) {
                setState(() {
                  countryCode = country.dialCode!;
                });
              },
              initialSelection: 'IN',
              favorite: const ['+91', 'IN'],
              showCountryOnly: false,
              showOnlyCountryWhenClosed: false,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: TextFormField(
                  controller: _mobileController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    hintText: 'Enter your mobile number',
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your mobile number';
                    } else if (!RegExp(r'^\d+$').hasMatch(value)) {
                      return 'Mobile number can only contain digits';
                    }
                    return null;
                  },
                  onSaved: (value) => mobile = value!,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Custom button widget for consistent styling.
Widget buildButton(VoidCallback onPressedMethod,
    {String? text, ButtonStyle? style, bool enabled = true}) {
  return ElevatedButton(
    style: style ??
        ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          minimumSize: const Size(double.infinity, 50),
        ),
    onPressed: enabled ? onPressedMethod : null,
    child: Text(
      text ?? "Submit",
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: 16,
            color: Colors.white,
          ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    // Determine the current preview image:
    ImageProvider currentImage;
    if (kIsWeb && _webProfileImageBytes != null) {
      currentImage = MemoryImage(_webProfileImageBytes!);
    } else if (!kIsWeb && _profileImage != null) {
      currentImage = FileImage(_profileImage!);
    } else if (_uploadedProfileImageUrl != null &&
        _uploadedProfileImageUrl!.isNotEmpty) {
      currentImage = NetworkImage(_uploadedProfileImageUrl!);
    } else {
      currentImage = const AssetImage('assets/default_profile.png');
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(
            color: Colors.white), // Set back button color to white
        title: Text('Complete Your Profile',
            style: TextStyle(fontSize: 22, color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile Image with edit option overlay
              Center(
                child: GestureDetector(
                  onTap: _pickProfileImage,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: currentImage,
                      ),
                      if (isImageUploading)
                        Positioned.fill(
                          child: Container(
                            color: Colors.black,
                            child: const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              ),
                            ),
                          ),
                        ),
                      // Edit icon overlay
                      const Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.white,
                          child:
                              Icon(Icons.edit, size: 15, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Name field
              buildDecoratedField(
                label: 'Name',
                hint: 'Enter your name',
                controller: _nameController,
                onSaved: (value) => name = value!,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter your name' : null,
              ),
              const SizedBox(height: 20),
              // Company field
              buildDecoratedField(
                label: 'Company Name',
                hint: 'Enter your company',
                controller: _companyController,
                onSaved: (value) => company = value!,
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter your company name'
                    : null,
              ),
              const SizedBox(height: 20),
              // Email field
              buildDecoratedField(
                label: 'Email',
                hint: 'Enter your email',
                controller: _emailController,
                onSaved: (value) => email = value!,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter your email' : null,
              ),
              const SizedBox(height: 20),
              // ...inside your Column in the Form...
              Row(
                children: [
                  Checkbox(
                    value: agreedToTerms,
                    onChanged: (value) {
                      setState(() {
                        agreedToTerms = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          agreedToTerms = !agreedToTerms;
                        });
                      },
                      child: Text(
                        "I agree to the Terms & Conditions",
                        style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Mobile field with country code picker
              buildMobileField(),
              const SizedBox(height: 20),
              // Bio field
              buildDecoratedField(
                label: 'Bio',
                hint: 'Enter your bio',
                controller: _bioController,
                onSaved: (value) => bio = value!,
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              // Save and Continue button
              buildButton(
                () async {
                  print('Save and Continue button pressed');
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    print('Form saved');
                    // If a new local image has been chosen, upload it now.
                    String? profileImageUrl = await _uploadProfileImageIfNeeded();
                    // Prepare the updated user data.
                    User updatedUser = widget.user.copyWith(
                      profileName: name,
                      bio: bio,
                      company: company,
                      // Use the uploaded URL if available; otherwise, fallback to existing URL.
                      url: profileImageUrl ?? widget.user.url,
                      mobile: '$countryCode$mobile',
                      email: email,
                      isProfileComplete: true,
                    );
                  try {
                    await _userService.updateUser(updatedUser);
                    print('User updated in Firestore');
                    // Redirect to ProfilePage after successful save
                    if (mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage(user: updatedUser)),
                      );
                    }
                  } catch (e) {
                    print('Error updating user: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error saving profile. Please try again.'),
                      ),
                    );
                  }
                  } else {
                    print('Form is not valid');
                  }
                },
                text: 'Save and Continue',
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Set the background color
                  foregroundColor: Colors.white, // Set the text color
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
