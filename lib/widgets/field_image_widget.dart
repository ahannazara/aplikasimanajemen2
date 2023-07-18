import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_3/widgets/dialog_widget.dart';
import 'package:image_picker/image_picker.dart';

class FieldImageWidget extends StatelessWidget {
  const FieldImageWidget({
    super.key,
    this.urlImage,
    required this.label,
    required this.picker,
    required this.onEvent,
    this.pathTemp,
  });

  final String? urlImage;
  final String label;
  final ImagePicker picker;
  final String? pathTemp;
  final void Function(String path) onEvent;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        XFile? imageX;
        _showDialogImage(
          context: context,
          onTap: (value) async {
            final navigation = Navigator.of(context);

            if (value == 'Camera') {
              navigation.pop();
              imageX = await picker.pickImage(
                source: ImageSource.camera,
              );
            } else {
              navigation.pop();
              imageX = await picker.pickImage(
                source: ImageSource.gallery,
              );
            }

            final imageY = imageX;

            if (imageY != null) {
              onEvent(imageY.path);
            }
          },
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 8),
          _image(pathImage: pathTemp),
        ],
      ),
    );
  }

  Widget _image({String? pathImage}) {
    final imageTemp = pathImage;
    final url = urlImage;
    if (imageTemp != null && imageTemp.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(
          File(imageTemp),
          width: 80,
          height: 80,
          fit: BoxFit.cover,
        ),
      );
    } else if (url != null && url.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          "https://keluhan1flutter.000webhostapp.com/$url",
          width: 80,
          height: 80,
          fit: BoxFit.cover,
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 2, color: Colors.black),
      ),
      constraints: const BoxConstraints(
        minHeight: 80,
        minWidth: 80,
      ),
      child: const Icon(
        Icons.add_a_photo_rounded,
        color: Colors.black,
        size: 24,
      ),
    );
  }

  void _showDialogImage({
    required BuildContext context,
    required void Function(String) onTap,
  }) {
    showDialog(
      context: context,
      builder: (context) => DialogWidget(onTap: onTap),
    );
  }
}
