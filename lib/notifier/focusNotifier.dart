
import 'package:flutter/material.dart';

class FocusNotifier with ChangeNotifier {

bool _onFocus;
FocusNotifier(this._onFocus);


bool get onFocus => _onFocus;

  void setOnFocus(bool focus){
    _onFocus = focus;
    notifyListeners();
  }
}