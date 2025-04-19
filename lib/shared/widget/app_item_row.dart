import 'package:flutter/material.dart';
import 'package:fluttertask/core/config/config.dart';
import 'package:fluttertask/shared/widget/app_shimmer.dart';
import 'package:fluttertask/shared/widget/spacing/app_spacer.dart';

class AppItemRow extends StatelessWidget {
  const AppItemRow({
    required this.title,
    required this.subTitle,
    this.icon,
    super.key,
    this.isDivider = false,
    this.maxLines = 3,
    this.maxWidth = 160,
  });
  final String title;
  final String subTitle;
  final bool isDivider;
  final IconData? icon;
  final int? maxLines;
  final double? maxWidth;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            if (icon != null) ...[Icon(icon, size: 18), AppHorizontalSpace.sm],
            SizedBox(
              width: maxWidth,
              child: Text(
                '$title :',
                maxLines: 2,
                style: AppStyles.bodyTextBold,
              ),
            ),
            Flexible(
              child: AppShimmer(
                enabled: subTitle == '' || subTitle == 'null',
                child: Text(
                  subTitle,
                  overflow: TextOverflow.ellipsis,
                  maxLines: maxLines,
                ),
              ),
            ),
          ],
        ),
        if (isDivider) ...[
          const Padding(
            padding: EdgeInsets.all(8),
            child: Divider(height: 0.5),
          ),
        ],
      ],
    );
  }
}
