import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GamerzTextInput extends StatelessWidget {
  final String? hintText;
  final dynamic validator;
  final dynamic onSaved;
  final dynamic onChanged;
  final Function()? toggleEye;
  final KeyboardType? keyboard;
  final String? init;
  final bool? isPassword;
  final Color? isPasswordColor;
  final bool? showObscureText;
  final bool? obscureText;
  final Color? styleColor;
  final Color? hintStyleColor;
  final bool? enabled;
  final bool? readOnly;
  final String? labelText;
  final dynamic? maxLines;
  final Color? borderColor;
  final Widget? prefix;
  final Widget? suffixIcon;
  final TextStyle? errorStyle;
  final Key? key;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final Color? fillColor;
  final bool? isError;
  final String? showErrorText;
  final VoidCallback? onTap;
  final int? maxLength;

  const GamerzTextInput(
      {this.hintText = '',
      required this.validator,
      required this.onSaved,
      this.toggleEye,
      this.init,
      this.errorStyle,
      this.isPassword = false,
      this.isPasswordColor,
      this.showObscureText,
      this.obscureText = false,
      this.keyboard,
      this.styleColor,
      this.maxLength,
      this.hintStyleColor,
      this.enabled = true,
      this.readOnly = false,
      this.labelText,
      this.maxLines = 1,
      this.borderColor = const Color(0xFF747474),
      this.onChanged,
      this.prefix,
      this.key,
      this.controller,
      this.inputFormatters,
      this.fillColor = const Color(0xFF313132),
      this.isError = false,
      this.showErrorText = "field can't be empty",
      this.suffixIcon,
      this.onTap});
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 0),
      height: 54,
      padding: const EdgeInsets.all(0),
      child: TextFormField(
          onTap: onTap ?? () {},
          inputFormatters: inputFormatters,
          controller: controller,
          key: key,
          maxLength: maxLength,
          enabled: enabled,
          readOnly: readOnly as bool,
          style: const TextStyle(fontSize: 16, color: Color(0xFFFFFFFF)),
          cursorColor: styleColor,
          obscureText: obscureText as bool,
          maxLines: maxLines,
          onChanged: onChanged ?? (String string) {},
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(25, 20, 20, 20),
            prefixIcon: Container(
                padding: const EdgeInsets.fromLTRB(5, 5, 5, 10), child: prefix),
            prefixIconConstraints: const BoxConstraints(
              maxHeight: 30,
              maxWidth: 30,
            ),
            filled: true,
            fillColor: fillColor,
            labelText: labelText,
            errorStyle: errorStyle ?? TextStyle(fontSize: 0.01),
            labelStyle: const TextStyle(color: Colors.black),
            hintText: hintText ?? labelText,
            hintStyle: const TextStyle(fontSize: 16, color: Color(0xff989898)),
            isDense: true,
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(width: 0.5, color: Color(0xffAEAEAE)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(width: 0.5, color: Color(0xffAEAEAE)),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: borderColor as Color),
            ),
            // contentPadding: EdgeInsets.only(top: 10, bottom: 10),
            suffixIcon: isPassword ?? true
                ? GestureDetector(
                    onTap: toggleEye != null ? toggleEye!() : () {},
                    child: Icon(
                      showObscureText ?? true
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: const Color(0xFFC0C1C3),
                    ),
                  )
                : suffixIcon,
            errorText: isError ?? true ? showErrorText : null,
          ),
          validator: validator,
          initialValue: init,
          onSaved: onSaved,
          keyboardType: keyboard == KeyboardType.EMAIL
              ? TextInputType.emailAddress
              : keyboard == KeyboardType.NUMBER
                  ? TextInputType.number
                  : keyboard == KeyboardType.PHONE
                      ? TextInputType.phone
                      : TextInputType.text),
    );
  }
}

enum KeyboardType { EMAIL, PHONE, NUMBER, TEXT }
