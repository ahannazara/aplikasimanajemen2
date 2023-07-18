import 'package:flutter/material.dart';

class FieldWidget extends StatelessWidget {
  const FieldWidget({
    super.key,
    required this.label,
    this.controller,
    this.onTap,
    this.readOnly,
    this.lines,
    this.hint,
  });

  final String label;
  final String? hint;
  final TextEditingController? controller;
  final void Function()? onTap;
  final bool? readOnly;
  final int? lines;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        TextField(
          readOnly: readOnly ?? false,
          controller: controller,
          minLines: lines,
          maxLines: lines,
          decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(),
            ),
            fillColor: Colors.white,
            filled: true,
            hintText: hint,
          ),
          onTap: onTap,
        ),
      ],
    );
  }
}
