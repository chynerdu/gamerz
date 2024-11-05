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
import '../../data-models.dart/register.dart';
import '../home/tabs.dart';
import 'login.dart';

class RegisterFinal extends StatefulWidget {
  final RegisterModel previousData;
  const RegisterFinal({super.key, required this.previousData});

  @override
  State<StatefulWidget> createState() {
    return _RegisterFinal();
  }
}

class _RegisterFinal extends State<RegisterFinal> {
  bool obscurePassword = true;
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  RegisterModel registerModel = RegisterModel();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  initState() {
    registerModel = widget.previousData;
    super.initState();
  }

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

  register({required UserAuthProvider authProvider, required context}) async {
    try {
      SmartDialog.showLoading();
      await authProvider.register(registerModel);
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
    Navigator.pushReplacement(
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
                            GestureDetector(
                                child: Icon(Icons.arrow_back,
                                    color: Colors.white, size: 24)),
                            GamerzTextButton(
                              label: 'Login',
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const Login())),
                            )
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                            'Almost done ${registerModel.firstName}  set a password for your account',
                            style: GamerzTheme.subHeaderStyle),
                        const SizedBox(height: 16),
                        Image.asset("assets/icons/stepper2.png"),
                        const SizedBox(height: 48),
                        GamerzTextInput(
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
                            if (value == '') return 'Password cannot be empty';
                          },
                          onSaved: (String? value) {
                            registerModel.password = value;
                          },
                          prefix: SvgPicture.asset('assets/icons/lock.svg'),
                        ),
                        const SizedBox(height: 36),
                        const Text('Confirm Password',
                            style: GamerzTheme.labelStyle),
                        const SizedBox(height: 10),
                        GamerzTextInput(
                          hintText: 'confirm your password',
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
                              return 'Confirm Password cannot be empty';
                            } else if (passwordController.text !=
                                confirmPasswordController.text) {
                              return 'Confirm password is not the same as password';
                            }
                          },
                          onSaved: (String? value) {},
                          prefix: SvgPicture.asset('assets/icons/lock.svg'),
                        ),
                        const SizedBox(height: 36)
                      ]),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GamerzElevatedButton(
                      label: 'Submit',
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        _formKey.currentState!.save();
                        register(authProvider: authProvider, context: context);
                      },
                    ),
                  ),
                  const SizedBox(height: 20)
                ])))));
  }
}
