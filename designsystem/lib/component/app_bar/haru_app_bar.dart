import 'package:designsystem/theme/colors.dart';
import 'package:designsystem/theme/fonts.dart';
import 'package:flutter/material.dart';

class HaruAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const HaruAppBar({
    super.key,
    required this.title,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      height: 52,
      color: gray700,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title, style: h4.copyWith(color: white)),
      ),
    );
  }
}
