import 'dart:math';

import 'package:collection/collection.dart';
import 'package:domain/domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecommendState {
  final RecommendEvent? event;
  final List<LottoDto> lottoNumbers;
  final bool isSumContains;
  final bool isPickContains;
  final bool isOddEvenContains;
  final bool isAllContains;
  final Set<int> unIncludedNumbers;
  final Set<int> includedNumbers;

  RecommendState({
    required this.event,
    required this.lottoNumbers,
    required this.isSumContains,
    required this.isPickContains,
    required this.isOddEvenContains,
    required this.isAllContains,
    required this.unIncludedNumbers,
    required this.includedNumbers,
  });

  factory RecommendState.init() => RecommendState(
    event: null,
    lottoNumbers: [],
    isSumContains: true,
    isPickContains: true,
    isOddEvenContains: true,
    isAllContains: true,
    unIncludedNumbers: {},
    includedNumbers: {},
  );

  RecommendState copyWith({
    RecommendEvent? event,
    List<LottoDto>? lottoNumbers,
    bool? isSumContains,
    bool? isPickContains,
    bool? isOddEvenContains,
    bool? isAllContains,
    Set<int>? unIncludedNumbers,
    Set<int>? includedNumbers,
  }) {
    return RecommendState(
      event: event ?? this.event,
      lottoNumbers: lottoNumbers ?? this.lottoNumbers,
      isSumContains: isSumContains ?? this.isSumContains,
      isPickContains: isPickContains ?? this.isPickContains,
      isOddEvenContains: isOddEvenContains ?? this.isOddEvenContains,
      isAllContains: isAllContains ?? this.isAllContains,
      unIncludedNumbers: unIncludedNumbers ?? this.unIncludedNumbers,
      includedNumbers: includedNumbers ?? this.includedNumbers,
    );
  }
}

sealed class RecommendEvent {}

class ShowToast extends RecommendEvent {
  final String message;

  ShowToast({required this.message});
}

class RecommendNotifier extends StateNotifier<RecommendState> {
  final LottoRepository repository;

  RecommendNotifier({required this.repository}) : super(RecommendState.init());

  fetchLottoNumbers() async {
    state = state.copyWith(lottoNumbers: await repository.getLocalLottoNumbers());
  }

  toggleSumContains({required bool isSumContains}) {
    state = state.copyWith(
      isSumContains: isSumContains,
      isAllContains: isSumContains && state.isPickContains && state.isOddEvenContains,
    );
  }

  togglePickContains({required bool isPickContains}) {
    state = state.copyWith(
      isPickContains: isPickContains,
      isAllContains: isPickContains && state.isSumContains && state.isOddEvenContains,
    );
  }

  toggleOddEvenContains({required bool isOddEvenContains}) {
    state = state.copyWith(
      isOddEvenContains: isOddEvenContains,
      isAllContains: isOddEvenContains && state.isSumContains && state.isPickContains,
    );
  }

  toggleAllContains({required bool isAllContains}) {
    state = state.copyWith(
      isSumContains: isAllContains,
      isPickContains: isAllContains,
      isOddEvenContains: isAllContains,
      isAllContains: isAllContains,
    );
  }

  addUnIncludedNumber({required int number}) {
    if (state.includedNumbers.contains(number)) {
      state = state.copyWith(event: ShowToast(message: '추가된 번호는 포함하지 않을 수 없습니다.'));
    } else {
      state = state.copyWith(unIncludedNumbers: {...state.unIncludedNumbers, number});
    }
  }

  removeUnIncludedNumber({required int number}) {
    state = state.copyWith(unIncludedNumbers: {...state.unIncludedNumbers}..remove(number));
  }

  addIncludedNumber({required int number}) {
    if (state.unIncludedNumbers.contains(number)) {
      state = state.copyWith(event: ShowToast(message: '추가된 번호는 포함할 수 없습니다.'));
    } else {
      state = state.copyWith(includedNumbers: {...state.includedNumbers, number});
    }
  }

  removeIncludedNumber({required int number}) {
    state = state.copyWith(includedNumbers: {...state.includedNumbers}..remove(number));
  }

  removeAllIncludedNumber() {
    state = state.copyWith(includedNumbers: {});
  }

