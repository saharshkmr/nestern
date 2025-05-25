import 'package:cloud_firestore/cloud_firestore.dart';

class LocationService {
  // Follow the same structure as JobService with nested collection
  final CollectionReference _locationsCollection = FirebaseFirestore.instance
      .collection('nestern')
      .doc('courses')
      .collection('locations');

  // Get all available locations
  Future<List<String>> getLocations() async {
    try {
      final QuerySnapshot snapshot = await _locationsCollection
          .orderBy('name')
          .get();

      List<String> locations = snapshot.docs
          .map((doc) => (doc.data() as Map<String, dynamic>)['name'] as String)
          .toList();

      // Always add the "Add New Location" option at the end
      locations.add('Add New Location');
      
      return locations;
    } on FirebaseException catch (e) {
      print('Firebase Exception fetching locations: ${e.code} - ${e.message}');
      // Return default locations if there's an error
      return [
        'DevelUp COE, Peenya',
        'TechHub, Whitefield',
        'Innovation Center, Electronic City',
        'Learning Center, Koramangala',
        'Add New Location'
      ];
    } catch (e) {
      print('Error fetching locations: $e');
      // Return default locations if there's an error
      return [
        'DevelUp COE, Peenya',
        'TechHub, Whitefield',
        'Innovation Center, Electronic City',
        'Learning Center, Koramangala',
        'Add New Location'
      ];
    }
  }

  // Add a new location
  Future<String> addLocation(String locationName) async {
    try {
      // Check if location already exists
      final QuerySnapshot existingLocation = await _locationsCollection
          .where('name', isEqualTo: locationName)
          .limit(1)
          .get();

      if (existingLocation.docs.isNotEmpty) {
        // Location already exists, return its ID
        return existingLocation.docs.first.id;
      }

      // Add new location
      DocumentReference docRef = await _locationsCollection.add({
        'name': locationName,
        'createdAt': FieldValue.serverTimestamp(),
      });
      
      return docRef.id;
    } on FirebaseException catch (e) {
      print('Firebase Exception adding location: ${e.code} - ${e.message}');
      throw Exception('Failed to add location: $e');
    } catch (e) {
      print('Error adding location: $e');
      throw Exception('Failed to add location: $e');
    }
  }

  // Get location by ID
  Future<String?> getLocationById(String locationId) async {
    try {
      final DocumentSnapshot doc = await _locationsCollection
          .doc(locationId)
          .get();

      if (doc.exists) {
        return (doc.data() as Map<String, dynamic>)['name'] as String;
      }
      return null;
    } on FirebaseException catch (e) {
      print('Firebase Exception fetching location by ID: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      print('Error fetching location by ID: $e');
      return null;
    }
  }

  // Update a location
  Future<void> updateLocation(String locationId, String newName) async {
    try {
      await _locationsCollection.doc(locationId).update({
        'name': newName,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch (e) {
      print('Firebase Exception updating location: ${e.code} - ${e.message}');
      throw Exception('Failed to update location: $e');
    } catch (e) {
      print('Error updating location: $e');
      throw Exception('Failed to update location: $e');
    }
  }

  // Delete a location
  Future<void> deleteLocation(String locationId) async {
    try {
      await _locationsCollection.doc(locationId).delete();
    } on FirebaseException catch (e) {
      print('Firebase Exception deleting location: ${e.code} - ${e.message}');
      throw Exception('Failed to delete location: $e');
    } catch (e) {
      print('Error deleting location: $e');
      throw Exception('Failed to delete location: $e');
    }
  }
}