import 'package:flutter/material.dart';

class CustomSnackbar {
  static void showSnackBar({
    required ScaffoldMessengerState state,
    required String text,
    Color? color,
    bool? enableAction = true,
  }) {
    final snackBar = SnackBar(
      content: Text(text),
      backgroundColor: (Colors.black12),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: 'ismiss',
        onPressed: () => state.removeCurrentSnackBar(),
      ),
    );
    state.showSnackBar(snackBar);
  }
}
