import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/parking.dart';

class ParkingFirestoreService {
  final _parkingCollection = FirebaseFirestore.instance.collection('parkings');

  Future<List<Parking>> getParkingsByPerson(String personId) async {
    final query = await _parkingCollection.where('personId', isEqualTo: personId).get();
    return query.docs.map((doc) => Parking.fromJson(doc.data()..['id'] = doc.id)).toList();
  }

  Future<Parking> startParking(Parking parking) async {
    final docRef = await _parkingCollection.add(parking.toJson());
    final doc = await docRef.get();
    return Parking.fromJson(doc.data()!..['id'] = doc.id);
  }

  Future<Parking> stopParking(String parkingId) async {
    final endTime = DateTime.now();
    await _parkingCollection.doc(parkingId).update({'endTime': endTime});
    final doc = await _parkingCollection.doc(parkingId).get();
    return Parking.fromJson(doc.data()!..['id'] = doc.id);
  }

   Stream<List<Parking>> parkingsForPersonStream(String personId) {
    return _parkingCollection
        .where('personId', isEqualTo: personId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Parking.fromJson(doc.data()..['id'] = doc.id))
            .toList());
  }
}