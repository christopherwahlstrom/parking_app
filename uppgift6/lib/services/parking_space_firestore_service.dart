import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/parking_space.dart';

class ParkingSpaceFirestoreService {
  final _collection = FirebaseFirestore.instance.collection('parkingSpaces');

  Future<List<ParkingSpace>> getAllParkingSpaces() async {
    final query = await _collection.get();
    return query.docs
        .map((doc) => ParkingSpace.fromJson(doc.data()..['id'] = doc.id))
        .toList();
  }

  Future<ParkingSpace> getParkingSpaceById(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) throw Exception('Parking space not found');
    return ParkingSpace.fromJson(doc.data()!..['id'] = doc.id);
  }
}