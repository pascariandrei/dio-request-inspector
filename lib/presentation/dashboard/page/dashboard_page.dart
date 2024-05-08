import 'package:dio_request_inspector/common/enums.dart';
import 'package:dio_request_inspector/presentation/dashboard/provider/dashboard_notifier.dart';
import 'package:dio_request_inspector/presentation/dashboard/widget/item_response_widget.dart';
import 'package:dio_request_inspector/presentation/dashboard/widget/password_protection_dialog.dart';
import 'package:dio_request_inspector/presentation/detail/page/detail_page.dart';
import 'package:dio_request_inspector/presentation/resources/color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  static const routeName = '/dio-request-inspector/dashboard';
  final String password;

  const DashboardPage({Key? key, this.password = ''}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
   HttpActivity? httpActivity;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    httpActivity = null;
    if (widget.password.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        dialogInputPassword();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return httpActivity != null
        ? DetailPage(
            data: httpActivity!,
            onBackTap: () {
              httpActivity = null;
              setState(() {});
            },
          )
        : GestureDetector(
            onLongPress: () {},
            child: ChangeNotifierProvider<DashboardNotifier>(
              create: (context) => DashboardNotifier(),
              child: Consumer<DashboardNotifier>(
                builder: (context, provider, child) {
                  return Scaffold(
                      backgroundColor: Colors.grey[200],
                      appBar: AppBar(
                        shadowColor: Colors.transparent,
                        surfaceTintColor: Colors.transparent,
                        leading: IconButton(
                            onPressed: () {
                              provider.clearAllResponses();
                            },
                            icon: Icon(Icons.delete, color: AppColor.primary)),
                        actions: [
                          IconButton(
                              onPressed: () {
                                provider.toggleSearch();
                              },
                              icon: Icon(
                                provider.isSearch ? Icons.close : Icons.search,
                                color: AppColor.primary,
                              )),
                          PopupMenuButton(
                              icon: Icon(
                                Icons.sort,
                                color: AppColor.primary,
                              ),
                              iconColor: Colors.white,
                              itemBuilder: (context) {
                                return [
                                  const PopupMenuItem(
                                    value: SortActivity.byTime,
                                    child: Text('Time'),
                                  ),
                                  const PopupMenuItem(
                                    value: SortActivity.byMethod,
                                    child: Text('Method'),
                                  ),
                                  const PopupMenuItem(
                                    value: SortActivity.byStatus,
                                    child: Text('Status'),
                                  ),
                                ];
                              },
                              onSelected: (value) {
                                provider.sortAllResponses(value);
                              })
                        ],
                        title: !provider.isSearch
                            ? Text('Http Activities', style: TextStyle(color: AppColor.primary))
                            : TextField(
                                style: TextStyle(color: AppColor.primary),
                                autofocus: true,
                                onChanged: (value) {
                                  provider.search(value);
                                },
                                focusNode: provider.focusNode,
                                controller: provider.searchController,
                                decoration: InputDecoration(
                                  hintText: 'Search',
                                  focusColor: AppColor.primary,
                                  hintStyle: TextStyle(color: AppColor.primary),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                ),
                              ),
                        backgroundColor: Colors.white,
                      ),
                      body: buildBody(context, provider));
                },
              ),
            ),
          );
  }

  Widget buildBody(BuildContext context, DashboardNotifier provider) {
    if (provider.getAllResponsesState == RequestState.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (provider.getAllResponses.isEmpty) {
      return const Center(
        child: Text('No Http Activities'),
      );
    } else {
      return ListView.builder(
        itemCount: provider.isSearch ? provider.activityFromSearch.length : provider.getAllResponses.length,
        itemBuilder: (context, index) {
          var data = provider.isSearch ? provider.activityFromSearch[index] : provider.getAllResponses[index];
          return InkWell(
            onTap: () {
              setState(() {
                httpActivity = data;
              });
            },
            child: ItemResponseWidget(data: data),
          );
        },
      );
    }
  }

  void dialogInputPassword() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PasswordProtectionDialog(
          password: widget.password,
        );
      },
    );
  }
}

