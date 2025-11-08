import 'package:dissaster_mgmnt_app/firebase_options.dart';
import 'package:dissaster_mgmnt_app/view/auth_screens/presentation/sign_up_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Handle background FCM messages
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("📩 Handling background message: ${message.messageId}");
}

// Local notifications plugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Register background FCM handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize local notifications
  const AndroidInitializationSettings initSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initSettings = InitializationSettings(
    android: initSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      print("🔔 Notification clicked: ${response.payload}");
    },
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  // 🔹 Initialize FCM, permissions, and token saving
  Future<void> _initNotifications() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Ask permission
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('🔔 Permission status: ${settings.authorizationStatus}');

    // Get FCM token
    String? token = await messaging.getToken();
    print("📱 FCM Token: $token");

    // ✅ Save token to Firestore (if user logged in)
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && token != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'email': user.email,
        'token': token,
      }, SetOptions(merge: true));
      print("✅ Token saved to Firestore");
    }

    // Keep token updated if refreshed
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'token': newToken});
        print("🔄 Token refreshed and updated in Firestore");
      }
    });

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title ?? "SOS Alert",
          notification.body ?? "Someone nearby needs help!",
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'sos_channel',
              'SOS Alerts',
              channelDescription: 'Channel for SOS emergency notifications',
              importance: Importance.high,
              priority: Priority.high,
            ),
          ),
        );
      }
    });

    // Handle notification tap when app is backgrounded
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("🚀 Notification clicked while backgrounded: ${message.data}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Disaster Management App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      home: const SignUpScreen(),
    );
  }
}
