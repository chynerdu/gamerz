import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';

import '../../../../app-providers/auth_provider.dart';
import '../../../../commom/gamerz-wrapper.dart';
import '../../../../commom/ui/textInput.dart';

class EditLastName extends StatefulWidget {
  final String initialValue;
  EditLastName({super.key, required this.initialValue});

  @override
  State<EditLastName> createState() => _EditLastNameState();
}

class _EditLastNameState extends State<EditLastName> {
  TextEditingController lastNameController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  initState() {
    lastNameController.text = widget.initialValue;
    super.initState();
  }

  submit(context) async {
    try {
      if (!formKey.currentState!.validate()) {
        return;
      }

      final authProvider =
          Provider.of<UserAuthProvider>(context, listen: false);
      await authProvider.updateUserProfile(
          key: 'last_name', value: lastNameController.text);
      Navigator.pop(context, true);
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    return GamerzWrapper(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Last Name'),
        actions: [
          Visibility(
              visible: lastNameController.text != widget.initialValue,
              child: GestureDetector(
                  onTap: () {
                    submit(context);
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 1),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.white)),
                      child: const Text("Done",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          )))))
        ],
      ),
      body: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(height: 20),
              GamerzTextInput(
                controller: lastNameController,
                hintText: 'Enter last name',
                validator: (String? value) {
                  if (lastNameController.text == '') {
                    return 'Last name cannot be empty';
                  }
                },
                onChanged: (String? value) {
                  setState(() {});
                },
                onSaved: (String? value) {},
              ),
            ],
          )),
    ));
  }
}
