import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../commom/gamerz-wrapper.dart';
import '../../commom/theming.dart';
import '../../commom/ui/gamerzRaisedButton.dart';
import '../../commom/ui/gamerzTextButton.dart';
import '../../commom/ui/textInput.dart';
import 'login.dart';
import 'reset_password.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ForgotPassword();
  }
}

class _ForgotPassword extends State<ForgotPassword> {
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
            body: SingleChildScrollView(
                child: Column(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Forgot Password',
                        style: GamerzTheme.headerStyle),
                    GamerzTextButton(
                      label: 'Login',
                      onPressed: () => Navigator.push(
                          context, MaterialPageRoute(builder: (_) => Login())),
                    )
                  ],
                ),
                const SizedBox(height: 36),
                const Text('Enter your email to proceed',
                    style: GamerzTheme.subHeaderStyle),
                const SizedBox(height: 36),
                const Text('Email Address', style: GamerzTheme.labelStyle),
                const SizedBox(height: 10),
                GamerzTextInput(
                  keyboard: KeyboardType.EMAIL,
                  hintText: 'Enter your email address',
                  validator: (String? value) {
                    if (value == '') return 'Email address cannot be empty';
                  },
                  onSaved: (String? value) {},
                  prefix: SvgPicture.asset('assets/icons/sms.svg'),
                ),
              ]),
              Align(
                alignment: Alignment.bottomCenter,
                child: GamerzElevatedButton(
                  label: 'Continue',
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => ResetPassword())),
                ),
              ),
              const SizedBox(height: 36)
            ]))));
  }
}
