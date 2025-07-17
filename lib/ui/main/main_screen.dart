import 'package:collection/collection.dart';
import 'package:designsystem/assets/icons.dart';
import 'package:designsystem/designsystem.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lottoz/ui/main/bottom_item_vo.dart';

class MainScreen extends StatelessWidget {
  final Widget child;

  const MainScreen({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final tabs = [
      BottomItemVo(icon: homeIcon, name: '홈', path: '/home'),
      BottomItemVo(icon: statisticsIcon, name: '통계', path: '/statistics'),
      BottomItemVo(icon: recommendIcon, name: '추천 번호', path: '/recommend'),
      BottomItemVo(icon: moreIcon, name: '더보기', path: '/more'),
    ];
    final currentIndex = tabs.indexOf(
      tabs.firstWhere((tab) => tab.path == GoRouterState.of(context).matchedLocation),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: currentIndex == 0 ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(MediaQuery.of(context).padding.top),
          child: Container(
            height: MediaQuery.of(context).padding.top,
            color: currentIndex == 0 ? Colors.transparent : gray700,
          ),
        ),
        body: child,
        bottomNavigationBar: _mainBottomNavigationBar(
          context: context,
          tabs: tabs,
          currentIndex: currentIndex,
        ),
      ),
    );
  }

  Widget _mainBottomNavigationBar({
    required BuildContext context,
    required List<BottomItemVo> tabs,
    required int currentIndex,
  }) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const HorizontalDivider(),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: Row(
              children: tabs.mapIndexed((index, tab) {
                var isSelected = index == currentIndex;
                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      context.go(tab.path);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgIcon(
                          asset: tab.icon,
                          size: 24,
                          color: isSelected ? gray800 : gray400,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          tab.name,
                          style: dockbar.copyWith(
                            color: isSelected ? gray800 : gray400,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
