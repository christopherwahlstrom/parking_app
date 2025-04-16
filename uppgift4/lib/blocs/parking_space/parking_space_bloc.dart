import 'package:flutter_bloc/flutter_bloc.dart';
import 'parking_space_event.dart';
import 'parking_space_state.dart';
import '../../services/parking_space_service.dart';

class ParkingSpaceBloc extends Bloc<ParkingSpaceEvent, ParkingSpaceState> {
  final ParkingSpaceService parkingSpaceService;

  ParkingSpaceBloc({required this.parkingSpaceService}) : super(ParkingSpaceInitial()) {
    on<LoadParkingSpaces>(_onLoadParkingSpaces);
  }

  Future<void> _onLoadParkingSpaces(
    LoadParkingSpaces event,
    Emitter<ParkingSpaceState> emit,
  ) async {
    emit(ParkingSpaceLoading());

    try {
      final spaces = await parkingSpaceService.getAllParkingSpaces();
      emit(ParkingSpaceLoaded(spaces));
    } catch (e) {
      emit(ParkingSpaceError('Kunde inte hämta parkeringszoner: $e'));
    }
  }
}
