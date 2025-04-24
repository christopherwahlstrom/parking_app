import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:parking_app_uppgift4/blocs/vehicle/vehicle_bloc.dart';
import 'package:parking_app_uppgift4/blocs/vehicle/vehicle_event.dart';
import 'package:parking_app_uppgift4/blocs/vehicle/vehicle_state.dart';
import 'package:parking_app_uppgift4/models/vehicle.dart';
import 'package:parking_app_uppgift4/services/vehicle_service.dart';
import 'package:parking_app_uppgift4/services/person_service.dart';

// Mock-klasser
class MockVehicleService extends Mock implements VehicleService {}
class MockPersonService extends Mock implements PersonService {}

void main() {
  late MockVehicleService mockVehicleService;
  late MockPersonService mockPersonService;
  late VehicleBloc bloc;

  setUp(() {
    mockVehicleService = MockVehicleService();
    mockPersonService = MockPersonService();
    bloc = VehicleBloc(
      vehicleService: mockVehicleService,
      personService: mockPersonService,
    );
  });

  tearDown(() {
    bloc.close();
  });

  const personId = 'test-person-id';
  final vehicles = [
    Vehicle(
      id: '1',
      ownerId: personId,
      registrationNumber: 'ABC123',
      type: 'Volvo',
    ),
  ];

  blocTest<VehicleBloc, VehicleState>(
    'emits [VehicleLoading, VehicleLoaded] när LoadVehicles lyckas',
    build: () {
      when(() => mockVehicleService.getAllVehicles())
        .thenAnswer((_) async => vehicles);
      return bloc;
    },
    act: (bloc) => bloc.add(LoadVehicles(personId)),
    expect: () => [
      isA<VehicleLoading>(),
      predicate<VehicleLoaded>((state) =>
        state.vehicles.length == 1 &&
        state.vehicles.first.registrationNumber == 'ABC123'
      ),
    ],
  );

  blocTest<VehicleBloc, VehicleState>(
    'emits [VehicleLoading, VehicleError] när getAllVehicles kastar',
    build: () {
      when(() => mockVehicleService.getAllVehicles())
        .thenThrow(Exception('network error'));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadVehicles(personId)),
    expect: () => [
      isA<VehicleLoading>(),
      isA<VehicleError>(),
    ],
  );
}
