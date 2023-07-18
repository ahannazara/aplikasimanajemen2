import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_3/models/payload_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PayloadModel? payloadModel;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        toolbarHeight: 50,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _requestButton(),
            const SizedBox(height: 8),
            _itemsButton(),
            const SizedBox(height: 8),
            _reportsButton(),
            const SizedBox(height: 8),
            _registerButton()
          ],
        ),
      ),
    );
  }

  Widget _registerButton() {
    final role = payloadModel?.role;
    if (role != null && (role == Role.admin)) {
      return ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, '/register'),
        child: const SizedBox(
          width: 100,
          child: Text(
            "Create Account",
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }
    return const SizedBox();
  }

  Widget _requestButton() {
    final role = payloadModel?.role;
    if (role != null) {
      final check = role == Role.admin ||
          role == Role.supervisor ||
          role == Role.houseKeeping ||
          role == Role.mechanicalElectrical;
      if (check) {
        return ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/requests'),
          child: const SizedBox(
            width: 100,
            child: Text(
              "Request Stock",
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      }
    }
    return const SizedBox();
  }

  Widget _itemsButton() {
    final role = payloadModel?.role;
    if (role != null &&
        (role == Role.admin ||
            role == Role.supervisor ||
            role == Role.houseKeeping ||
            role == Role.mechanicalElectrical)) {
      return ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, '/items'),
        child: const SizedBox(
          width: 100,
          child: Text(
            "Items",
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }
    return const SizedBox();
  }

  Widget _reportsButton() {
    final role = payloadModel?.role;
    if (role != null) {
      final check = role == Role.admin ||
          role == Role.supervisor ||
          role == Role.houseKeeping ||
          role == Role.mechanicalElectrical;
      final staff = role == Role.staf;
      if (staff) {
        return ElevatedButton(
          onPressed: () => Navigator.pushNamed(
            context,
            '/reports',
            arguments: ['Crash'],
          ),
          child: const SizedBox(
            width: 100,
            child: Text(
              "Reports",
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      } else if (check) {
        return ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/reports'),
          child: const SizedBox(
            width: 100,
            child: Text(
              "Reports",
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      }
    }
    return const SizedBox();
  }

  _init() async {
    // get token from local storage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token != null) {
      List<int> bytes = base64.decode(token);
      String jsonPayload = utf8.decode(bytes);
      Map<String, dynamic> decodePayload = jsonDecode(jsonPayload);
      setState(() => payloadModel = PayloadModel.fromMap(decodePayload));
    }
  }
}
