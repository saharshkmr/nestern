import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nestern/models/feedback.dart';
import 'package:nestern/models/job.dart';
import 'package:nestern/models/notification.dart';
import 'package:nestern/models/report.dart';
import 'package:nestern/services/notification_service.dart';

class JobService {
  final CollectionReference _jobsCollection = FirebaseFirestore.instance
      .collection('nestern')
      .doc('jobs')
      .collection('listings');

  final CollectionReference _jobsfeedbackCollection = FirebaseFirestore.instance
      .collection('nestern')
      .doc('jobs')
      .collection('jobsfeedback');

  final CollectionReference _jobsreportCollection = FirebaseFirestore.instance
      .collection('nestern')
      .doc('jobs')
      .collection('jobsreport');

  // Add a reference to the applications collection
  final CollectionReference _applicationsCollection = FirebaseFirestore.instance
      .collection('taurusai')
      .doc('applications')
      .collection('listings');

  // Add your imports and class definition here

  // Existing methods...

  // Add this method to get the count of applied jobs for a user
  Future<int> getAppliedJobsCount(String userId) async {
    // TODO: Replace with actual logic to fetch applied jobs count from your backend or database
    // For now, return a dummy value
    return 0;
  }

  // Add this method to fetch the number of interviews for a user
  Future<int> getInterviewsCount(String userId) async {
    // TODO: Replace with actual implementation to fetch interview count from backend or database
    // For now, return a dummy value
    return 0;
  }


