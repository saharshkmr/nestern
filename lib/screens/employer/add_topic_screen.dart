import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:open_file/open_file.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:nestern/models/topic.dart';
import 'package:nestern/models/user.dart';
import 'package:nestern/services/auth_service.dart';
import 'package:nestern/services/course_service.dart';
import 'package:nestern/widgets/input_widget.dart';
// import 'package:nestern/theme/app_theme.dart';
import 'package:nestern/widgets/video_helper.dart'; // Import the video helper for web

class AddTopicScreen extends StatefulWidget {
  final String courseId;
  final Topic? topic;

  const AddTopicScreen({Key? key, required this.courseId, this.topic})
      : super(key: key);

  @override
  _AddTopicScreenState createState() => _AddTopicScreenState();
}

class _AddTopicScreenState extends State<AddTopicScreen> {
  final CourseService _courseService = CourseService();
  final _formKey = GlobalKey<FormState>();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  String description = '';
  // Controllers for text fields
  final _nameController = TextEditingController();
  final _titleController = TextEditingController();
  // final _descriptionController = TextEditingController();
  quill.QuillController _descriptionController = quill.QuillController.basic();

  final _instructorController = TextEditingController();
  final _cityController = TextEditingController();

  // Dynamic question controllers
  final List<TextEditingController> _questionControllers = [
    TextEditingController()
  ];
  final List<String> _questions = [""];

  // Image picking
  XFile? _pickedImage;
  Uint8List? _imageBytes;
  String? _imageUrl; // Store the Firebase Storage URL
  bool _isUploadingImage = false;

  // Video picking
  XFile? _pickedVideo;
  Uint8List? _videoBytes;
  VideoPlayerController? _videoController;
  String? _videoUrl; // Store the Firebase Storage URL
  bool _isUploadingVideo = false;

  // Document picking
  PlatformFile? _pickedDocument;
  String? _documentUrl; // Store the Firebase Storage URL
  String? _documentName; // Store the document name
  bool _isUploadingDocument = false;

