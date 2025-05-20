import 'package:flutter/material.dart';
import 'package:parkx/models/estado.dart';
import 'package:parkx/models/parking.dart';

class ParkingProvider with ChangeNotifier {
  Parking? _parking;
  bool _selected = false;
  Estado? _estado;

  Parking get parking => _parking!;
  bool get selected => _selected;
  Estado get estado => _estado!;

  set parking(Parking parking) {
    _parking = parking;
    notifyListeners();
  }

  set estado(Estado estado) {
    _estado = estado;
    notifyListeners();
  }

  set selected(bool value) {
    _selected = value;
    notifyListeners();
  }
}
