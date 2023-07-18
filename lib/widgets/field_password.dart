import 'package:flutter/material.dart';

class FieldPasswordWidget extends StatelessWidget {
  const FieldPasswordWidget({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.onTap,
    this.readOnly,
    required this.obsecure,
  });

  final String label;
  final String? hint;
  final TextEditingController? controller;
  final void Function()? onTap;
  final bool? readOnly;
  final bool obsecure;

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
          obscureText: obsecure,
          decoration: InputDecoration(
            suffixIcon: GestureDetector(
              onTap: onTap,
              child: Icon(
                obsecure
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                size: 24,
                color: Colors.black,
              ),
            ),
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
        ),
      ],
    );
  }
}
