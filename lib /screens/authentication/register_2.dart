// import 'package:fil/common/UI/filRaisedButton.dart';
// import 'package:fil/common/UI/filTextButton.dart';
// import 'package:fil/common/UI/textInput.dart';
// import 'package:fil/common/custom_theme.dart';
// import 'package:fil/common/fillWrapper.dart';
// import 'package:fil/common/route_constants.dart';
// import 'package:fil/models/register.dart';
// import 'package:fil/services/bloc/auth/login/bloc/login_bloc.dart';
// import 'package:fil/services/bloc/auth/register/bloc/register_bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class RegisterFinal extends StatefulWidget {
//   final RegisterModel previousData;
//   const RegisterFinal({super.key, required this.previousData});

//   @override
//   State<StatefulWidget> createState() {
//     return _RegisterFinal();
//   }
// }

// class _RegisterFinal extends State<RegisterFinal> {
//   bool obscurePassword = true;
//   TextEditingController passwordController = TextEditingController();
//   TextEditingController confirmPasswordController = TextEditingController();
//   RegisterModel registerModel = RegisterModel();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   @override
//   initState() {
//     registerModel = widget.previousData;
//     super.initState();
//   }

//   toggleObscurePassword() {
//     obscurePassword = !obscurePassword;
//     setState(() {});
//   }

//   void rebuildAllChildren(BuildContext context) {
//     void rebuild(Element el) {
//       el.markNeedsBuild();
//       el.visitChildren(rebuild);
//     }

//     (context as Element).visitChildren(rebuild);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider<RegisterBloc>(
//         create: (_) => RegisterBloc(),
//         child: BlocListener<RegisterBloc, RegisterState>(
//             listener: (context, state) {
//               if (state is RegisterLoading) {
//                 SmartDialog.showLoading();
//               } else if (state is RegisterError) {
//                 SmartDialog.dismiss();
//                 SmartDialog.showToast(state.error as String);
//               } else if (state is RegisterSuccessful) {
//                 SmartDialog.dismiss();
//                 Navigator.pushNamed(context, HomeRoute);
//               }
//             },
//             child: FilWrapper(
//                 child: Scaffold(
//                     backgroundColor: Colors.transparent,
//                     appBar: AppBar(
//                       automaticallyImplyLeading: false,
//                       backgroundColor: Colors.transparent,
//                       elevation: 0,
//                     ),
//                     body: BlocBuilder<RegisterBloc, RegisterState>(
//                         builder: (context, state) {
//                       return Form(
//                           key: _formKey,
//                           child: SingleChildScrollView(
//                               child: Column(children: [
//                             Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       GestureDetector(
//                                           child: Icon(Icons.arrow_back,
//                                               color: Colors.white, size: 24)),
//                                       FilTextButton(
//                                         label: 'Login',
//                                         onPressed: () => Navigator.pushNamed(
//                                             context, LoginRoute),
//                                       )
//                                     ],
//                                   ),
//                                   const SizedBox(height: 24),
//                                   Text(
//                                       'Almost done ${registerModel.firstName}  set a password for your account',
//                                       style: FilTheme.subHeaderStyle),
//                                   const SizedBox(height: 16),
//                                   Image.asset("assets/icons/stepper2.png"),
//                                   const SizedBox(height: 48),
//                                   FilTextInput(
//                                     hintText: 'Enter your password',
//                                     obscureText: obscurePassword,
//                                     suffixIcon: GestureDetector(
//                                         onTap: () {
//                                           toggleObscurePassword();
//                                           rebuildAllChildren(context);
//                                         },
//                                         child: Icon(
//                                             obscurePassword
//                                                 ? Icons.visibility_off
//                                                 : Icons.visibility,
//                                             color: Colors.white)),
//                                     validator: (String? value) {
//                                       if (value == '')
//                                         return 'Password cannot be empty';
//                                     },
//                                     onSaved: (String? value) {
//                                       registerModel.password = value;
//                                     },
//                                     prefix: SvgPicture.asset(
//                                         'assets/icons/lock.svg'),
//                                   ),
//                                   const SizedBox(height: 36),
//                                   const Text('Confirm Password',
//                                       style: FilTheme.labelStyle),
//                                   const SizedBox(height: 10),
//                                   FilTextInput(
//                                     hintText: 'confirm your password',
//                                     obscureText: obscurePassword,
//                                     suffixIcon: GestureDetector(
//                                         onTap: () {
//                                           toggleObscurePassword();
//                                           rebuildAllChildren(context);
//                                         },
//                                         child: Icon(
//                                             obscurePassword
//                                                 ? Icons.visibility_off
//                                                 : Icons.visibility,
//                                             color: Colors.white)),
//                                     validator: (String? value) {
//                                       if (value == '') {
//                                         return 'Confirm Password cannot be empty';
//                                       } else if (passwordController.text !=
//                                           confirmPasswordController.text) {
//                                         return 'Confirm password is not the same as password';
//                                       }
//                                     },
//                                     onSaved: (String? value) {},
//                                     prefix: SvgPicture.asset(
//                                         'assets/icons/lock.svg'),
//                                   ),
//                                   const SizedBox(height: 36)
//                                 ]),
//                             Align(
//                               alignment: Alignment.bottomCenter,
//                               child: FilElevatedButton(
//                                 label: 'Submit',
//                                 onPressed: () {
//                                   if (!_formKey.currentState!.validate()) {
//                                     return;
//                                   }
//                                   _formKey.currentState!.save();

//                                   context
//                                       .read<RegisterBloc>()
//                                       .add(UserRegister(registerModel));
//                                 },
//                               ),
//                             ),
//                             const SizedBox(height: 20)
//                           ])));
//                     })))));
//   }
// }
