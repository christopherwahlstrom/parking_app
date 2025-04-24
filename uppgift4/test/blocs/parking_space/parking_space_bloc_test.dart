import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:parking_app_uppgift4/blocs/parking_space/parking_space_bloc.dart';
import 'package:parking_app_uppgift4/blocs/parking_space/parking_space_event.dart';
import 'package:parking_app_uppgift4/blocs/parking_space/parking_space_state.dart';
import 'package:parking_app_uppgift4/models/parking_space.dart';
import 'package:parking_app_uppgift4/services/parking_space_service.dart';

class MockParkingSpaceService extends Mock implements ParkingSpaceService {}

void main() {
  late MockParkingSpaceService mockParkingSpaceService;
  late ParkingSpaceBloc bloc;

  setUp(() {
    mockParkingSpaceService = MockParkingSpaceService();
    bloc = ParkingSpaceBloc(parkingSpaceService: mockParkingSpaceService);
  });

  tearDown(() {
    bloc.close();
  });

  final parkingSpaces = [
    ParkingSpace(id: '1', adress: 'Testgatan 1', prisPerTimme: 10.0),
    ParkingSpace(id: '2', adress: 'Testgatan 2', prisPerTimme: 20.0),
  ];

  blocTest<ParkingSpaceBloc, ParkingSpaceState>(
    'emits [ParkingSpaceLoading, ParkingSpaceLoaded] on success',
    build: () {
      when(() => mockParkingSpaceService.getAllParkingSpaces())
          .thenAnswer((_) async => parkingSpaces);
      return bloc;
    },
    act: (bloc) => bloc.add(LoadParkingSpaces()),
    expect: () => [
      isA<ParkingSpaceLoading>(),
      isA<ParkingSpaceLoaded>(),
    ],
  );

  blocTest<ParkingSpaceBloc, ParkingSpaceState>(
    'emits [ParkingSpaceLoading, ParkingSpaceError] on failure',
    build: () {
      when(() => mockParkingSpaceService.getAllParkingSpaces())
          .thenThrow(Exception('error'));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadParkingSpaces()),
    expect: () => [
      isA<ParkingSpaceLoading>(),
      isA<ParkingSpaceError>(),
    ],
  );
}