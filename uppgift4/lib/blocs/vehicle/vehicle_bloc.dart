import 'package:flutter_bloc/flutter_bloc.dart';
import 'vehicle_event.dart';
import 'vehicle_state.dart';
import '../../services/vehicle_service.dart';
import '../../models/vehicle.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final VehicleService vehicleService;

  VehicleBloc({required this.vehicleService}) : super(VehicleInitial()) {
    on<LoadVehicles>(_onLoadVehicles);
    on<AddVehicle>(_onAddVehicle);
    on<UpdateVehicle>(_onUpdateVehicle);
    on<DeleteVehicle>(_onDeleteVehicle);
  }

  Future<void> _onLoadVehicles(LoadVehicles event, Emitter<VehicleState> emit) async {
    emit(VehicleLoading());
    try {
      final allVehicles = await vehicleService.getAllVehicles();
      final personVehicles = allVehicles.where((v) => v.ownerId == event.personId).toList();
      emit(VehicleLoaded(personVehicles));
    } catch (e) {
      emit(VehicleError('Kunde inte ladda fordon: $e'));
    }
  }

  Future<void> _onAddVehicle(AddVehicle event, Emitter<VehicleState> emit) async {
    try {
      await vehicleService.createVehicle(event.vehicle);
      // Emitera ett success state direkt
      emit(VehicleAddedSuccess());
      // Ladda om listan med fordon
      add(LoadVehicles(event.vehicle.ownerId));
    } catch (e) {
      emit(VehicleError('Kunde inte lägga till fordon: $e'));
    }
  }

  Future<void> _onUpdateVehicle(UpdateVehicle event, Emitter<VehicleState> emit) async {
    try {
      await vehicleService.updateVehicle(event.vehicle);
      add(LoadVehicles(event.vehicle.ownerId));
    } catch (e) {
      emit(VehicleError('Kunde inte uppdatera fordon: $e'));
    }
  }

  Future<void> _onDeleteVehicle(DeleteVehicle event, Emitter<VehicleState> emit) async {
    try {
      await vehicleService.deleteVehicle(event.vehicleId);
      add(LoadVehicles(event.personId));
    } catch (e) {
      emit(VehicleError('Kunde inte ta bort fordon: $e'));
    }
  }
}
