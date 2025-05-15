import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/person.dart';

class PersonFirestoreService {
  final _personCollection = FirebaseFirestore.instance.collection('persons');

  Future<Person?> getPersonById(String id) async {
    final doc = await _personCollection.doc(id).get();
    if (doc.exists) {
      return Person.fromJson(doc.data()!);
    }
    return null;
  }

  Future<Person?> getPersonByName(String name) async {
    final query = await _personCollection.where('name', isEqualTo: name).get();
    if (query.docs.isNotEmpty) {
      return Person.fromJson(query.docs.first.data());
    }
    return null;
  }

  Future<bool> createPerson(Person person) async {
    try {
      await _personCollection.doc(person.id).set(person.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updatePerson(Person person) async {
    try {
      await _personCollection.doc(person.id).update(person.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> removeVehicleFromPerson(String personId, String vehicleId) async {
    final doc = await _personCollection.doc(personId).get();
    if (doc.exists) {
      final person = Person.fromJson(doc.data()!);
      person.vehicleIds.remove(vehicleId);
      await updatePerson(person);
    }
  }

  Future<void> addVehicleToPerson(String personId, String vehicleId) async {
    final doc = await _personCollection.doc(personId).get();
    if (doc.exists) {
      final person = Person.fromJson(doc.data()!);
      if (!person.vehicleIds.contains(vehicleId)) {
        person.vehicleIds.add(vehicleId);
        await updatePerson(person);
      }
    }
  }
}