import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../commom/gamerz-wrapper.dart';
import '../../commom/theming.dart';
import '../../commom/ui/gamerzRaisedButton.dart';
import '../../commom/ui/gamerzTextButton.dart';
import '../../commom/ui/textInput.dart';
import '../../data-models.dart/login.dart';
import 'forgot_password.dart';
import 'register.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() {
    return _Login();
  }
}

class _Login extends State<Login> {
  final LoginModel loginModel = LoginModel();
  bool obscurePassword = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GoogleSignIn googleSignIn = GoogleSignIn();

  toggleObscurePassword() {
    obscurePassword = !obscurePassword;
    setState(() {});
  }

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  // Future<void> _handleGoogleSignIn() async {
  //   try {
  //     var account = await _googleSignIn.signIn();
  //     print('Account $account');
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  Future<void> _handleGoogleSignIn() async {
    try {
      await _handleGoogleSignOut();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      print('sign in accoutn >> $googleSignInAccount');
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      print('access token ${googleSignInAuthentication.accessToken}');
      log('idToken ${googleSignInAuthentication.idToken.toString()}');
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;
      print('user $user');

      // Use the user object for further operations or navigate to a new screen.
    } catch (e) {
      print('sign in error ${e.toString()}');
    }
  }

  Future<void> _handleGoogleSignOut() async {
    try {
      await googleSignIn.signOut();
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return GamerzWrapper(
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Form(
                key: _formKey,
                child: SingleChildScrollView(
                    child: Column(children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Login', style: GamerzTheme.headerStyle),
                            GamerzTextButton(
                              label: 'Sign up',
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => Register())),
                            )
                          ],
                        ),
                        const SizedBox(height: 36),
                        const Text(
                            'Enter email and password to login to your account',
                            style: GamerzTheme.subHeaderStyle),
                        const SizedBox(height: 36),
                        const Text('Email Address',
                            style: GamerzTheme.labelStyle),
                        const SizedBox(height: 10),
                        GamerzTextInput(
                          keyboard: KeyboardType.EMAIL,
                          hintText: 'Enter your email address',
                          validator: (String? value) {
                            if (value == '') {
                              return 'Email address cannot be empty';
                            }
                          },
                          onSaved: (String? value) {
                            loginModel.email = value;
                          },
                          prefix: SvgPicture.asset('assets/svgs/sms.svg'),
                        ),
                        const SizedBox(height: 36),
                        const Text('Password', style: GamerzTheme.labelStyle),
                        const SizedBox(height: 10),
                        GamerzTextInput(
                          keyboard: KeyboardType.TEXT,
                          hintText: 'Enter your password',
                          obscureText: obscurePassword,
                          suffixIcon: GestureDetector(
                              onTap: () {
                                toggleObscurePassword();
                                rebuildAllChildren(context);
                              },
                              child: Icon(
                                  obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.white)),
                          validator: (String? value) {
                            if (value == '') {
                              return 'Password cannot be empty';
                            }
                          },
                          onSaved: (String? value) {
                            loginModel.password = value;
                          },
                          prefix: SvgPicture.asset('assets/svgs/lock.svg'),
                        ),
                        const SizedBox(height: 36),
                        Align(
                          alignment: Alignment.center,
                          child: GamerzTextButton(
                            label: 'Forgot password?',
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ForgotPassword())),
                          ),
                        )
                      ]),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GamerzElevatedButton(
                        label: 'Login',
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          _formKey.currentState!.save();

                          // context
                          //     .read<LoginBloc>()
                          //     .add(UserLogin(loginModel));

                          // Navigator.pushNamed(context, HomeRoute)
                        }),
                  ),
                  const SizedBox(height: 36),
                  Text('Or'),
                  const SizedBox(height: 20),
                  GamerzGoogleElevatedButton(
                    label: 'Login With Google',
                    onPressed: () => _handleGoogleSignIn(),
                  )
                ])))));
  }
}
