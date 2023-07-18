import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_3/widgets/dropdown_widget.dart';
import 'package:flutter_application_3/widgets/field_password.dart';
import 'package:flutter_application_3/widgets/field_widget.dart';
import 'package:flutter_application_3/widgets/snacbar_widget.dart';
import 'package:http/http.dart' as http;

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nikController = TextEditingController();
  bool obsecure = true;
  final List<String> listValue = [
    'house keeping',
    'mechanical electrical',
    'supervisor',
    'admin',
    'staf',
  ];
  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        toolbarHeight: 50,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            FieldWidget(
              label: 'Username',
              controller: _usernameController,
            ),
            const SizedBox(height: 16),
            FieldPasswordWidget(
              obsecure: obsecure,
              onTap: () => setState(() => obsecure = !obsecure),
              label: 'Password',
              controller: _passwordController,
            ),
            const SizedBox(height: 16),
            FieldWidget(
              label: 'NIK',
              controller: _nikController,
            ),
            const SizedBox(height: 16),
            DropdownWidget(
              dropdownValue: dropdownValue ?? listValue[0],
              listValue: listValue,
              onChanged: (value) {},
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _createAccount,
              child: const Text("CREATE ACCOUNT"),
            )
          ],
        ),
      ),
    );
  }

  _createAccount() async {
    final navigator = Navigator.of(context);
    final stateMessage = ScaffoldMessenger.of(context);
    // get data from server
    var url = "https://keluhan1flutter.000webhostapp.com/register.php";

    final response = await http.post(Uri.parse(url), body: {
      "username": _usernameController.text,
      "password": _passwordController.text,
      "role": dropdownValue ?? listValue[0],
      "induk": _nikController.text,
    });

    if (response.statusCode == 200) {
      log("Response status: ${response.statusCode}");
      log("Response body: ${response.body}");

      navigator.pop();
    } else {
      Map<String, dynamic> data = jsonDecode(response.body);
      var message = data['message'] as String;
      log(message);
      CustomSnackbar.showSnackBar(
        state: stateMessage,
        text: message,
        color: Colors.red.shade300,
      );
    }
  }
}
