import 'package:flutter/material.dart';
import '../models/parking.dart';
import '../models/parking_space.dart';
import '../services/parking_service.dart';
import '../services/parking_space_service.dart';
import 'package:collection/collection.dart';


class ParkingView extends StatefulWidget {
  final String personId;

  const ParkingView({super.key, required this.personId});

  @override
  State<ParkingView> createState() => _ParkingViewState();
}

class _ParkingViewState extends State<ParkingView> {
  List<ParkingSpace> _spaces = [];
  Parking? _activeParking;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSpacesAndActiveParking();
  }

  Future<void> _loadSpacesAndActiveParking() async {
    final spaces = await ParkingSpaceService().loadSpaces();
    final parkings = await ParkingService().getParkingsByPerson(widget.personId);

    setState(() {
      _spaces = spaces;
      _activeParking = parkings.firstWhereOrNull((p) => p.sluttid == null);
      _isLoading = false;
    });
  }

  Future<void> _startParking(ParkingSpace space) async {
    final newParking = Parking(
      id: '', 
      vehicleId: 'TODO', 
      parkingSpaceId: space.id,
      starttid: DateTime.now(),
      sluttid: null,
    );
    final created = await ParkingService().startParking(newParking);
    setState(() => _activeParking = created);
  }

  Future<void> _stopParking() async {
    if (_activeParking == null) return;
    await ParkingService().stopParking(_activeParking!.id);
    setState(() => _activeParking = null);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(title: const Text('Parkering')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_activeParking != null)
            Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                title: Text('Aktiv parkering i zon ${_activeParking!.parkingSpaceId}'),
                subtitle: Text('Startade: ${_activeParking!.starttid}'),
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
