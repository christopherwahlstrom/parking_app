import 'package:server/handlers/person_handlers.dart';
import 'package:server/handlers/vehicle_handlers.dart';
import 'package:server/handlers/parking_space_handlers.dart';
import 'package:server/handlers/parking_handlers.dart';
import 'package:shelf_router/shelf_router.dart';

class ServerConfig {
  ServerConfig._privateConstructor() {
    initialize();
  }

  static final ServerConfig _instance = ServerConfig._privateConstructor();

  static ServerConfig get instance => _instance;

  late Router router;

  Future initialize() async {
    router = Router();

    // Person routes
    router.post('/persons', postPersonHandler);
    router.get('/persons', getPersonsHandler);
    router.get('/persons/<id>', getPersonHandler);
    router.put('/persons/<id>', updatePersonHandler);
    router.delete('/persons/<id>', deletePersonHandler);

    // Vehicle routes
    router.post('/vehicles', postVehicleHandler);
    router.get('/vehicles', getVehiclesHandler);
    router.get('/vehicles/<id>', getVehicleByIdHandler);
    router.put('/vehicles/<id>', updateVehicleHandler);
    router.delete('/vehicles/<id>', deleteVehicleHandler);

    // Parking Space routes
    router.post('/parking_spaces', postParkingSpaceHandler);
    router.get('/parking_spaces', getParkingSpacesHandler);
    router.get('/parking_spaces/<id>', getParkingSpaceByIdHandler);
    router.put('/parking_spaces/<id>', updateParkingSpaceHandler);
    router.delete('/parking_spaces/<id>', deleteParkingSpaceHandler);


    // Parking routes
    router.post('/parkings', postParkingHandler);
    router.get('/parkings', getParkingsHandler);
    router.get('/parkings/<id>', getParkingByIdHandler);
    router.put('/parkings/<id>', updateParkingHandler);
    router.delete('/parkings/<id>', deleteParkingHandler);
  }
}
