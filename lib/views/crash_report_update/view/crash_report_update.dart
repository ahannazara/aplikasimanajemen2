import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_3/models/crash_report_model.dart';
import 'package:flutter_application_3/widgets/dropdown_widget.dart';
import 'package:flutter_application_3/widgets/field_image_widget.dart';
import 'package:flutter_application_3/widgets/field_time_widget.dart';
import 'package:flutter_application_3/widgets/field_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CrashReportUpdatePage extends StatefulWidget {
  const CrashReportUpdatePage({
    super.key,
    this.report,
  });

  final DataCrashReport? report;

  @override
  State<CrashReportUpdatePage> createState() => _CrashReportUpdatePageState();
}

class _CrashReportUpdatePageState extends State<CrashReportUpdatePage> {
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  ImagePicker picker = ImagePicker();
  String? tempImg;
  String? dropdownValue;

  List<String> listValue = ['Open', 'Close'];

  @override
  void initState() {
    super.initState();
    final report = widget.report;
    dropdownValue = listValue[0];
    if (report != null) {
      _descController.text = report.description ?? '';
      _timeController.text = DateFormat('dd MMM yyyy', 'id_ID').format(
        report.time ?? DateTime.now(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.report == null ? 'Report Crash Create' : 'Report Crash Update',
        ),
        toolbarHeight: 50,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownWidget(
              onChanged: (value) => setState(() => dropdownValue = value),
              dropdownValue: dropdownValue ?? listValue[0],
              listValue: listValue,
            ),
            const SizedBox(height: 16),
            FieldWidget(
              controller: _descController,
              label: 'Repair Process',
              lines: 3,
            ),
            const SizedBox(height: 16),
            FieldTimeWidget(
              controller: _timeController,
              label: 'Time',
            ),
            const SizedBox(height: 16),
            FieldImageWidget(
              urlImage: null,
              label: 'Image',
              pathTemp: tempImg,
              onEvent: (String path) => setState(() => tempImg = path),
              picker: picker,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () =>
                  widget.report == null ? _fetchCreate() : _fetchUpdate(),
              child: Text(widget.report == null ? "CREATE" : "UPDATE"),
            )
          ],
        ),
      ),
    );
  }

  _fetchUpdate() async {
    final navigator = Navigator.of(context);

    // get token from local storage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    // get data from server
    var url =
        "https://keluhan1flutter.000webhostapp.com/crash_report_update.php";
    if (token != null) {
      http.MultipartRequest request = http.MultipartRequest(
        'POST',
        Uri.parse(url),
      );
      request.headers['Authorization'] = token;
      final path = tempImg;

      if (path != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', path),
        );
      }

      request.fields['id'] = widget.report?.id ?? '';
      request.fields['description'] = _descController.text;
      request.fields['status'] = dropdownValue ?? listValue[0];
      request.fields['time'] = _timeController.text;

      final send = await request.send();
      final response = await http.Response.fromStream(send);
      log("Request fields: ${request.fields}");
      log("Request files: ${request.files}");
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
  }

  _fetchCreate() async {
    final navigator = Navigator.of(context);

    // get token from local storage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    // get data from server
    var url = "https://keluhan1flutter.000webhostapp.com/crash_report_add.php";
    if (token != null) {
      http.MultipartRequest request = http.MultipartRequest(
        'POST',
        Uri.parse(url),
      );
      request.headers['Authorization'] = token;
      final path = tempImg;

      if (path != null) {
        request.files.add(await http.MultipartFile.fromPath('image', path));
      }

      request.fields['id'] = widget.report?.id ?? '';
      request.fields['description'] = _descController.text;
      request.fields['status'] = dropdownValue ?? listValue[0];
      request.fields['time'] = _timeController.text;

      final send = await request.send();
      final response = await http.Response.fromStream(send);

      log("Request fields: ${request.fields}");
      log("Request files: ${request.files}");
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
  }
}
