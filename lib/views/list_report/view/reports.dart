import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_3/models/crash_report_model.dart';
import 'package:flutter_application_3/models/payload_model.dart';
import 'package:flutter_application_3/models/work_report_model.dart';
import 'package:flutter_application_3/views/list_report/widget/crash_reports.dart';
import 'package:flutter_application_3/views/list_report/widget/work_reports.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:excel/excel.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({
    super.key,
    this.listTab,
  });

  final List<String>? listTab;

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage>
    with SingleTickerProviderStateMixin {
  List<DataCrashReport?>? crashReports = [];
  List<DataWorkReport?>? workReports = [];
  List<String> listTab = [];
  late TabController _tabController;
  PayloadModel? payloadModel;

  @override
  void initState() {
    super.initState();
    _init();
    listTab = widget.listTab ?? [];
    if (listTab.isEmpty) listTab = ['Work', 'Crash'];
    _tabController = TabController(
      length: listTab.length,
      vsync: this,
      initialIndex: 0,
    );
    _listenTab(listTab);
    _tabController.addListener(() => _listenTab(listTab));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Report'),
        toolbarHeight: 50,
        bottom: TabBar(
          controller: _tabController,
          tabs: listTab.map((e) => Tab(text: e)).toList(),
        ),
      ),
      body: _tabbar(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _printDataButton(),
            const SizedBox(width: 16),
            _floatingButton(),
          ],
        ),
      ),
    );
  }

  Widget _printDataButton() {
    final role = payloadModel?.role;
    if (listTab[_tabController.index] == 'Work' &&
        role != null &&
        role == Role.admin) {
      return GestureDetector(
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.blue,
          ),
          child: const Icon(
            Icons.print_rounded,
            color: Colors.white,
          ),
        ),
        onTap: () async {
          var directory = await getApplicationDocumentsDirectory();

          var status = await Permission.storage.status;
          if (!status.isGranted) {
            await Permission.storage.request();
          }

          if (Platform.isAndroid) {
            directory = Directory("/storage/emulated/0/Download");
          }

          _workReportExcel(directory);
          log(directory.path);
        },
      );
    } else if (listTab[_tabController.index] == 'Crash' &&
        role != null &&
        role == Role.admin) {
      return GestureDetector(
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.blue,
          ),
          child: const Icon(
            Icons.print_rounded,
            color: Colors.white,
          ),
        ),
        onTap: () async {
          var directory = await getApplicationDocumentsDirectory();

          var status = await Permission.storage.status;
          if (!status.isGranted) {
            await Permission.storage.request();
          }

          if (Platform.isAndroid) {
            directory = Directory("/storage/emulated/0/Download");
          }

          _crashReportExcel(directory);
        },
      );
    }
    return const SizedBox();
  }

  Widget _floatingButton() {
    final role = payloadModel?.role;
    if (listTab[_tabController.index] == 'Work' &&
        role != null &&
        (role == Role.houseKeeping ||
            role == Role.mechanicalElectrical ||
            role == Role.admin)) {
      return GestureDetector(
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.blue,
          ),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        onTap: () => Navigator.pushNamed(context, '/reports/work/update').then(
          (value) async => _fetchWorkReports(),
        ),
      );
    } else if (listTab[_tabController.index] == 'Crash' &&
        role != null &&
        role == Role.admin) {
      return GestureDetector(
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.blue,
          ),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        onTap: () => Navigator.pushNamed(context, '/reports/crash/update').then(
          (value) async => _fetchCrashReports(),
        ),
      );
    }
    return const SizedBox();
  }

  Widget _tabbar() {
    final role = payloadModel?.role;
    List<Widget> listView = listTab.map((e) {
      if (e == 'Work' && role != null) {
        return WorkReportsWidget(
          reports: workReports,
          onUpdate: (report) => Navigator.pushNamed(
            context,
            '/reports/work/update',
            arguments: report,
          ).then((value) async => _fetchWorkReports()),
          onDelete: (id) async => _fetchWorkDelete(id: id),
          role: role,
        );
      } else if (e == 'Crash' && role != null) {
        return CrashReportsWidget(
          role: role,
          reports: crashReports,
          onUpdate: (report) => Navigator.pushNamed(
            context,
            '/reports/crash/update',
            arguments: report,
          ).then((value) async => _fetchCrashReports()),
          onDelete: (id) async => _fetchCrashDelete(id: id),
        );
      }
      return const SizedBox();
    }).toList();

    return TabBarView(
      controller: _tabController,
      children: listView,
    );
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

  _fetchWorkReports() async {
    final navigator = Navigator.of(context);

    // get token from local storage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    // get data from server
    var url = "https://keluhan1flutter.000webhostapp.com/work_reports.php";

    final headers = token == null ? null : {'Authorization': token};
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      log("Response status: ${response.statusCode}");
      log("Response body: ${response.body}");

      Map<String, dynamic> decode = jsonDecode(response.body);
      final data = WorkReportModel.fromMap(decode);

      setState(() => workReports = data.data);
    } else {
      Map<String, dynamic> data = jsonDecode(response.body);
      var message = data['message'] as String?;
      log(message ?? '');

      if (response.statusCode == 401) {
        navigator.pushReplacementNamed('/login');
      }
    }
  }

  _fetchCrashReports() async {
    final navigator = Navigator.of(context);

    // get token from local storage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    // get data from server
    var url = "https://keluhan1flutter.000webhostapp.com/crash_reports.php";

    final headers = token == null ? null : {'Authorization': token};
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      log("Response status: ${response.statusCode}");
      log("Response body: ${response.body}");

      Map<String, dynamic> decode = jsonDecode(response.body);
      final data = CrashReportModel.fromMap(decode);

      setState(() => crashReports = data.data);
    } else {
      Map<String, dynamic> data = jsonDecode(response.body);
      var message = data['message'] as String?;
      log(message ?? '');

      if (response.statusCode == 401) {
        navigator.pushReplacementNamed('/login');
      }
    }
  }

  _fetchWorkDelete({String? id}) async {
    final navigator = Navigator.of(context);

    // get token from local storage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    // get data from server
    var url =
        "https://keluhan1flutter.000webhostapp.com/work_report_delete.php";
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
      await _fetchWorkReports();
    } else {
      Map<String, dynamic> data = jsonDecode(response.body);
      var message = data['message'] as String?;
      log(message ?? '');
      if (response.statusCode == 401) {
        navigator.pushReplacementNamed('/login');
      }
    }
  }

  _fetchCrashDelete({String? id}) async {
    final navigator = Navigator.of(context);

    // get token from local storage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    // get data from server
    var url =
        "https://keluhan1flutter.000webhostapp.com/crash_report_delete.php";
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
      await _fetchCrashReports();
    } else {
      Map<String, dynamic> data = jsonDecode(response.body);
      var message = data['message'] as String?;
      log(message ?? '');
      if (response.statusCode == 401) {
        navigator.pushReplacementNamed('/login');
      }
    }
  }

  void _listenTab(List<String> listTab) {
    if (listTab[_tabController.index] == 'Work') {
      _fetchWorkReports();
    } else if (listTab[_tabController.index] == 'Crash') {
      _fetchCrashReports();
    }
  }

  void _crashReportExcel(Directory directory) {
    // Create an Excel workbook
    var excel = Excel.createExcel();

    // Create a sheet in the workbook
    Sheet sheet = excel['Work Report'];

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0)).value =
        'ID';
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0)).value =
        'USER ID';
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0)).value =
        'USERNAME';
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0)).value =
        'DESCRIPTION';
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 0)).value =
        'IMAGE';
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 0)).value =
        'STATUS REPORT';
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 0)).value =
        'TIME';

    (crashReports ?? []).asMap().entries.map((entry) {
      int index = entry.key + 1;
      DataCrashReport? val = entry.value;
      if (val != null) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: index))
            .value = val.id;
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: index))
            .value = val.userId;
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: index))
            .value = val.username;
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: index))
            .value = val.description;
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: index))
            .value = val.image;
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: index))
            .value = val.status;
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: index))
            .value = val.time.toString();
      }
    }).toList();

    // Save the Excel file
    var fileBytes = excel.save();

    File('${directory.path}/crash report.xlsx')
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes ?? []);
  }

  void _workReportExcel(Directory directory) {
    // Create an Excel workbook
    var excel = Excel.createExcel();

    // Create a sheet in the workbook
    Sheet sheet = excel['Work Report'];

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0)).value =
        'ID';
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0)).value =
        'USER ID';
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0)).value =
        'USERNAME';
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0)).value =
        'LOCATION';
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: 0)).value =
        'BUILDING';
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: 0)).value =
        'DESCRIPTION';
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: 0)).value =
        'REPAIR PROCESS';
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: 0)).value =
        'STATUS REPORT';
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: 0)).value =
        'IMAGE BEFORE';
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: 0)).value =
        'IMAGE AFTER';
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 10, rowIndex: 0)).value =
        'START TIME';
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 11, rowIndex: 0)).value =
        'FINISH TIME';

    (workReports ?? []).asMap().entries.map((entry) {
      int index = entry.key + 1;
      DataWorkReport? val = entry.value;
      if (val != null) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: index))
            .value = val.id;
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: index))
            .value = val.userId;
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: index))
            .value = val.username;
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: index))
            .value = val.location;
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: index))
            .value = val.building;
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: index))
            .value = val.description;
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: index))
            .value = val.repair;
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: index))
            .value = val.status;
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: index))
            .value = val.imageBefore;
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: index))
            .value = val.imageBefore;
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 10, rowIndex: index))
            .value = val.startTime.toString();
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 11, rowIndex: index))
            .value = val.finishTime.toString();
      }
    }).toList();

    // Save the Excel file
    var fileBytes = excel.save();

    File('${directory.path}/work report.xlsx')
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes ?? []);
  }
}
