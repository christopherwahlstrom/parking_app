import '../../models/parking_space.dart';

abstract class ParkingSpaceState {}

class ParkingSpaceInitial extends ParkingSpaceState {}

class ParkingSpaceLoading extends ParkingSpaceState {}

class ParkingSpaceLoaded extends ParkingSpaceState {
  final List<ParkingSpace> parkingSpaces;

  ParkingSpaceLoaded(this.parkingSpaces);
}

class ParkingSpaceError extends ParkingSpaceState {
  final String message;

  ParkingSpaceError(this.message);
}
