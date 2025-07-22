import 'package:collection/collection.dart';
import 'package:core/extension/double_extension.dart';
import 'package:core/utils/lotto_utils.dart';
import 'package:designsystem/assets/icons.dart';
import 'package:designsystem/component/app_bar/lotto_app_bar.dart';
import 'package:designsystem/component/divider/horizontal_divider.dart';
import 'package:designsystem/component/media/svg_icon.dart';
import 'package:designsystem/theme/colors.dart';
import 'package:designsystem/theme/fonts.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';

class LottoDetailScreen extends StatelessWidget {
  final LottoDto lotto;

  const LottoDetailScreen({super.key, required this.lotto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LottoAppBar(
        title: '${lotto.drwNo}회 당첨 번호',
        topPadding: MediaQuery.of(context).padding.top,
        hasBack: true,
      ),
      body: _lottoDetailBody(),
    );
  }

  Widget _lottoDetailBody() {
    return Builder(
      builder: (context) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          child: Column(
            children: [
              _lottoNumbers(),
              const HorizontalDivider(),
              _lottoWinPrice(),
              const HorizontalDivider(),
              _lottoAnalyze(),
              const HorizontalDivider(),
              _lottoStores(),
            ],
          ),
        );
      },
    );
  }

  Widget _lottoNumbers() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${lotto.drwNo}회', style: h4),
              const SizedBox(width: 8),
              Text(lotto.drwNoDate, style: bodyM.copyWith(color: gray600)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children:
                lotto.numbers.mapIndexed((index, number) {
                    return _lottoDetailNumber(number: number);
                  }).toList()
                  ..add(const SvgIcon(asset: plusIcon, size: 20))
                  ..add(_lottoDetailNumber(number: lotto.bnusNo)),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('총 판매액  ', style: bodyS),
                    Text(lotto.totSellamnt.toWon(), style: h5),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('총 당첨금  ', style: bodyS),
                    Text(lotto.firstAccumamnt.toWon(), style: h5),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('1게임 당첨금  ', style: bodyS),
                    Text(lotto.firstWinamnt.toWon(), style: h5),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('당첨자 수  ', style: bodyS),
                    Text('${lotto.firstPrzwnerCo}명', style: h5),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _lottoDetailNumber({required int? number}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              color: number != null ? getLottoColor(number: number) : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$number',
                style: subtitle1.copyWith(
                  color: gray25,
                  shadows: [
                    Shadow(
                      offset: const Offset(0.5, 0.5),
                      blurRadius: 2.0,
                      color: number != null ? gray400 : Colors.transparent,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _lottoWinPrice() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('당첨금액', style: h3),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(border: Border.all(color: gray100)),
            child: Column(
              children: [
                Container(
                  color: gray700,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 60,
                        child: Text(
                          '순위',
                          style: subtitle3.copyWith(color: white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(height: 40, width: 1, color: gray100),
                      SizedBox(
                        width: 100,
                        child: Text(
                          '당첨자 수',
                          style: subtitle3.copyWith(color: white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(height: 40, width: 1, color: gray100),
                      Expanded(
                        child: Text(
                          '1게임 당첨금',
                          style: subtitle3.copyWith(color: white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                _priceItem(
                  rank: '1등',
                  totalPrice: '270억 9,193만원',
                  price: '15억 9,364만원',
                  count: '17명',
                  type: '자동 7 / 수동 10 / 반자동 0',
                ),
                const HorizontalDivider(),
                _priceItem(rank: '2등', totalPrice: '45억 1,532만원', price: '5,250만원', count: '86명'),
                const HorizontalDivider(),
                _priceItem(rank: '3등', totalPrice: '45억 1,532만원', price: '145만원', count: '3,109명'),
                const HorizontalDivider(),
                _priceItem(rank: '4등', totalPrice: '77억 9,690만원', price: '5만원', count: '155,938명'),
                const HorizontalDivider(),
                _priceItem(
                  rank: '5등',
                  totalPrice: '129억 8,185만원',
                  price: '5천원',
                  count: '2,596,371명',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceItem({
    required String rank,
    required String totalPrice,
    required String price,
    required String count,
    String? type,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(rank, style: bodyS, textAlign: TextAlign.center),
        ),
        Container(height: 40, width: 1, color: gray100),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          width: 100,
          child: Text(count, style: bodyS),
        ),
        Container(height: 40, width: 1, color: gray100),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(price, style: bodyS),
          ),
        ),
      ],
    );
  }

  Widget _lottoAnalyze() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('분석', style: h3),
          _analyzeItem(
            title: '총 판매액',
            content: ' 이번주 총 판매액은 1,138억 268만원으로 최근 1년 총 판매액 평균인 1,000억보다 13% 높습니다.',
          ),
          _analyzeItem(
            title: '당첨',
            content:
                ' 이번주 1등 총 당첨금은 270억 9,193만원으로 최근 1년 1등 총 당첨금 평균인 240억보다 13% '
                '높고, 1게임 당첨금은 15억 9,364만원으로 최근 1년 1게임 당첨금 평균인 20억보다 30% 낮습니다.\n'
                ' 1등 당첨자 수는 17명으로, 이는 1등 당첨 확률(1/814만)보다 1% 높은 수치입니다.\n'
                ' 2등 당첨자 수는 84명으로, 이는 2등 당첨 확률(1/135만)보다 1% 높은 수치입니다.',
          ),
          _analyzeItem(title: '합계', content: ' 이번주 당첨 번호 합계는 126이고, 전체 회차 합계 평균인 138보다 12 낮습니다.'),
        ],
      ),
    );
  }

  Widget _analyzeItem({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(title, style: subtitle2),
        const SizedBox(height: 8),
        Text(content, style: bodyS),
      ],
    );
  }

  Widget _lottoStores() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('1등 당첨 판매점', style: h3),
          ),
          const SizedBox(height: 16),
          _StoreList(
            stores: List.generate(17, (i) {
              return StoreDto(storeName: 'storeName', address: 'address', type: 'type');
            }),
            perPage: 5,
          ),
          const SizedBox(height: 32),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('2등 당첨 판매점', style: h3),
          ),
          const SizedBox(height: 16),
          _StoreList(
            stores: List.generate(40, (i) {
              return StoreDto(storeName: 'storeName', address: 'address', type: 'type');
            }),
            perPage: 8,
          ),
        ],
      ),
    );
  }
}

