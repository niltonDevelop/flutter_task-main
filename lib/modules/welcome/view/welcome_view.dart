import 'package:flutter/material.dart';
import 'package:fluttertask/core/constants/routes.dart';
import 'package:fluttertask/shared/controller/base_controller.dart';
import 'package:fluttertask/shared/widget/spacing/spacing.dart';
import 'package:fluttertask/shared/widget/widget.dart';
import 'package:go_router/go_router.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Hero(
                tag: 'logo',
                child: Image.asset(
                  'assets/img/note.png',
                  width: 200,
                  height: 200,
                ),
              ),
              AppVerticalSpace.md,
              AppText(
                text: context.loc.welcome,
                fontSize: AppSpacing.xmd,
                fontWeight: FontWeight.bold,
              ),
              AppText(
                text: context.loc.descriptionWelcome,
                fontSize: AppSpacing.md,
                fontWeight: FontWeight.w400,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppVerticalSpace.xslg,
                  AppButton(
                    text: context.loc.getStarted,
                    onPressed: () {
                      context.go(Routes.register.description);
                    },
                    showIcon: false,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
