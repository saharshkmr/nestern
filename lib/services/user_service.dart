// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart' as auth;
// import 'package:nestern/models/Student.dart';
// import 'package:nestern/models/Employee.dart';

// class UserService {
//   final CollectionReference _studentsCollection = FirebaseFirestore.instance
//   .collection('nestern')
//   .doc('users')
//   .collection('students');


//   final CollectionReference _employeesCollection = FirebaseFirestore.instance
//   .collection('nestern')
//   .doc('users')
//   .collection('employee');

//   final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

//     // ------------------- GET CURRENT USER ID -------------------
//   // This getter returns the current logged-in user's ID using FirebaseAuth.
//   String? get currentUserId => auth.FirebaseAuth.instance.currentUser?.uid;


//   // ------------------- STUDENT SIGNUP -------------------
//   Future<Student?> studentSignUp(String email, String password, Student student) async {
//     try {
//       auth.UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       auth.User? user = userCredential.user;

//       if (user != null) {
//         // Save student data in Firestore
//         student = student.copyWith(id: user.uid);
//         await _usersCollection.doc(user.uid).set({
//           ...student.toJson(),
//           'role': 'student',
//         });
//         return student;
//       }
//       return null;
//     } on auth.FirebaseAuthException catch (e) {
//       print('FirebaseAuthException during student signup: ${e.code} - ${e.message}');
//       throw Exception(e.message);
//     } catch (e) {
//       print('Error during student signup: $e');
//       throw Exception('An unknown error occurred during student signup.');
//     }
//   }

//   // ------------------- EMPLOYEE SIGNUP -------------------
//   Future<Employee?> employeeSignUp(String email, String password, Employee employee) async {
//     try {
//       auth.UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       auth.User? user = userCredential.user;

//       if (user != null) {
//         // Save employee data in Firestore
//         employee = employee.copyWith(id: user.uid);
//         await _usersCollection.doc(user.uid).set({
//           ...employee.toJson(),
//           'role': 'employee',
//         });
//         return employee;
//       }
//       return null;
//     } on auth.FirebaseAuthException catch (e) {
//       print('FirebaseAuthException during employee signup: ${e.code} - ${e.message}');
//       throw Exception(e.message);
//     } catch (e) {
//       print('Error during employee signup: $e');
//       throw Exception('An unknown error occurred during employee signup.');
//     }
//   }
// }