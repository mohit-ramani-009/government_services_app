
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  bool noInternet = true;

  void changeConnectionStatus(bool noInternet) {
    this.noInternet = noInternet;
    notifyListeners();
  }
}
