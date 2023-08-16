import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game_chat_1/providers/profile_proivder.dart';
import 'package:game_chat_1/screens/widgets/CustomFormField.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key, required this.Username});

  String Username;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      body: Consumer<ProfileScreenProvider>(
        builder: (context, provider, child) {
          return Form(
            key: provider.formKey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(provider.userImage),
                      ),
                      Positioned(
                        bottom: 0,
                        right: -10,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: const CircleBorder(),
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                          onPressed: () => print('editing pp'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: SizedBox(
                      width: 200,
                      child: EditableTextForm(
                        initialValue: widget.Username,
                        title: 'Username',
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Username cannot be empty';
                          }
                          if (value.length < 5) {
                            return 'Username must be at least 5 characters';
                          }
                          return null;
                        },
                        controller: provider.usernameController,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: provider.validateForm,
                    child: const Text('Save Changes'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
