import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import 'package:flutter_svg/flutter_svg.dart';

import '../../commom/gamerz-wrapper.dart';
import '../../commom/theming.dart';
import '../../commom/ui/gamerzRaisedButton.dart';
import '../../commom/ui/gamerzTextButton.dart';
import '../../commom/ui/textInput.dart';
import 'login.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ResetPassword();
  }
}

class _ResetPassword extends State<ResetPassword> {
  bool obscurePassword = true;
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

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
            body: SingleChildScrollView(
                child: Column(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Reset Password',
                        style: GamerzTheme.headerStyle),
                    GamerzTextButton(
                      label: 'Login',
                      onPressed: () => Navigator.push(
                          context, MaterialPageRoute(builder: (_) => Login())),
                    )
                  ],
                ),
                const SizedBox(height: 36),
                const Text(
                    'Request an otp and enter provide the otp sent to your email and new password',
                    style: GamerzTheme.subHeaderStyle),
                const SizedBox(height: 36),
                const Text('OTP', style: GamerzTheme.labelStyle),
                const SizedBox(height: 10),
                OtpTextField(
                  mainAxisAlignment: MainAxisAlignment.start,
                  fieldWidth: MediaQuery.of(context).size.width * 0.15,
                  numberOfFields: 5,
                  filled: true,
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  borderWidth: 1,
                  fillColor: const Color(0xFF313132),
                  enabledBorderColor: const Color(0xFF747474),
                  focusedBorderColor: const Color(0xFFE7E7E7),
                  borderColor: const Color(0xFF747474),
                  showFieldAsBox: true,
                  //runs when a code is typed in
                  onCodeChanged: (String code) {
                    //handle validation or checks here
                  },
                  //runs when every textfield is filled
                  onSubmit: (String verificationCode) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Verification Code"),
                            content: Text('Code entered is $verificationCode'),
                          );
                        });
                  }, // end onSubmit
                ),
                const SizedBox(height: 20),
                Align(
                    alignment: Alignment.centerRight,
                    child: GamerzTextButton(
                      label: 'Send OTP',
                      onPressed: () => Navigator.push(
                          context, MaterialPageRoute(builder: (_) => Login())),
                    )),
                const Divider(
                  thickness: 1,
                  height: 0,
                  color: Color(0xFF747474),
                ),
                const SizedBox(height: 36),
                const Text('Password', style: GamerzTheme.labelStyle),
                const SizedBox(height: 10),
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
                  onSaved: (String? value) {},
                  prefix: SvgPicture.asset('assets/icons/lock.svg'),
                ),
                const SizedBox(height: 36),
                const Text('Confirm Password', style: GamerzTheme.labelStyle),
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
              ]),
              Align(
                alignment: Alignment.bottomCenter,
                child:
                    GamerzElevatedButton(label: 'Submit', onPressed: () => {}),
              ),
              const SizedBox(height: 36)
            ]))));
  }
}
