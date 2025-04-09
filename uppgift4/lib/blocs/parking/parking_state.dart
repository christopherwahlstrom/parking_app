import '../../models/parking.dart';

abstract class ParkingState {}

class ParkingInitial extends ParkingState {}

class ParkingLoading extends ParkingState {}

class ParkingStartedSuccess extends ParkingState {}

class ParkingStoppedSuccess extends ParkingState {}

class ParkingLoaded extends ParkingState {
  final List<Parking> parkings;
  
    ParkingLoaded(this.parkings);
}

class ParkingError extends ParkingState {
  final String message;

  ParkingError(this.message);
}

