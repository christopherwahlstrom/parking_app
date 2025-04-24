import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:parking_app_uppgift4/blocs/parking/parking_bloc.dart';
import 'package:parking_app_uppgift4/blocs/parking/parking_event.dart';
import 'package:parking_app_uppgift4/blocs/parking/parking_state.dart';
import 'package:parking_app_uppgift4/models/parking.dart';

import 'package:parking_app_uppgift4/services/parking_service.dart';



class MockParkingService extends Mock implements ParkingService {}

void main() {
  late MockParkingService mockParkingService;
  late ParkingBloc parkingBloc;

  setUp(() {
    mockParkingService = MockParkingService();
    parkingBloc = ParkingBloc(parkingService: mockParkingService);
  });

  tearDown(() {
    parkingBloc.close();
  });

  group('ParkingBloc', () {
    const personId = 'test-person-id';
    final parkingList = <Parking>[
      Parking(
        id: '1',
        personId: personId,
        vehicleId: 'v1',
        parkingSpaceId: 'ps1',
        startTime: DateTime.now(),
      ),
    ];

    blocTest<ParkingBloc, ParkingState>(
      'emits [ParkingLoading, ParkingLoaded] on successful LoadActiveParkings',
      build: () {
        when(() => mockParkingService.getParkingsByPerson(personId))
            .thenAnswer((_) async => parkingList);
        return parkingBloc;
      },
      act: (bloc) => bloc.add(LoadActiveParkings(personId)),
      expect: () => [
        isA<ParkingLoading>(),
        isA<ParkingLoaded>(),
      ],
    );

    blocTest<ParkingBloc, ParkingState>(
      'emits [ParkingLoading, ParkingError] on failed LoadActiveParkings',
      build: () {
        when(() => mockParkingService.getParkingsByPerson(personId))
            .thenThrow(Exception('error'));
        return parkingBloc;
      },
      act: (bloc) => bloc.add(LoadActiveParkings(personId)),
      expect: () => [
        isA<ParkingLoading>(),
        isA<ParkingError>(),
      ],
    );
  });
}