import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FieldTimeWidget extends StatelessWidget {
  const FieldTimeWidget({
    super.key,
    required this.label,
    this.controller,
    this.onTap,
    this.hint,
  });

  final String label;
  final String? hint;
  final TextEditingController? controller;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        TextField(
          readOnly: true,
          controller: controller,
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
          onTap: () => _onTapTime(
            context: context,
          ),
        ),
      ],
    );
  }

  void _onTapTime({
    required BuildContext context,
  }) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1945),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      String formattedDate = DateFormat('dd MMMM yyyy').format(pickedDate);
      controller?.text = formattedDate;
    }
  }
}
