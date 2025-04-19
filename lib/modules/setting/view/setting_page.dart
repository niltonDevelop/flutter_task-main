import 'package:flutter/material.dart';
import 'package:fluttertask/core/auth/repository/user_repository.dart';
import 'package:fluttertask/core/config/config.dart';
import 'package:fluttertask/core/network/api_service.dart';
import 'package:fluttertask/modules/setting/controller/setting_controller.dart';
import 'package:fluttertask/modules/setting/view/setting_view.dart';
import 'package:fluttertask/shared/controller/base_controller.dart';
import 'package:fluttertask/shared/widget/app_scaffold.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  factory SettingPage.routeBuilder(_, __) {
    return SettingPage(key: const Key('setting_page'));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingController>(
      create:
          (_) => SettingController(
            userRepository: UserRepository(apiService: ApiService()),
          )..getUser(),
      child: AppScaffold(
        title: Text(context.loc.setting, style: AppStyles.headingPrimary),
        onBackPressed: context.pop,
        body: SettingView(),
      ),
    );
  }
}
