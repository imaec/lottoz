import 'package:designsystem/theme/colors.dart';
import 'package:designsystem/theme/fonts.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:numberpicker/numberpicker.dart';

showNumberPicker({
  required BuildContext context,
  required String title,
  required int start,
  required int end,
  required Function(int) onSelected,
  int step = 1,
  int initNumber = 1,
  bool isAllShow = false,
}) {
  int number = start;

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
    ),
    builder: (context) {
      return Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                children: [
                  const SizedBox(width: 120),
                  Expanded(
                    child: Text(title, style: h4, textAlign: TextAlign.center),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (isAllShow) {
                            context.pop();
                            onSelected(end);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          width: 60,
                          child: Center(
                            child: Text(isAllShow ? '전체' : '', style: h5.copyWith(color: graphBlue)),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.pop();
                          onSelected(number);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          width: 60,
                          child: Center(
                            child: Text('선택', style: h5.copyWith(color: graphBlue)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            LottoNumberPicker(
              start: start,
              end: end,
              step: step,
              initNumber: initNumber,
              onChanged: (value) {
                number = value;
              },
            ),
          ],
        ),
      );
    },
  );
}

class LottoNumberPicker extends StatefulWidget {
  final int start;
  final int end;
  final int step;
  final int initNumber;
  final Function(int) onChanged;

  const LottoNumberPicker({
    super.key,
    required this.start,
    required this.end,
    required this.step,
    required this.initNumber,
    required this.onChanged,
  });

  @override
  State<LottoNumberPicker> createState() => _LottoNumberPickerState();
}

class _LottoNumberPickerState extends State<LottoNumberPicker> {
  int _number = 1;

  @override
  void initState() {
    _number = ((widget.initNumber / 10).toInt()) * 10;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        NumberPicker(
          minValue: widget.start,
          maxValue: widget.end,
          value: _number >= widget.start ? _number : widget.start,
          itemCount: 5,
          step: widget.step,
          itemWidth: double.infinity,
          textStyle: subtitle1,
          selectedTextStyle: h2,
          haptics: true,
          infiniteLoop: true,
          onChanged: (value) {
            setState(() {
              _number = value;
            });
            widget.onChanged(value);
          },
        ),
        _gradient(),
      ],
    );
  }

  Widget _gradient() {
    return SizedBox(
      height: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IgnorePointer(
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    white.withValues(alpha: 1),
                    white.withValues(alpha: 0.6),
                    white.withValues(alpha: 0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          IgnorePointer(
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    white.withValues(alpha: 0),
                    white.withValues(alpha: 0.6),
                    white.withValues(alpha: 1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
