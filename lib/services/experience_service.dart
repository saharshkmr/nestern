import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nestern/models/experience.dart';
import 'package:nestern/models/notification.dart'
    as NotificationModel; // Import with alias

class ExperienceService {
  final CollectionReference _experiencesCollection = FirebaseFirestore.instance
      .collection('nestern')
      .doc('users')
      .collection('experiences');

  final CollectionReference _notificationsCollection = FirebaseFirestore
      .instance
      .collection('nestern')
      .doc('notifications')
      .collection('userNotifications'); //Notification Collection

  final CollectionReference _profilesCollection = FirebaseFirestore.instance
      .collection('nestern')
      .doc('users')
      .collection('profiles');

  Future<String> createExperience(Experience experience) async {
    try {
      DocumentReference docRef =
          await _experiencesCollection.add(experience.toJson());
      experience.id = docRef.id; // Set the experience ID to the document ID
      await docRef.set(experience.toJson());
      await addExpToProfile(experience);
      // Add notification
      await _notificationsCollection.add(NotificationModel.Notification(
        type: 'Experience Created',
        content: 'A new experience has been added.',
        senderId: experience.userId,
        recipientId: experience.userId,
        timestamp: DateTime.now(),
        id: '', //Firestore will create this.
      ).toJson());

      return docRef.id;
    } on FirebaseException catch (e) {
      print('Firebase Exception creating experience: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('Error creating experience: $e');
      rethrow;
    }
  }

  Future<Experience?> getExperience(String experienceId) async {
    try {
      DocumentSnapshot doc =
          await _experiencesCollection.doc(experienceId).get();
      return doc.exists
          ? Experience.fromJson(doc.data() as Map<String, dynamic>)
          : null;
    } on FirebaseException catch (e) {
      print('Firebase Exception getting experience: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      print('Error getting experience: $e');
      return null;
    }
  }

  Future<List<Experience>> getExperiencesByUserId(String userId) async {
    try {
      QuerySnapshot snapshot =
          await _experiencesCollection.where('userId', isEqualTo: userId).get();
      return snapshot.docs
          .map((doc) => Experience.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } on FirebaseException catch (e) {
      print(
          'Firebase Exception getting experiences by user ID: ${e.code} - ${e.message}');
      return [];
    } catch (e) {
      print('Error getting experiences by user ID: $e');
      return [];
    }
  }

  Future<List<Experience>> getAllExperiences() async {
    try {
      QuerySnapshot snapshot = await _experiencesCollection.get();
      return snapshot.docs
          .map((doc) => Experience.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } on FirebaseException catch (e) {
      print(
          'Firebase Exception getting all experiences: ${e.code} - ${e.message}');
      return [];
    } catch (e) {
      print('Error getting all experiences: $e');
      return [];
    }
  }

  Future<void> addExpToProfile(Experience experience) async {
    await _profilesCollection.doc(experience.userId).update({
      'experiences': FieldValue.arrayUnion([
        {
          'id': experience.id,
          'title': experience.title,
          'company': experience.company,
          'location': experience.location,
          'from': experience.from.toIso8601String(),
          'to': experience.to?.toIso8601String(),
          'current': experience.current,
          'description': experience.description,
          'jobTitle': experience.jobTitle,
          'jobField': experience.jobField,
          'skill': experience.skill,
        }
      ])
    });
  }

  Future<void> updateexpInProfile(Experience experience) async {
    final docRef = _profilesCollection.doc(experience.userId);
    final snapshot = await docRef.get();

    if (!snapshot.exists) {
      throw Exception("Profile not found");
    }
    final data = snapshot.data() as Map<String, dynamic>?;
    List<dynamic> experiences = data?['experience'] ?? [];

    // Replace the address with matching ID
    List updatedexp = experiences.map((exp) {
      if (exp['id'] == experience.id) {
        return {
          'id': experience.id,
          'Company': experience.company,
          'Start Date': experience.from.toString(),
          'End Date': experience.to.toString(),
        };
      }
      return exp;
    }).toList();

    await docRef.update({'experience': updatedexp});
  }

  Future<void> deleteexpFromProfile({
    required String userId,
    required String experienceId,
  }) async {
    final docRef = _profilesCollection.doc(userId);
    final snapshot = await docRef.get();

    if (!snapshot.exists) {
      throw Exception("Profile not found");
    }

    final data = snapshot.data() as Map<String, dynamic>?;
    List<dynamic> experience = data?['experience'] ?? [];

    // Filter out the experience to delete
    List updatedExperiences =
        experience.where((exp) => exp['id'] != experienceId).toList();

    // Update Firestore with filtered list
    await docRef.update({'experience': updatedExperiences});
  }

  Future<void> updateExperience(
      Experience experience, Experience oldExperience) async {
    //Add old experience parameter
    try {
      await _experiencesCollection
          .doc(experience.id)
          .update(experience.toJson());
      await updateexpInProfile(experience);

      if (experience != oldExperience) {
        await _notificationsCollection.add(NotificationModel.Notification(
          type: 'Experience Updated',
          content: 'An experience has been updated.',
          senderId: experience.userId,
          recipientId: experience.userId,
          timestamp: DateTime.now(),
          id: '', //Firestore will create this.
        ).toJson());
      }
    } on FirebaseException catch (e) {
      print('Firebase Exception updating experience: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('Error updating experience: $e');
      rethrow;
    }
  }

  Future<void> deleteExperience(String experienceId, String userId) async {
    //Add userId parameter
    try {
      await _experiencesCollection.doc(experienceId).delete();
      await deleteexpFromProfile(userId: userId, experienceId: experienceId);
      await _notificationsCollection.add(NotificationModel.Notification(
        type: 'Experience Deleted',
        content: 'An experience has been deleted.',
        senderId: userId,
        recipientId: userId,
        timestamp: DateTime.now(),
        id: '', //Firestore will create this.
      ).toJson());
    } on FirebaseException catch (e) {
      print('Firebase Exception deleting experience: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('Error deleting experience: $e');
      rethrow;
    }
  }
}
