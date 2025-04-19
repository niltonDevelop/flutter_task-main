import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertask/core/config/color/app_color_scheme.dart';
import 'package:fluttertask/core/config/config.dart';
import 'package:fluttertask/shared/controller/base_controller.dart';
import 'package:fluttertask/shared/widget/spacing/app_spacer.dart';
import 'package:fluttertask/shared/widget/text_widget.dart';
import 'package:go_router/go_router.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.body,
    this.onBackPressed,
    this.title,
    this.customDrawer,
    this.floatingActionButton,
    this.showFloatingButton = false,
    this.floatingActionButtonLocation,
    super.key,
    this.toolbarHeight = 70,
    this.onPressed,
  });

  final Widget? title;
  final Widget body;
  final VoidCallback? onBackPressed;
  final double toolbarHeight;
  final Widget? customDrawer;
  final Widget? floatingActionButton;
  final bool showFloatingButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    return SafeArea(
      bottom: false,
      child:
          isIOS
              ? _buildCupertinoScaffold(context)
              : _buildMaterialScaffold(context),
    );
  }

  Widget _buildCupertinoScaffold(BuildContext context) {
    return Stack(
      children: [
        CupertinoPageScaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          child: CustomScrollView(
            physics: const NeverScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    bottom: 10,
                    left: 10,
                    right: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (onBackPressed != null)
                        CupertinoButton(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          padding: EdgeInsets.zero,
                          onPressed: onBackPressed,
                          child: Icon(
                            CupertinoIcons.back,
                            size: 30,
                            color: AppColorScheme.of(context).secundary,
                          ),
                        )
                      else if (customDrawer != null)
                        CupertinoButton(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            showCupertinoModalPopup(
                              context: context,
                              builder:
                                  (_) => CupertinoActionSheet(
                                    title: const Text(
                                      'Menú',
                                      style: AppStyles.h2TextBlack,
                                    ),
                                    actions: [customDrawer!],
                                    cancelButton: CupertinoActionSheetAction(
                                      isDefaultAction: false,
                                      isDestructiveAction: true,
                                      onPressed: context.pop,
                                      child: Text(context.loc.cancel),
                                    ),
                                  ),
                            );
                          },
                          child: Icon(
                            CupertinoIcons.bars,
                            size: 30,
                            color: AppColorScheme.of(context).secundary,
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                      const SizedBox(width: 10),
                      Expanded(child: Center(child: title)),
                      (onBackPressed != null || customDrawer != null)
                          ? const SizedBox(width: 30)
                          : const SizedBox.shrink(),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
              ),
              SliverFillRemaining(child: body),
            ],
          ),
        ),
        if (showFloatingButton)
          Positioned(
            bottom: 20,
            right: 20,
            child: Builder(
              builder: (context) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColorScheme.of(context).textSecundary,
                  ),
                  child: CupertinoButton(
                    padding: const EdgeInsets.all(16),
                    borderRadius: BorderRadius.circular(30),
                    color: AppColorScheme.of(context).textSecundary,
                    onPressed: onPressed,
                    child: Row(
                      children: [
                        Icon(
                          CupertinoIcons.add,
                          color: AppColorScheme.of(context).textPrimary,
                        ),
                        AppHorizontalSpace.sm,
                        AppText(
                          text: context.loc.addTask,
                          color: AppColorScheme.of(context).textPrimary,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildMaterialScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        forceMaterialTransparency: true,
        elevation: 0,
        leadingWidth: 36,
        title: title,
        toolbarHeight: toolbarHeight,
        leading:
            onBackPressed != null
                ? IconButton(
                  onPressed: onBackPressed,
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.arrow_back),
                )
                : (customDrawer != null
                    ? Builder(
                      builder:
                          (context) => IconButton(
                            onPressed: () => Scaffold.of(context).openDrawer(),
                            icon: const Icon(Icons.menu),
                          ),
                    )
                    : null),
      ),
      drawer: customDrawer != null ? Drawer(child: customDrawer) : null,
      body: body,
      floatingActionButton:
          showFloatingButton
              ? FloatingActionButton.extended(
                backgroundColor: AppColorScheme.of(context).textSecundary,
                onPressed: onPressed,
                label: Row(
                  children: [
                    Icon(
                      Icons.add,
                      color: AppColorScheme.of(context).textPrimary,
                    ),
                    AppHorizontalSpace.sm,
                    AppText(
                      text: context.loc.addTask,
                      color: AppColorScheme.of(context).textPrimary,
                    ),
                  ],
                ),
              )
              : null,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}
