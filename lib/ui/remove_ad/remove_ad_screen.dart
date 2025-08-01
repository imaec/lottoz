import 'package:collection/collection.dart';
import 'package:designsystem/component/app_bar/lotto_app_bar.dart';
import 'package:designsystem/component/divider/horizontal_divider.dart';
import 'package:designsystem/theme/colors.dart';
import 'package:designsystem/theme/fonts.dart';
import 'package:flutter/material.dart';
import 'package:lottoz/model/ad/remove_ad_item_vo.dart';

class RemoveAdScreen extends StatefulWidget {
  const RemoveAdScreen({super.key});

  @override
  State<RemoveAdScreen> createState() => _RemoveAdScreenState();
}

class _RemoveAdScreenState extends State<RemoveAdScreen> {
  final _removeAdItems = [
    RemoveAdItemVo(name: '1개월 광고 제거', description: '₩2,200/1개월', discount: ''),
    RemoveAdItemVo(name: '6개월 광고 제거', description: '₩9,900/6개월', discount: '25% 할인'),
    RemoveAdItemVo(name: '12개월 광고 제거', description: '₩15,000/1년', discount: '43% 할인'),
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LottoAppBar(
        title: '광고 제거',
        topPadding: MediaQuery.of(context).padding.top,
        hasBack: true,
      ),
      body: _removeAdBody(),
    );
  }

  Widget _removeAdBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Column(
          children: _removeAdItems.mapIndexed((index, item) {
            return Column(
              children: [
                index == 0 ? const SizedBox() : const SizedBox(height: 16),
                _removeAdItem(index: index, item: item),
              ],
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        const HorizontalDivider(),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('광고 제거를 구매하시는 분들께 드리는 혜택!', style: h4),
              const SizedBox(height: 12),
              _adAdvantage(advantage: '광고 없이 쾌적하게 앱을 사용 할 수 있어요.'),
              const SizedBox(height: 2),
              _adAdvantage(advantage: '내 번호를 구글 드라이브에 저장해 안전하게 보관하고 기기가 바뀌어도 복구할 수 있어요.'),
              const SizedBox(height: 2),
              _adAdvantage(advantage: '안정적인 앱 업데이트를 보장합니다.'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _removeAdItem({required int index, required RemoveAdItemVo item}) {
    final isSelected = _selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            color: gray50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isSelected ? graphBlue : gray200, width: isSelected ? 2 : 1),
          ),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: isSelected ? graphBlue : gray200, width: 2),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? graphBlue : Colors.transparent,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: subtitle1),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: item.description.split('/').mapIndexed((index, text) {
                      return Text(
                        '$text${index == 0 ? '/' : ''}',
                        style: bodyM.copyWith(
                          color: index == 0 ? gray700 : gray600,
                          fontSize: index == 0 ? 16 : 15,
                          fontWeight: index == 0 ? FontWeight.w500 : FontWeight.w400,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                item.discount,
                style: subtitle2.copyWith(color: isSelected ? graphBlue : gray700),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _adAdvantage({required String advantage}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(color: gray700, shape: BoxShape.circle),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(advantage, style: bodyM.copyWith(color: gray600)),
        ),
      ],
    );
  }
}
