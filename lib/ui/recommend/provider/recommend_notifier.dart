import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecommendState {
  final bool isSumContains;
  final bool isPickContains;
  final bool isOddEvenContains;
  final bool isAllContains;
  final Set<int> unIncludedNumbers;
  final Set<int> includedNumbers;

  RecommendState({
    required this.isSumContains,
    required this.isPickContains,
    required this.isOddEvenContains,
    required this.isAllContains,
    required this.unIncludedNumbers,
    required this.includedNumbers,
  });

  factory RecommendState.init() => RecommendState(
    isSumContains: true,
    isPickContains: true,
    isOddEvenContains: true,
    isAllContains: true,
    unIncludedNumbers: {},
    includedNumbers: {},
  );

  RecommendState copyWith({
    bool? isSumContains,
    bool? isPickContains,
    bool? isOddEvenContains,
    bool? isAllContains,
    Set<int>? unIncludedNumbers,
    Set<int>? includedNumbers,
  }) {
    return RecommendState(
      isSumContains: isSumContains ?? this.isSumContains,
      isPickContains: isPickContains ?? this.isPickContains,
      isOddEvenContains: isOddEvenContains ?? this.isOddEvenContains,
      isAllContains: isAllContains ?? this.isAllContains,
      unIncludedNumbers: unIncludedNumbers ?? this.unIncludedNumbers,
      includedNumbers: includedNumbers ?? this.includedNumbers,
    );
  }
}

class RecommendNotifier extends StateNotifier<RecommendState> {
  RecommendNotifier() : super(RecommendState.init());

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
      // todo : 추가된 번호는 포함하지 않을 수 없습니다.
    } else {
      state = state.copyWith(unIncludedNumbers: {...state.unIncludedNumbers, number});
    }
  }

  removeUnIncludedNumber({required int number}) {
    state = state.copyWith(unIncludedNumbers: {...state.unIncludedNumbers}..remove(number));
  }

  addIncludedNumber({required int number}) {
    if (state.unIncludedNumbers.contains(number)) {
      // todo : 추가된 번호는 포함할 수 없습니다.
    } else {
      state = state.copyWith(includedNumbers: {...state.includedNumbers, number});
    }
  }

  removeIncludedNumber({required int number}) {
    state = state.copyWith(includedNumbers: {...state.includedNumbers}..remove(number));
  }
}
