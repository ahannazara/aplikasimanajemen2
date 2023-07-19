import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_3/models/items_model.dart';
import 'package:flutter_application_3/models/payload_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ItemsPage extends StatefulWidget {
  const ItemsPage({super.key});

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  List<DataItems?>? items = [];
  PayloadModel? payloadModel;

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Item'),
        toolbarHeight: 50,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          var item = (items ?? [])[index];

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item?.name ?? '',
                        style: const TextStyle(fontSize: 18.0),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Total : ${item?.total}',
                        style: const TextStyle(fontSize: 12.0),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _deleteButton(id: item?.id),
                      _updateButton(item: item),
                    ],
                  ),
                )
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemCount: (items ?? []).length,
      ),
      floatingActionButton: _floatingButton(),
    );
  }

  Widget? _floatingButton() {
    final role = payloadModel?.role;
    if (role != null && (role == Role.supervisor || role == Role.admin)) {
      return FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, '/items/update').then(
          (value) async => _fetchItems(),
        ),
      );
    }
    return null;
  }

  Widget _updateButton({DataItems? item}) {
    final role = payloadModel?.role;
    if (role != null && (role == Role.admin || role == Role.supervisor)) {
      return IconButton(
        onPressed: () => Navigator.pushNamed(
          context,
          '/items/update',
          arguments: item,
        ).then((value) async => _fetchItems()),
        icon: const Icon(Icons.update_rounded),
      );
    }
    return const SizedBox();
  }

  Widget _deleteButton({String? id}) {
    final role = payloadModel?.role;
    if (role != null && (role == Role.admin || role == Role.supervisor)) {
      return IconButton(
        onPressed: () async => _fetchDelete(id: id),
        icon: const Icon(Icons.delete),
      );
    }
    return const SizedBox();
  }

  _fetchDelete({String? id}) async {
    final navigator = Navigator.of(context);

    // get token from local storage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    // get data from server
    var url = "https://keluhan1flutter.000webhostapp.com/item_delete.php";
    final headers = token == null ? null : {'Authorization': token};
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: {'id': id},
    );

    log("Request fields: ${{'id': id}}");
    log("Response status: ${response.statusCode}");
    log("Response body: ${response.body}");

    if (response.statusCode == 200) {
      await _fetchItems();
    } else {
      Map<String, dynamic> data = jsonDecode(response.body);
      var message = data['message'] as String?;
      log(message ?? '');
      if (response.statusCode == 401) {
        navigator.pushReplacementNamed('/login');
      }
    }
  }

  _fetchItems() async {
    final navigator = Navigator.of(context);

    // get token from local storage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token != null) {
      List<int> bytes = base64.decode(token);
      String jsonPayload = utf8.decode(bytes);
      Map<String, dynamic> decodePayload = jsonDecode(jsonPayload);
      setState(() => payloadModel = PayloadModel.fromMap(decodePayload));
    }

    // get data from server
    var url = "https://keluhan1flutter.000webhostapp.com/items.php";
    final headers = token == null ? null : {'Authorization': token};
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      log("Response status: ${response.statusCode}");
      log("Response body: ${response.body}");
      Map<String, dynamic> decode = jsonDecode(response.body);
      final data = ItemsModel.fromMap(decode);
      setState(() => items = data.data);
    } else {
      Map<String, dynamic> data = jsonDecode(response.body);
      var message = data['message'] as String?;
      log('Error : $message');

      if (response.statusCode == 401) {
        navigator.pushReplacementNamed('/login');
      }
    }
  }
}
