import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:nestern/models/profile.dart';
import 'package:nestern/models/experience.dart'; // Add import for Experience model
import 'package:nestern/services/experience_service.dart'; // Add import for ExperienceService
import 'package:nestern/models/notification.dart'
    as NotificationModel; // Import with alias

class ProfileService {
  final CollectionReference _profilesCollection = FirebaseFirestore.instance
      .collection('nestern')
      .doc('users')
      .collection('profiles');
  final CollectionReference _usersCollection = FirebaseFirestore.instance
      .collection('nestern')
      .doc('users')
      .collection('accounts');
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final CollectionReference _notificationsCollection = FirebaseFirestore
      .instance
      .collection('nestern')
      .doc('notifications')
      .collection('userNotifications'); //Notification Collection

  // Add reference to ExperienceService
  final ExperienceService _experienceService = ExperienceService();

  Future<void> createProfile(Profile profile) async {
    // Check if the profile already exists
    DocumentSnapshot existingProfileDoc = await _profilesCollection
        .doc(profile.userId)
        .get(); // Check if the document exists
    if (existingProfileDoc.exists) {
      print('Profile already exists for userId: ${profile.userId}');
      return; // Exit if the profile already exists
    }
    try {
      await _profilesCollection.doc(profile.userId).set(profile.toJson());

      // Add notification
      await _notificationsCollection.add(NotificationModel.Notification(
        type: 'Profile Created',
        content: 'Your profile has been created.',
        senderId: profile.userId,
        recipientId: profile.userId,
        timestamp: DateTime.now(),
        id: '', //Firestore will create this.
      ).toJson());
    } on FirebaseException catch (e) {
      print('Firebase Exception creating profile: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('Error creating profile: $e');
      rethrow;
    }
  }

  // Helper method to get content type based on file extension
  String _getContentType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      default:
        return 'application/octet-stream';
    }
  }

  Future<Profile?> getProfile(String userId) async {
    try {
      DocumentSnapshot doc = await _profilesCollection.doc(userId).get();
      return doc.exists
          ? Profile.fromJson(doc.data() as Map<String, dynamic>)
          : null;
    } on FirebaseException catch (e) {
      print('Firebase Exception getting profile: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      print('Error getting profile: $e');
      return null;
    }
  }

  Future<void> updateProfile(Profile profile, Profile oldProfile) async {
    //Add old profile parameter
    try {
      await _profilesCollection.doc(profile.userId).update(profile.toJson());

      if (profile != oldProfile) {
        await _notificationsCollection.add(NotificationModel.Notification(
          type: 'Profile Updated',
          content: 'Your profile has been updated.',
          senderId: profile.userId,
          recipientId: profile.userId,
          timestamp: DateTime.now(),
          id: '', //Firestore will create this.
        ).toJson());
      }
    } on FirebaseException catch (e) {
      print('Firebase Exception updating profile: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('Error updating profile: $e');
      rethrow;
    }
  }

  Future<void> deleteProfile(String userId) async {
    try {
      await _profilesCollection.doc(userId).delete();

      await _notificationsCollection.add(NotificationModel.Notification(
        type: 'Profile Deleted',
        content: 'Your profile has been deleted.',
        senderId: userId,
        recipientId: userId,
        timestamp: DateTime.now(),
        id: '', //Firestore will create this.
      ).toJson());
    } on FirebaseException catch (e) {
      print('Firebase Exception deleting profile: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('Error deleting profile: $e');
      rethrow;
    }
  }

  // Existing methods and fields

  // Add this method to return the profile completion percentage for a user
  Future<double> getProfileCompletionPercentage(String userId) async {
    // TODO: Replace with actual logic to calculate profile completion
    // For now, return a dummy value (e.g., 0.75 for 75% complete)
    return 0.75;
  }

  // NEW METHOD: Get potential benefits that a connection with this user might offer
  Future<List<String>> getPotentialBenefits(
      String userId, String currentUserId) async {
    try {
      List<String> benefits = [];

      // Get user's profile
      Profile? profile = await getProfile(userId);

      // Get user's experiences
      List<Experience> experiences =
          await _experienceService.getExperiencesByUserId(userId);

      // First benefit based on current experience
      if (experiences.isNotEmpty) {
        experiences.sort((a, b) => b.from.compareTo(a.from));
        final currentExperience = experiences.first;

        // Analyze job title for specialized benefit
        String jobTitle = currentExperience.title.toLowerCase();
        String company = currentExperience.company;

        if (jobTitle.contains('ceo') ||
            jobTitle.contains('founder') ||
            jobTitle.contains('president')) {
          benefits.add('Leadership connection at $company');
        } else if (jobTitle.contains('cto') ||
            jobTitle.contains('developer') ||
            jobTitle.contains('engineer')) {
          benefits.add('Technical expertise in ${currentExperience.jobField}');
        } else if (jobTitle.contains('marketing') ||
            jobTitle.contains('brand') ||
            jobTitle.contains('communications')) {
          benefits.add('Marketing insights from $company');
        } else if (jobTitle.contains('sales') ||
            jobTitle.contains('business development')) {
          benefits.add('Sales network at $company');
        } else if (jobTitle.contains('hr') ||
            jobTitle.contains('human resources') ||
            jobTitle.contains('talent')) {
          benefits.add('Recruitment connections at $company');
        } else if (jobTitle.contains('manager') ||
            jobTitle.contains('director')) {
          benefits.add('Management expertise at $company');
        } else {
          benefits.add('Industry insights from $company');
        }
      }

      // Second benefit based on industry experience
      if (experiences.length > 1) {
        // Get unique industries from past experiences
        Set<String> industries =
            experiences.map((e) => e.jobField.toLowerCase()).toSet();

        if (industries.isNotEmpty) {
          // Choose most relevant industry
          String mainIndustry = industries.first;
          benefits.add('Network in the $mainIndustry industry');
        }
      }

      // Third benefit based on skills if available in profile
      if (profile != null && profile.skills.isNotEmpty) {
        // Get the first three skills
        List<String> topSkills = profile.skills.take(3).toList();
        if (topSkills.isNotEmpty) {
          benefits.add('Expertise in ${topSkills.join(", ")}');
        }
      }

      // If we haven't got enough benefits yet, add a generic one
      if (benefits.length < 3) {
        benefits.add('Expand your professional network');
      }

      // Limit to 3 benefits
      return benefits.take(3).toList();
    } catch (e) {
      print('Error getting potential benefits: $e');
      // Return generic benefits in case of error
      return [
        'Expand your professional network',
        'Discover new industry insights',
        'Connect with industry professionals'
      ];
    }
  }

  // NEW METHOD: Get complementary skills between two users
  Future<List<String>> getComplementarySkills(
      String userId, String currentUserId) async {
    try {
      Profile? userProfile = await getProfile(userId);
      Profile? currentUserProfile = await getProfile(currentUserId);

      if (userProfile == null || currentUserProfile == null) {
        return [];
      }

      // Find skills the other user has that current user doesn't
      Set<String> userSkills =
          Set.from(userProfile.skills.map((s) => s.toLowerCase()));
      Set<String> currentUserSkills =
          Set.from(currentUserProfile.skills.map((s) => s.toLowerCase()));

      Set<String> complementarySkills =
          userSkills.difference(currentUserSkills);

      return complementarySkills.take(3).toList();
    } catch (e) {
      print('Error getting complementary skills: $e');
      return [];
    }
  }

  Future<String> uploadResume(String userId, File resumeFile) async {
    try {
      String fileName =
          'resumes/$userId/${DateTime.now().millisecondsSinceEpoch}.pdf';
      Reference storageRef = _storage.ref().child(fileName);
      UploadTask uploadTask = storageRef.putFile(resumeFile);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Update profile document with the new resume URL.
      await _profilesCollection.doc(userId).update({
        'uploadResumeIds':
            FieldValue.arrayUnion([downloadUrl]), // Add to the list
      });

      // Update user document to indicate that the user has a resume.
      await _usersCollection.doc(userId).update({
        'hasResume': true,
      });

      return downloadUrl;
    } on FirebaseException catch (e) {
      print('Firebase Exception uploading resume: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('Error uploading resume: $e');
      rethrow;
    }
  }

// ------------------- UPLOAD RESUME (WEB) -------------------
  Future<String> uploadResumeFromBytes(
      String userId, Uint8List fileBytes, String fileName) async {
    try {
      // Validate inputs
      if (fileBytes.isEmpty || fileName.isEmpty) {
        throw ArgumentError('File bytes and file name must not be empty.');
      }

      // Optional: Enforce a file size limit (e.g., 5 MB)
      const maxFileSizeInBytes = 5 * 1024 * 1024;
      if (fileBytes.length > maxFileSizeInBytes) {
        throw Exception('File size exceeds 5MB limit.');
      }

      // Create a unique file path
      String filePath =
          'resumes/$userId/${DateTime.now().millisecondsSinceEpoch}_$fileName';
      String contentType = _getContentType(fileName);

      // Upload to Firebase Storage
      Reference storageRef = _storage.ref().child(filePath);
      UploadTask uploadTask = storageRef.putData(
        fileBytes,
        SettableMetadata(contentType: contentType),
      );

      // Wait for upload and get download URL
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      print('Resume uploaded. URL: $downloadUrl');

      // Ensure the profile document has the uploadResumeIds field as an array
      DocumentReference profileRef = _profilesCollection.doc(userId);
      await profileRef.set({'uploadResumeIds': []}, SetOptions(merge: true));

      // Add download URL to the array
      await profileRef.update({
        'uploadResumeIds': FieldValue.arrayUnion([downloadUrl]),
      });
      print('Resume URL added to uploadResumeIds.');

      // Mark that the user has uploaded a resume
      await _usersCollection.doc(userId).update({
        'hasResume': true,
      });

      return downloadUrl;
    } on FirebaseException catch (e) {
      print('Firebase Exception uploading resume: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('General error uploading resume: $e');
      rethrow;
    }
  }

  Future<void> deleteResume(String userId, String resumeUrl) async {
    try {
      // Delete the file from Firebase Storage
      Reference storageRef = _storage.refFromURL(resumeUrl);
      await storageRef.delete();

      // Remove the URL from the user's profile document
      await _profilesCollection.doc(userId).update({
        'uploadResumeIds': FieldValue.arrayRemove([resumeUrl]),
      });

      // Check if any resumes are left, and update the 'hasResume' flag accordingly
      DocumentSnapshot profileSnapshot =
          await _profilesCollection.doc(userId).get();
      final profileData = profileSnapshot.data() as Map<String, dynamic>?;
      final List<dynamic> resumeList = profileData?['uploadResumeIds'] ?? [];

      if (resumeList.isEmpty) {
        await _usersCollection.doc(userId).update({
          'hasResume': false,
        });
      }
    } on FirebaseException catch (e) {
      print('Firebase Exception deleting resume: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('Error deleting resume: $e');
      rethrow;
    }
  }

  Future<void> deleteAllResumes(String userId) async {
    try {
      DocumentSnapshot profileSnapshot =
          await _profilesCollection.doc(userId).get();
      final profileData = profileSnapshot.data() as Map<String, dynamic>?;
      final List<dynamic> resumeUrls = profileData?['uploadResumeIds'] ?? [];

      // Delete each resume from Firebase Storage
      for (String url in resumeUrls) {
        try {
          Reference storageRef = _storage.refFromURL(url);
          await storageRef.delete();
        } catch (e) {
          print('Error deleting individual resume from storage: $e');
          // You may want to handle this more gracefully in production
        }
      }

      // Clear the resume URLs from Firestore
      await _profilesCollection.doc(userId).update({
        'uploadResumeIds': [],
      });

      // Update the user's hasResume flag
      await _usersCollection.doc(userId).update({
        'hasResume': false,
      });

      // Optional: Add a notification
      await _notificationsCollection.add(NotificationModel.Notification(
        type: 'Resumes Deleted',
        content: 'All your resumes have been deleted.',
        senderId: userId,
        recipientId: userId,
        timestamp: DateTime.now(),
        id: '',
      ).toJson());
    } on FirebaseException catch (e) {
      print(
          'Firebase Exception deleting all resumes: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('Error deleting all resumes: $e');
      rethrow;
    }
  }
}
