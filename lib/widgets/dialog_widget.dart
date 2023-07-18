import 'package:flutter/material.dart';

class DialogWidget extends StatelessWidget {
  const DialogWidget({
    super.key,
    required this.onTap,
  });

  final void Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buttonChoice(
              context: context,
              icon: Icons.camera_alt_rounded,
              text: 'Camera',
            ),
            const SizedBox(width: 8),
            _buttonChoice(
              context: context,
              icon: Icons.photo_library_rounded,
              text: 'Galery',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buttonChoice({
    required String text,
    required IconData icon,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () => onTap(text),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(
              text,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(width: 4),
            Icon(icon)
          ],
        ),
      ),
    );
  }
}
