import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';

showSnackBar({required BuildContext context, required String message}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      content: SizedBox(
        height: 56,
        child: Center(
          child: Text(
            message,
            style: subtitle2.copyWith(color: white, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      duration: const Duration(milliseconds: 1500),
      dismissDirection: DismissDirection.vertical,
    ),
  );
}
