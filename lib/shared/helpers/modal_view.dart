import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertask/core/config/config.dart';
import 'package:fluttertask/shared/widget/app_button_icon.dart';
import 'package:fluttertask/shared/widget/spacing/spacing.dart';
import 'package:go_router/go_router.dart';

class ModalView extends StatelessWidget {
  const ModalView({
    required this.titleHeader,
    this.child,
    this.onSaved,
    this.showCancelButton = true,
    this.showDivider = true,
    super.key,
    this.saveText = 'Guardar',
    this.cancelText = 'Cancelar',
  });

  Future<T?> show<T>(BuildContext context, {bool isDismissible = true}) async {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return showCupertinoModalPopup<T>(context: context, builder: build);
    } else {
      return showModalBottomSheet<T>(
        context: context,
        isScrollControlled: true,
        builder: build,
        isDismissible: isDismissible,
      );
    }
  }

  final String titleHeader;
  final Widget? child;
  final void Function(BuildContext)? onSaved;
  final bool showCancelButton;
  final bool showDivider;
  final String saveText;
  final String cancelText;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    final content = Padding(
      padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(titleHeader, style: AppStyles.headingPrimary),
            AppVerticalSpace.md,
            if (showDivider) ...[
              const Divider(height: 0.5, color: AppColors.greyscale200),
              AppVerticalSpace.md,
            ],
            if (child != null) ...[child!, AppVerticalSpace.md],
            if (onSaved != null) ...[
              AppButton(
                showIcon: false,
                text: saveText,
                onPressed: () => onSaved!(context),
              ),
              AppVerticalSpace.md,
            ],
            if (showCancelButton) ...[
              AppButton(text: cancelText, onPressed: context.pop),
              AppVerticalSpace.xmd,
            ],
          ],
        ),
      ),
    );

    return Theme.of(context).platform == TargetPlatform.iOS
        ? CupertinoActionSheet(
          title: Text(titleHeader, style: AppStyles.headingPrimary),
          message: child,
          actions: [
            if (onSaved != null)
              CupertinoActionSheetAction(
                onPressed: () => onSaved!(context),
                child: Text(
                  saveText,
                  style: TextStyle(color: CupertinoColors.activeBlue),
                ),
              ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: context.pop,
            child: Text(
              cancelText,
              style: TextStyle(color: CupertinoColors.destructiveRed),
            ),
          ),
        )
        : content;
  }
}
