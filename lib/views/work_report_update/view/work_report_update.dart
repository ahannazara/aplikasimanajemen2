import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_3/models/work_report_model.dart';
import 'package:flutter_application_3/widgets/dropdown_widget.dart';
import 'package:flutter_application_3/widgets/field_image_widget.dart';
import 'package:flutter_application_3/widgets/field_time_widget.dart';
import 'package:flutter_application_3/widgets/field_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class WorkReportUpdatePage extends StatefulWidget {
  const WorkReportUpdatePage({
    super.key,
    this.report,
  });

  final DataWorkReport? report;

  @override
  State<WorkReportUpdatePage> createState() => _WorkReportUpdatePageState();
}

class _WorkReportUpdatePageState extends State<WorkReportUpdatePage> {
  final TextEditingController _buildingController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _fixingController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _finisController = TextEditingController();

  ImagePicker picker = ImagePicker();
  String? tempImgBefore;
  String? tempImgAfter;
  String? dropdownValue;

  List<String> listValue = ['Open', 'Close'];

  @override
  void initState() {
    super.initState();
    final report = widget.report;
    if (report != null) {
      _buildingController.text = report.building ?? '';
      _locationController.text = report.location ?? '';
      _fixingController.text = report.repair ?? '';
      _descController.text = report.description ?? '';
      _startController.text = DateFormat('dd MMM yyyy', 'id_ID').format(
        report.startTime ?? DateTime.now(),
      );
      _finisController.text = DateFormat('dd MMM yyyy', 'id_ID').format(
        report.finishTime ?? DateTime.now(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.report == null ? 'Report Work Create' : 'Report Work Update',
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
              controller: _buildingController,
              label: 'Building',
            ),
            const SizedBox(height: 16),
            FieldWidget(
              controller: _locationController,
              label: 'Location',
            ),
            const SizedBox(height: 16),
            FieldWidget(
              controller: _fixingController,
              label: 'Fixing description',
              lines: 3,
            ),
            const SizedBox(height: 16),
            FieldWidget(
              controller: _descController,
              label: 'Repair Process',
              lines: 3,
            ),
            const SizedBox(height: 16),
            FieldTimeWidget(
              controller: _startController,
              label: 'Start Time',
            ),
            const SizedBox(height: 16),
            FieldTimeWidget(
              controller: _finisController,
              label: 'Finis Time',
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FieldImageWidget(
                  urlImage: null,
                  label: 'Image Before',
                  pathTemp: tempImgBefore,
                  onEvent: (String path) => setState(
                    () => tempImgBefore = path,
                  ),
                  picker: picker,
                ),
                FieldImageWidget(
                  label: 'Image After',
                  urlImage: null,
                  pathTemp: tempImgAfter,
                  onEvent: (String path) => setState(
                    () => tempImgAfter = path,
                  ),
                  picker: picker,
                )
              ],
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
        "https://keluhan1flutter.000webhostapp.com/work_report_update.php";
    if (token != null) {
      http.MultipartRequest request = http.MultipartRequest(
        'POST',
        Uri.parse(url),
      );
      request.headers['Authorization'] = token;
      final pathBefore = tempImgBefore;
      final pathAfter = tempImgAfter;

      if (pathBefore != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image_before', pathBefore),
        );
      }

      if (pathAfter != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image_after', pathAfter),
        );
      }

      request.fields['id'] = widget.report?.id ?? '';
      request.fields['building'] = _buildingController.text;
      request.fields['location'] = _locationController.text;
      request.fields['description'] = _descController.text;
      request.fields['repair'] = _fixingController.text;
      request.fields['status'] = dropdownValue ?? listValue[0];
      request.fields['start_time'] = _startController.text;
      request.fields['finish_time'] = _finisController.text;

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
    var url = "https://keluhan1flutter.000webhostapp.com/work_report_add.php";
    if (token != null) {
      http.MultipartRequest request = http.MultipartRequest(
        'POST',
        Uri.parse(url),
      );
      request.headers['Authorization'] = token;
      final pathBefore = tempImgBefore;
      final pathAfter = tempImgAfter;

      if (pathBefore != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image_before', pathBefore),
        );
      }

      if (pathAfter != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image_after', pathAfter),
        );
      }

      request.fields['building'] = _buildingController.text;
      request.fields['location'] = _locationController.text;
      request.fields['description'] = _descController.text;
      request.fields['repair'] = _fixingController.text;
      request.fields['status'] = dropdownValue ?? listValue[0];
      request.fields['start_time'] = _startController.text;
      request.fields['finish_time'] = _finisController.text;

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
