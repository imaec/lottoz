import 'package:collection/collection.dart';
import 'package:core/utils/lotto_utils.dart';
import 'package:designsystem/assets/icons.dart';
import 'package:designsystem/component/divider/horizontal_divider.dart';
import 'package:designsystem/component/media/svg_icon.dart';
import 'package:designsystem/component/number/number.dart';
import 'package:designsystem/theme/colors.dart';
import 'package:designsystem/theme/fonts.dart';
import 'package:flutter/material.dart';
import 'package:lottoz/model/lotto_vo.dart';
import 'package:lottoz/ui/statistics/pick/pick_statistics_vo.dart';
import 'package:lottoz/ui/statistics/sum/sum_statistics_vo.dart';

import 'continuous/continuous_statistics_vo.dart';
import 'odd_even/odd_even_statistics_vo.dart';

part 'continuous/continuous_tab_content.dart';
part 'odd_even/odd_even_tab_content.dart';
part 'pick/pick_tab_content.dart';
part 'statistics_header.dart';
part 'sum/sum_tab_content.dart';
part 'win/win_tab_content.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(
    length: 5,
    vsync: this,
    initialIndex: 0,
  );
  late final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _statisticsBody(),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Widget _statisticsBody() {
    return Column(
      children: [
        Container(
          color: gray700,
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            dividerColor: Colors.transparent,
            indicatorColor: white,
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: white,
            labelStyle: h5,
            labelPadding: const EdgeInsets.symmetric(horizontal: 16),
            unselectedLabelColor: gray400,
            unselectedLabelStyle: subtitle2,
            tabAlignment: TabAlignment.start,
            tabs: const [
              Tab(text: '합계', height: 50),
              Tab(text: '출현/미출현', height: 50),
              Tab(text: '연속번호', height: 50),
              Tab(text: '홀/짝', height: 50),
              Tab(text: '당첨', height: 50),
            ],
            onTap: (index) {
              setState(() {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                );
              });
            },
          ),
        ),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _tabController.animateTo(index);
              });
            },
            itemBuilder: (context, index) {
              switch (index) {
                case 0:
                  return _sumTabContent();
                case 1:
                  return _pickTabContent();
                case 2:
                  return _continuousTabContent();
                case 3:
                  return _oddEvenTabContent();
                case 4:
                  return _winTabContent();
                default:
                  return null;
              }
            },
          ),
        ),
      ],
    );
  }
}
