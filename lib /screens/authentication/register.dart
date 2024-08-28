import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../commom/gamerz-wrapper.dart';
import '../../commom/theming.dart';
import '../../commom/ui/gamerzRaisedButton.dart';
import '../../commom/ui/gamerzTextButton.dart';
import '../../commom/ui/textInput.dart';
import '../../data-models.dart/register.dart';
import 'login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<StatefulWidget> createState() {
    return _Register();
  }
}

class _Register extends State<Register> {
  bool obscurePassword = true;
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final RegisterModel registerModel = RegisterModel();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                            const Text('Sign Up',
                                style: GamerzTheme.headerStyle),
                            GamerzTextButton(
                              label: 'Login',
                              onPressed: () => Navigator.push(context,
                                  MaterialPageRoute(builder: (_) => Login())),
                            )
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Text('Step 1 out of 2',
                            style: GamerzTheme.subHeaderStyle),
                        const SizedBox(height: 16),
                        Image.asset("assets/icons/stepper1.png"),
                        const SizedBox(height: 48),
                        SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('First Name',
                                            style: GamerzTheme.labelStyle),
                                        const SizedBox(height: 10),
                                        GamerzTextInput(
                                          hintText: 'Enter first name',
                                          validator: (String? value) {
                                            if (value == '') {
                                              return 'First name cannot be empty';
                                            }
                                          },
                                          onSaved: (String? value) {
                                            registerModel.firstName = value;
                                          },
                                          prefix: SvgPicture.asset(
                                              'assets/icons/user.svg'),
                                        ),
                                      ],
                                    )),
                                // last name
                                SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Last Name',
                                            style: GamerzTheme.labelStyle),
                                        const SizedBox(height: 10),
                                        GamerzTextInput(
                                          hintText: 'Enter last name',
                                          validator: (String? value) {
                                            if (value == '') {
                                              return 'Last name cannot be empty';
                                            }
                                          },
                                          onSaved: (String? value) {
                                            registerModel.lastName = value;
                                          },
                                          prefix: SvgPicture.asset(
                                              'assets/icons/user.svg'),
                                        ),
                                      ],
                                    ))
                              ],
                            )),
                        const SizedBox(height: 36),
                        const Text('Username', style: GamerzTheme.labelStyle),
                        const SizedBox(height: 10),
                        GamerzTextInput(
                          keyboard: KeyboardType.EMAIL,
                          hintText: 'Enter a username',
                          validator: (String? value) {
                            if (value == '') return 'Username cannot be empty';
                          },
                          onSaved: (String? value) {
                            registerModel.username = value;
                          },
                          prefix: SvgPicture.asset('assets/icons/at.svg'),
                        ),
                        const SizedBox(height: 36),
                        const Text('Email Address',
                            style: GamerzTheme.labelStyle),
                        const SizedBox(height: 10),
                        GamerzTextInput(
                          keyboard: KeyboardType.EMAIL,
                          hintText: 'Enter your email address',
                          validator: (String? value) {
                            if (value == '')
                              return 'Email address cannot be empty';
                          },
                          onSaved: (String? value) {
                            registerModel.email = value;
                          },
                          prefix: SvgPicture.asset('assets/icons/sms.svg'),
                        ),
                      ]),
                  const SizedBox(height: 36),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GamerzElevatedButton(
                        label: 'Continue',
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          _formKey.currentState!.save();

                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => RegisterFinal(
                          //             previousData: registerModel)));
                        }),
                  ),
                  const SizedBox(height: 20)
                ])))));
  }
}
