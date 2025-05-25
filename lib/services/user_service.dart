import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nestern/models/profile.dart';
import 'package:nestern/models/social.dart';
import 'package:nestern/models/user.dart';
import 'package:nestern/models/notification.dart' as NotificationModel;
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:firebase_auth/firebase_auth.dart'
    as auth; // Added for current user

class UserService {
  // final CollectionReference _usersCollection = FirebaseFirestore.instance
  //     .collection('nestern')
  //     .doc('users')
  //     .collection('accounts');

  final CollectionReference _profilesCollection = FirebaseFirestore.instance
      .collection('nestern')
      .doc('users')
      .collection('profiles');

  final FirebaseStorage _storage = FirebaseStorage.instance;

  final CollectionReference _notificationsCollection = FirebaseFirestore
      .instance
      .collection('nestern')
      .doc('notifications')
      .collection('userNotifications');

  /// now points at a top-level users collection
  final CollectionReference _usersCollection =
    FirebaseFirestore.instance.collection('users');

  // … your other collections (profiles, notifications) …

  /// UPDATE (create-or-update) user so you never hit "not-found"
  Future<void> updateUser(User user) async {
    try {
      await _usersCollection
        .doc(user.id)
        .set(user.toJson(), SetOptions(merge: true));  // ← merge instead of update
      await _notificationsCollection.add(
        NotificationModel.Notification(
          type: 'User Updated',
          content: 'Your user data has been updated.',
          senderId: user.id,
          recipientId: user.id,
          timestamp: DateTime.now(),
          id: '',
        ).toJson(),
      );
    } on FirebaseException catch (e) {
      print(
        'Firebase Exception updating user: ${e.code} - ${e.message}'
      );
      rethrow;
    }
  }

