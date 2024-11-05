import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../app-providers/auth_provider.dart';
import '../../../../commom/gamerz-wrapper.dart';
import '../../../../commom/ui/textInput.dart';
import '../../../../helpers/snackbars.dart';

class EditBio extends StatefulWidget {
  final String initialValue;
  EditBio({super.key, required this.initialValue});

  @override
  State<EditBio> createState() => _EditBioState();
}

class _EditBioState extends State<EditBio> {
  TextEditingController bioController = TextEditingController();
  CustomSnackbars customSnackbars = CustomSnackbars();
  final formKey = GlobalKey<FormState>();

  @override
  initState() {
    bioController.text = widget.initialValue;
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
          key: 'bio', value: bioController.text);
      Navigator.pop(context, true);
    } catch (error) {
      final errorMessage = error is Map ? error['error'] : error.toString();
      customSnackbars.showSnackbar(
          title: 'Error', message: errorMessage, icon: const Icon(Icons.error));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GamerzWrapper(
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Bio'),
              actions: [
                Visibility(
                    visible: bioController.text != widget.initialValue,
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
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      TextFormField(
                        maxLength: 100,
                        maxLines: 3,
                        controller: bioController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText:
                              'Unleash your gaming story in 100 characters!',
                        ),
                        validator: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Your bio can\'t be empty. Show off your gaming spirit!';
                          }
                          return null;
                        },
                        onChanged: (String? value) {
                          setState(() {});
                        },
                      ),
                    ],
                  )),
            )));
  }
}
