import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreenProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool emailVerifys = false;

  final FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  updateTheImageNow() {
    streamImagesFromUserId(auth.currentUser!.uid);
  }

  checkEmailVerification() async {
    // User? user = auth.currentUser;
    await FirebaseAuth.instance.currentUser!.reload();
    if (FirebaseAuth.instance.currentUser!.emailVerified) {
      emailVerifys = true;
    }
    notifyListeners();
  }

  Future<void> validateForm(context) async {
    if (formKey.currentState!.validate()) {
      User? user = auth.currentUser;
      return users.doc(user!.uid).update({
        'username': usernameController.text
      }).then((value) => showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Profile Information Change'),
              content: const Text('Profile informations successfully changed!'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Container(
                    color: Colors.green,
                    padding: const EdgeInsets.all(14),
                    child: const Text('Okay'),
                  ),
                ),
              ],
            ),
          ));
    }
    notifyListeners();
  }

  String userImage = "";

  streamImagesFromUserId(String userId) async{
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (documentSnapshot.exists) {
      userImage = documentSnapshot.data()?['image_url'] ?? 'image yok la gardaş';
    } else {
      print('Belge bulunamadı.');
    }
    notifyListeners();
  }
}
