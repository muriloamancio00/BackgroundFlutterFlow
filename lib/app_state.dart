import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _latLngList = prefs
              .getStringList('ff_latLngList')
              ?.map(latLngFromString)
              .withoutNulls ??
          _latLngList;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  List<LatLng> _latLngList = [];
  List<LatLng> get latLngList => _latLngList;
  set latLngList(List<LatLng> value) {
    _latLngList = value;
    prefs.setStringList(
        'ff_latLngList', value.map((x) => x.serialize()).toList());
  }

  void addToLatLngList(LatLng value) {
    latLngList.add(value);
    prefs.setStringList(
        'ff_latLngList', _latLngList.map((x) => x.serialize()).toList());
  }

  void removeFromLatLngList(LatLng value) {
    latLngList.remove(value);
    prefs.setStringList(
        'ff_latLngList', _latLngList.map((x) => x.serialize()).toList());
  }

  void removeAtIndexFromLatLngList(int index) {
    latLngList.removeAt(index);
    prefs.setStringList(
        'ff_latLngList', _latLngList.map((x) => x.serialize()).toList());
  }

  void updateLatLngListAtIndex(
    int index,
    LatLng Function(LatLng) updateFn,
  ) {
    latLngList[index] = updateFn(_latLngList[index]);
    prefs.setStringList(
        'ff_latLngList', _latLngList.map((x) => x.serialize()).toList());
  }

  void insertAtIndexInLatLngList(int index, LatLng value) {
    latLngList.insert(index, value);
    prefs.setStringList(
        'ff_latLngList', _latLngList.map((x) => x.serialize()).toList());
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
