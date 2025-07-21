part of 'home_screen.dart';

Widget _homeStoreList({required List<StoreDto> stores}) {
  return Padding(
    padding: const EdgeInsets.only(top: 24, bottom: 36),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('1등 당첨 판매점', style: subtitle2),
              Text('더보기', style: bodyS.copyWith(color: gray600)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _StoreList(stores: stores),
        const SizedBox(height: 36),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('2등 당첨 판매점', style: subtitle2),
              Text('더보기', style: bodyS.copyWith(color: gray600)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _StoreList(stores: stores),
      ],
    ),
  );
}

class _StoreList extends StatefulWidget {
  final List<StoreDto> stores;

  const _StoreList({required this.stores});

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
    final count = (widget.stores.length / 5).ceil();

    return Column(
      children: [
        SizedBox(
          height: 365,
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
              for (var i = 0; i < widget.stores.length; i += 5) {
                chunks.add(widget.stores.skip(i).take(5).toList());
              }
              final stores = chunks[index];

              return SizedBox(
                height: 365,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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
              color:
              _selectedIndex == index ? gray700 : gray700.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(6),
            ),
          );
        }),
      ),
    );
  }
}
