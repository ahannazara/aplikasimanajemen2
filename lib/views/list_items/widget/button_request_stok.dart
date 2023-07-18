import 'package:flutter/material.dart';
import 'package:flutter_application_3/models/payload_model.dart';

class ButtonRequestStock extends StatelessWidget {
  const ButtonRequestStock({
    super.key,
    this.payloadRole,
  });

  final Role? payloadRole;

  @override
  Widget build(BuildContext context) {
    if (payloadRole == Role.admin ||
        payloadRole == Role.houseKeeping ||
        payloadRole == Role.mechanicalElectrical) {
      return IconButton(
        onPressed: () => Navigator.pushNamed(context, '/requests'),
        icon: const Icon(Icons.add_to_photos_rounded),
      );
    }
    return const SizedBox();
  }
}
