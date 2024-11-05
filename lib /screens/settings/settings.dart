import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import '../../app-providers/auth_provider.dart';
import '../../helpers/customColors.dart';
import '../../service/local-storage.dart';
import '../authentication/login.dart';

class Setting extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SettingsState();
  }
}

class SettingsState extends State<Setting> {
  LocalStorage localStorage = LocalStorage();
  bool disableNewPostAlert = false;
  bool newGamerzPost = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getValues();
    });
    super.initState();
  }

  logout() async {
    final navigatorState = Navigator.of(context);
    final authProvider = Provider.of<UserAuthProvider>(context, listen: false);
    await authProvider.logout();
    navigatorState
        .pushReplacement(MaterialPageRoute(builder: (_) => const Login()));
  }

  confirmLogout() async {
    // if (_selectedIndex != 0) {
    //   setState(() {
    //     _selectedIndex = 0;
    //   });
    //   return false;
    // }
    return (await showDialog(
          context: context,
          builder: (context) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: AlertDialog(
              title: const Text(
                'Are You Sure You Want To Logout?',
                style: TextStyle(
                    fontSize: 20, color: Color.fromARGB(168, 233, 30, 98)),
              ),
              content: const Text(
                'Sorry to see you go. You\'re always welcome back!🙂',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: const Color.fromARGB(150, 0, 0, 0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'Yes',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                    logout();
                  },
                ),
                TextButton(
                  child: const Text(
                    'No',
                    style: TextStyle(color: CustomColors.PrimaryColor),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            ),
          ),
        )) ??
        false;
  }

  getValues() async {
    bool cachedValue1 =
        await localStorage.getBoolData(name: "disableNewPostAlert") ?? false;
    bool cachedValue2 =
        await localStorage.getBoolData(name: "newGamerzPostPush") ?? false;

    // bool cachedValue3 =
    await localStorage.getBoolData(name: "showAlertJobNearby") ?? false;
    setState(() {
      disableNewPostAlert = cachedValue1;
      newGamerzPost = cachedValue2;
      // showAlertJobNearby = cachedValue3;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Setttings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              )),
          leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back_ios)),
        ),
        body: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Container(
              child: Stack(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.notifications),
                        SizedBox(width: 5),
                        Text(
                          'Push Notifications',
                          style: TextStyle(
                            fontSize: 16,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'You have to reload the app for changes to take effect',
                      style: TextStyle(
                        fontSize: 12,
                        letterSpacing: 0.5,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(193, 233, 30, 98),
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Disable New Post Alerts',
                          style: TextStyle(
                            fontSize: 13,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        FlutterSwitch(
                          disabled: true,
                          activeColor: CustomColors.PrimaryColor,
                          valueFontSize: 13.0,
                          toggleSize: 18.0,
                          value: disableNewPostAlert,
                          borderRadius: 30.0,
                          padding: 6.0,
                          showOnOff: true,
                          onToggle: (val) async {
                            setState(() {
                              disableNewPostAlert = val;
                            });
                            await localStorage.setBoolData(
                                name: 'disableNewPostAlertPush',
                                data: disableNewPostAlert);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Disable New Gamers Post Alert',
                          style: TextStyle(
                            fontSize: 13,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        FlutterSwitch(
                          activeColor: CustomColors.PrimaryColor,
                          valueFontSize: 13.0,
                          toggleSize: 18.0,
                          value: newGamerzPost,
                          borderRadius: 30.0,
                          padding: 6.0,
                          showOnOff: true,
                          onToggle: (val) async {
                            setState(() {
                              newGamerzPost = val;
                            });
                            await localStorage.setBoolData(
                                name: 'newGamerzPostPush', data: newGamerzPost);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
                Expanded(
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                            onTap: () {
                              confirmLogout();
                            },
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 1),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: Colors.white)),
                                child: const Text("Logout",
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: CustomColors.PrimaryColor,
                                      fontWeight: FontWeight.w500,
                                    ))))))
              ]),
            )));
  }
}
