import '../../models/parking.dart';

abstract class ParkingEvent {}

class StartParking extends ParkingEvent {
  final Parking parking;

  StartParking(this.parking);
}

class LoadActiveParkings extends ParkingEvent {
  final String personId;

  LoadActiveParkings(this.personId);
}

class StopParking extends ParkingEvent {
  final String parkingId;
  final DateTime endTime;

  StopParking({required this.parkingId, required this.endTime});
}
