import 'package:flutter_bloc/flutter_bloc.dart';
import 'parking_event.dart';
import 'parking_state.dart';
import '../../models/parking.dart';
import '../../services/parking_service.dart';


class ParkingBloc extends Bloc<ParkingEvent, ParkingState> {
  final ParkingService parkingService;

  ParkingBloc({required this.parkingService}) : super(ParkingInitial()) {
    on<StartParking>(_onStartParking);
    on<LoadActiveParkings>(_onLoadActiveParkings);
    on<StopParking>(_onStopParking);
  }

  Future<void> _onStartParking(StartParking event, Emitter<ParkingState> emit) async {
    emit(ParkingLoading());
    try {
      await parkingService.startParking(event.parking);
      emit(ParkingStartedSuccess());
      add(LoadActiveParkings(event.parking.personId));
    } catch (e) {
      emit(ParkingError('Kunde inte starta parkering: $e'));
    }
  }

  Future<void> _onLoadActiveParkings(LoadActiveParkings event, Emitter<ParkingState> emit) async {
    emit(ParkingLoading());
    try {
      final parkings = await parkingService.getParkingsByPerson(event.personId);
      emit(ParkingLoaded(parkings.where((p) => p.endTime == null).toList()));
    } catch (e) {
      emit(ParkingError('Kunde inte hämta aktiva parkeringar: $e'));
    }
  }

  Future<void> _onStopParking(StopParking event, Emitter<ParkingState> emit) async {
    emit(ParkingLoading());
    try {
      await parkingService.stopParking(event.parkingId, event.endTime);
      emit(ParkingStoppedSuccess());
    } catch (e) {
      emit(ParkingError('Kunde inte stoppa parkering: $e'));
    }
  }
}