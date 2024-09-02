import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';
import 'app-providers/auth_provider.dart';
import 'app-providers/games.provider.dart';
import 'app-providers/main_provider.dart';
import 'app-providers/post_provider.dart';
import 'commom/custom-colors.dart';
import 'screens/home.dart';
import 'screens/home/tabs.dart';
import 'theme-data.dart';

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   await Firebase.initializeApp();

//   print("Handling a background message: ${message.messageId}");
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  await Firebase.initializeApp().whenComplete(() {
    print('app initialized >>>>');
    runApp(MultiProvider(
        providers: [
          ChangeNotifierProvider<AllGamesProvider>(
              create: (_) => AllGamesProvider()),
          ChangeNotifierProvider<PostProvider>(create: (_) => PostProvider()),
          ChangeNotifierProvider<UserAuthProvider>(
              create: (_) => UserAuthProvider())
        ],
        child: new MaterialApp(
          home: new MyApp(),
        )));
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    // provider.getAllGames();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => initFlutterLocalNotification());
    super.initState();
  }

  initFlutterLocalNotification() async {
    await FirebaseMessaging.instance.subscribeToTopic("newGamePost");

    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
    // bool disableJobAlerts =
    //     await localStorage.getBoolData(name: "jobAlertPush") ?? false;
    // bool disableNewMessageAlert =
    //     await localStorage.getBoolData(name: "newMessagePush") ?? false;
    // bool showAlertJobNearby =
    //     await localStorage.getBoolData(name: "showAlertJobNearby") ?? false;

//     FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//         FlutterLocalNotificationsPlugin();
// // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('gigplace');
//     // final IOSInitializationSettings initializationSettingsIOS =
//     //     IOSInitializationSettings(
//     //         // onDidReceiveLocalNotification: onDidReceiveLocalNotification
//     //         );
//     // final MacOSInitializationSettings initializationSettingsMacOS =
//     //     MacOSInitializationSettings();
//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//       // iOS: initializationSettingsIOS,
//       // macOS: initializationSettingsMacOS
//     );
//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//     );

//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'high_important_channel4', // id
//       'High Importance Notifications4', // title

//       importance: Importance.max,
//     );

//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);

//  init local notification before listening to message
    FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
      print('mesage event received $event');

      // if (event.data['type'] == 'job') {
      //   if (c.userData.value.role == "service-provider") {
      //     jobService.fetchAllJobs();
      //     jobService.fetchAppliedJobs();
      //     jobService.fetchApprovedJobs();
      //   } else {
      //     jobService.fetchMyOpenJobs();
      //     jobService.fetchMyJobs();

      //     jobService.fetchActiveApplicants();
      //   }
      // } else if (event.data['type'] == 'chat') {
      //   messageService.fetchRecentChats();
      // }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });
  }

  void selectNotification(String? payload) {}

//  void onDidReceiveLocalNotification(String? payload) {}

  callNotifification(message, channel) async {
    try {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      // print('small icon  ${android.smallIcon}');
      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.

      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id, channel.name,
              channelDescription: 'your channel description',
              priority: Priority.high,
              color: CustomColors.backgroundColors,
              ticker: 'ticker',
              // sound: RawResourceAndroidNotificationSound('evisit_tone'),
              playSound: true,

              icon: android.smallIcon,
              // other properties...
            ),
          ));
    } catch (e) {
      print('error calling notification $e');
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AllGamesProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gamerz',
      navigatorObservers: [FlutterSmartDialog.observer],
      builder: FlutterSmartDialog.init(),
      theme: ThemeData(
          brightness: Brightness.dark,
          fontFamily: 'BigSpace',
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primaryColor: Colors.black,
          iconTheme: IconThemeData(color: Color(0xffE91E63))),
      routes: {'/': (BuildContext context) => NavigationTabs(provider)},
    );
  }
}