  createNumbers() {
    List<int> results = [];
    final sumMin = _getSumSvg() - 50;
    final sumMax = _getSumSvg() + 50;
    bool generated = false;

    while (!generated) {
      int sum = 0;
      bool checkNotIncludeNumber = true;
      results = _getRandomNumbers();
      // 생성된 번호의 합이 지정된 범위안에 들어오는지 확인
      for (var number in results) {
        if (state.unIncludedNumbers.contains(number)) {
          checkNotIncludeNumber = false;
          break;
        }
        sum += number;
      }
      final checkSum = state.isSumContains ? sum >= sumMin && sum <= sumMax : true;
      final oddCount = results.where((number) => number.isOdd).toList().length;
      final evenCount = results.where((number) => number.isEven).toList().length;
      final checkOdd = oddCount >= 2 && oddCount <= 4;
      final checkEven = evenCount >= 2 && evenCount <= 4;
      final checkOddEven = state.isOddEvenContains ? checkOdd && checkEven : true;

      if (checkSum && checkOddEven && checkNotIncludeNumber) {
        generated = true;
      }
    }

    results.sort((prev, next) => prev.compareTo(next));
    state = state.copyWith(includedNumbers: results.toSet());
  }

  int _getSumSvg() {
    final sum = state.lottoNumbers.fold(0, (sum, lotto) => sum + lotto.sum);
    return (sum / state.lottoNumbers.length).toInt();
  }

  List<int> _getRandomNumbers() {
    final List<int> results = [];
    bool generated = false;

    while (!generated) {
      bool isExist = false;
      final number = state.isPickContains
          ? _getRandomNumber(weights: _getWeight())
          : _getRandomNumber();

      for (var i in results) {
        if (i == number) {
          isExist = true;
          break;
        }
      }
      if (!isExist) results.add(number);
      if (results.length == _getGenerateCount()) generated = true;
    }

    for (var number in state.includedNumbers) {
      results.add(number);
    }

    return results;
  }

  int _getRandomNumber({Map<int, int>? weights}) {
    if (weights == null) {
      return Random().nextInt(45) + 1;
    } else {
      final listNumber = List.generate(45, (i) => 0);
      final listWeight = List.generate(45, (i) => 0);

      for (var key in weights.keys) {
        listNumber[key] = key + 1;
        listWeight[key] = weights[key]!;
      }

      int sum = 0;
      for (var weight in listWeight) {
        sum += weight;
      }
      final selectionPosition = Random().nextInt(sum);
      int prevValue = 0;
      int currentMaxValue = 0;
      int foundIndex = -1;
      for (var i = 0; i < listWeight.length; i++) {
        currentMaxValue = prevValue + listWeight[i];
        if (selectionPosition >= prevValue && selectionPosition < currentMaxValue) {
          foundIndex = i;
          break;
        }
        prevValue = currentMaxValue;
      }

      int selection = -1;
      if (foundIndex != -1) {
        selection = listNumber[foundIndex];
      }

      return selection;
    }
  }

  Map<int, int> _getWeight() {
    final Map<int, int> weights = {};
    final countSum = List.generate(45, (i) => 0);

    for (var lotto in state.lottoNumbers) {
      for (var number in lotto.numbers) {
        countSum[number - 1]++;
      }
    }

    int bestValue = 0;
    countSum.forEachIndexed((index, count) {
      final weightTemp = count == 0 ? 1 : (1 / count);
      final weight = (weightTemp * 100).round();
      if (weight >= bestValue && weight <= 99) {
        bestValue = weight;
      }
      weights[index] = weight;
    });
    for (var key in weights.keys) {
      if (weights[key] == 100) {
        weights[key] = bestValue + 10;
      }
    }

    return weights;
  }

  int _getGenerateCount() => 6 - state.includedNumbers.length;

  saveMyLottoNumbers() async {
    if (state.includedNumbers.length != 6) {
      state = state.copyWith(event: ShowToast(message: '번호를 생성해 주세요.'));
      return;
    }
    final numbers = state.includedNumbers.toList();
    await repository.saveMyLottoNumber(
      myLottoNumber: MyLottoDto(
        no1: numbers[0],
        no2: numbers[1],
        no3: numbers[2],
        no4: numbers[3],
        no5: numbers[4],
        no6: numbers[5],
      ),
    );
    state = state.copyWith(
      event: ShowToast(message: '번호를 저장 했습니다!'),
      includedNumbers: {},
    );
  }

  clearEvent() {
    state = state.copyWith(event: null);
  }
}
