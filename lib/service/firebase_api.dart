import 'package:eduflex/main.dart';
import 'package:eduflex/pages/chat.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();

    final fCmToken = await _firebaseMessaging.getToken();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', fCmToken!);
    print('Token: $fCmToken');

    initPushNotification();
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    navgatorKey.currentState
        ?.push(MaterialPageRoute(builder: (context) => Chat()));
    // navgatorKey.currentState?.pushNamed('/notification', arguments: message);
  }

  Future initPushNotification() async {
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
}
