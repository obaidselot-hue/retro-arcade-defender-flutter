// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:retro_arcade_defender/main.dart';
import 'package:retro_arcade_defender/screens/menu_screen.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app loads without errors
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(MenuScreen), findsOneWidget);

    // Verify that the menu screen contains expected text
    expect(find.text('▶ PLAY'), findsOneWidget);
    expect(find.text('Level'), findsOneWidget);
    expect(find.text('Audio'), findsOneWidget);
    expect(find.text('About'), findsOneWidget);
  });
}
