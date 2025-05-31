// test/views/auth/simple_login_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:overstay_frontend/views/auth/simple_login.dart';

void main() {
  testWidgets('Login-knappen findes på SimpleLoginPage', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SimpleLoginPage());
    expect(find.byKey(const Key('login_button')), findsOneWidget);
  });

  testWidgets('Viser valideringsfejl hvis felter er tomme', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SimpleLoginPage());
    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pump(); // Trigger validation
    expect(find.text('Username required'), findsOneWidget);
    expect(find.text('Password required'), findsOneWidget);
  });

  testWidgets('Forkert login viser fejlbesked', (WidgetTester tester) async {
    await tester.pumpWidget(const SimpleLoginPage());
    await tester.enterText(find.byKey(const Key('username')), 'wrong');
    await tester.enterText(find.byKey(const Key('password')), 'wrong');
    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pump(); // for error message
    expect(find.text('Wrong username or password'), findsOneWidget);
  });

  testWidgets('Korrekt login viser ikke fejlbesked', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SimpleLoginPage());
    await tester.enterText(find.byKey(const Key('username')), 'test');
    await tester.enterText(find.byKey(const Key('password')), '1234');
    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pump();
    expect(find.text('Wrong username or password'), findsNothing);
  });
}