  Future<String> createJobReport(Report report) async {
    try {
      // Add the feedback to the job feedback collection
      DocumentReference docRef = await _jobsreportCollection.add(report.toJson());
      report.id = docRef.id; // Set the feedback ID to the document ID
      await docRef.set(report.toJson());
      return docRef.id;
    } on FirebaseException catch (e) {
      print('Firebase Exception creating job report: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('Error creating job report: $e');
      rethrow;
    }
  }
  

  Future<String> createJobFeedback(Feedback feedback) async {
    try {
      // Add the feedback to the job feedback collection
      DocumentReference docRef = await _jobsfeedbackCollection.add(feedback.toJson());
      feedback.id = docRef.id; // Set the feedback ID to the document ID
      await docRef.set(feedback.toJson());
      return docRef.id;
    } on FirebaseException catch (e) {
      print('Firebase Exception creating job feedback: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('Error creating job feedback: $e');
      rethrow;
    }
  }

  Future<String> createJob(Job job) async {
    try {
      DocumentReference docRef = await _jobsCollection.add(job.toJson());
      job.id = docRef.id; // Set the job ID to the document ID
      await docRef.set(job.toJson());
      return docRef.id;
    } on FirebaseException catch (e) {
      print('Firebase Exception creating job: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('Error creating job: $e');
      rethrow;
    }
  }

  Future<Job?> getJob(String jobId) async {
    try {
      DocumentSnapshot doc = await _jobsCollection.doc(jobId).get();
      return doc.exists
          ? Job.fromJson(doc.data() as Map<String, dynamic>)
          : null;
    } on FirebaseException catch (e) {
      print('Firebase Exception getting job: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      print('Error getting job: $e');
      return null;
    }
  }

  Future<List<Job>> getAllJobs() async {
    try {
      QuerySnapshot snapshot = await _jobsCollection.get();
      return snapshot.docs
          .map((doc) => Job.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } on FirebaseException catch (e) {
      print('Firebase Exception getting all jobs: ${e.code} - ${e.message}');
      return [];
    } catch (e) {
      print('Error getting all jobs: $e');
      return [];
    }
  }

  // Method to get jobs applied by a user
  Future<List<Job>> getJobsAppliedByUser(String userId) async {
    try {
      print('Fetching applications for userId: $userId');
      
      // First fetch all applications for this user
      Query applicationsQuery = _applicationsCollection.where('userId', isEqualTo: userId);
      QuerySnapshot applicationsSnapshot = await applicationsQuery.get();
      print('Found ${applicationsSnapshot.docs.length} applications for user');
      
      if (applicationsSnapshot.docs.isEmpty) {
        return [];
      }
      
      // Extract job IDs from applications
      List<String> jobIds = applicationsSnapshot.docs
          .map((doc) => (doc.data() as Map<String, dynamic>)['jobId'] as String)
          .toList();
      
      print('Job IDs from applications: $jobIds');
      
      // Now fetch the actual job details for these IDs
      List<Job> appliedJobs = [];
      
      // Since Firestore doesn't support direct 'where in' for large arrays,
      // we'll fetch each job individually
      for (String jobId in jobIds) {
        Job? job = await getJob(jobId);
        if (job != null) {
          appliedJobs.add(job);
        }
      }
      
      print('Successfully fetched ${appliedJobs.length} jobs applied by user');
      return appliedJobs;
    } on FirebaseException catch (e) {
      print('Firebase Exception getting applied jobs: ${e.code} - ${e.message}');
      return [];
    } catch (e, stackTrace) {
      print('Error getting applied jobs: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }

  Future<void> updateJob(Job job, Job oldJob) async {
    //Add old job parameter
    try {
      await _jobsCollection.doc(job.id).update(job.toJson());

      if (job != oldJob) {
        NotificationService notificationService = NotificationService();
        Notification notification = Notification(
          id: '',
          type: 'Job Updated',
          content: 'Job ${job.title} has been updated.',
          senderId: job.userId!,
          recipientId: 'all', // Or implement a way to notify relevant users
          timestamp: DateTime.now(),
        );
        await notificationService.createNotification(notification);
      }
    } on FirebaseException catch (e) {
      print('Firebase Exception updating job: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('Error updating job: $e');
      rethrow;
    }
  }

  Future<List<Job>> getJobsCreatedByUser(String userId) async {
    Query query = _jobsCollection.where('userId', isEqualTo: userId);
    QuerySnapshot snapshot = await query.get();
    return snapshot.docs
        .map((doc) => Job.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> deleteJob(String jobId, String userId) async {
    //Add userId parameter
    try {
      await _jobsCollection.doc(jobId).delete();

      NotificationService notificationService = NotificationService();
      Notification notification = Notification(
        id: '',
        type: 'Job Deleted',
        content: 'A job has been deleted.',
        senderId: userId,
        recipientId: 'all', // Or implement a way to notify relevant users
        timestamp: DateTime.now(),
      );
      await notificationService.createNotification(notification);
    } on FirebaseException catch (e) {
      print('Firebase Exception deleting job: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('Error deleting job: $e');
      rethrow;
    }
  }

  Future<List<Job>> searchJobs(String query) async {
    try {
      QuerySnapshot snapshot = await _jobsCollection
          .where('title', isGreaterThanOrEqualTo: query)
          .where('title', isLessThan: '${query}z')
          .get();
      return snapshot.docs
          .map((doc) => Job.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } on FirebaseException catch (e) {
      print('Firebase Exception searching jobs: ${e.code} - ${e.message}');
      return [];
    } catch (e) {
      print('Error searching jobs: $e');
      return [];
    }
  }

  Future<List<Job>> getRecentJobs(
      {int limit = 10, DocumentSnapshot? startAfter}) async {
    try {
      Query query =
          _jobsCollection.orderBy('postedDate', descending: true).limit(limit);

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      QuerySnapshot snapshot = await query.get();
      return snapshot.docs
          .map((doc) => Job.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } on FirebaseException catch (e) {
      print('Firebase Exception getting recent jobs: ${e.code} - ${e.message}');
      return [];
    } catch (e) {
      print('Error getting recent jobs: $e');
      return [];
    }
  }

  Future<void> createJobWithNotification(Job job, String creatorId) async {
    String jobId = await createJob(job);

    NotificationService notificationService = NotificationService();
    Notification notification = Notification(
      id: '',
      type: 'job',
      content: 'New job posted: ${job.title}',
      senderId: creatorId,
      recipientId:
          'all', // You might want to implement a way to notify relevant users
      timestamp: DateTime.now(),
    );
    await notificationService.createNotification(notification);
  }
}