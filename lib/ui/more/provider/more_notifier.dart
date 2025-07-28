import 'package:domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MoreState {
  final MoreEvent? event;
  final bool isLoading;
  final int maxRound;
  final List<LottoDto> lottoNumbers;
  final int statisticsSize;

  MoreState({
    required this.event,
    required this.isLoading,
    required this.maxRound,
    required this.lottoNumbers,
    required this.statisticsSize,
  });

  factory MoreState.init() =>
      MoreState(event: null, isLoading: false, maxRound: 20, lottoNumbers: [], statisticsSize: 20);

  MoreState copyWith({
    MoreEvent? event,
    bool? isLoading,
    int? maxRound,
    List<LottoDto>? lottoNumbers,
    int? statisticsSize,
  }) => MoreState(
    event: event ?? this.event,
    isLoading: isLoading ?? this.isLoading,
    maxRound: maxRound ?? this.maxRound,
    lottoNumbers: lottoNumbers ?? this.lottoNumbers,
    statisticsSize: statisticsSize ?? this.statisticsSize,
  );
}

sealed class MoreEvent {}

class ShowSnackBar extends MoreEvent {
  final String message;

  ShowSnackBar({required this.message});
}

class MoreNotifier extends StateNotifier<MoreState> {
  final LottoRepository lottoRepository;
  final SettingRepository settingRepository;

  MoreNotifier({required this.lottoRepository, required this.settingRepository})
    : super(MoreState.init());

  fetchStatisticsSize() async {
    final lottoNumbers = await lottoRepository.getLocalLottoNumbers();
    state = state.copyWith(
      maxRound: lottoNumbers.first.drwNo,
      lottoNumbers: lottoNumbers,
      statisticsSize: await settingRepository.getStatisticsSize(),
    );
  }

  updateStatisticsSize({required int statisticsSize}) async {
    state = state.copyWith(
      statisticsSize: await settingRepository.updateStatisticsSize(statisticsSize: statisticsSize),
    );
  }

  Future<bool> backupMyNumbers({required BackupType backupType}) async {
    final myLottoNumbers = await lottoRepository.getMyLottoNumbers();
    if (myLottoNumbers.isEmpty) {
      _showError(message: '백업할 번호가 없습니다.');
      return false;
    }

    state = state.copyWith(isLoading: true);

    await settingRepository.backupMyNumbers(
      myLottoNumbers: myLottoNumbers,
      backupType: backupType,
      onError: (message) {
        _showError(message: message);
      },
    );
    state = state.copyWith(event: ShowSnackBar(message: '백업이 완료되었습니다.'), isLoading: false);
    return true;
  }

  Future<bool> restoreMyNumbers({required BackupType backupType}) async {
    state = state.copyWith(isLoading: true);

    final lottoNumbers = await Future.wait([
      lottoRepository.getMyLottoNumbers(),
      settingRepository.restoreMyNumbers(
        backupType: backupType,
        onError: (message) {
          _showError(message: message);
        },
      ),
    ]);

    await lottoRepository.saveMyLottoNumbers(
      myLottoNumbers: lottoNumbers[0].removeDuplicates(lottoNumbers[1]),
    );

    state = state.copyWith(event: ShowSnackBar(message: '내 번호를 가져왔습니다.'), isLoading: false);
    return true;
  }

  _showError({String? message}) {
    state = state.copyWith(
      event: ShowSnackBar(message: message ?? '오류가 발생했습니다.'),
      isLoading: false,
    );
  }

  clearEvent() {
    state = state.copyWith(event: null);
  }
}
