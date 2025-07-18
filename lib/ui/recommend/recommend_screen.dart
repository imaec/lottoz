import 'package:designsystem/assets/icons.dart';
import 'package:designsystem/component/app_bar/haru_app_bar.dart';
import 'package:designsystem/component/divider/horizontal_divider.dart';
import 'package:designsystem/component/media/svg_icon.dart';
import 'package:designsystem/component/number/number.dart';
import 'package:designsystem/theme/colors.dart';
import 'package:designsystem/theme/fonts.dart';
import 'package:flutter/material.dart';

class RecommendScreen extends StatelessWidget {
  const RecommendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HaruAppBar(title: '추천 번호'),
      body: _recommendBody(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 32),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: gray700,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text('번호 저장', style: h5.copyWith(color: white)),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: gray700,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text('번호 생성', style: h5.copyWith(color: white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _recommendBody() {
    return Column(
      children: [
        _statisticsSwitches(),
        _recommendNumbers(),
      ],
    );
  }

  Widget _statisticsSwitches() {
    return Column(
      children: [
        const SizedBox(height: 24),
        _statisticsSwitch(subject: '합계 적용'),
        _statisticsSwitch(subject: '출현/미출현 적용'),
        _statisticsSwitch(subject: '홀/짝 적용'),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: HorizontalDivider(),
        ),
        _statisticsSwitch(subject: '전체 적용'),
        const SizedBox(height: 24),
        const HorizontalDivider(),
      ],
    );
  }

  Widget _statisticsSwitch({required String subject}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(subject, style: bodyM),
          Switch(
            value: true,
            onChanged: (isChecked) {},
          ),
        ],
      ),
    );
  }

  Widget _recommendNumbers() {
    final List<int> notIncludedNumbers = [1];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 24),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('포함하고 싶지 않은 번호', style: bodyM),
              SvgIcon(asset: plusIcon, size: 28),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: notIncludedNumbers.map((number) {
              return lottoNumber(number: number);
            }).toList(),
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              _recommendNumber(),
              const SizedBox(width: 10),
              _recommendNumber(),
              const SizedBox(width: 12),
              _recommendNumber(),
              const SizedBox(width: 12),
              _recommendNumber(),
              const SizedBox(width: 12),
              _recommendNumber(),
              const SizedBox(width: 12),
              _recommendNumber(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _recommendNumber() {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: gray700),
          ),
        ),
      ),
    );
  }
}
