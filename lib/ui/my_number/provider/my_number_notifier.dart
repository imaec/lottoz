import 'package:domain/model/lotto/lotto_dto.dart';
import 'package:domain/model/lotto/my_lotto_dto.dart';
import 'package:domain/repository/lotto_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottoz/model/lotto/my_lotto_vo.dart';

class MyNumberState {
  final MyNumberEvent? event;
  final List<MyLottoVo> myLottoNumbers;

  MyNumberState({required this.event, required this.myLottoNumbers});

  factory MyNumberState.init() => MyNumberState(event: null, myLottoNumbers: []);

  MyNumberState copyWith({MyNumberEvent? event, List<MyLottoVo>? myLottoNumbers}) {
    return MyNumberState(
      event: event ?? this.event,
      myLottoNumbers: myLottoNumbers ?? this.myLottoNumbers,
    );
  }
}

sealed class MyNumberEvent {}

class ShowSnackBar extends MyNumberEvent {
  final String message;

  ShowSnackBar({required this.message});
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

  removeMyNumber({required int id}) async {
    await repository.removeMyNumber(id: id);
    state = state.copyWith(event: ShowSnackBar(message: '내 번호가 삭제 됐습니다.'));
    fetchLottoNumbers();
  }

  clearEvent() {
    state = state.copyWith(event: null);
  }
}
