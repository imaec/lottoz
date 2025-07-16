import 'package:flutter/material.dart';

import 'colors.dart';

final appTheme = ThemeData(
  colorScheme: _colorScheme,
  useMaterial3: true
);

const _colorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: gray800,
  onPrimary: white,
  secondary: gray600,
  onSecondary: white,
  primaryContainer: gray500,
  onPrimaryContainer: white,
  surface: gray25,
  surfaceTint: gray600,
  onSurface: gray800,
  error: error,
  onError: white,
);
