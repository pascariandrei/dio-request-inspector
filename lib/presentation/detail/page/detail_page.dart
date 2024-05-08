import 'package:dio_request_inspector/data/models/http_activity.dart';
import 'package:dio_request_inspector/presentation/detail/provider/detail_notifier.dart';
import 'package:dio_request_inspector/presentation/resources/color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatelessWidget {
  static const routeName = '/dio-request-inspector/detail';

  final HttpActivity data;
  final VoidCallback onBackTap;

  const DetailPage({Key? key, required this.data, required this.onBackTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {},
      child: ChangeNotifierProvider<DetailNotifier>(
          create: (context) => DetailNotifier(data: data),
          builder: (context, child) {
            return DefaultTabController(
              length: 4,
              child: Scaffold(
                appBar: _appBar(context),
                floatingActionButton: _floatingActionButton(context),
                body: _buildBody(context),
              ),
            );
          }),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Consumer<DetailNotifier>(
      builder: (context, provider, child) {
        return TabBarView(
          children: [
            _overviewWidget(provider.overviews),
            _requestWidget(provider.requests),
            _responseWidget(provider.responses),
            _errorWidget(provider.errors),
          ],
        );
      },
    );
  }

  Widget _responseWidget(List<Widget> responses) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: responses,
      ),
    );
  }

  Widget _errorWidget(List<Widget> errors) {
    return errors.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.warning, color: AppColor.primary, size: 50),
                Text('No error found', style: TextStyle(color: AppColor.primary)),
              ],
            ),
          )
        : SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: errors,
            ),
          );
  }

  Widget _requestWidget(List<Widget> requests) {
    return SingleChildScrollView(physics: const BouncingScrollPhysics(), child: Column(children: requests));
  }

  Widget _overviewWidget(List<Widget> overviews) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: overviews,
        ),
      ),
    );
  }

  Widget _floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        context.read<DetailNotifier>().share();
      },
      backgroundColor: AppColor.primary,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), bottomLeft: Radius.circular(100), bottomRight: Radius.circular(100), topLeft: Radius.circular(100))),
      child: const Icon(Icons.share, color: Colors.white),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.white,
      title: const Text('Detail Activity', style: TextStyle(color: Colors.black)),
      elevation: 3,
      leading: IconButton(
        onPressed: () {
          onBackTap();
        },
        icon: const Icon(Icons.arrow_back, color: Colors.black),
      ),
      bottom: const TabBar(
        indicatorColor: Colors.blueGrey,
        labelColor: Colors.black,
        tabs: [
          Tab(
            text: 'Overview',
            icon: Icon(
              Icons.info,
              color: Colors.black,
            ),
          ),
          Tab(
            text: 'Request',
            icon: Icon(Icons.arrow_upward, color: Colors.black),
          ),
          Tab(
            text: 'Response',
            icon: Icon(Icons.arrow_downward, color: Colors.black),
          ),
          Tab(
            text: 'Error',
            icon: Icon(Icons.warning, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
