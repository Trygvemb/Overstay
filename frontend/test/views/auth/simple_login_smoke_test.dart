import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:overstay_frontend/views/auth/simple_login.dart';

void main() {
  testWidgets('SimpleLoginPage bygger uden fejl', (WidgetTester tester) async {
    await tester.pumpWidget(const SimpleLoginPage());
    // Består hvis siden loader uden fejl
  });

  testWidgets('Login-knap findes på SimpleLoginPage', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SimpleLoginPage());
    expect(find.byKey(const Key('login_button')), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('Fejlbesked vises hvis man indtaster forkerte credentials', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SimpleLoginPage());

    // Indtast brugernavn og forkert password
    await tester.enterText(find.byKey(const Key('username')), 'forkert');
    await tester.enterText(find.byKey(const Key('password')), 'forkert');
    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pump();

    expect(find.text('Wrong username or password'), findsOneWidget);
  });

  testWidgets('Input validering viser "Username required"', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SimpleLoginPage());

    // Lad begge felter være tomme og klik login
    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pump();

    expect(find.text('Username required'), findsOneWidget);
    expect(find.text('Password required'), findsOneWidget);
  });
}
