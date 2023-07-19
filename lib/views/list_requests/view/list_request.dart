import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_3/models/payload_model.dart';
import 'package:flutter_application_3/models/request_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ListRequestPage extends StatefulWidget {
  const ListRequestPage({super.key});

  @override
  State<ListRequestPage> createState() => _ListRequestPageState();
}

class _ListRequestPageState extends State<ListRequestPage> {
  List<DataRequest?>? request = [];
  PayloadModel? payloadModel;

  @override
  void initState() {
    super.initState();
    _fetchRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Request'),
        toolbarHeight: 50,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          var req = (request ?? [])[index];

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
                        req?.name ?? '',
                        style: const TextStyle(fontSize: 18.0),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'By : ${req?.userName}',
                        style: const TextStyle(fontSize: 12.0),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Total : ${req?.total}',
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
                      _deleteButton(),
                      _updatebutton(req: req),
                    ],
                  ),
                )
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemCount: (request ?? []).length,
      ),
      floatingActionButton: _floatingButton(),
    );
  }

  Widget _updatebutton({DataRequest? req}) {
    final role = payloadModel?.role;
    if (role != null && (role == Role.admin || role == Role.supervisor)) {
      return IconButton(
        onPressed: () => Navigator.pushNamed(
          context,
          '/requests/update',
          arguments: req,
        ).then((value) async => _fetchRequest()),
        icon: const Icon(Icons.update_rounded),
      );
    }
    return const SizedBox();
  }

  Widget _deleteButton() {
    final role = payloadModel?.role;
    if (role != null && (role == Role.admin || role == Role.supervisor)) {
      IconButton(
        onPressed: () => _fetchDelete(),
        icon: const Icon(Icons.delete),
      );
    }
    return const SizedBox();
  }

  Widget? _floatingButton() {
    final role = payloadModel?.role;
    if (role != null &&
        (role == Role.admin ||
            role == Role.houseKeeping ||
            role == Role.mechanicalElectrical)) {
      return FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.pushNamed(context, '/requests/update')
            .then((value) async => _fetchRequest()),
      );
    }
    return null;
  }

  _fetchRequest() async {
    final navigator = Navigator.of(context);

    // get token from local storage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token != null) {
      List<int> bytes = base64.decode(token);
      String jsonPayload = utf8.decode(bytes);
      Map<String, dynamic> decodePayload = jsonDecode(jsonPayload);
      setState(() => payloadModel = PayloadModel.fromMap(decodePayload));
      log(token);
      // get data from server
      var url = "https://keluhan1flutter.000webhostapp.com/requests.php";
      final headers = {'Authorization': token};
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        log("Response status: ${response.statusCode}");
        log("Response body: ${response.body}");
        Map<String, dynamic> decode = jsonDecode(response.body);
        final data = RequestModel.fromMap(decode);
        setState(() => request = data.data);
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

  _fetchDelete({String? id}) async {
    final navigator = Navigator.of(context);

    // get token from local storage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    // get data from server
    var url = "https://keluhan1flutter.000webhostapp.com/request_delete.php";
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
      await _fetchRequest();
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
