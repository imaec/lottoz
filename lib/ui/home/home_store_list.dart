part of 'home_screen.dart';

Widget _homeStoreList() {
  const stores = ['1', '2', '3', '4', '5', '6'];

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
        Column(
          children: stores.mapIndexed((index, store) {
            return Column(
              children: [
                SizedBox(height: index != 0 ? 10 : 0),
                _store(),
              ],
            );
          }).toList(),
        )
      ],
    ),
  );
}

Widget _store() {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    padding: const EdgeInsets.all(12),
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
            const Text('인터넷 복권판매사이트', style: subtitle3),
            const SizedBox(height: 2),
            Text('동행복권(dhlottery.co.kr)', style: labelRegular.copyWith(color: gray400)),
          ],
        ),
        Text('자동', style: labelRegular.copyWith(color: gray600)),
      ],
    ),
  );
}
