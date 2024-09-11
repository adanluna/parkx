import 'package:flutter/foundation.dart';
import 'package:parkx/models/wallet.dart';

class WalletProvider with ChangeNotifier {
  Wallet? _wallet;

  set wallet(Wallet? wallet) {
    _wallet = wallet;
    notifyListeners();
  }

  Wallet? get wallet => _wallet;

  void clear() {
    _wallet = null;
    notifyListeners();
  }
}
