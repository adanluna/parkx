import 'package:flutter/material.dart';
import 'package:parkx/models/parking.dart';

class ParkingProvider with ChangeNotifier {
  Parking? _parking;
  bool _selected = false;

  Parking get parking => _parking!;
  bool get selected => _selected;

  set parking(Parking parking) {
    _parking = parking;
    notifyListeners();
  }

  set selected(bool value) {
    _selected = value;
    notifyListeners();
  }
}
