import 'package:flutter/material.dart';

class EditableTextForm extends StatefulWidget {
  final String title;
  final String? Function(String) validator;
  final TextEditingController controller;
  final String initialValue;

  EditableTextForm({
    required this.title,
    required this.validator,
    required this.controller,
    required this.initialValue,
  });

  @override
  _EditableTextFormState createState() => _EditableTextFormState();
}

class _EditableTextFormState extends State<EditableTextForm> {
  @override
  void initState() {
    super.initState();
    widget.controller.text = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: 'Enter ${widget.title}',
      ),
      validator: (value) {
        return widget.validator(value ?? ''); // Pass an empty string if null
      },
    );
  }
}
