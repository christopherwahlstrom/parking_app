import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import '../models/parking.dart';
import '../models/parking_space.dart';
import '../models/vehicle.dart';
import '../services/parking_service.dart';
import '../services/parking_space_service.dart';
import '../services/vehicle_service.dart';
import '../utils/snackbar_service.dart';
import 'package:uuid/uuid.dart';

class ParkingView extends StatefulWidget {
  final String personId;
  final List<String> vehicleIds;

  const ParkingView({
    super.key,
    required this.personId,
    required this.vehicleIds,
  });

  @override
  State<ParkingView> createState() => _ParkingViewState();
}

class _ParkingViewState extends State<ParkingView> {
  List<ParkingSpace> _spaces = [];
  List<Vehicle> _vehicles = [];
  Parking? _activeParking;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final spaces = await ParkingSpaceService().loadSpaces();
      final vehicles = await Future.wait(widget.vehicleIds.map((id) => VehicleService().getVehicleById(id)));
      final validVehicles = vehicles.whereType<Vehicle>().toList();
      final parkings = await ParkingService().getParkingsByPerson(widget.personId);

      setState(() {
        _spaces = spaces;
        _vehicles = validVehicles;
        _activeParking = parkings.firstWhereOrNull((p) => p.endTime == null);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        SnackBarService.showError(context, 'Kunde inte ladda parkeringsdata');
      }
    }
  }

  Future<String?> _selectVehicleDialog() async {
  return await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Välj fordon'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _vehicles.map((v) {
            return Card(
              color: Theme.of(context).cardColor,
              margin: const EdgeInsets.symmetric(vertical: 4),
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.directions_car),
                title: Text(v.registrationNumber),
                subtitle: Text('Typ: ${v.type}'),
                onTap: () => Navigator.pop(context, v.id),
              ),
            );
          }).toList(),
        ),
      ),
    ),
  );
}



    Future<void> _startParking(ParkingSpace space) async {
    if (_vehicles.isEmpty) {
      SnackBarService.showError(context, 'Du har inget registrerat fordon.');
      return;
    }

    String selectedVehicleId;
    if (_vehicles.length == 1) {
      selectedVehicleId = _vehicles.first.id;
    } else {
      final result = await _selectVehicleDialog();
      if (result == null || result.isEmpty) return;
      selectedVehicleId = result;
    }

    final newParking = Parking(
      id: const Uuid().v4(),
      personId: widget.personId, 
      vehicleId: selectedVehicleId,
      parkingSpaceId: space.id,
      startTime: DateTime.now(),
      endTime: null,
    );

    try {
      final created = await ParkingService().startParking(newParking);
      setState(() => _activeParking = created);
      if (mounted) {
        SnackBarService.showSuccess(context, 'Parkering startad!');
      }
    } catch (e) {
      if (mounted) {
        SnackBarService.showError(context, 'Misslyckades med att starta parkering');
      }
    }
  }
  Future<void> _stopParking() async {
    if (_activeParking == null) return;

    try {
      await ParkingService().stopParking(_activeParking!.id);
      setState(() => _activeParking = null);
      if (mounted) {
        SnackBarService.showSuccess(context, 'Parkering avslutad');
      }
    } catch (e) {
      if (mounted) {
        SnackBarService.showError(context, 'Misslyckades med att stoppa parkering');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parkeringsplatser'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_activeParking != null)
            Card(
              margin: const EdgeInsets.all(8),
              color: Theme.of(context).cardColor,
              child: ListTile(
                title: Text('Aktiv parkering i zon: ${_activeParking!.parkingSpace?.adress ?? _activeParking!.parkingSpaceId}'),
                subtitle: Text('Startade: ${_activeParking!.startTime.toString().substring(0, 16)}'),
                trailing: ElevatedButton(
                  onPressed: _stopParking,
                  child: const Text('Stoppa'),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _spaces.length,
                itemBuilder: (context, index) {
                  final space = _spaces[index];
                  return Card(
                    color: Theme.of(context).cardColor,
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      title: Text(space.adress),
                      subtitle: Text('Pris: ${space.prisPerTimme} kr/h'),
                      trailing: ElevatedButton(
                        onPressed: () => _startParking(space),
                        child: const Text('Parkera här'),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
