import 'package:flutter_test/flutter_test.dart';
import 'package:rizz_keyboard/main.dart';

void main() {
  testWidgets('Rizz Keyboard loads', (WidgetTester tester) async {
    await tester.pumpWidget(const RizzKeyboardApp());
    expect(find.text('🤖'), findsOneWidget);
  });
}