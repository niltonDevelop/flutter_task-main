import 'package:flutter/material.dart';
import 'package:fluttertask/core/config/color/app_colors.dart';
import 'package:fluttertask/core/config/style/app_styles.dart';

class AppDecorations {
  static InputDecoration textFormFieldDecoration({
    String? hintText,
    IconData? suffixIcon,
  }) {
    return InputDecoration(
      isDense: true,
      labelStyle: AppStyles.bodyText,
      alignLabelWithHint: false,
      hintText: hintText ?? '...',
      hintStyle: AppStyles.bodyHintText,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.secondaryBackground),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.secondaryBackground),
        borderRadius: BorderRadius.circular(10),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.error),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.error),
        borderRadius: BorderRadius.circular(10),
      ),
      filled: true,
      fillColor: AppColors.primaryBackground,
      suffixIcon: Icon(suffixIcon, size: 24, color: AppColors.primaryLead),
      contentPadding: const EdgeInsets.all(10),
    );
  }
}
