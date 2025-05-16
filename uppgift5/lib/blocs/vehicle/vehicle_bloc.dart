import 'package:flutter_bloc/flutter_bloc.dart';
import 'vehicle_event.dart';
import 'vehicle_state.dart';
import '../../services/vehicle_firestore_service.dart';
import '../../services/person_firestore_service.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final VehicleFirestoreService vehicleService;
  final PersonFirestoreService personService;

  VehicleBloc({
    required this.vehicleService,
    required this.personService,
  }) : super(VehicleInitial()) {
    on<LoadVehicles>(_onLoadVehicles);
    on<AddVehicle>(_onAddVehicle);
    on<UpdateVehicle>(_onUpdateVehicle);
    on<DeleteVehicle>(_onDeleteVehicle);
  }

  Future<void> _onLoadVehicles(LoadVehicles event, Emitter<VehicleState> emit) async {
    emit(VehicleLoading());
    try {
      final vehicles = await vehicleService.getVehiclesForPerson(event.personId);
      emit(VehicleLoaded(vehicles));
    } catch (e) {
      emit(VehicleError('Kunde inte ladda fordon: $e'));
    }
  }

  Future<void> _onAddVehicle(AddVehicle event, Emitter<VehicleState> emit) async {
    emit(VehicleLoading());
    try {
      await vehicleService.createVehicle(event.vehicle);
      await personService.addVehicleToPerson(event.vehicle.ownerId, event.vehicle.id);
      final vehicles = await vehicleService.getVehiclesForPerson(event.vehicle.ownerId);
      emit(VehicleLoaded(vehicles));
    } catch (e) {
      emit(VehicleError('Kunde inte lägga till fordon: $e'));
    }
  }

  Future<void> _onUpdateVehicle(UpdateVehicle event, Emitter<VehicleState> emit) async {
    emit(VehicleLoading());
    try {
      await vehicleService.updateVehicle(event.vehicle);
      final vehicles = await vehicleService.getVehiclesForPerson(event.vehicle.ownerId);
      emit(VehicleLoaded(vehicles));
    } catch (e) {
      emit(VehicleError('Kunde inte uppdatera fordon: $e'));
    }
  }

  Future<void> _onDeleteVehicle(DeleteVehicle event, Emitter<VehicleState> emit) async {
    emit(VehicleLoading());
    try {
      await vehicleService.deleteVehicle(event.vehicleId);
      await personService.removeVehicleFromPerson(event.personId, event.vehicleId);
      final vehicles = await vehicleService.getVehiclesForPerson(event.personId);
      emit(VehicleLoaded(vehicles));
    } catch (e) {
      emit(VehicleError('Kunde inte ta bort fordon: $e'));
    }
  }
}
