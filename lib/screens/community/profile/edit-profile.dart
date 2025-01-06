import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app-providers/auth_provider.dart';
import '../../../commom/gamerz-wrapper.dart';
import '../../../data-models.dart/userModel.dart';
import 'edit-forms/edit-bio.dart';
import 'edit-forms/edit-first-name.dart';
import 'edit-forms/edit-last-name.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController websiteController = TextEditingController();

  @override
  void initState() {
    final authProvider = Provider.of<UserAuthProvider>(context, listen: false);
    Data profile = authProvider.userData;
    firstNameController.text = profile.firstName ?? '';
    lastNameController.text = profile.lastName ?? '';
    bioController.text = profile.bio ?? '';
    websiteController.text = profile.website ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<UserAuthProvider>(context, listen: false);
    return GamerzWrapper(
        child: Scaffold(
            appBar: AppBar(
              title: const Text('Edit Profile'),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Form(
                  child: Column(
                children: [
                  TextFormField(
                    readOnly: true,
                    onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditFirstName(
                                    initialValue: firstNameController.text)))
                        .then((isSuccessfullySubmitted) {
                      // Rebuild widget when navigating back
                      if (isSuccessfullySubmitted) {
                        setState(() {
                          firstNameController.text =
                              authProvider.userData.firstName ?? '';
                        });
                      }
                    }),
                    controller: firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                      hintText: 'Enter your first name',
                      border: UnderlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'First Name is required' : null,
                  ),
                  TextFormField(
                    controller: lastNameController,
                    onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditLastName(
                                    initialValue: lastNameController.text)))
                        .then((isSuccessfullySubmitted) {
                      // Rebuild widget when navigating back
                      if (isSuccessfullySubmitted) {
                        setState(() {
                          lastNameController.text =
                              authProvider.userData.lastName ?? '';
                        });
                      }
                    }),
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                      hintText: 'Enter your last name',
                      border: UnderlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Last Name is required' : null,
                  ),
                  TextFormField(
                    readOnly: true,
                    onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditBio(initialValue: bioController.text)))
                        .then((isSuccessfullySubmitted) {
                      // Rebuild widget when navigating back
                      if (isSuccessfullySubmitted) {
                        setState(() {
                          bioController.text = authProvider.userData.bio ?? '';
                        });
                      }
                    }),
                    controller: bioController,
                    decoration: const InputDecoration(
                      labelText: 'Bio',
                      hintText: 'Enter your bio',
                      border: UnderlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Bio is required' : null,
                  ),
                  TextFormField(
                    readOnly: true,
                    enabled: false,
                    controller: websiteController,
                    decoration: const InputDecoration(
                      labelText: 'Website',
                      hintText: 'Enter your website',
                      border: UnderlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Website is required' : null,
                  ),
                ],
              )),
            )));
  }
}
