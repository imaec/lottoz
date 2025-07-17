part of '../statistics_screen.dart';

Widget _winTabContent() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _statisticsHeader(),
      const HorizontalDivider(),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _winAverages(),
            const HorizontalDivider(),
            _winStatistics(),
          ],
        ),
      ),
    ],
  );
}

Widget _winAverages() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('1등 당첨 평균 (20회)', style: subtitle2),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _winContent(subject: '총 당첨금', content: '28,106,807,311 (약 281억)'),
            const SizedBox(height: 16),
            _winContent(subject: '1게임 당첨금', content: '2,089,808,176 (약 21억)'),
            const SizedBox(height: 16),
            _winContent(subject: '당첨자 수', content: '15.4명'),
          ],
        ),
      ],
    ),
  );
}

Widget _winStatistics() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('1등 당첨 통계 (20회)', style: subtitle2),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _winContent(subject: '1게임 최고 당첨금', content: '4,576,672,000 (약 46억)'),
            const SizedBox(height: 16),
            _winContent(subject: '1게임 최소 당첨금', content: '823,931,021 (약 8억)'),
            const SizedBox(height: 16),
            _winContent(subject: '최대 당첨자 수', content: '36명'),
            const SizedBox(height: 16),
            _winContent(subject: '최소 당첨자 수', content: '6명'),
          ],
        ),
      ],
    ),
  );
}

Widget _winContent({
  required String subject,
  required String content,
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(subject, style: bodyS.copyWith(color: gray600)),
      Text(content, style: bodyM),
    ],
  );
}
