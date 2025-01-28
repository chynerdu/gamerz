import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:gamerz/commom/custom-colors.dart';
import 'package:provider/provider.dart';
import '../app-providers/post_provider.dart';
import '../commom/gamerz-wrapper.dart';
import '../commom/ui/gamerzRaisedButton.dart';
import '../helpers/snackbars.dart';

class ReportPostPrompt extends StatefulWidget {
  final String id;
  const ReportPostPrompt({super.key, required this.id});

  @override
  ReportPostPromptState createState() => ReportPostPromptState();
}

class ReportPostPromptState extends State<ReportPostPrompt> {
  TextEditingController otherController = TextEditingController();
  String _selectedOption = '';
  CustomSnackbars customSnackbars = CustomSnackbars();
  final formKey = GlobalKey<FormState>();

  submit(context) async {
    try {
      if (_selectedOption == '') {
        customSnackbars.showSnackbar(
            title: 'Error',
            message: "Select an option",
            icon: const Icon(Icons.error));
        return;
      }
      if ((_selectedOption == 'others' && !formKey.currentState!.validate())) {
        return;
      }
      String message =
          _selectedOption != 'others' ? _selectedOption : otherController.text;
      final postProvider = Provider.of<PostProvider>(context, listen: false);

      await postProvider.reportPost(widget.id, message);
      SmartDialog.showToast(
          'We have received your report. Thank you for keeping our community safe for everyone',
          displayTime: const Duration(seconds: 7));
      // customSnackbars.showSnackbar(
      //     title: 'Report',
      //     message:
      //         "We have received your report. Thank you for making our community safe for everyone",
      //     icon: const Icon(Icons.check));
      Navigator.pop(context, true);
    } catch (error) {}
  }

  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            TextButton(
              child: const Text(
                'Close',
                style: TextStyle(color: CustomColors.primaryColor),
              ),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
        body: GamerzWrapper(
            child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 20),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                child:
                    const Text('Report Post', style: TextStyle(fontSize: 20))),
            const SizedBox(height: 20),
            const Text('I am reporting this post because:',
                textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              RadioListTile<String>(
                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                title: const Text("This post makes me uncomfortable."),
                value: "uncomfortable",
                groupValue: _selectedOption,
                onChanged: (value) {
                  setState(() {
                    if (value != null) {
                      _selectedOption = value;
                    }
                  });
                },
              ),
              RadioListTile<String>(
                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                title: const Text("This post promotes violence."),
                value: "violence",
                groupValue: _selectedOption,
                onChanged: (value) {
                  setState(() {
                    if (value != null) {
                      _selectedOption = value;
                    }
                  });
                },
              ),
              RadioListTile<String>(
                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                title: const Text(
                    "This post contains nudity and or offensive words."),
                value: "inappropriate",
                groupValue: _selectedOption,
                onChanged: (value) {
                  setState(() {
                    if (value != null) {
                      _selectedOption = value;
                    }
                  });
                },
              ),
              RadioListTile<String>(
                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                title: const Text("Other reasons"),
                value: "others",
                groupValue: _selectedOption,
                onChanged: (value) {
                  setState(() {
                    if (value != null) {
                      _selectedOption = value;
                    }
                  });
                },
              ),
              Visibility(
                  visible: _selectedOption == 'others',
                  child: Form(
                    key: formKey,
                    child: TextFormField(
                      maxLength: 100,
                      maxLines: 3,
                      controller: otherController,
                      decoration: const InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(),
                        hintText: 'Tell us more',
                      ),
                      validator: (String? value) {
                        if (otherController.text == '' ||
                            otherController.text.length < 3) {
                          return "Enter a valid reason";
                        }
                        return null;
                      },
                      onChanged: (String? value) {
                        setState(() {});
                      },
                    ),
                  )),
            ]),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: GamerzElevatedButton(
                  label: 'Submit', onPressed: () => submit(context)),
            ),
            const SizedBox(height: 20),
          ]),
        )));
  }
}
