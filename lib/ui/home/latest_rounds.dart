part of 'home_screen.dart';

Widget _latestRounds({required List<LottoDto> lottoNumbers}) {
  return Padding(
    padding: const EdgeInsets.only(top: 24, bottom: 36),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('최근 회차 결과', style: subtitle2),
              GestureDetector(
                onTap: () {
                  appRouter.push('/latestRoundList');
                },
                child: Text('더보기', style: bodyS.copyWith(color: gray600)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 160,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: lottoNumbers.length,
            itemBuilder: (context, index) {
              return _latestRound(lottoDto: lottoNumbers[index]);
            },
            separatorBuilder: (context, index) {
              return const SizedBox(width: 16);
            },
          ),
        ),
      ],
    ),
  );
}

Widget _latestRound({required LottoDto lottoDto}) {
  final numbers = [
    lottoDto.drwtNo1,
    lottoDto.drwtNo2,
    lottoDto.drwtNo3,
    lottoDto.drwtNo4,
    lottoDto.drwtNo5,
    lottoDto.drwtNo6,
  ];

  return GestureDetector(
    onTap: () {
      appRouter.push('/detail', extra: lottoDto);
    },
    behavior: HitTestBehavior.translucent,
    child: Container(
      width: 240,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: gray100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('${lottoDto.drwNo}회', style: labelBold),
              const SizedBox(width: 4),
              Text(lottoDto.drwNoDate, style: labelTag.copyWith(color: gray400)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: numbers.mapIndexed((index, number) {
              return _number(number: number);
            }).toList(),
          ),
          const SizedBox(height: 8),
          Row(
            children: numbers.mapIndexed((index, number) {
              if (index < 4) {
                return _latestRoundNumber(number: null);
              } else {
                if (index == 4) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        'BONUS',
                        style: labelBold.copyWith(fontSize: 8),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  );
                } else {
                  return _number(number: lottoDto.bnusNo);
                }
              }
            }).toList(),
          ),
          const Spacer(),
          Row(
            children: [
              Text('1등', style: labelBold.copyWith(color: gray600)),
              const SizedBox(width: 4),
              Text('${lottoDto.firstPrzwnerCo}명', style: labelBold),
            ],
          ),
          Text(
            '1인당 약 ${lottoDto.firstWinamnt.to100Million()}억원',
            style: labelBold.copyWith(color: gray600),
          ),
        ],
      ),
    ),
  );
}

Widget _number({required int? number}) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
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
              style: labelBold.copyWith(
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
