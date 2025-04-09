import '../../models/vehicle.dart';

abstract class VehicleEvent {}

class LoadVehicles extends VehicleEvent {
  final String personId;
  LoadVehicles(this.personId);
}

class AddVehicle extends VehicleEvent {
  final Vehicle vehicle;
  AddVehicle(this.vehicle);
}

class UpdateVehicle extends VehicleEvent {
  final Vehicle vehicle;
  UpdateVehicle(this.vehicle);
}

class DeleteVehicle extends VehicleEvent {
  final String vehicleId;
  final String personId;
  DeleteVehicle({required this.vehicleId, required this.personId});
}
