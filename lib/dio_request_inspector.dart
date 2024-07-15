library dio_request_inspector;

import 'package:dio_request_inspector/common/injection.dart' as di;
import 'package:dio_request_inspector/common/interceptor.dart';
import 'package:dio_request_inspector/presentation/dashboard/page/dashboard_page.dart';
import 'package:flutter/material.dart';

class DioRequestInspector {
  static final navigatorObserver = NavigatorObserver();

  final bool isDebugMode;
  final bool showFloating;
  final Duration? duration;
  final String? password;

  DioRequestInspector({
    required this.isDebugMode,
    this.duration = const Duration(milliseconds: 500),
    this.showFloating = true,
    this.password = '',
  }) {
    di.init();
  }

  Interceptor getDioRequestInterceptor() {
    return Interceptor(
        kIsDebug: isDebugMode,
        navigatorKey: navigatorObserver,
        duration: duration,
        showFloating: showFloating);
  }

  void toInspector() {
    DioRequestInspector.navigatorObserver.navigator?.push(
        MaterialPageRoute<dynamic>(
            builder: (_) => DashboardPage(password: password!)));
  }


  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kIsDebug) {
      print("Request [${options.method}] ${options.path}");
      print("Headers: ${options.headers}");
      print("Data: ${options.data}");
    }
    handler.next(options); // Ensure this is called only once
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kIsDebug) {
      print("Response [${response.statusCode}] ${response.requestOptions.path}");
      print("Data: ${response.data}");
    }
    handler.next(response); // Ensure this is called only once
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (kIsDebug) {
      print("Error: ${err.message}");
    }
    handler.next(err); // Ensure this is called only once
  }
}
