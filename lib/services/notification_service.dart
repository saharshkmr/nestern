import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nestern/models/notification.dart';

class NotificationService {
  final CollectionReference _notificationsCollection = FirebaseFirestore
      .instance
      .collection('nestern')
      .doc('notifications')
      .collection('userNotifications');

  final CollectionReference _usersCollection = FirebaseFirestore.instance
      .collection('nestern')
      .doc('users')
      .collection('userItem');

  Future<String> createNotification(Notification notification) async {
    try {
      DocumentReference docRef =
          await _notificationsCollection.add(notification.toJson());
      notification.id = docRef.id; // Set the notification ID to the document ID
      await docRef.set(notification.toJson());
      return docRef.id;
    } on FirebaseException catch (e) {
      print(
          'Firebase Exception creating notification: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('Error creating notification: $e');
      rethrow;
    }
  }

  Future<List<Notification>> getNotificationsForUser(String userId) async {
    try {
      QuerySnapshot snapshot = await _notificationsCollection
          .where('recipientId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs
          .map((doc) =>
              Notification.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } on FirebaseException catch (e) {
      print(
          'Firebase Exception getting notifications for user: ${e.code} - ${e.message}');
      return [];
    } catch (e) {
      print('Error getting notifications for user: $e');
      return [];
    }
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _notificationsCollection
          .doc(notificationId)
          .update({'isRead': true});
    } on FirebaseException catch (e) {
      print(
          'Firebase Exception marking notification as read: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('Error marking notification as read: $e');
      rethrow;
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      await _notificationsCollection.doc(notificationId).delete();
    } on FirebaseException catch (e) {
      print(
          'Firebase Exception deleting notification: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('Error deleting notification: $e');
      rethrow;
    }
  }

  Stream<List<Notification>> notificationStream(String userId) {
    return _notificationsCollection
        .where('recipientId',
            whereIn: [userId, 'all']) // Include 'userId' or 'all'
        .snapshots()
        .map((snapshot) {
          var notifications = snapshot.docs
              .map((doc) =>
                  Notification.fromJson(doc.data() as Map<String, dynamic>))
              .toList();
          // Sort notifications by timestamp in descending order (newest first) client-side
          notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
          return notifications;
        });
  }

  // Get a user by their ID
  // Future<User?> getUserById(String userId) async {
  //   try {
  //     DocumentSnapshot userDoc = await _usersCollection.doc(userId).get();

  //     if (userDoc.exists) {
  //       return User.fromJson(userDoc.data() as Map<String, dynamic>);
  //     }
  //     return null;
  //   } catch (e) {
  //     print('Error getting user by ID: $e');
  //     return null;
  //   }
  // }

  // Get profile name by user ID
  // Future<String> getUsernameById(String userId) async {
  //   try {
  //     User? user = await getUserById(userId);
  //     return user?.profileName ??
  //         userId; // Fallback to userId if profile name isn't available
  //   } catch (e) {
  //     print('Error getting username: $e');
  //     return userId; // Return the userId as fallback
  //   }
  // }
}