  bool _isDescriptionExpanded = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // If editing an existing topic, populate the form fields
    if (widget.topic != null) {
      print("Editing existing topic: ${widget.topic!.id}");
      print(
        "Topic data: title=${widget.topic!.title}, video=${widget.topic!.studyVideoUrl}, doc=${widget.topic!.attachment}",
      );

      _nameController.text = widget.topic!.name;
      _titleController.text = widget.topic!.title;
      // _descriptionController.text = widget.topic!.description;
      _instructorController.text = widget.topic!.instructor;

      if (widget.topic!.description.isNotEmpty) {
        try {
          final delta = jsonDecode(widget.topic!.description);
          final doc = quill.Document.fromJson(delta);
          _descriptionController = quill.QuillController(
            document: doc,
            selection: const TextSelection.collapsed(offset: 0),
          );
        } catch (e) {
          final doc = quill.Document()..insert(0, widget.topic!.description);
          _descriptionController = quill.QuillController(
            document: doc,
            selection: const TextSelection.collapsed(offset: 0),
          );
        }
        description = widget.topic!.description;
      }

      // Initialize image if available
      if (widget.topic!.imageUrl != null &&
          widget.topic!.imageUrl!.isNotEmpty) {
        _imageUrl = widget.topic!.imageUrl;
        print("Initializing existing image: $_imageUrl");
      }

      // Initialize video if available
      if (widget.topic!.studyVideoUrl != null &&
          widget.topic!.studyVideoUrl!.isNotEmpty) {
        _videoUrl = widget.topic!.studyVideoUrl;
        print("Initializing existing video: $_videoUrl");
        _initializeExistingVideo(widget.topic!.studyVideoUrl!);
      }

      // Initialize document if available
      if (widget.topic!.attachment != null &&
          widget.topic!.attachment!.isNotEmpty) {
        print("Initializing existing document: ${widget.topic!.attachment}");
        final parts = widget.topic!.attachment!.split('|');
        if (parts.length > 1) {
          _documentUrl = parts[0];
          _documentName = parts[1];
        } else {
          _documentUrl = widget.topic!.attachment;
          _documentName = 'Document';
        }
      }

      // Initialize questions
      if (widget.topic!.question.isNotEmpty) {
        _questions.clear();
        _questionControllers.clear();

        for (var question in widget.topic!.question) {
          _questions.add(question);
          _questionControllers.add(TextEditingController(text: question));
        }
      }

      // Set description expanded if it has content
      if (widget.topic!.description.isNotEmpty) {
        _isDescriptionExpanded = true;
      }
    }
  }

  Future<void> _initializeExistingVideo(String videoUrl) async {
    try {
      _videoController = VideoPlayerController.network(videoUrl);
      await _videoController!.initialize();
      _videoController!.setLooping(true);
      setState(() {
        // Create a dummy XFile to indicate we have a video
        _pickedVideo = XFile(videoUrl);
      });
    } catch (e) {
      print('Error initializing existing video: $e');
    }
  }

  // Image picking methods
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      if (kIsWeb) {
        final bytes = await picked.readAsBytes();
        setState(() {
          _pickedImage = picked;
          _imageBytes = bytes;
          _imageUrl = null; // Reset the stored URL since we have a new image
        });
      } else {
        setState(() {
          _pickedImage = picked;
          _imageUrl = null; // Reset the stored URL since we have a new image
        });
      }
    }
  }

  Future<void> _clearImage() async {
    setState(() {
      _pickedImage = null;
      _imageBytes = null;
      _imageUrl = null;
    });
  }

  Future<void> _previewImage() async {
    if (_pickedImage == null && _imageUrl == null) return;

    if (_imageUrl != null) {
      // Preview the stored image
      showDialog(
        context: context,
        builder: (_) => Dialog(
          child: Image.network(_imageUrl!, fit: BoxFit.cover),
        ),
      );
    } else if (_pickedImage != null) {
      // Preview the picked image
      showDialog(
        context: context,
        builder: (_) => Dialog(
          child: kIsWeb
              ? Image.memory(_imageBytes!, fit: BoxFit.cover)
              : Image.file(File(_pickedImage!.path), fit: BoxFit.cover),
        ),
      );
    }
  }

  // Video picking methods
  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickVideo(source: ImageSource.gallery);
    if (picked != null) {
      if (_videoController != null) {
        await _videoController!.dispose();
      }
      if (kIsWeb) {
        final bytes = await picked.readAsBytes();
        _videoController = VideoPlayerController.network(
          createObjectUrl(bytes),
        );
        _videoBytes = bytes;
      } else {
        _videoController = VideoPlayerController.file(File(picked.path));
      }
      await _videoController!.initialize();
      _videoController!.setLooping(true);
      setState(() {
        _pickedVideo = picked;
        _videoUrl = null; // Reset the stored URL since we have a new video
      });
      _videoController!.play();
    }
  }

  Future<void> _clearVideo() async {
    if (_videoController != null) {
      await _videoController!.dispose();
    }
    setState(() {
      _pickedVideo = null;
      _videoBytes = null;
      _videoController = null;
      _videoUrl = null;
    });
  }

  Future<void> _previewVideo() async {
    if ((_pickedVideo == null && _videoUrl == null) ||
        (_videoController == null) ||
        !_videoController!.value.isInitialized) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: AspectRatio(
            aspectRatio: _videoController!.value.aspectRatio,
            child: VideoPlayer(_videoController!),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _videoController!.pause();
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            )
          ],
        );
      },
    );
  }

  // Document picking methods
  Future<void> _pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _pickedDocument = result.files.first;
        _documentUrl =
            null; // Reset the stored URL since we have a new document
        _documentName = _pickedDocument!.name;
      });
    }
  }

  Future<void> _clearDocument() async {
    setState(() {
      _pickedDocument = null;
      _documentUrl = null;
      _documentName = null;
    });
  }

  Future<void> _previewDocument() async {
    if (_pickedDocument != null && _pickedDocument!.path != null) {
      if (kIsWeb) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Preview not supported on web')),
        );
      } else {
        OpenFile.open(_pickedDocument!.path);
      }
    } else if (_documentUrl != null) {
      // Open the document URL in a browser
      if (await canLaunch(_documentUrl!)) {
        await launch(_documentUrl!);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open document')),
        );
      }
    }
  }

  Future<void> _downloadDocument() async {
    // If the user just picked a local file…
    if (_pickedDocument != null && _pickedDocument!.path != null) {
      if (kIsWeb) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Download not supported on web')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Starting download...')),
        );
        OpenFile.open(_pickedDocument!.path!);
      }
    }
    // Otherwise, if we have a stored URL, just launch it everywhere
    else if (_documentUrl != null) {
      final url = _documentUrl!;
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not download document')),
        );
      }
    }
  }

  void _clearForm() {
    _nameController.clear();
    _titleController.clear();
    _descriptionController.clear();
    _instructorController.clear();
    _cityController.clear();
    for (var ctrl in _questionControllers) {
      ctrl.clear();
    }
    _questions
      ..clear()
      ..add("");
    _clearImage();
    _clearVideo();
    _clearDocument();
    setState(() => _isDescriptionExpanded = false);
  }

  // Upload image to Firebase Storage
  Future<String?> _uploadImage() async {
    if (_pickedImage == null)
      return _imageUrl; // Return existing URL if no new image

    setState(() => _isUploadingImage = true);

    try {
      final fileName = path.basename(_pickedImage!.path);
      final destination =
          'topics/${widget.courseId}/images/${DateTime.now().millisecondsSinceEpoch}_$fileName';

      UploadTask? uploadTask;

      if (kIsWeb) {
        // Web upload
        if (_imageBytes != null) {
          uploadTask = _storage.ref(destination).putData(_imageBytes!);
        }
      } else {
        // Mobile upload
        final file = File(_pickedImage!.path);
        uploadTask = _storage.ref(destination).putFile(file);
      }

      if (uploadTask == null) return null;

      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() => _isUploadingImage = false);
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      setState(() => _isUploadingImage = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
      return null;
    }
  }

  // Upload video to Firebase Storage
  Future<String?> _uploadVideo() async {
    if (_pickedVideo == null)
      return _videoUrl; // Return existing URL if no new video

    setState(() => _isUploadingVideo = true);

    try {
      final fileName = path.basename(_pickedVideo!.path);
      final destination =
          'topics/${widget.courseId}/videos/${DateTime.now().millisecondsSinceEpoch}_$fileName';

      UploadTask? uploadTask;

      if (kIsWeb) {
        // Web upload
        if (_videoBytes != null) {
          uploadTask = _storage.ref(destination).putData(_videoBytes!);
        }
      } else {
        // Mobile upload
        final file = File(_pickedVideo!.path);
        uploadTask = _storage.ref(destination).putFile(file);
      }

      if (uploadTask == null) return null;

      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() => _isUploadingVideo = false);
      return downloadUrl;
    } catch (e) {
      print('Error uploading video: $e');
      setState(() => _isUploadingVideo = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading video: $e')),
      );
      return null;
    }
  }

  // Upload document to Firebase Storage
  Future<String?> _uploadDocument() async {
    if (_pickedDocument == null)
      return _documentUrl != null
          ? '$_documentUrl|$_documentName'
          : null; // Return existing URL if no new document

    setState(() => _isUploadingDocument = true);

    try {
      final fileName = _pickedDocument!.name;
      final destination =
          'topics/${widget.courseId}/documents/${DateTime.now().millisecondsSinceEpoch}_$fileName';

      UploadTask? uploadTask;

      if (kIsWeb) {
        // Web upload
        if (_pickedDocument!.bytes != null) {
          uploadTask =
              _storage.ref(destination).putData(_pickedDocument!.bytes!);
        }
      } else {
        // Mobile upload
        if (_pickedDocument!.path != null) {
          final file = File(_pickedDocument!.path!);
          uploadTask = _storage.ref(destination).putFile(file);
        }
      }

      if (uploadTask == null) return null;

      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      setState(() => _isUploadingDocument = false);
      return '$downloadUrl|$fileName'; // Store URL and filename together
    } catch (e) {
      print('Error uploading document: $e');
      setState(() => _isUploadingDocument = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading document: $e')),
      );
      return null;
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      final currentUser = await FirebaseAuthService().getCurrentUser();
      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not logged in')),
        );
        setState(() => _isSubmitting = false);
        return;
      }

      // Upload files first
      final imageUrl = await _uploadImage();
      final videoUrl = await _uploadVideo();
      final documentUrl = await _uploadDocument();

      print('Submitting form with image URL: $imageUrl');
      print('Submitting form with video URL: $videoUrl');
      print('Submitting form with document URL: $documentUrl');

      // Gather all questions that are not empty
      final List<String> validQuestions = [];
      for (int i = 0; i < _questions.length; i++) {
        if (_questions[i].trim().isNotEmpty) {
          validQuestions.add(_questions[i]);
        }
      }

      // Create or update topic
      final Topic newTopic = Topic(
        id: widget.topic?.id ?? '',
        courseId: widget.courseId,
        name: _nameController.text,
        title: _titleController.text,
        description:
            jsonEncode(_descriptionController.document.toDelta().toJson()),
        instructor: _instructorController.text,
        imageUrl: imageUrl, // Add the image URL
        studyVideoUrl: videoUrl,
        attachment: documentUrl,
        question: validQuestions,
        userId: currentUser.uid!,
      );

      try {
        String topicId;
        if (widget.topic == null) {
          // Create new topic
          topicId = await _courseService.createTopic(newTopic);
          await _courseService.addTopicToCourse(
            widget.courseId,
            topicId,
            newTopic.title,
            newTopic.description,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Topic added successfully')),
          );
        } else {
          // Update existing topic
          topicId = widget.topic!.id;
          newTopic.id = topicId;
          await _courseService.updateTopic(newTopic, widget.topic!);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Topic updated successfully')),
          );
        }

        setState(() => _isSubmitting = false);
        Navigator.pop(context); // Return to previous screen
      } catch (e) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Error ${widget.topic == null ? 'adding' : 'updating'} topic: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _instructorController.dispose();
    _cityController.dispose();
    for (var ctrl in _questionControllers) ctrl.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  //build quill editor
  Widget buildQuillEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const Text('Description',
        //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
    Widget decoratedPreview({required Widget child}) => Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          clipBehavior: Clip.hardEdge,
          child: child,
        );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.topic == null ? 'Add Topic' : 'Edit Topic',
            style: Theme.of(context).textTheme.titleLarge),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
                maxWidth: 600), // Increased max width to prevent overlapping
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildTextField(
                        context,
                        'Name',
                        _nameController,
                        (v) => v!.isEmpty ? 'Enter name' : null,
                        (v) => _nameController.text = v!,
                      ),
                      const SizedBox(height: 16),
                      buildTextField(
                        context,
                        'Title',
                        _titleController,
                        (v) => v!.isEmpty ? 'Enter title' : null,
                        (v) => _titleController.text = v!,
                      ),
                      const SizedBox(height: 16),
                      buildTextField(
                        context,
                        'Instructor',
                        _instructorController,
                        (v) => v!.isEmpty ? 'Enter instructor' : null,
                        (v) => _instructorController.text = v!,
                      ),
                      const SizedBox(height: 16),

                      // Image picker
                      ElevatedButton.icon(
                        onPressed: _isSubmitting ? null : _pickImage,
                        icon: Icon(Icons.image),
                        label: Text(_pickedImage == null && _imageUrl == null
                            ? 'Add Image'
                            : 'Change Image'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_isUploadingImage)
                        Column(
                          children: [
                            SizedBox(height: 8),
                            LinearProgressIndicator(),
                            SizedBox(height: 8),
                            Text('Uploading image...'),
                          ],
                        ),
                      if (_pickedImage != null || _imageUrl != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Image Preview:'),
                            const SizedBox(height: 8),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                decoratedPreview(
                                  child: _imageUrl != null
                                      ? Image.network(_imageUrl!,
                                          fit: BoxFit.cover)
                                      : kIsWeb
                                          ? Image.memory(_imageBytes!,
                                              fit: BoxFit.cover)
                                          : Image.file(File(_pickedImage!.path),
                                              fit: BoxFit.cover),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  icon: Icon(Icons.visibility,
                                      color: Colors.blue),
                                  label: Text('Preview'),
                                  onPressed:
                                      _isSubmitting ? null : _previewImage,
                                ),
                                TextButton.icon(
                                  icon: Icon(Icons.delete,
                                      color: Colors.blue),
                                  label: Text('Remove'),
                                  onPressed: _isSubmitting ? null : _clearImage,
                                ),
                              ],
                            ),
                          ],
                        ),
                      const SizedBox(height: 16),

                      // Video picker
                      ElevatedButton.icon(
                        onPressed: _isSubmitting ? null : _pickVideo,
                        icon: Icon(Icons.videocam),
                        label: Text(_pickedVideo == null && _videoUrl == null
                            ? 'Add Video'
                            : 'Change Video'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_isUploadingVideo)
                        Column(
                          children: [
                            SizedBox(height: 8),
                            LinearProgressIndicator(),
                            SizedBox(height: 8),
                            Text('Uploading video...'),
                          ],
                        ),
                      if ((_pickedVideo != null || _videoUrl != null) &&
                          _videoController != null &&
                          _videoController!.value.isInitialized)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Video Preview:'),
                            const SizedBox(height: 8),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                decoratedPreview(
                                  child: AspectRatio(
                                    aspectRatio:
                                        _videoController!.value.aspectRatio,
                                    child: VideoPlayer(_videoController!),
                                  ),
                                ),
                                // Play/Pause overlay
                                Positioned.fill(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _videoController!.value.isPlaying
                                            ? _videoController!.pause()
                                            : _videoController!.play();
                                      });
                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                      child: Center(
                                        child: Icon(
                                          _videoController!.value.isPlaying
                                              ? Icons.pause_circle_outline
                                              : Icons.play_circle_outline,
                                          size: 50,
                                          color: Colors.white.withOpacity(0.7),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  icon: Icon(Icons.visibility,
                                      color: Colors.blue),
                                  label: Text('Preview'),
                                  onPressed:
                                      _isSubmitting ? null : _previewVideo,
                                ),
                                TextButton.icon(
                                  icon: Icon(Icons.delete,
                                      color: Colors.blue),
                                  label: Text('Remove'),
                                  onPressed: _isSubmitting ? null : _clearVideo,
                                ),
                              ],
                            ),
                          ],
                        ),
                      const SizedBox(height: 16),

                      // Document attachment
                      ElevatedButton.icon(
                        onPressed: _isSubmitting ? null : _pickDocument,
                        icon: Icon(Icons.attach_file),
                        label: Text(
                            _pickedDocument == null && _documentUrl == null
                                ? 'Add Document'
                                : 'Change Document'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_isUploadingDocument)
                        Column(
                          children: [
                            SizedBox(height: 8),
                            LinearProgressIndicator(),
                            SizedBox(height: 8),
                            Text('Uploading document...'),
                          ],
                        ),
                      if (_pickedDocument != null || _documentUrl != null)
                        Card(
                          elevation: 2,
                          child: ListTile(
                            leading: Icon(Icons.description),
                            title: Text(
                                _pickedDocument?.name ??
                                    _documentName ??
                                    'Document',
                                overflow: TextOverflow.ellipsis),
                            subtitle: _pickedDocument != null
                                ? Text(
                                    '${(_pickedDocument!.size / 1024).toStringAsFixed(2)} KB',
                                    overflow: TextOverflow.ellipsis)
                                : Text('Stored document',
                                    overflow: TextOverflow.ellipsis),
                            onTap: _isSubmitting ? null : _previewDocument,
                            trailing: Wrap(
                              spacing: 8,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.download,
                                      color: Colors.blue),
                                  onPressed:
                                      _isSubmitting ? null : _downloadDocument,
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete,
                                      color: Colors.blue),
                                  onPressed:
                                      _isSubmitting ? null : _clearDocument,
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),

                      // Description toggle
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Description',
                              style: Theme.of(context).textTheme.titleLarge),
                          IconButton(
                            icon: Icon(
                                _isDescriptionExpanded
                                    ? Icons.remove
                                    : Icons.add,
                                color: Theme.of(context).iconTheme.color),
                            onPressed: _isSubmitting
                                ? null
                                : () => setState(() => _isDescriptionExpanded =
                                    !_isDescriptionExpanded),
                          ),
                        ],
                      ),
                      if (_isDescriptionExpanded) buildQuillEditor(),
                      const SizedBox(height: 16),

                      // Dynamic questions
                      Text('Questions',
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Column(
                        children:
                            List.generate(_questionControllers.length, (i) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Expanded(
                                  child: buildTextField(
                                    context,
                                    'Question ${i + 1}',
                                    _questionControllers[i],
                                    (v) => null, // Make validation optional
                                    (v) => _questions[i] = v!,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: _isSubmitting
                                      ? null
                                      : () {
                                          setState(() {
                                            _questionControllers
                                                .add(TextEditingController());
                                            _questions.add("");
                                          });
                                        },
                                ),
                                if (_questionControllers.length > 1)
                                  IconButton(
                                    icon: Icon(Icons.remove),
                                    onPressed: _isSubmitting
                                        ? null
                                        : () {
                                            setState(() {
                                              _questionControllers
                                                  .removeAt(i)
                                                  .dispose();
                                              _questions.removeAt(i);
                                            });
                                          },
                                  ),
                              ],
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 24),

                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isSubmitting ? null : _submitForm,
                              child: _isSubmitting
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          widget.topic == null
                                              ? 'Saving...'
                                              : 'Updating...',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                      ],
                                    )
                                  : Text(
                                      widget.topic == null
                                          ? 'Save Topic'
                                          : 'Update Topic',
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(double.infinity, 48),
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
