import 'package:designsystem/assets/icons.dart';
import 'package:designsystem/component/media/svg_icon.dart';
import 'package:designsystem/theme/colors.dart';
import 'package:designsystem/theme/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class LottoAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double topPadding;
  final bool hasBack;

  const LottoAppBar({super.key, required this.title, this.topPadding = 0, this.hasBack = false});

  @override
  Size get preferredSize => Size.fromHeight(52 + topPadding);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(height: topPadding, color: gray700),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            height: 52,
            color: gray700,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  hasBack
                      ? Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                context.pop();
                              },
                              child: const SvgIcon(asset: backIcon, size: 24, color: white),
                            ),
                            const SizedBox(width: 16),
                          ],
                        )
                      : const SizedBox(),
                  Text(title, style: h4.copyWith(color: white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
