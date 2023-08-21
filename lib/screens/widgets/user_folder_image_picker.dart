// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
//
// class UserGalleryImagePicker extends StatefulWidget {
//   const UserGalleryImagePicker({super.key, required this.onPickImage});
//
//   final void Function(File pickedImage) onPickImage;
//
//   @override
//   State<UserGalleryImagePicker> createState() => _UserGalleryImagePickerState();
// }
//
// class _UserGalleryImagePickerState extends State<UserGalleryImagePicker> {
//   File? _pickedImageFile;
//
//   void _pickImage() async {
//     final pickedImage = await ImagePicker().pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 50,
//       maxWidth: 150,
//     );
//     if (pickedImage == null) {
//       return;
//     }
//     setState(() {
//       _pickedImageFile = File(pickedImage.path);
//     });
//
//     widget.onPickImage(_pickedImageFile!);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         CircleAvatar(
//           foregroundImage:
//               _pickedImageFile != null ? FileImage(_pickedImageFile!) : null,
//           radius: 40,
//           child: Icon(Icons.folder_copy),
//         ),
//         TextButton.icon(
//           onPressed: _pickImage,
//           icon: const Icon(Icons.folder_copy),
//           label: const Text(
//             "Gallery",
//           ),
//         )
//       ],
//     );
//   }
// }
