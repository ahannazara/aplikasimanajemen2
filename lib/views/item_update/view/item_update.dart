import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_3/models/items_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ItemUpdate extends StatefulWidget {
  const ItemUpdate({
    super.key,
    this.item,
  });

  final DataItems? item;

  @override
  State<ItemUpdate> createState() => _ItemUpdateState();
}

class _ItemUpdateState extends State<ItemUpdate> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final data = widget.item;
    if (data != null) {
      _nameController.text = data.name ?? '';
      _totalController.text = data.total ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? 'Item Create' : 'Item Update'),
        toolbarHeight: 50,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Name Item'),
            const SizedBox(height: 4),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
                fillColor: Colors.white,
                filled: true,
                hintText: "item name",
              ),
            ),
            const SizedBox(height: 16),
            const Text('Total Item'),
            const SizedBox(height: 4),
            TextField(
              controller: _totalController,
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
                fillColor: Colors.white,
                filled: true,
                hintText: "total name",
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: widget.item == null ? _fetchCreate : _fetchUpdate,
              child: Text(widget.item == null ? "CREATE" : "UPDATE"),
            )
          ],
        ),
      ),
    );
  }

  void _fetchUpdate() async {
    final navigator = Navigator.of(context);

    // get token from local storage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    // get data from server
    var url = "https://keluhan1flutter.000webhostapp.com/item_update.php";
    final headers = token == null ? null : {'Authorization': token};
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: {
        'name': _nameController.text,
        'total': _totalController.text,
        'id': widget.item?.id,
      },
    );

    log("Response status: ${response.statusCode}");
    log("Response body: ${response.body}");

    if (response.statusCode == 200) {
      navigator.pop();
    } else {
      Map<String, dynamic> data = jsonDecode(response.body);
      var message = data['message'] as String?;
      log(message ?? '');
      if (response.statusCode == 401) {
        navigator.pushReplacementNamed('/login');
      }
    }
  }

  void _fetchCreate() async {
    final navigator = Navigator.of(context);

    // get token from local storage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    // get data from server
    var url = "https://keluhan1flutter.000webhostapp.com/item_add.php";
    final headers = token == null ? null : {'Authorization': token};
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: {
        'name': _nameController.text,
        'total': _totalController.text,
      },
    );

    if (response.statusCode == 200) {
      navigator.pop();
    } else {
      Map<String, dynamic> data = jsonDecode(response.body);
      var message = data['message'] as String?;
      log(message ?? '');
      if (response.statusCode == 401) {
        navigator.pushReplacementNamed('/login');
      }
    }
  }
}
