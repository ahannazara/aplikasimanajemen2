import 'dart:developer';

import 'package:flutter_application_3/homepage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "password"),
            ),
          ),
          // text field password
          const SizedBox(
            height: 10,
            width: 10000,
          ),
          ElevatedButton(
              onPressed: () async {
                final ctx = context;
                var password = txtpassword.text.toString();
                var username = txtusername.text.toString();

                var url = "https://keluhan1flutter.000webhostapp.com/login.php";
                await http.post(Uri.parse(url), body: {
                  "username": username,
                  "password": password
                }).then((response) {
                  log("Response status: ${response.statusCode}");
                  log("Response body: ${response.body}");
                  if (response.statusCode == 200) {
                    Navigator.push(
                      ctx,
                      MaterialPageRoute(builder: (ctx) => const homepage()),
                    );
                  }
                });
              },
              child: const Text("LOGIN"))
        ],
      ),
    );
  }
}
