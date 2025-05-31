import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:overstay_frontend/views/auth/simple_login.dart';

void main() {
  testWidgets('Signup-link findes på SimpleLoginPage', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SimpleLoginPage());
    expect(find.byKey(const Key('signup_btn')), findsOneWidget);
    expect(find.text("Don't have an account? Create one here"), findsOneWidget);
  });
}
