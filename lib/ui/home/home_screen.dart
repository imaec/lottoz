import 'dart:io';

import 'package:collection/collection.dart';
import 'package:core/extension/num_extension.dart';
import 'package:core/utils/lotto_utils.dart';
import 'package:designsystem/designsystem.dart';
import 'package:domain/model/common/inspection_exception.dart';
import 'package:domain/model/lotto/lotto_dto.dart';
import 'package:domain/model/lotto/store_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottoz/provider/lotto_notifier.dart';
import 'package:lottoz/provider/lotto_state_provider.dart';
import 'package:lottoz/router/go_router.dart';

part 'home_store_list.dart';
part 'lastest_round_winning_numbers.dart';
part 'latest_rounds.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(lottoNotifierProvider.notifier);
    final state = ref.watch(lottoNotifierProvider);

    ref.listen(lottoNotifierProvider, (prev, next) {
      if (prev?.event != next.event) {
        if (next.event is ShowInspectionDialog) {
          final exception = (next.event as ShowInspectionDialog).exception;
          _showInspectionDialog(context: context, exception: exception);
          notifier.clearEvent();
        }
        if (next.event is ShowExceptionDialog) {
          final exception = (next.event as ShowExceptionDialog).exception;
          _showExceptionDialog(context: context, exception: exception);
          notifier.clearEvent();
        }
      }
    });

    return Scaffold(
      body: Column(
        children: [
          Expanded(child: _homeBody(state: state)),
          BannerAdWidget(bannerType: HomeBanner()),
        ],
      ),
    );
  }

  _homeBody({required LottoState state}) {
    if (state.lottoNumbers.isNotEmpty) {
      return SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              _latestRoundWinningNumbers(lottoDto: state.lottoNumbers.first),
              const HorizontalDivider(),
              _latestRounds(lottoNumbers: state.lottoNumbers.sublist(1, 11).toList()),
              const HorizontalDivider(),
              _homeStoreList(firstStores: state.firstStores),
            ],
          ),
        ),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  _showInspectionDialog({required BuildContext context, required InspectionException exception}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            title: const Text('시스템 점검중 입니다.'),
            titleTextStyle: subtitle1,
            content: Text('${exception.content}\n${exception.time}'),
            contentTextStyle: bodyM,
            actions: [
              TextButton(
                onPressed: () {
                  context.pop();
                },
                child: Text(
                  '불편하지만 계속 사용하기',
                  style: subtitle2.copyWith(fontWeight: FontWeight.w700, color: graphBlue),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (Platform.isAndroid) {
                    SystemNavigator.pop();
                  } else if (Platform.isIOS) {
                    exit(0);
                  }
                },
                child: Text('앱 종료', style: subtitle2.copyWith(fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        );
      },
    );
  }

  _showExceptionDialog({required BuildContext context, required Exception exception}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            title: const Text('오류가 발생 했습니다.\n관리자에게 문의 해주세요.'),
            titleTextStyle: subtitle1,
            content: Text(exception.toString()),
            contentTextStyle: bodyM,
            actions: [
              TextButton(
                onPressed: () {
                  context.pop();
                },
                child: Text(
                  '불편하지만 계속 사용하기',
                  style: subtitle2.copyWith(fontWeight: FontWeight.w700, color: graphBlue),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (Platform.isAndroid) {
                    SystemNavigator.pop();
                  } else if (Platform.isIOS) {
                    exit(0);
                  }
                },
                child: Text('앱 종료', style: subtitle2.copyWith(fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        );
      },
    );
  }
}
