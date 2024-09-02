import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../app-providers/auth_provider.dart';
import '../../app-providers/games.provider.dart';
import '../../commom/gamerz-wrapper.dart';
import '../../commom/theming.dart';
import '../../commom/ui/gamerzRaisedButton.dart';
import '../../commom/ui/gamerzTextButton.dart';
import '../../commom/ui/textInput.dart';
import '../../data-models.dart/login.dart';
import '../../helpers/socialAuths.dart';
import '../home/tabs.dart';
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
  final SocialAuth socialAuth = SocialAuth();

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

  Future<void> _handleGoogleSignIn(authProvider, context) async {
    try {
      dynamic token = await socialAuth.googleAuth(
          authProvider: authProvider, context: context);
      if (token != null) {
        await socialLogin(
            token: token,
            type: 'google',
            authProvider: authProvider,
            context: context);
      } else {
        SmartDialog.showToast('Login failed',
            displayTime: const Duration(seconds: 3));
      }

      // Use the user object for further operations or navigate to a new screen.
    } catch (e) {
      print('sign in error $e');
      SmartDialog.showToast('sign in error $e',
          displayTime: const Duration(seconds: 3));
    }
  }

  socialLogin(
      {required UserAuthProvider authProvider,
      required type,
      required token,
      required context}) async {
    try {
      SmartDialog.showLoading(msg: 'Logging you in...');
      await authProvider.socialLogin(type: type, token: token);
      goToMain(context);
      SmartDialog.dismiss();
    } catch (e) {
      SmartDialog.dismiss();
      if (e == 'signup') {
        SmartDialog.showToast(
            'It looks like you don\'t have an account. Signup!',
            displayTime: const Duration(seconds: 6));

        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const Register()));
      } else {
        SmartDialog.showToast(e as String,
            displayTime: const Duration(seconds: 3));
      }
    }
  }

  loginUser({required UserAuthProvider authProvider, required context}) async {
    try {
      SmartDialog.showLoading(msg: 'Logging you in...');
      await authProvider.login(loginModel);
      goToMain(context);
      SmartDialog.dismiss();
    } catch (e) {
      SmartDialog.dismiss();
      SmartDialog.showToast(e as String,
          displayTime: const Duration(seconds: 3));
    }
  }

  goToMain(context) {
    final provider = Provider.of<AllGamesProvider>(context, listen: false);
    Navigator.push(
        context, MaterialPageRoute(builder: (_) => NavigationTabs(provider)));
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<UserAuthProvider>(context);
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
                                      builder: (_) => const Register())),
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
                                    builder: (_) => const ForgotPassword())),
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
                          loginUser(
                              authProvider: authProvider, context: context);

                          // context
                          //     .read<LoginBloc>()
                          //     .add(UserLogin(loginModel));

                          // Navigator.pushNamed(context, HomeRoute)
                        }),
                  ),
                  const SizedBox(height: 36),
                  const Text('Or'),
                  const SizedBox(height: 20),
                  GamerzGoogleElevatedButton(
                    label: 'Login With Google',
                    onPressed: () => _handleGoogleSignIn(authProvider, context),
                  )
                ])))));
  }
}
