import 'package:flutter/material.dart';
import '../models/parking.dart';
import '../models/parking_space.dart';
import '../services/parking_service.dart';
import '../services/parking_space_service.dart';

class HistoryView extends StatefulWidget {
  final String personId;

  const HistoryView({required this.personId, super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  List<Parking> _history = [];
  Map<String, ParkingSpace> _spacesById = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final parkings = await ParkingService().getParkingsByPerson(widget.personId);
    final spaces = await ParkingSpaceService().loadSpaces();

    final finished = parkings.where((p) => p.endTime != null).toList();
    final spaceMap = {for (var s in spaces) s.id: s};

    setState(() {
      _history = finished;
      _spacesById = spaceMap;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());

    if (_history.isEmpty) {
      return const Center(child: Text("Inga avslutade parkeringar."));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Historik')),
      body: ListView.builder(
        itemCount: _history.length,
        itemBuilder: (context, index) {
          final parking = _history[index];
          final space = _spacesById[parking.parkingSpaceId];
          final duration = parking.endTime!.difference(parking.startTime);
          final cost = (duration.inMinutes / 60.0) * (space?.prisPerTimme ?? 0);

          return ListTile(
            title: Text(space?.adress ?? 'Okänd plats'),
            subtitle: Text(
              'Från: ${parking.startTime}\nTill: ${parking.endTime}\nTid: ${duration.inMinutes} min\nKostnad: ${cost.toStringAsFixed(2)} kr',
            ),
          );
        },
      ),
    );
  }
}
