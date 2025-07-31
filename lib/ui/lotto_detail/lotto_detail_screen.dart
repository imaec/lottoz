import 'package:collection/collection.dart';
import 'package:core/extension/num_extension.dart';
import 'package:core/utils/lotto_utils.dart';
import 'package:designsystem/assets/icons.dart';
import 'package:designsystem/component/ads/ad.dart';
import 'package:designsystem/component/ads/banner_ad_widget.dart';
import 'package:designsystem/component/ads/banner_type.dart';
import 'package:designsystem/component/ads/interstitial_ad.dart';
import 'package:designsystem/component/ads/interstitial_type.dart';
import 'package:designsystem/component/app_bar/lotto_app_bar.dart';
import 'package:designsystem/component/divider/horizontal_divider.dart';
import 'package:designsystem/component/media/svg_icon.dart';
import 'package:designsystem/theme/colors.dart';
import 'package:designsystem/theme/fonts.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottoz/main.dart';
import 'package:lottoz/ui/lotto_detail/provider/lotto_detail_state_provider.dart';

class LottoDetailScreen extends ConsumerStatefulWidget {
  final LottoDto lotto;

  const LottoDetailScreen({super.key, required this.lotto});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => LottoDetailScreenState();
}

class LottoDetailScreenState extends ConsumerState<LottoDetailScreen> {
  AdSize? _adSize;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(lottoDetailNotifierProvider.notifier).fetchLottoDetail(lotto: widget.lotto);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!isAdEnable) return;

    final size = MediaQuery.of(context).size;
    _adSize = AdSize.getCurrentOrientationInlineAdaptiveBannerAdSize(size.width.truncate() - 40);

    detailAdaptiveBannerAd = BannerAd(
      adUnitId: DetailAdaptiveBanner().adUnitId,
      size: _adSize ?? AdSize.mediumRectangle,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdFailedToLoad: (ad, error) {
          debugPrint('  [ERROR] 배너 광고 로드 실패: $error');
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        DetailInterstitial().showInterstitialAd();
      },
      child: Scaffold(
        appBar: LottoAppBar(
          title: '${widget.lotto.drwNo}회 당첨 번호',
          topPadding: MediaQuery.of(context).padding.top,
          hasBack: true,
        ),
        body: _lottoDetailBody(),
        bottomNavigationBar: BannerAdWidget(bannerType: DetailBanner()),
      ),
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
              isAdEnable
                  ? BannerAdWidget(bannerType: DetailAdaptiveBanner())
                  : const HorizontalDivider(),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      constraints: const BoxConstraints(maxWidth: 540),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${widget.lotto.drwNo}회', style: h4),
              const SizedBox(width: 8),
              Text(widget.lotto.drwNoDate, style: bodyM.copyWith(color: gray600)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children:
                widget.lotto.numbers.mapIndexed((index, number) {
                    return _lottoDetailNumber(number: number);
                  }).toList()
                  ..add(const SvgIcon(asset: plusIcon, size: 20))
                  ..add(_lottoDetailNumber(number: widget.lotto.bnusNo)),
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
                    Text(widget.lotto.totSellamnt.toWon(), style: h5),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('총 당첨금  ', style: bodyS),
                    Text(widget.lotto.firstAccumamnt.toWon(), style: h5),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('1게임 당첨금  ', style: bodyS),
                    Text(widget.lotto.firstWinamnt.toWon(), style: h5),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('당첨자 수  ', style: bodyS),
                    Text('${widget.lotto.firstPrzwnerCo}명', style: h5),
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
    final state = ref.watch(lottoDetailNotifierProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('당첨금액', style: h3),
          const SizedBox(height: 16),
          state.isPricesLoading
              ? const SizedBox(height: 240, child: Center(child: CircularProgressIndicator()))
              : Container(
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
                              width: 120,
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
                      SizedBox(
                        height: 200,
                        child: ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.winPrices.length,
                          itemBuilder: (context, index) {
                            final winPrice = state.winPrices[index];

                            return _priceItem(
                              rank: winPrice.rank,
                              totalPrice: winPrice.totalPrice,
                              price: winPrice.price,
                              count: winPrice.count,
                              type: '자동 7 / 수동 10 / 반자동 0',
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const HorizontalDivider();
                          },
                        ),
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
          width: 120,
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
    final state = ref.watch(lottoDetailNotifierProvider);

    return state.isStatisticsLoading
        ? const SizedBox(height: 240, child: Center(child: CircularProgressIndicator()))
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('분석', style: h3),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: state.winStatistics.map((statistics) {
                    return _analyzeItem(title: statistics.title, content: statistics.content);
                  }).toList(),
                ),
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
    final state = ref.watch(lottoDetailNotifierProvider);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('1등 당첨 판매점', style: h3),
          ),
          const SizedBox(height: 16),
          _StoreList(stores: state.firstStores, isLoading: state.isFirstStoresLoading, perPage: 5),
          const SizedBox(height: 32),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('2등 당첨 판매점', style: h3),
          ),
          const SizedBox(height: 16),
          _StoreList(
            stores: state.secondStores,
            isLoading: state.isSecondStoresLoading,
            perPage: 8,
          ),
        ],
      ),
    );
  }
}

class _StoreList extends StatefulWidget {
  final List<StoreDto> stores;
  final bool isLoading;
  final int perPage;

  const _StoreList({required this.stores, required this.isLoading, required this.perPage});

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
    final count = (widget.stores.length / widget.perPage).ceil();

    if (widget.isLoading) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 64),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(store.storeName, style: subtitle3),
                const SizedBox(height: 2),
                Text(
                  store.address,
                  style: labelRegular.copyWith(color: gray400),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
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
