import 'dart:async';
import 'package:connectivity/connectivity.dart';

class Network{
  static bool isAvailable = false;
  // ignore: unused_field, cancel_subscriptions
  static StreamSubscription<ConnectivityResult> _streamSubscription;

  static Future<bool> isNetworkAvailable() async{
    var result = await Connectivity().checkConnectivity();
    Network.isAvailable = result != ConnectivityResult.none;
    return Future.value(isAvailable);
  }

  static void init(){
    isNetworkAvailable().then((value){
      Network.isAvailable = value;
    });
    Network._streamSubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async{ 
      isNetworkAvailable();
    });
  }

  static void registerSubscription(Function callback){
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async{
      callback();
    });
  }
}