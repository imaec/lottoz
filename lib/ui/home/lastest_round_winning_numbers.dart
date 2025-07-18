part of 'home_screen.dart';

Widget _latestRoundWinningNumbers({required LottoDto lottoDto}) {
  final numbers = [
    lottoDto.drwtNo1,
    lottoDto.drwtNo2,
    lottoDto.drwtNo3,
    lottoDto.drwtNo4,
    lottoDto.drwtNo5,
    lottoDto.drwtNo6,
  ];

  return Padding(
    padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 36),
    child: Column(
      children: [
        Text(lottoDto.drwNoDate, style: bodyS.copyWith(color: gray600)),
        Text('${lottoDto.drwNo}회 당첨 번호', style: h2),
        const SizedBox(height: 24),
        Row(
          children: numbers.mapIndexed((index, number) {
            return _latestRoundNumber(number: number);
          }).toList(),
        ),
        const SizedBox(height: 8),
        Row(
          children: numbers.mapIndexed((index, number) {
            if (index < 4) {
              return _latestRoundNumber(number: null);
            } else {
              if (index == 4) {
                return const Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text('BONUS', style: labelBold, textAlign: TextAlign.end),
                  ),
                );
              } else {
                return _latestRoundNumber(number: lottoDto.bnusNo);
              }
            }
          }).toList(),
        ),
        const SizedBox(height: 32),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('1등 당첨자 수 ', style: bodyS),
                  Text('${lottoDto.firstPrzwnerCo}명', style: h6),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: gray600),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: gray700,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(6),
                          bottomLeft: Radius.circular(6),
                        ),
                      ),
                      child: Text('1등', style: subtitle2.copyWith(color: white)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      width: 220,
                      child: Text(
                        '${lottoDto.firstWinamnt.comma()} '
                        '(약 ${lottoDto.firstWinamnt.to100Million()}억) 원',
                        style: subtitle2.copyWith(color: gray600),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _latestRoundNumber({required int? number}) {
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
