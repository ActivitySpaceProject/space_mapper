import 'dart:async';

import 'package:asm/model/spacetime_observation.dart';
import 'package:asm/database/database.dart';
import 'package:asm/bloc/block.dart';

class SpacetimeObservationBloc implements Bloc {
  final _spacetimeObservationController = StreamController<List<SpacetimeObservation>>.broadcast();

  get spacetimeObservations => _spacetimeObservationController.stream;

  dispose() {
    _spacetimeObservationController.close();
  }

  getClients() async {
    _spacetimeObservationController.sink.add(await DBProvider.db.getAllSpacetimeObservations());
  }

  SpacetimeObservationBloc() {
    getClients();
  }
  
  delete(int id) {
    DBProvider.db.deleteSpacetimeObservation(id);
    getClients();
  }

  add(SpacetimeObservation spacetimeObservation) {
    DBProvider.db.newSpacetimeObservation(spacetimeObservation);
    getClients();
  }
}