import 'package:domain/model/lotto/lotto_dto.dart';
import 'package:domain/model/lotto/my_lotto_dto.dart';
import 'package:domain/repository/lotto_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottoz/model/lotto/MyLottoVo.dart';

class MyNumberState {
  final List<MyLottoVo> myLottoNumbers;

  MyNumberState({required this.myLottoNumbers});

  factory MyNumberState.init() => MyNumberState(myLottoNumbers: []);

  MyNumberState copyWith({List<MyLottoVo>? myLottoNumbers}) {
    return MyNumberState(
      myLottoNumbers: myLottoNumbers ?? this.myLottoNumbers,
    );
  }
}

class MyNumberNotifier extends StateNotifier<MyNumberState> {
  final LottoRepository repository;

  MyNumberNotifier({required this.repository}) : super(MyNumberState.init());

  fetchLottoNumbers() async {
    final futures = [repository.getLocalLottoNumbers(), repository.getMyLottoNumbers()];
    final results = await Future.wait(futures);
    final lottoNumbers = results[0] as List<LottoDto>;
    final myLottoNumbers = results[1] as List<MyLottoDto>;

    state = state.copyWith(
      myLottoNumbers: myLottoNumbers.map((e) => e.toVo(lotto: lottoNumbers.first)).toList(),
    );
  }
}
