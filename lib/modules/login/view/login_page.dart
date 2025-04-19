import 'package:flutter/material.dart';
import 'package:fluttertask/modules/login/view/login_view.dart';
import 'package:fluttertask/shared/widget/app_scaffold.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  factory LoginPage.routeBuilder(_, __) {
    return LoginPage(key: const Key('login_page'));
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(body: LoginView());
  }
}
