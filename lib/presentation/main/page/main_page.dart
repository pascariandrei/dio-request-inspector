import 'package:dio_request_inspector/dio_request_inspector.dart';
import 'package:dio_request_inspector/presentation/dashboard/page/dashboard_page.dart';
import 'package:flutter/material.dart';

class DioRequestInspectorMain extends StatelessWidget {
   final DioRequestInspector inspector;

  const DioRequestInspectorMain(
      {Key? key, required this.child, required this.inspector})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DashboardPage();
  }
}