  /// CONSISTENT storage path for all uploads
  Future<String?> uploadProfileImageFromBytes(
      String userId, Uint8List imageBytes, String fileName) async {
    try {
      final ref = _storage
        .ref()
        .child('Profile/$userId/${DateTime.now().millisecondsSinceEpoch}_$fileName.jpg');
      final task = ref.putData(
        imageBytes,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      final snapshot = await task.whenComplete(() {});
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading profile image: $e');
      return null;
    }
  }


  // ------------------- GET CURRENT USER ID -------------------
  // This getter returns the current logged-in user's ID using FirebaseAuth.
  String? get currentUserId => auth.FirebaseAuth.instance.currentUser?.uid;

  // ------------------- CREATE USER -------------------
  Future<void> createUser(User user) async {
    try {
      await _usersCollection.doc(user.id).set(user.toJson());
      await _notificationsCollection.add(
        NotificationModel.Notification(
          type: 'User Created',
          content: 'A new user has been created.',
          senderId: user.id,
          recipientId: user.id,
          timestamp: DateTime.now(),
          id: '',
        ).toJson(),
      );
    } on FirebaseException catch (e) {
      print('Firebase Exception creating user: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('Error creating user: $e');
      rethrow;
    }
  }

  // ------------------- GET USER -------------------
  Future<User?> getUser(String userId) async {
    try {
      DocumentSnapshot doc = await _usersCollection.doc(userId).get();
      if (doc.exists) {
        return User.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } on FirebaseException catch (e) {
      print('Firebase Exception getting user: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  // ------------------- GET USER BY ID (If not found, creates new user) -------------------
  Future<User?> getUserById(String userId) async {
    try {
      DocumentSnapshot doc = await _usersCollection.doc(userId).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = userId;
        return User.fromJson(data);
      }
    } catch (e) {
      User newUser = User(
        id: userId,
        company: '',
        email: '',
        uid: userId,
        role: 'user',
        profileName: '',
        mobile: '',
        url: '',
        bio: '',
        isProfileComplete: false,
        hasResume: false,
        skills: [],
      );
      await createUser(newUser);
    }
    return null;
  }

  // ------------------- GET USERS BY IDS -------------------
  Future<List<User>> getUsersByIds(List<String> userIds) async {
    if (userIds.isEmpty) return [];
    List<User> users = [];

    // Split userIds into chunks of 30 or fewer.
    for (int i = 0; i < userIds.length; i += 30) {
      final chunk = userIds.sublist(
        i,
        i + 30 > userIds.length ? userIds.length : i + 30,
      );
      try {
        QuerySnapshot snapshot = await _usersCollection
            .where(FieldPath.documentId, whereIn: chunk)
            .get();
        print(
            "Debug: getUsersByIds fetched ${snapshot.docs.length} docs for IDs: $chunk");
        users.addAll(snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          // Use the given profileName; if missing or empty, set a fallback.
          if (!data.containsKey('profileName') ||
              data['profileName'].toString().isEmpty) {
            data['profileName'] = 'Unknown';
          }
          return User.fromJson(data);
        }).toList());
      } catch (e) {
        print('Error getting users by IDs for chunk $chunk: $e');
      }
    }
    return users;
  }

  // ------------------- GET ALL USERS -------------------
  Future<List<User>> getAllUsers() async {
    try {
      QuerySnapshot snapshot = await _usersCollection.get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        if (!data.containsKey('profileName') ||
            data['profileName'].toString().isEmpty) {
          data['profileName'] = 'Unknown';
        }
        return User.fromJson(data);
      }).toList();
    } on FirebaseException catch (e) {
      print('Firebase Exception getting all users: ${e.code} - ${e.message}');
      return [];
    } catch (e) {
      print('Error getting all users: $e');
      return [];
    }
  }

  // ------------------- UPDATE USER -------------------
  // Future<void> updateUser(User user) async {
  //   try {
  //     await _usersCollection.doc(user.id).update(user.toJson());
  //     await _notificationsCollection.add(
  //       NotificationModel.Notification(
  //         type: 'User Updated',
  //         content: 'Your user data has been updated.',
  //         senderId: user.id,
  //         recipientId: user.id,
  //         timestamp: DateTime.now(),
  //         id: '',
  //       ).toJson(),
  //     );
  //   } on FirebaseException catch (e) {
  //     print('Firebase Exception updating user: ${e.code} - ${e.message}');
  //     rethrow;
  //   } catch (e) {
  //     print('Error updating user: $e');
  //     rethrow;
  //   }
  // }

  // ------------------- DELETE USER -------------------
  Future<void> deleteUser(String userId) async {
    try {
      await _usersCollection.doc(userId).delete();
      await _profilesCollection.doc(userId).delete();
      await _notificationsCollection.add(
        NotificationModel.Notification(
          type: 'User Deleted',
          content: 'Your user data has been deleted.',
          senderId: userId,
          recipientId: userId,
          timestamp: DateTime.now(),
          id: '',
        ).toJson(),
      );
    } on FirebaseException catch (e) {
      print('Firebase Exception deleting user: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('Error deleting user: $e');
      rethrow;
    }
  }

  // ------------------- GET PROFILE -------------------
  Future<Profile?> getProfile(String userId) async {
    try {
      DocumentSnapshot doc = await _profilesCollection.doc(userId).get();
      if (doc.exists) {
        return Profile.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } on FirebaseException catch (e) {
      print('Firebase Exception getting profile: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      print('Error getting profile: $e');
      return null;
    }
  }

  // ------------------- CREATE / UPDATE PROFILE -------------------
  Future<void> createOrUpdateProfile(
      Profile profile, Profile oldProfile) async {
    try {
      await _profilesCollection
          .doc(profile.userId)
          .set(profile.toJson(), SetOptions(merge: true));
      if (profile != oldProfile) {
        await _notificationsCollection.add(
          NotificationModel.Notification(
            type: 'Profile Updated',
            content: 'Your profile has been updated.',
            senderId: profile.userId,
            recipientId: profile.userId,
            timestamp: DateTime.now(),
            id: '',
          ).toJson(),
        );
      }
    } on FirebaseException catch (e) {
      print(
          'Firebase Exception creating/updating profile: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('Error creating/updating profile: $e');
      rethrow;
    }
  }

  // ------------------- CHECK PROFILE COMPLETE -------------------
  Future<bool> isProfileComplete(String userId) async {
    try {
      DocumentSnapshot doc = await _usersCollection.doc(userId).get();
      return doc.exists &&
          (doc.data() as Map<String, dynamic>)['isProfileComplete'] == true;
    } on FirebaseException catch (e) {
      print(
          'Firebase Exception checking profile completion: ${e.code} - ${e.message}');
      return false;
    } catch (e) {
      print('Error checking profile completion: $e');
      return false;
    }
  }

  // ------------------- CHECK IF HAS RESUME -------------------
  Future<bool> hasResume(String userId) async {
    try {
      DocumentSnapshot doc = await _usersCollection.doc(userId).get();
      return doc.exists &&
          (doc.data() as Map<String, dynamic>)['hasResume'] == true;
    } on FirebaseException catch (e) {
      print('Firebase Exception checking resume: ${e.code} - ${e.message}');
      return false;
    } catch (e) {
      print('Error checking resume: $e');
      return false;
    }
  }

  // ------------------- UPLOAD PROFILE IMAGE (MOBILE) -------------------
  Future<String?> uploadProfileImageXFile(String userId, XFile image) async {
    try {
      final String fileName =
          '${DateTime.now().millisecondsSinceEpoch}_$userId.jpg';
      final Reference ref =
          FirebaseStorage.instance.ref().child('Profile/$fileName');

      late final UploadTask uploadTask;
      if (kIsWeb) {
        final bytes = await image.readAsBytes();
        uploadTask = ref.putData(bytes);
      } else {
        uploadTask = ref.putFile(File(image.path));
      }

      final TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading profile image: $e');
      return null;
    }
  }

  Future<String?> uploadProfileImage(String userId, File image) async {
    try {
      final String fileName =
          '${DateTime.now().millisecondsSinceEpoch}_$userId.jpg';
      final Reference ref =
          FirebaseStorage.instance.ref().child('Profile/$fileName');

      final UploadTask uploadTask = ref.putFile(image);
      final TaskSnapshot snapshot = await uploadTask;

      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading profile image: $e');
      return null;
    }
  }

  // ------------------- UPLOAD PROFILE IMAGE (WEB) -------------------
  // Future<String?> uploadProfileImageFromBytes(
  //     String userId, Uint8List imageBytes, String fileName) async {
  //   try {
  //     final storageRef = _storage.ref().child('Profile/$userId/$fileName');
  //     final uploadTask = storageRef.putData(
  //       imageBytes,
  //       SettableMetadata(contentType: 'image/jpeg'),
  //     );
  //     final snapshot = await uploadTask.whenComplete(() {});
  //     if (snapshot.state == TaskState.success) {
  //       return await snapshot.ref.getDownloadURL();
  //     }
  //   } on FirebaseException catch (e) {
  //     print(
  //         'Firebase Exception uploading profile image from bytes: ${e.code} - ${e.message}');
  //   } catch (e) {
  //     print('Error uploading profile image from bytes: $e');
  //   }
  //   return null;
  // }

  // ------------------- UPLOAD RESUME (MOBILE) -------------------
  Future<String> uploadResume(String userId, File resumeFile) async {
    try {
      String fileName =
          'resumes/$userId/${DateTime.now().millisecondsSinceEpoch}/resumeFile';
      Reference storageRef = _storage.ref().child(fileName);
      UploadTask uploadTask = storageRef.putFile(resumeFile);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Update profile document with the new resume URL.
      await _profilesCollection.doc(userId).update({
        'resumeUrl': FieldValue.arrayUnion([downloadUrl]), // Add to the list
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
      String filePath =
          'resumes/$userId/${DateTime.now().millisecondsSinceEpoch}fileName';
      Reference storageRef = _storage.ref().child(filePath);
      UploadTask uploadTask = storageRef.putData(
        fileBytes,
        SettableMetadata(contentType: 'application/pdf'),
      );
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
// Update profile document with the new resume URL.
      await _profilesCollection.doc(userId).update({
        'resumeUrl': FieldValue.arrayUnion([downloadUrl]), // Add to the list
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
}
