import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkInfo {
  final Connectivity connectivity;

  NetworkInfo(this.connectivity);

  Future<bool> isConnected() async {
    final connectivityResult = await connectivity.checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) return false;
    return true;
  }

  Stream<bool> get onConnectivityChanged {
    return connectivity.onConnectivityChanged.map((connectivityResult) {
      if (connectivityResult.contains(ConnectivityResult.none)) return false;
      return true;
    });
  }
}
