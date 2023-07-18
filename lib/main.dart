import 'package:flutter/material.dart';
import 'package:flutter_application_3/models/crash_report_model.dart';

import 'package:flutter_application_3/models/items_model.dart';
import 'package:flutter_application_3/models/work_report_model.dart';
import 'package:flutter_application_3/models/request_model.dart';
import 'package:flutter_application_3/views/crash_report_update/view/crash_report_update.dart';
import 'package:flutter_application_3/views/create_account/view/create_account.dart';
import 'package:flutter_application_3/views/home/view/home.dart';
import 'package:flutter_application_3/views/item_update/view/item_update.dart';
import 'package:flutter_application_3/views/list_items/view/items.dart';
import 'package:flutter_application_3/views/list_requests/view/list_request.dart';
import 'package:flutter_application_3/views/login/view/login.dart';
import 'package:flutter_application_3/views/list_report/view/reports.dart';
import 'package:flutter_application_3/views/request_update/view/request_update.dart';
import 'package:flutter_application_3/views/work_report_update/view/work_report_update.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: '/login',
      routes: {
        '/': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/items': (context) => const ItemsPage(),
        '/items/update': (context) {
          final argument =
              ModalRoute.of(context)?.settings.arguments as DataItems?;
          return ItemUpdate(item: argument);
        },
        '/reports': (context) {
          final argument =
              ModalRoute.of(context)?.settings.arguments as List<String>?;
          return ReportsPage(listTab: argument);
        },
        '/reports/work/update': (context) {
          final argument =
              ModalRoute.of(context)?.settings.arguments as DataWorkReport?;
          return WorkReportUpdatePage(report: argument);
        },
        '/reports/crash/update': (context) {
          final argument =
              ModalRoute.of(context)?.settings.arguments as DataCrashReport?;
          return CrashReportUpdatePage(report: argument);
        },
        '/requests': (context) => const ListRequestPage(),
        '/requests/update': (context) {
          final argument =
              ModalRoute.of(context)?.settings.arguments as DataRequest?;
          return RequestUpdatePage(request: argument);
        },
        '/register' :(context) => const CreateAccountPage(),
      },
    );
  }
}