class _StoreList extends StatefulWidget {
  final List<StoreDto> stores;
  final int perPage;

  const _StoreList({required this.stores, required this.perPage});

  @override
  State<_StoreList> createState() => _StoreListState();
}

class _StoreListState extends State<_StoreList> {
  late final PageController _pageController = PageController();
  int _selectedIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.stores.isEmpty) {
      return const Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator());
    }

    final count = (widget.stores.length / widget.perPage).ceil();

    return Column(
      children: [
        SizedBox(
          height: 65 * widget.perPage + (10 * widget.perPage - 1),
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            itemCount: count,
            itemBuilder: (context, index) {
              List<List<StoreDto>> chunks = [];
              for (var i = 0; i < widget.stores.length; i += widget.perPage) {
                chunks.add(widget.stores.skip(i).take(widget.perPage).toList());
              }
              final stores = chunks[index];

              return SizedBox(
                height: 365,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: stores.length,
                  itemBuilder: (context, index) {
                    return _store(store: stores[index]);
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 10);
                  },
                ),
              );
            },
          ),
        ),
        _indicator(count: count),
      ],
    );
  }

  Widget _store({required StoreDto store}) {
    return Container(
      padding: const EdgeInsets.all(12),
      height: 65,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: gray100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(store.storeName, style: subtitle3),
              const SizedBox(height: 2),
              Text(store.address, style: labelRegular.copyWith(color: gray400)),
            ],
          ),
          Text(store.type, style: labelRegular.copyWith(color: gray600)),
        ],
      ),
    );
  }

  Widget _indicator({required int count}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: List.generate(count, (index) {
          return Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: _selectedIndex == index ? gray700 : gray700.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(6),
            ),
          );
        }),
      ),
    );
  }
}
