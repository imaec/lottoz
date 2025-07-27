import 'package:collection/collection.dart';
import 'package:core/extension/num_extension.dart';
import 'package:core/utils/lotto_utils.dart';
import 'package:designsystem/assets/icons.dart';
import 'package:designsystem/component/divider/horizontal_divider.dart';
import 'package:designsystem/component/media/svg_icon.dart';
import 'package:designsystem/component/number/number.dart';
import 'package:designsystem/component/picker/lotto_number_picker.dart';
import 'package:designsystem/theme/colors.dart';
import 'package:designsystem/theme/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottoz/model/statistics/pick_statistics_vo.dart';
import 'package:lottoz/model/statistics/sum_statistics_vo.dart';
import 'package:lottoz/model/statistics/un_pick_statistics_vo.dart';
import 'package:lottoz/model/statistics/win_statistics_vo.dart';
import 'package:lottoz/ui/statistics/provider/statistics_notifier.dart';
import 'package:lottoz/ui/statistics/provider/statistics_state_provider.dart';

import '../../model/statistics/continuous_statistics_vo.dart';
import '../../model/statistics/odd_even_statistics_vo.dart';

part 'continuous/continuous_tab_content.dart';

part 'odd_even/odd_even_tab_content.dart';

part 'pick/pick_tab_content.dart';

part 'statistics_header.dart';

part 'sum/sum_tab_content.dart';

part 'win/win_tab_content.dart';

class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => StatisticsScreenState();
}

class StatisticsScreenState extends ConsumerState<StatisticsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 5, vsync: this, initialIndex: 0);
  late final PageController _pageController = PageController();

  @override
  void initState() {
    ref.read(statisticsNotifierProvider.notifier).fetchLottoNumber();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(statisticsNotifierProvider.notifier);
    final state = ref.watch(statisticsNotifierProvider);

    return Scaffold(body: _statisticsBody(notifier: notifier, state: state));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Widget _statisticsBody({required StatisticsNotifier notifier, required StatisticsState state}) {
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
        state.lottoNumbers.isEmpty
            ? const Expanded(child: Center(child: CircularProgressIndicator()))
            : Expanded(
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
                        return _sumTabContent(notifier: notifier, state: state);
                      case 1:
                        return _pickTabContent(notifier: notifier, state: state);
                      case 2:
                        return _continuousTabContent(notifier: notifier, state: state);
                      case 3:
                        return _oddEvenTabContent(notifier: notifier, state: state);
                      case 4:
                        return _winTabContent(notifier: notifier, state: state);
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
