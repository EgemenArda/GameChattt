import 'package:flutter/material.dart';
import 'package:game_chat_1/screens/widgets/CustomFormField.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key, required this.Username});

  String Username;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  void _validateForm() {
    if (_formKey.currentState!.validate()) {
      print(_usernameController.text);
    }
  }

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();


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
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        NetworkImage('https://picsum.photos/250?image=9'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: -10,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: CircleBorder(),
                      ),
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      onPressed: () => print('editing pp'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  SizedBox(
                    width: 200,
                    child: EditableTextForm(
                      initialValue: 'Egemen',
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
                      controller: _usernameController,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: _validateForm,
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
