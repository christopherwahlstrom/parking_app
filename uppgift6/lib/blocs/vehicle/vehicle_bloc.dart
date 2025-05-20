import 'package:flutter_bloc/flutter_bloc.dart';
import 'vehicle_event.dart';
import 'vehicle_state.dart';
import '../../services/vehicle_firestore_service.dart';
import '../../services/person_firestore_service.dart';
import '../../models/vehicle.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final VehicleFirestoreService vehicleService;
  final PersonFirestoreService personService;

  VehicleBloc({
    required this.vehicleService,
    required this.personService,
  }) : super(VehicleInitial()) {
    on<LoadVehicles>((event, emit) async {
      emit(VehicleLoading());
      await emit.forEach<List<Vehicle>>(
        vehicleService.vehiclesForPersonStream(event.personId),
        onData: (vehicles) => VehicleLoaded(vehicles),
        onError: (error, stackTrace) => VehicleError('Kunde inte ladda fordon: $error'),
      );
    });

    on<AddVehicle>(_onAddVehicle);
    on<UpdateVehicle>(_onUpdateVehicle);
    on<DeleteVehicle>(_onDeleteVehicle);
  }

  Future<void> _onAddVehicle(AddVehicle event, Emitter<VehicleState> emit) async {
    try {
      await vehicleService.createVehicle(event.vehicle);
      await personService.addVehicleToPerson(event.vehicle.ownerId, event.vehicle.id);
    } catch (e) {
      emit(VehicleError('Kunde inte lägga till fordon: $e'));
    }
  }

  Future<void> _onUpdateVehicle(UpdateVehicle event, Emitter<VehicleState> emit) async {
    try {
      await vehicleService.updateVehicle(event.vehicle);
    } catch (e) {
      emit(VehicleError('Kunde inte uppdatera fordon: $e'));
    }
  }

  Future<void> _onDeleteVehicle(DeleteVehicle event, Emitter<VehicleState> emit) async {
    try {
      await vehicleService.deleteVehicle(event.vehicleId);
      await personService.removeVehicleFromPerson(event.personId, event.vehicleId);
    } catch (e) {
      emit(VehicleError('Kunde inte ta bort fordon: $e'));
    }
  }
}
