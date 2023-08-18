import 'package:flutter/material.dart';

class EditableTextForm extends StatefulWidget {
  final String title;
  final String? Function(String) validator;
  final TextEditingController controller;
  final String initialValue;

  const EditableTextForm({
    super.key,
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
      autocorrect: false,
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.title,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        hintText: 'Enter ${widget.title}',
      ),
      validator: (value) {
        return widget.validator(value ?? '');
      },
    );
  }
}
