import 'dart:convert';
import 'dart:developer';
import 'package:flutter_application_3/models/payload_model.dart';
import 'package:flutter_application_3/widgets/snacbar_widget.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController txtusername = TextEditingController();

  TextEditingController txtpassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Column(
        children: [
          const SizedBox(
            height: 50,
            width: 10000,
          ),
          //text login
          const Text(
            "LOGIN",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          // text field username
          const SizedBox(
            height: 50,
            width: 10000,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              controller: txtusername,
              decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "username"),
            ),
          ),
          // text field password
          const SizedBox(
            height: 10,
            width: 10000,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              controller: txtpassword,
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                fillColor: Colors.white,
                filled: true,
                hintText: "password",
              ),
            ),
          ),
          // text field password
          const SizedBox(
            height: 10,
            width: 10000,
          ),
          ElevatedButton(
            onPressed: _postLogin,
            child: const Text("LOGIN"),
          )
        ],
      ),
    );
  }

  _postLogin() async {
    final navigator = Navigator.of(context);
    final stateMessage = ScaffoldMessenger.of(context);
    // get data from server
    var url = "https://keluhan1flutter.000webhostapp.com/login.php";

    final response = await http.post(Uri.parse(url), body: {
      "username": txtusername.text,
      "password": txtpassword.text,
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      log("Response status: ${response.statusCode}");
      log("Response body: ${response.body}");

      var token = data['token'] as String?;

      if (token != null) {
        List<int> bytes = base64.decode(token);
        String jsonPayload = utf8.decode(bytes);
        Map<String, dynamic> decodePayload = jsonDecode(jsonPayload);
        final payload = PayloadModel.fromMap(decodePayload);

        // save token in phone
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('jwt_token', token);

        if (payload.role != null) {
          navigator.pushReplacementNamed('/', arguments: payload.role);
        } else {
          CustomSnackbar.showSnackBar(
            state: stateMessage,
            text: 'Token is failed',
            color: Colors.red.shade300,
          );
        }
      }
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
