import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vehicle.dart';

class VehicleFirestoreService {
  final _vehicleCollection = FirebaseFirestore.instance.collection('vehicles');

  Future<Vehicle?> getVehicleById(String id) async {
    final doc = await _vehicleCollection.doc(id).get();
    if (doc.exists) {
      return Vehicle.fromJson(doc.data()!);
    }
    return null;
  }

  Future<Vehicle?> createVehicle(Vehicle vehicle) async {
    try {
      await _vehicleCollection.doc(vehicle.id).set(vehicle.toJson());
      return vehicle;
    } catch (e) {
      return null;
    }
  }

  Future<void> updateVehicle(Vehicle vehicle) async {
    await _vehicleCollection.doc(vehicle.id).update(vehicle.toJson());
  }

  Future<void> deleteVehicle(String id) async {
    await _vehicleCollection.doc(id).delete();
  }

  Future<List<Vehicle>> getAllVehicles() async {
    final query = await _vehicleCollection.get();
    return query.docs.map((doc) => Vehicle.fromJson(doc.data())).toList();
  }

    Future<List<Vehicle>> getVehiclesForPerson(String ownerId) async {
    try {
      final query = await _vehicleCollection.where('ownerId', isEqualTo: ownerId).get();
      print("VehicleFirestoreService: Fick ${query.docs.length} fordon för ownerId $ownerId");
      return query.docs.map((doc) => Vehicle.fromJson(doc.data())).toList();
    } catch (e) {
      print("VehicleFirestoreService: Fel vid hämtning av fordon: $e");
      return []; // Returnera alltid tom lista vid fel
    }
  }
}
